/**
 * @exampleText
 * 
 * <a name="CodeRadioButton"></a>
 * <h1>CodeRadioButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeRadioButton.html">CodeRadioButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeRadioButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeRadioButtonExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.utils.propertyproxy.ReplaceTextPropertyProxy;
	import temple.utils.ValueBinder;
	import temple.codecomponents.label.CodeLabel;
	import temple.ui.form.components.RadioGroup;
	import flash.display.DisplayObject;
	import temple.codecomponents.form.components.CodeRadioButton;
	
	/**
	 * @author Thijs Broerse
	 */
	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeRadioButtonExample extends DocumentClassExample
	{
		public function CodeRadioButtonExample()
		{
			super("Temple - CodeRadioButtonExample");
			
			var group:RadioGroup = new RadioGroup();
			
			group.add(CodeRadioButton(this.add(new CodeRadioButton("This is option 1", 1), 10, 10)));
			group.add(CodeRadioButton(this.add(new CodeRadioButton("This is option 2", 2), 10, 30)));
			group.add(CodeRadioButton(this.add(new CodeRadioButton("This is option 3", 3), 10, 50)));
			group.add(CodeRadioButton(this.add(new CodeRadioButton("This is option 4", 4), 10, 70)));
			
			var output:CodeLabel = new CodeLabel();
			this.add(output, 10, 100);
			
			// Use a ValueBinder to set the selected value in a label
			var replacer:ReplaceTextPropertyProxy = new ReplaceTextPropertyProxy("You selected value {value}");
			replacer.setTextForValue(null, "Nothing selected");
			new ValueBinder(group, output, "label", replacer);
		}

		private function add(child:DisplayObject, x:Number, y:Number):DisplayObject
		{
			this.addChild(child);
			child.x = x;
			child.y = y;
			
			return child;
		}
	}
}
