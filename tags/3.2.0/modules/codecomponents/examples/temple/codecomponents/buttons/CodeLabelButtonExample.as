/**
 * @exampleText
 * 
 * <a name="CodeLabelButton"></a>
 * <h1>CodeLabelButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeLabelButton.html">CodeLabelButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeLabelButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeLabelButtonExample.as" target="_blank">View source</a></p>
 */
package
{
	import flash.display.DisplayObject;
	import temple.codecomponents.buttons.CodeLabelButton;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeLabelButtonExample extends DocumentClassExample
	{
		public function CodeLabelButtonExample()
		{
			super("Temple - CodeLabelButtonExample");
			
			this.add(new CodeLabelButton("TEST"), 10, 10);

			this.add(new CodeLabelButton("A button with\nsome more text", true), 10, 40);
		}

		private function add(child:DisplayObject, x:Number, y:Number):void
		{
			this.addChild(child);
			child.x = x;
			child.y = y;
		}
	}
}
