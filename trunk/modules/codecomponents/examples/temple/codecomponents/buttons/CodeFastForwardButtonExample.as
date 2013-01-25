/**
 * @exampleText
 * 
 * <a name="CodeFastForwardButton"></a>
 * <h1>CodeFastForwardButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeFastForwardButton.html">CodeFastForwardButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeFastForwardButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeFastForwardButtonExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeFastForwardButton;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeFastForwardButtonExample extends DocumentClassExample
	{
		public function CodeFastForwardButtonExample()
		{
			super("Temple - CodeFastForwardButtonExample");
			
			addChild(new CodeFastForwardButton(14, 14, 10, 10));
			addChild(new CodeFastForwardButton(20, 20, 30, 10));
			addChild(new CodeFastForwardButton(100, 30, 10, 40));
		}
	}
}
