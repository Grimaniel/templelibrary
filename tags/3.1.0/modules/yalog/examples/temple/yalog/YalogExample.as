/**
 * @exampleText
 * 
 * <a name="Yalog"></a>
 * <h1>Yalog</h1>
 * 
 * <p>This is an example of the usage of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/yalog/doc/nl/acidcats/yalog/Yalog.html">Yalog</a> class.</p>
 * 
 * <p>Go to <a href="http://yalala.tyz.nl/" target="_blank">http://yalala.tyz.nl/</a> to view the output of Yalog.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/yalog/examples/temple/yalog/YalogExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/yalog/examples/temple/yalog/YalogExample.as" target="_blank">View source</a></p>
 */
package
{
	import flash.text.StyleSheet;
	import nl.acidcats.yalog.Yalog;

	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class YalogExample extends DocumentClassExample
	{
		public function YalogExample()
		{
			super("Temple - YalogExample");
			
			// View Yalog outout in Yalala: http://yalala.tyz.nl/
			var textField:TextField = new TextField();
			textField.defaultTextFormat = new TextFormat("Arial", 12, 0x333333, true);
			this.addChild(textField);
			textField.width = this.stage.stageWidth;
			textField.height = this.stage.stageHeight;
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("a {text-decoration: underline;}");
			textField.styleSheet = style;
			textField.htmlText = "<p>Go to <a href=\"http://yalala.tyz.nl/\" target=\"_blank\">http://yalala.tyz.nl/</a> to view the output of Yalog</p>";
			
			// Send an info message to Yalala
			Yalog.info("This is an info message", toString());

			// Send an debug message to Yalala
			Yalog.debug("This is a debug message", toString());
			
			// Send an error message to Yalala
			Yalog.error("This is an error message", toString());

			// Send an warning to Yalala
			Yalog.warn("This is a warning", toString());

			// Send a fatal message to Yalala
			Yalog.fatal("This is a fatal message", toString());
		}
	}
}
