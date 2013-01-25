/**
 * @exampleText
 * 
 * <a name="SimpleDateFormat"></a>
 * <h1>SimpleDateFormat</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/doc/temple/utils/SimpleDateFormat.html">SimpleDateFormat</a> class.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/SimpleDateFormatExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/SimpleDateFormatExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.utils.SimpleDateFormat;
	import flash.text.TextField;

	public class SimpleDateFormatExample extends DocumentClassExample
	{
		private var _output:TextField;
		
		public function SimpleDateFormatExample()
		{
			super("Temple - SimpleDateFormatExample");
			
			_output = new TextField();
			addChild(_output);
			_output.width = stage.stageWidth;
			_output.height = stage.stageHeight;
			
			test("yyyy.MM.dd G 'at' HH:mm:ss");
			test("EEE, MMM d, ''yy");
			test("h:mm a");
			test("hh 'o''clock' a");
			test("K:mm a");
			test("yyyyy.MMMMM.dd GGG hh:mm aaa");
			test("EEE, d MMM yyyy HH:mm:ss");
			test("yyMMddHHmmss");
		}

		private function test(pattern:String):void
		{
			_output.appendText(pattern + "\t\t" + SimpleDateFormat.format(new Date(), pattern) + "\n");
		}
	}
}
