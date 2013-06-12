/**
 * @exampleText
 * 
 * <a name="ImageLoader"></a>
 * <h1>ImageLoader</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/ImageLoader.html">ImageLoader</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/ImageLoaderExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/ImageLoaderExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.common.enum.Align;
	import temple.common.enum.ScaleMode;
	import temple.ui.ImageLoader;

	import flash.display.StageAlign;

	public class ImageLoaderExample extends DocumentClassExample 
	{
		public function ImageLoaderExample()
		{
			var url:String = "image.jpg";
			
			var imageLoader:ImageLoader;
			
			// original size
			imageLoader = new ImageLoader(null, NaN, NaN, ScaleMode.NO_SCALE, StageAlign.TOP_LEFT, false);
			imageLoader.load(url);
			imageLoader.alpha = .5;
			addChild(imageLoader);
			
			
			imageLoader = new ImageLoader(null, 100, 100, ScaleMode.NO_SCALE, null, true);
			imageLoader.load(url);
			imageLoader.x = 10;
			imageLoader.y = 10;
			addChild(imageLoader);
			
			imageLoader = new ImageLoader(null, 100, 100, ScaleMode.EXACT_FIT, null, false);
			imageLoader.load(url);
			imageLoader.x = 120;
			imageLoader.y = 10;
			addChild(imageLoader);
			
			imageLoader = new ImageLoader(null, 100, 100, ScaleMode.NO_BORDER, null, true);
			imageLoader.load(url);
			imageLoader.x = 240;
			imageLoader.y = 10;
			addChild(imageLoader);
			
			imageLoader = new ImageLoader(null, 100, 100, ScaleMode.SHOW_ALL, null, false);
			imageLoader.load(url);
			imageLoader.x = 360;
			imageLoader.y = 10;
			addChild(imageLoader);
			
			
			imageLoader = new ImageLoader(null, 100, 100, ScaleMode.NO_BORDER, null, false);
			imageLoader.load(url);
			imageLoader.x = 60;
			imageLoader.y = 120;
			addChild(imageLoader);
			
			
			imageLoader = new ImageLoader(null, 200, 200, ScaleMode.NO_SCALE, Align.TOP_LEFT, true);
			imageLoader.load(url);
			imageLoader.x = 10;
			imageLoader.y = 240;
			addChild(imageLoader);

			imageLoader = new ImageLoader(null, 200, 200, ScaleMode.NO_SCALE, Align.RIGHT, true);
			imageLoader.load(url);
			imageLoader.x = 220;
			imageLoader.y = 240;
			addChild(imageLoader);
		}
	}
}
