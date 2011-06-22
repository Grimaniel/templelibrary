/**
 * @exampleText
 * 
 * <a name="LiquidScrollComponent"></a>
 * <h1>Liquid ScrollComponent</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/scroll/ScrollComponent.html">ScrollComponent</a>.</p>
 * 
 * <p>By setting liquid properties (left, right, top, bottom etc.) the ScrollComponent will be liquid en will automatically be resized according to the size of the stage. 
 * If you resize the example, the dimension of the ScrollComponent will be adjusted. The size of the button of the ScrollBar will also automatically be resized. The ScrollBar
 * will be hidden when the size of the ScrollComponent is large enough to display all the content.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/LiquidScrollComponentExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/LiquidScrollComponentExample.swf</a></p>
 * 
 * <p>This example uses an .fla file which can be found at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/LiquidScrollComponentExample.fla" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/LiquidScrollComponentExample.fla</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/LiquidScrollComponentExample.as" target="_blank">Download source</a></p>
 */
package
{
	import temple.ui.buttons.MultiStateButton;
	import temple.utils.propertyproxy.AutoAlphaPropertyProxy;
	import temple.utils.propertyproxy.TweenLitePropertyProxy;
	import temple.ui.scroll.ScrollComponent;

	public class LiquidScrollComponentExample extends DocumentClassExample
	{
		public var scrollComponent:ScrollComponent;

		public function LiquidScrollComponentExample()
		{
			super("Temple - LiquidScrollComponentExample");
			
			// The content, mask and ScrollBar are set by the ScrollComponent.
			// Open the .fla to see how it is constructed. The objects are set by there instance name.
			
			// Set a TweenLitePropertyProxy as scrollProxy to make the scrolling smooth.
			this.scrollComponent.scrollBehavior.scrollProxy = new TweenLitePropertyProxy();
			
			// Set an AutoAlphaPropertyProxy as showProxy for the scrollbar, so it will fade in and out when is should be shown or hidden.
			this.scrollComponent.scrollbar.showProxy = new AutoAlphaPropertyProxy();
			
			// set some margin at the top and bottom to create some space there
			this.scrollComponent.marginTop = 20;
			this.scrollComponent.marginBottom = 30;
			
			// make liquid, 10 pixels from every side of the stage
			this.scrollComponent.top = 10;
			this.scrollComponent.left = 10;
			this.scrollComponent.right = 10;
			this.scrollComponent.bottom = 10;
			
			// the scrollbar should be at the right side of the ScrollComponent, attached to the top and bottom.
			this.scrollComponent.scrollbar.top = 0;
			this.scrollComponent.scrollbar.right = 0;
			this.scrollComponent.scrollbar.bottom = 0;
			
			// make the button of the scrollbar resize to the content of the ScrollComponent
			this.scrollComponent.scrollbar.autoSizeButton = true;
			
			// Change the way the button reacts on drag out
			MultiStateButton(this.scrollComponent.scrollbar.button).outOnDragOut = false;
			
		}
	}
}
