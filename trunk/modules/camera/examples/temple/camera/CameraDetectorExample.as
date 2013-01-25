/**
 * @exampleText
 * 
 * <a name="CameraDetector"></a>
 * <h1>CameraDetector Example</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/camera/doc/temple/camera/CameraDetector.html">CameraDetector</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/camera/examples/temple/camera/CameraDetectorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/camera/examples/temple/camera/CameraDetectorExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.camera.CameraDetector;
	import temple.camera.CameraDetectorEvent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class CameraDetectorExample extends DocumentClassExample
	{
		private var _video:Video;
		private var _cameraDetector:CameraDetector;
		
		public function CameraDetectorExample()
		{
			super("Temple - CameraDetectorExample");
			
			var button:Sprite = createButton("Click here: Detect camera!");
			button.addEventListener(MouseEvent.CLICK, handleButtonClick);
			addChild(button);
			
			_video = new Video(stage.stageWidth, stage.stageHeight);
			_video.smoothing = true;
			addChild(_video);
			
			_cameraDetector = new CameraDetector();
			_cameraDetector.debug = true;
			
			_cameraDetector.addEventListener(CameraDetectorEvent.ACTIVE_CAMERA_FOUND, handleCameraDetectorEvent);
			_cameraDetector.addEventListener(CameraDetectorEvent.CAMERA_NOT_ALLOWED, handleCameraDetectorEvent);
			_cameraDetector.addEventListener(CameraDetectorEvent.NO_CAMERA_FOUND, handleCameraDetectorEvent);
			
		}

		private function handleButtonClick(event:MouseEvent):void
		{
			_cameraDetector.detectActiveCamera();
		}

		private function handleCameraDetectorEvent(event:CameraDetectorEvent):void
		{
			var message:Sprite;
			
			switch (event.type)
			{
				case CameraDetectorEvent.ACTIVE_CAMERA_FOUND: 
				{
					_video.attachCamera(event.camera);
					logInfo("Camera found");
					break;
				}
				case CameraDetectorEvent.CAMERA_NOT_ALLOWED: 
				{
					logError("No camera; not allowed");
					message = createMessage("No camera; not allowed", 0xE5ECF9, 0x6B90DA);
					break;
				}
				case CameraDetectorEvent.NO_CAMERA_FOUND: 
				{
					logError("No camera found");
					message = createMessage("No camera found", 0xE5ECF9, 0x6B90DA);
					break;
				}			
				default:
				{
					logError("handleCameraDetectorEvent: unhandled event '" + event.type + "'");
					break;
				}
			}
			if (message) 
			{
				message.x = (stage.stageWidth - message.width) / 2;
				message.y = (stage.stageHeight - message.height) / 1.6;
				addChild(message);
			}
		}
		private function createButton(label:String):Sprite
		{
			var button:Sprite = createMessage(label, 0xDEDEDA ,0x808080);
			button.x = (stage.stageWidth - button.width) / 2;
			button.y = (stage.stageHeight - button.height) / 2;
			button.buttonMode = true;
			
			return button;
		}
		
		private function createMessage(label:String, backgroundColor:uint, borderColor:uint):Sprite
		{
			var message:Sprite = new Sprite();
			message.graphics.beginFill(backgroundColor);
			message.graphics.lineStyle(1, borderColor, 1, true);
			message.graphics.drawRoundRect(0, -4, 200, 28, 8);
			message.graphics.endFill();
			message.mouseChildren = false;
			
			var messageLabel:TextField = new TextField();
			messageLabel.defaultTextFormat = new TextFormat("Arial", 12, 0x333333, true, null, null, null, null, "center");
			messageLabel.width = 200;
			messageLabel.height = 20;
			messageLabel.selectable = messageLabel.mouseEnabled = false;
			messageLabel.text = label;
			message.addChild(messageLabel);
			
			return message;
		}
	}
	
}
