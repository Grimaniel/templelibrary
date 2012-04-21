/**
 * @exampleText
 * 
 * <a name="ImageLoaderScaleMode"></a>
 * <h1>ImageLoader and ScaleMode</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/ImageLoader.html">ImageLoader</a> and ScaleMode.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/ImageLoaderScaleModeExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/states/StatesExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.common.enum.ScaleMode;
	import temple.ui.ImageLoader;
	import temple.ui.layout.liquid.LiquidBehavior;

	public class ImageLoaderScaleModeExample extends DocumentClassExample 
	{
		private static var _URL:String = "image.jpg";

		public function ImageLoaderScaleModeExample()
		{
			super();
			
			var cache:Boolean = true;
			
			new LiquidBehavior(this.addChild(new ImageLoader(_URL, NaN, NaN, ScaleMode.NO_SCALE, null, true, true, null, cache)), {top: 0, left:0, relativeWidth: 0.5, relativeHeight: 0.5});
			new LiquidBehavior(this.addChild(new ImageLoader(_URL, NaN, NaN, ScaleMode.EXACT_FIT, null, true, true, null, cache)), {top: 0, right:0, relativeWidth: 0.5, relativeHeight: 0.5});
			new LiquidBehavior(this.addChild(new ImageLoader(_URL, NaN, NaN, ScaleMode.NO_BORDER, null, true, true, null, cache)), {bottom: 0, left:0, relativeWidth: 0.5, relativeHeight: 0.5});
			new LiquidBehavior(this.addChild(new ImageLoader(_URL, NaN, NaN, ScaleMode.SHOW_ALL, null, true, true, null, cache)), {bottom: 0, right:0, relativeWidth: 0.5, relativeHeight: 0.5});
		}
	}
}
