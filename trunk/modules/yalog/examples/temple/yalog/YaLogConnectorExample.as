/**
 * @exampleText
 * 
 * <a name="YaLogConnector"></a>
 * <h1>YaLogConnector</h1>
 * 
 * <p>This is an example of the usage of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/yalog/doc/temple/yalog/util/YaLogConnector.html">YaLogConnector</a> class.</p>
 * 
 * <p>Go to <a href="http://yalala.tyz.nl/" target="_blank">http://yalala.tyz.nl/</a> to view the output of Yalog.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/yalog/examples/temple/yalog/YaLogConnectorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/yalog/examples/temple/yalog/YaLogConnectorExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.core.debug.log.Log;
	import temple.yalog.util.YaLogConnector;

	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class YaLogConnectorExample extends DocumentClassExample
	{
		public function YaLogConnectorExample()
		{
			super("Temple - YaLogConnectorExample");
			
			// By calling this method, all message send to the Log class will automatically passed to Yalog
			// You can pass a name to the connection which is displaying in Yalala. This can be very useful to distinct multiple applications.
			YaLogConnector.connect("YaLogConnectorExample");
			
			// View Yalog outout in Yalala: http://yalala.tyz.nl/
			var textField:TextField = new TextField();
			textField.defaultTextFormat = new TextFormat("Arial", 12, 0x333333, true);
			addChild(textField);
			textField.width = stage.stageWidth;
			textField.height = stage.stageHeight;
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("a {text-decoration: underline;}");
			textField.styleSheet = style;
			textField.htmlText = "<p>Go to <a href=\"http://yalala.tyz.nl/\" target=\"_blank\">http://yalala.tyz.nl/</a> to view the output of Yalog</p>";
			
			// Send an info message to the Log
			Log.info("This is an info message", toString());

			// Send an debug message to the Log
			Log.debug("This is a debug message", toString());
			
			// Send an error message to the Log
			Log.error("This is an error message", toString());

			// Send an warning to the Log
			Log.warn("This is a warning", toString());

			// Send a fatal message to Yalala
			Log.fatal("This is a fatal message", toString());
			
			
			// You can also use the short methods for logging. These methods are built-in in every Temple class
			logInfo("This is an info message");
			logDebug("This is a debug message");
			logError("This is an error message");
			logWarn("This is a warning");
			logFatal("This is a fatal message");
		}
	}
}
