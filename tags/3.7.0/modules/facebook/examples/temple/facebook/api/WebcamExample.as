/**
 * @exampleText
 * 
 * <a name="Webcam"></a>
 * <h1>Webcam</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/doc/temple/facebook/api/IFacebookPhotoAPI.html">FacebookPhotoAPI</a>,
 * and some other features of the FacebookAPI like loading friends and groups.</p>
 * 
 * <p>This example uses the Temple's <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/readme.html">CodeComponents</a> for the UI elements.
 * With this example you can take a photo with your webcam and upload the photo to Facebook. You can post the photo in your (friends) wall or in a group.</p>
 * 
 * <p>This example will only run from the HTML file in a browser. Since we are not using a channel.html, this example might not work in all browsers.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/examples/temple/facebook/api/WebcamExample.html" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/examples/temple/facebook/api/WebcamExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeLabelButton;
	import temple.codecomponents.form.components.CodeCheckBox;
	import temple.codecomponents.form.components.CodeComboBox;
	import temple.codecomponents.form.components.CodeInputField;
	import temple.codecomponents.form.components.CodeRadioButton;
	import temple.codecomponents.labels.CodeLabel;
	import temple.codecomponents.windows.CodeWindow;
	import temple.common.interfaces.ISelectable;
	import temple.core.display.CoreBitmap;
	import temple.core.display.CoreShape;
	import temple.core.display.CoreSprite;
	import temple.core.media.CoreVideo;
	import temple.core.utils.CoreTimer;
	import temple.facebook.adapters.FacebookAdapter;
	import temple.facebook.adapters.FacebookLocalConnectionAdapter;
	import temple.facebook.api.FacebookAPI;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.enum.FacebookConstant;
	import temple.facebook.data.vo.IFacebookObjectData;
	import temple.facebook.data.vo.IFacebookResult;
	import temple.ui.form.components.RadioGroup;
	import temple.ui.layout.HBox;
	import temple.ui.layout.VBox;
	import temple.ui.layout.liquid.LiquidBehavior;

	import com.greensock.TweenLite;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.media.Camera;

	[SWF(backgroundColor="#000000", frameRate="31", width="640", height="480")]
	public class WebcamExample extends DocumentClassExample
	{
		private static const _ME:String = FacebookConstant.ME;
		private static const _ALBUM:String = "album";
		private static const _FRIEND:String = "friend";
		private static const _GROUP:String = "group";
		
		private var _video:CoreVideo;
		private var _cameraComboBox:CodeComboBox;
		private var _photoTimer:CoreTimer;
		private var _countDown:CodeLabel;
		private var _flash:CoreShape;
		private var _photoData:BitmapData;
		private var _photo:CoreBitmap;
		private var _photoButton:CodeLabelButton;
		private var _discardButton:CodeLabelButton;
		private var _uploadButton:CodeLabelButton;
		private var _facebook:FacebookAPI;
		private var _uploadWindow:CodeWindow;
		private var _wallRadioGroup:RadioGroup;
		private var _facebookObjectSelector:CodeComboBox;
		private var _submitButton:CodeLabelButton;
		private var _messageField:CodeInputField;
		private var _noStoryCheckBox:CodeCheckBox;
		private var _resolutionComboBox:CodeComboBox;
		
		public function WebcamExample()
		{
			super("Temple - WebcamExample");
			
			if (!Camera.names.length)
			{
				// No webcams
				var label:CodeLabel = new CodeLabel("No webcam found");
				label.textField.textColor = 0xFFFFFF;
				addChild(label);
				label.horizontalCenter = 0;
				label.verticalCenter = 0;
				return;
			}
			
			_video = new CoreVideo(stage.stageWidth, stage.stageHeight);
			_video.smoothing = true;
			
			var videoContainer:CoreSprite = new CoreSprite();
			_video.scaleX = -1;
			_video.x = _video.width;
			videoContainer.addChild(_video);
			addChild(videoContainer);
			
			_photoData = new BitmapData(_video.width, _video.height);
			
			_photo = new CoreBitmap(_photoData);
			addChild(_photo);
			_photo.visible = false;
			
			new LiquidBehavior(videoContainer, {left:0, top:0, bottom:0, right: 0});
			new LiquidBehavior(_photo, {left:0, top:0, bottom:0, right: 0});
			
			var hbox:HBox = new HBox(4);
			hbox.background = true;
			hbox.backgroundColor = 0xFFFFFF;
			hbox.backgroundAlpha = .5;
			hbox.left = 0;
			hbox.top = 0;
			hbox.right = 0;
			addChild(hbox);
			
			hbox.addChild(new CodeLabel("Select camera:"));
			
			_cameraComboBox = new CodeComboBox(160, 18, Camera.names);
			_cameraComboBox.addEventListener(Event.CHANGE, handleCameraSelected);
			hbox.addChild(_cameraComboBox);
			_cameraComboBox.selectedIndex = 0;
			
			hbox.addChild(new CodeLabel("Select resolution:"));
			
			_resolutionComboBox = new CodeComboBox(80, 18, [
				new Resolution(160, 120),
				new Resolution(320, 240),
				new Resolution(400, 300),
				new Resolution(500, 300),
				new Resolution(600, 400),
				new Resolution(620, 440),
				new Resolution(640, 440), 
				new Resolution(640, 480), 
				new Resolution(1024, 600),
				new Resolution(1024, 768),
				new Resolution(1280, 720),
				new Resolution(1920, 1080),
				]);
			_resolutionComboBox.addEventListener(Event.CHANGE, handleResolutionSelected);
			hbox.addChild(_resolutionComboBox);
			//_resolutionComboBox.selectedIndex = 0;
			
			hbox = new HBox(4);
			hbox.background = true;
			hbox.backgroundColor = 0xFFFFFF;
			hbox.backgroundAlpha = .5;
			hbox.left = 0;
			hbox.bottom = 0;
			hbox.right = 0;
			addChild(hbox);
			
			_photoTimer = new CoreTimer(1000, 3);
			_photoTimer.addEventListener(TimerEvent.TIMER, handlePhotoTimerEvent);
			_photoTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlePhotoTimerEvent);
			
			hbox.addChild(_photoButton = new CodeLabelButton("Make photo")).addEventListener(MouseEvent.CLICK, handleMakePhotoClick);
			hbox.addChild(_discardButton = new CodeLabelButton("Discard photo")).addEventListener(MouseEvent.CLICK, handleDiscardPhotoClick);
			hbox.addChild(_uploadButton = new CodeLabelButton("Upload photo to Facebook")).addEventListener(MouseEvent.CLICK, handleUploadPhotoClick);
			
			_discardButton.disable();
			_uploadButton.disable();
			
			_countDown = new CodeLabel("");
			addChild(_countDown);
			_countDown.verticalCenter = 0;
			_countDown.horizontalCenter = 0;
			_countDown.scale = 10;
			_countDown.textField.textColor = 0xFFFFFF;
			_countDown.textField.selectable = false;
			_countDown.filters = [new DropShadowFilter()];
			_countDown.visible = false;
			
			_flash = new CoreShape();
			_flash.graphics.beginFill(0xFFFFFF);
			_flash.graphics.drawRect(0, 0, 1, 1);
			_flash.graphics.endFill();
			addChild(_flash);
			_flash.autoAlpha = 0;
			new LiquidBehavior(_flash, {left:0, right:0, top:0, bottom: 0});
			
			_facebook = new FacebookAPI(FacebookAdapter.available ? new FacebookAdapter(loaderInfo.url.indexOf("https") == 0) : new FacebookLocalConnectionAdapter());
			_facebook.debug = true;
			_facebook.init(loaderInfo.parameters.appId);
			
			_uploadWindow = new CodeWindow(190, 270, "Upload to Facebook", false);
			_uploadWindow.horizontalCenter = 0;
			_uploadWindow.verticalCenter = 0;
			_uploadWindow.scalable = false;
			_uploadWindow.visible = false;
			_uploadWindow.draggable = false;
			addChild(_uploadWindow);
			
			var vbox:VBox = new VBox(4);
			_uploadWindow.add(vbox, 10, 10);
			
			vbox.addChild(new CodeLabel("Upload to:"));
			
			_wallRadioGroup = new RadioGroup();
			_wallRadioGroup.add(ISelectable(vbox.addChild(new CodeRadioButton("My own wall"))), _ME);
			_wallRadioGroup.add(ISelectable(vbox.addChild(new CodeRadioButton("An album"))), _ALBUM);
			_wallRadioGroup.add(ISelectable(vbox.addChild(new CodeRadioButton("Friends wall"))), _FRIEND);
			_wallRadioGroup.add(ISelectable(vbox.addChild(new CodeRadioButton("A group"))), _GROUP);
			_wallRadioGroup.addEventListener(Event.CHANGE, handleWallRadioGroupChange);
			
			_facebookObjectSelector = new CodeComboBox();
			vbox.addChild(_facebookObjectSelector);
			_facebookObjectSelector.visible = false;
			_facebookObjectSelector.addEventListener(Event.CHANGE, handleFacebookObjectSelected);
			
			_messageField = new CodeInputField(160, 40, true);
			vbox.addChild(_messageField);
			_messageField.hintText = "add message";
			
			_noStoryCheckBox = new CodeCheckBox("Hide on timeline");
			vbox.addChild(_noStoryCheckBox);
			
			_submitButton = new CodeLabelButton("Upload");
			vbox.addChild(_submitButton);
			_submitButton.disable();
			_submitButton.addEventListener(MouseEvent.CLICK, handleSubmitButtonClick);
		}

		private function handleResolutionSelected(event:Event):void
		{
			var resolution:Resolution = _resolutionComboBox.value as Resolution;
			
			if (resolution)
			{
				_video.camera.setMode(resolution.width, resolution.height, 25);
			}
		}

		private function handleCameraSelected(event:Event):void
		{
			_video.attachCamera(Camera.getCamera(String(_cameraComboBox.selectedIndex)));
		}

		private function handleMakePhotoClick(event:MouseEvent):void
		{
			_photoTimer.reset();
			_countDown.visible = true;
			_countDown.text = String(_photoTimer.repeatCount - _photoTimer.currentCount);
			_photoTimer.start();
			_photoButton.disable();
		}

		private function handlePhotoTimerEvent(event:TimerEvent):void
		{
			if (event.type == TimerEvent.TIMER)
			{
				_countDown.text = String(_photoTimer.repeatCount - _photoTimer.currentCount);
			}
			else if (event.type == TimerEvent.TIMER_COMPLETE)
			{
				makePhoto();
			}
		}

		private function makePhoto():void
		{
			_countDown.visible = false;
			_flash.autoAlpha = 1;
			_photoData.draw(_video);
			_photo.visible = true;
			TweenLite.to(_flash, 1, {autoAlpha: 0});
			
			_discardButton.enable();
			_uploadButton.enable();
		}
		
		private function handleDiscardPhotoClick(event:MouseEvent):void
		{
			_photo.visible = false;
			_photoButton.enable();
			_discardButton.disable();
			_uploadButton.disable();
		}

		private function handleUploadPhotoClick(event:MouseEvent):void
		{
			_uploadWindow.visible = true;
		}
		
		private function handleFacebookObjectSelected(event:Event):void
		{
			if (_facebookObjectSelector.value)
			{
				_submitButton.enable();
			}
		}

		private function handleWallRadioGroupChange(event:Event):void
		{
			switch (_wallRadioGroup.value)
			{
				case _ME:
					_facebookObjectSelector.visible = false;
					_submitButton.enable();
					break;
				case _ALBUM:
					_facebookObjectSelector.visible = true;
					_submitButton.disable();
					_facebookObjectSelector.removeAll();
					_facebookObjectSelector.hintText = "select album";
					_facebookObjectSelector.reset();
					_facebook.photos.getAlbums(this.onAlbums);
					break;
				case _FRIEND:
					_facebookObjectSelector.visible = true;
					_submitButton.disable();
					_facebookObjectSelector.removeAll();
					_facebookObjectSelector.hintText = "select friend";
					_facebookObjectSelector.reset();
					_facebook.friends.getFriends(this.onFriends);
					break;
				case _GROUP:
					_facebookObjectSelector.visible = true;
					_submitButton.disable();
					_facebookObjectSelector.removeAll();
					_facebookObjectSelector.hintText = "select group";
					_facebookObjectSelector.reset();
					_facebook.get(this.onGroups, FacebookConnection.GROUPS);
					break;
				default:
					_facebookObjectSelector.visible = false;
					_submitButton.disable();
					break;
			}
		}

		private function onAlbums(result:IFacebookResult):void
		{
			if (_wallRadioGroup.value == _ALBUM && result.success)
			{
				_facebookObjectSelector.addItems(result.data, "name");
				_facebookObjectSelector.sortOn("label");
			}
		}

		private function onFriends(result:IFacebookResult):void
		{
			if (_wallRadioGroup.value == _FRIEND && result.success)
			{
				_facebookObjectSelector.addItems(result.data, "name");
				_facebookObjectSelector.sortOn("label");
			}
		}

		private function onGroups(result:IFacebookResult):void
		{
			if (_wallRadioGroup.value == _GROUP && result.success)
			{
				_facebookObjectSelector.addItems(result.data, "name");
				_facebookObjectSelector.sortOn("label");
			}
		}
		
		private function handleSubmitButtonClick(event:MouseEvent):void
		{
			var id:String;
			
			switch (_wallRadioGroup.value)
			{
				case _ME:
					id = FacebookConstant.ME;
					break;
				case _FRIEND:
				case _GROUP:
				case _ALBUM:
					if (_facebookObjectSelector.value is IFacebookObjectData)
					{
						id = IFacebookObjectData(_facebookObjectSelector.value).id;
					}
					break;
				default:
					return;
					break;
			}
			
			if (id)
			{
				_facebook.photos.upload(_photoData, _messageField.value, this.onUpload, id, _noStoryCheckBox.selected);
				_uploadWindow.visible = false;
			}
		}

		private function onUpload(result:IFacebookResult):void
		{
		}
	}
}

class Resolution
{
	public var width:int;
	public var height:int;

	public function Resolution(width:int, height:int)
	{
		this.width = width;
		this.height = height;
	}

	public function toString():String
	{
		return width + " * " + height;
	}
}
