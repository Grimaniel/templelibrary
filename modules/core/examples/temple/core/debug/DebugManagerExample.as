/**
 * @exampleText
 * 
 * <a name="DebugManager"></a>
 * <h1>DebugManager</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/debug/DebugManager.html">DebugManager</a>
 * and the usage of the debug KEY.</p>
 * 
 * <p>You can enable debugging of a Temple application by providing the correct debug key in the query string of the SWF or HTML.
 * For security reasons the key is stored in a separate file with is included with the [embed] tag. By adding the content
 * of this file in the 'debug' parameter of the query string, debugging of all Temple objects is enabled:</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/debug/DebugManagerExample.swf?debug=QUXSybN5Qm" target="_blank">DebugManagerExample.swf?debug=QUXSybN5Qm</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/debug/DebugManagerExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/debug/DebugManagerExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.core.debug.DebugManager;
	import temple.core.debug.addToDebugManager;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogEvent;
	import temple.core.templelibrary;

	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DebugManagerExample extends DocumentClassExample
	{
		// Embed the key (which is stored in a seperate text file) and set KEY field of the DebugManager
		[Embed(source="KEY", mimeType="application/octet-stream")]
		private static const _KEY:Class;
		DebugManager.templelibrary::KEY = new _KEY();
		
		// Create a TextField for showing the log messages
		private var _txtLog:TextField = new TextField();
		
		public function DebugManagerExample()
		{
			super("Temple - DebugManagerExample");
			
			addToDebugManager(this);
			
			// Adds a TextField to the stage. 
			this._txtLog.defaultTextFormat = new TextFormat("Arial", 11, 0x333333);
			this._txtLog.height = this.stage.stageHeight;
			this._txtLog.width = this.stage.stageWidth;
			this.addChild(this._txtLog);
			
			// Add listenener to log. Used for example, not nessessary if you open Yalala
			Log.addLogListener(this.handleLogEvent);
			
			// Check if debug is enabled
			if (this.debug)
			{
				this.logDebug("Debug enabled"); 
			}
			else
			{
				this.logDebug("Debug disabled"); 
			}
		}
		
		private function handleLogEvent(event:LogEvent):void
		{
			this._txtLog.appendText(event.data + "\n");
		}
	}
}
