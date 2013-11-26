/**
 * @exampleText
 * 
 * <a name="Photos"></a>
 * <h1>Photos</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/doc/temple/facebook/api/IFacebookPhotoAPI.html">FacebookPhotoAPI.</a></p>
 * 
 * <p>This example uses the Temple's <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/readme.html">CodeComponents</a> for the UI elements.
 * This examples loads friends from Facebook and displays their names in a list.</p>
 * 
 * <p>This example will only run from the HTML file in a browser. Since we are not using a channel.html, this example might not work in all browsers.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/examples/temple/facebook/api/PhotosExample.html" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/facebook/examples/temple/facebook/api/PhotosExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeLabelButton;
	import temple.core.display.CoreLoader;
	import temple.facebook.adapters.FacebookAdapter;
	import temple.facebook.api.FacebookAPI;
	import temple.facebook.data.enum.FacebookConstant;
	import temple.facebook.data.vo.IFacebookPhotoData;
	import temple.facebook.data.vo.IFacebookResult;

	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class PhotosExample extends DocumentClassExample
	{
		private static const _THUMBNAIL_WIDTH:Number = 140; 
		private static const _THUMBNAIL_HEIGHT:Number = 140; 
		
		private var _facebook:FacebookAPI;
		private var _photosButton:CodeLabelButton;
		private var _profilePhotosButton:CodeLabelButton;

		public function PhotosExample()
		{
			super("Temple - Facebook - PhotosExample");
			
			_facebook = new FacebookAPI(new FacebookAdapter(loaderInfo.url.indexOf("https:") == 0));
			_facebook.init(loaderInfo.parameters.appId);
			
			// Create buttons (using CodeComponents)
			_photosButton = new CodeLabelButton("Click here to load some photos of me");
			_photosButton.horizontalCenter = 0;
			_photosButton.verticalCenter = -20;
			addChild(_photosButton);
			_photosButton.addEventListener(MouseEvent.CLICK, handleClick);

			_profilePhotosButton = new CodeLabelButton("Click here to load profile photos of me");
			_profilePhotosButton.horizontalCenter = 0;
			_profilePhotosButton.verticalCenter = 20;
			addChild(_profilePhotosButton);
			_profilePhotosButton.addEventListener(MouseEvent.CLICK, handleClick);
		}

		private function handleClick(event:MouseEvent):void
		{
			_photosButton.enabled = false;
			_profilePhotosButton.enabled = false;
			
			// load photos
			if (event.target == _profilePhotosButton)
			{
				_facebook.photos.getProfilePhotos(onPhotos);
			}
			else
			{
				_facebook.photos.getPhotos(onPhotos, FacebookConstant.ME, 0, 40);
			}
		}

		private function onPhotos(result:IFacebookResult):void
		{
			_photosButton.visible = false;
			_profilePhotosButton.visible = false;
			
			if (result.success)
			{
				// get friends from data
				var photos:Vector.<IFacebookPhotoData> = Vector.<IFacebookPhotoData>(result.data);
				
				var cols:int = (stage.stageWidth - 40) / _THUMBNAIL_WIDTH;
				
				// show in output
				for (var i:int = 0, leni:int = photos.length; i < leni; i++)
				{
					var loader:CoreLoader = new CoreLoader();
					addChild(loader);
					loader.load(new URLRequest(photos[i].thumbnail));
					loader.x = 20 + (i % cols) * _THUMBNAIL_WIDTH;
					loader.y = 20 + Math.floor(i / cols) * _THUMBNAIL_HEIGHT;
				}
			}
		}
	}
}
