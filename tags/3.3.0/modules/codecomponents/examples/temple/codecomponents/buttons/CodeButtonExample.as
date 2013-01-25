/**
 * @exampleText
 * 
 * <a name="CodeButton"></a>
 * <h1>CodeButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeButton.html">CodeButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeButtonExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeButton;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeButtonExample extends DocumentClassExample
	{
		public function CodeButtonExample()
		{
			super("Temple - CodeButtonExample");
			
			this.addChild(new CodeButton(14, 14, 10, 10));
			this.addChild(new CodeButton(20, 20, 30, 10));
			this.addChild(new CodeButton(100, 30, 10, 40));
		}
	}
}
