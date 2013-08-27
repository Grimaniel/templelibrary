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
	import temple.codecomponents.form.components.CodeRadioButton;
	import temple.codecomponents.label.CodeLabel;
	import temple.ui.form.components.RadioGroup;
	import temple.ui.layout.VBox;
	import temple.utils.ValueBinder;
	import temple.utils.propertyproxy.ReplaceTextPropertyProxy;
	
	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeRadioButtonExample extends DocumentClassExample
	{
		public function CodeRadioButtonExample()
		{
			super("Temple - CodeRadioButtonExample");
			
			var vbox:VBox = new VBox(4);
			addChildAtPosition(vbox, 10, 10);
			
			var group:RadioGroup = new RadioGroup();
			
			group.add(CodeRadioButton(vbox.addChild(new CodeRadioButton("This is option 1", 1))));
			group.add(CodeRadioButton(vbox.addChild(new CodeRadioButton("This is option 2", 2))));
			group.add(CodeRadioButton(vbox.addChild(new CodeRadioButton("This is option 3", 3))));
			group.add(CodeRadioButton(vbox.addChild(new CodeRadioButton("This is option 4", 4))));
			
			var output:CodeLabel = new CodeLabel();
			vbox.addChild(output);
			
			// Use a ValueBinder to set the selected value in a label
			var replacer:ReplaceTextPropertyProxy = new ReplaceTextPropertyProxy("You selected value {value}");
			replacer.setTextForValue(null, "Nothing selected");
			new ValueBinder(group, output, "label", replacer);
		}
	}
}
