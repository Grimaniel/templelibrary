/**
 * @exampleText
 * 
 * <a name="URL"></a>
 * <h1>URL</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/doc/temple/utils/URL.html">URL</a> class.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/URLExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/URLExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.utils.URL;
	import temple.utils.types.ObjectUtils;

	import flash.text.TextField;

	public class URLExample extends DocumentClassExample
	{
		private var _output:TextField;
		
		public function URLExample()
		{
			super("Temple - URLExample");
			
			this._output = new TextField();
			this._output.width = this.stage.stageWidth;
			this._output.height = this.stage.stageHeight;
			this.addChild(this._output);
			
			var url:URL;
			
			this._output.appendText(new URL("http://www.domain.com?var1=test").setVariable("var1", "live").toString() + "\n");
			
			url = new URL();
			url.protocol = URL.MAILTO;
			url.domain = "mediamonks.com";
			url.username = "thijs";
			this._output.appendText(url + "\n");
			
			this._output.appendText(new URL("http://www.test.com").setVariable("var1", 1).setVariable("var2", 2) + "\n");

			this._output.appendText(new URL("http://www.test.com").setProtocol(URL.HTTPS) + "\n");

			this._output.appendText(new URL("index.html#foo").setHash("bar") + "\n");
			
			this.test("https://sub.domain.ext/dir/subdir/index.html?var1=yes&var2=no#hash");
			
			this.test("ftp://domain:8080/path?name=value#hash");

			this.test("ftp://asmith@ftp.example.org");
			
			this.test("ftp://username:password@ftp.example.org:1234/dir");
			
			this.test("http://www.mediamonks.com?test=true&var1=yes");
			
			this.test("mailto:thijs@mediamonks.com");

			this.test("index.html#test");
			
			this.test("#products/samples/123/some-description");
			
			this._output.appendText(new URL("#products/samples/123/some-description").getHashPart(1) + "\n");
			
			this._output.appendText(new URL().setHashPart(1, "part1").setHashPart(2, "part2") + "\n");
		}

		private function test(href:String):void
		{
			this._output.appendText(href + "\n");
			
			this._output.appendText(dump(new URL(href)) + "\n\n");
		}
	}
}
