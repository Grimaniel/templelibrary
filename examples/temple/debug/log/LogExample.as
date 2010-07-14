/**
 * @exampleText
 * 
 * <h1>Log</h1>
 * 
 * <p>This is an example about how to use <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/debug/log/Log.html">Log</a>.</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/debug/log/LogExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/debug/log/LogExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/debug/log/LogExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import temple.debug.log.Log;
	import nl.acidcats.yalog.util.YaLogConnector;
	import temple.core.CoreSprite;

	public class LogExample extends CoreSprite 
	{
		public function LogExample()
		{
			// Connect to Yalog, so we can see the output of the log in Yalala: http://yalala.tyz.nl/
			YaLogConnector.connect("Temple - LogExample");
			
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
			
			// quick way to log
			log("quick way to log");
			
			// log has also the ability to add an object which will be trace using ObjectUtils.traceObject
			log("this", this);
			
		}
	}
}
