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
			
			this._output = new TextField();
			this.addChild(this._output);
			this._output.width = this.stage.stageWidth;
			this._output.height = this.stage.stageHeight;
			
			this.test("yyyy.MM.dd G 'at' HH:mm:ss");
			this.test("EEE, MMM d, ''yy");
			this.test("h:mm a");
			this.test("hh 'o''clock' a");
			this.test("K:mm a");
			this.test("yyyyy.MMMMM.dd GGG hh:mm aaa");
			this.test("EEE, d MMM yyyy HH:mm:ss");
			this.test("yyMMddHHmmss");
		}

		private function test(pattern:String):void
		{
			this._output.appendText(pattern + "\t\t" + SimpleDateFormat.format(new Date(), pattern) + "\n");
		}
	}
}
