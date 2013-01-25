/**
 * @exampleText
 * 
 * <a name="CodeFastBackwardButton"></a>
 * <h1>CodeFastBackwardButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeFastBackwardButton.html">CodeFastBackwardButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeFastBackwardButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeFastBackwardButtonExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeFastBackwardButton;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeFastBackwardButtonExample extends DocumentClassExample
	{
		public function CodeFastBackwardButtonExample()
		{
			super("Temple - CodeFastBackwardButtonExample");
			
			this.addChild(new CodeFastBackwardButton(14, 14, 10, 10));
			this.addChild(new CodeFastBackwardButton(20, 20, 30, 10));
			this.addChild(new CodeFastBackwardButton(100, 30, 10, 40));
		}
	}
}
