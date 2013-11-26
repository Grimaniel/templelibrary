/**
 * @exampleText
 * 
 * <a name="CodeCheckBox"></a>
 * <h1>CodeCheckBox</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeCheckBox.html">CodeCheckBox</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeCheckBoxExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeCheckBoxExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.form.components.CodeCheckBox;
	import temple.codecomponents.label.CodeLabel;
	import temple.utils.ValueBinder;

	import flash.display.DisplayObject;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeCheckBoxExample extends DocumentClassExample
	{
		public function CodeCheckBoxExample()
		{
			super("Temple - CodeCheckBoxExample");
			
			add(new CodeCheckBox("This is an example of a CodeCheckBox"), 10, 10);
			add(new CodeCheckBox("An other CodeCheckBox", null, true), 10, 30);
			
			// Easy way to handle the value of a CheckBox is using a ValueBinder
			new ValueBinder(
				add(new CodeCheckBox("Click here", "Selected", false, "Unselected"), 10, 50) as CodeCheckBox,
				add(new CodeLabel(), 10, 70), "label");
		}
		
		private function add(child:DisplayObject, x:Number, y:Number):DisplayObject
		{
			addChild(child);
			child.x = x;
			child.y = y;
			
			return child;
		}
	}
}
