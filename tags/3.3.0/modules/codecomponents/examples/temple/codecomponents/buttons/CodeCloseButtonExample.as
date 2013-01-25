/**
 * @exampleText
 * 
 * <a name="CodeCloseButton"></a>
 * <h1>CodeCloseButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeCloseButton.html">CodeCloseButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeCloseButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeCloseButtonExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeCloseButton;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeCloseButtonExample extends DocumentClassExample
	{
		public function CodeCloseButtonExample()
		{
			super("Temple - CodeCloseButtonExample");
			
			this.addChild(new CodeCloseButton(14, 14, 10, 10));
			this.addChild(new CodeCloseButton(20, 20, 30, 10));
			this.addChild(new CodeCloseButton(100, 30, 10, 40));
		}
	}
}
