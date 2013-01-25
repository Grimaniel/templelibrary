/**
 * @exampleText
 * 
 * <a name="CoreLoader"></a>
 * <h1>CoreLoader</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/display/CoreLoader.html">CoreLoader</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/display/CoreLoaderExample.swf" target="_blank">View this example</a></p>
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/display/CoreLoaderExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.core.display.CoreLoader;
	import temple.core.display.CoreSprite;

	import flash.events.Event;
	import flash.net.URLRequest;

	public class CoreLoaderExample extends CoreSprite
	{
		private var _loader:CoreLoader;
		
		public function CoreLoaderExample()
		{
			this._loader = new CoreLoader();
			// add the listener on the loader instead of the contentLoaderInfo
			this._loader.addEventListenerOnce(Event.COMPLETE, this.handleLoaderComplete);
			this._loader.load(new URLRequest('http://code.google.com/p/templelibrary/logo'));
		}

		private function handleLoaderComplete(event:Event):void
		{
			this.addChild(this._loader);
			// center on stage
			this._loader.x = Math.round(.5 * (this.stage.stageWidth - this._loader.width));
			this._loader.y = Math.round(.5 * (this.stage.stageHeight - this._loader.height));
		}
	}
}
