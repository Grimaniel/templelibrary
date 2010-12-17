/**
 * @exampleText
 * 
 * <a name="ScrollComponentExample"></a>
 * <h1>ScrollComponentExample</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/scroll/ScrollComponent.html">ScrollComponent</a>.</p>
 *  
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/ScrollComponentExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/ScrollComponentExample.swf</a></p>
 * 
 * <p>This example uses an .fla file which can be found at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/ScrollComponentExample.fla" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/ScrollComponentExample.fla</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/scroll/ScrollComponentExample.as" target="_blank">Download source</a></p>
 */
package
{
	import temple.utils.propertyproxy.TweenLitePropertyProxy;
	import temple.ui.scroll.ScrollComponent;
	public class ScrollComponentExample extends DocumentClassExample
	{
		public var scrollComponent:ScrollComponent;
		
		public function ScrollComponentExample()
		{
			super("Temple - ScrollComponentExample");
			
			// The content, mask and ScrollBar are set by the ScrollComponent.
			// Open the .fla to see how it is constructed. The objects are set by there instance name.
			
			// Set a TweenLitePropertyProxy as scrollProxy to make the scrolling smooth.
			this.scrollComponent.scrollBehavior.scrollProxy = new TweenLitePropertyProxy();
			
			// set some margin at the top and bottom to create some space there
			this.scrollComponent.marginTop = 20;
			this.scrollComponent.marginBottom = 30;
		}
	}
}
