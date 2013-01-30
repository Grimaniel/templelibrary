/**
 * @exampleText
 * 
 * <a name="ScrollComponent"></a>
 * <h1>ScrollComponent</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/scroll/ScrollComponent.html">ScrollComponent</a>.</p>
 *  
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/scroll/ScrollComponentExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/scroll/ScrollComponentExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/scroll/ScrollComponentExample.as" target="_blank">View source</a></p>
 */
package
{
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
			//this.scrollComponent.scrollBehavior.scrollProxy = new TweenLitePropertyProxy();
			
			// set some margin at the top and bottom to create some space there
			this.scrollComponent.marginTop = 20;
			this.scrollComponent.marginBottom = 30;
		}
	}
}
