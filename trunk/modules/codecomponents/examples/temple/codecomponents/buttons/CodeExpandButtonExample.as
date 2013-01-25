/**
 * @exampleText
 * 
 * <a name="CodeExpandButton"></a>
 * <h1>CodeExpandButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeExpandButton.html">CodeExpandButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeExpandButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeExpandButtonExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeExpandButton;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeExpandButtonExample extends DocumentClassExample
	{
		public function CodeExpandButtonExample()
		{
			super("Temple - CodeExpandButtonExample");
			
			addChild(new CodeExpandButton(14, 14, 10, 10));
			addChild(new CodeExpandButton(20, 20, 30, 10));
			addChild(new CodeExpandButton(100, 30, 10, 40));
		}
	}
}
