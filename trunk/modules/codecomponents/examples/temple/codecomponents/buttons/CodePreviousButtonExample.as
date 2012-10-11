/**
 * @exampleText
 * 
 * <a name="CodePreviousButton"></a>
 * <h1>CodePreviousButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodePreviousButton.html">CodePreviousButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodePreviousButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodePreviousButtonExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodePreviousButton;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodePreviousButtonExample extends DocumentClassExample
	{
		public function CodePreviousButtonExample()
		{
			super("Temple - CodePreviousButtonExample");
			
			this.addChild(new CodePreviousButton(14, 14, 10, 10));
			this.addChild(new CodePreviousButton(20, 20, 30, 10));
			this.addChild(new CodePreviousButton(100, 30, 10, 40));
		}
	}
}
