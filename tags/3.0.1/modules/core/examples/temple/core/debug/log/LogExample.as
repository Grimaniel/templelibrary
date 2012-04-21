/**
 * @exampleText
 * 
 * <a name="Log"></a>
 * <h1>Log</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/debug/log/Log.html">Log</a>.</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/debug/log/LogExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/debug/log/LogExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class LogExample extends DocumentClassExample 
	{
		private var _txtLog:TextField = new TextField();
		
		public function LogExample()
		{
			// The super class connects to Yalog, so we can see the output of the log in Yalala: http://yalala.tyz.nl/
			super("Temple - LogExample");
			
			// Adds a TextField to the stage. 
			this._txtLog.defaultTextFormat = new TextFormat("Arial", 11, 0x333333);
			this._txtLog.height = this.stage.stageHeight;
			this._txtLog.width = this.stage.stageWidth;
			this.addChild(this._txtLog);
			
			// Add listenener to log. Used for example, not nessessary if you open Yalala
			Log.addLogListener(this.handleLog);
			
			
			// log an info message
			Log.info("This is an info message", this);
			
			// log an error
			Log.error("This is an error", this);
			
			// For all core object there is a shortcut for logging:
			this.logInfo("This is also an info message");
			
			// or
			this.logWarn("This is a warning");
			this.logDebug("This is a debug message");
			this.logFatal("This is a fatal message");
		}
		
		private function handleLog(e:LogEvent):void
		{
			this._txtLog.appendText(e.level + ": \t" + e.data + "\n");
		}

	}
}
