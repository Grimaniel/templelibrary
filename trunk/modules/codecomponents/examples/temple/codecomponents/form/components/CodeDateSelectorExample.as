/**
 * @exampleText
 * 
 * <a name="CodeDateSelector"></a>
 * <h1>CodeDateSelector</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeDateSelector.html">CodeDateSelector</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeDateSelectorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeDateSelectorExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.utils.ValueBinder;
	import temple.codecomponents.form.components.CodeDateSelector;
	import temple.codecomponents.label.CodeLabel;
	public class CodeDateSelectorExample extends DocumentClassExample
	{
		public function CodeDateSelectorExample()
		{
			super("Temple - CodeDateSelectorExample");
			
			var selector:CodeDateSelector;
			var output:CodeLabel;
			
			// Default CodeDateSelector
			selector = new CodeDateSelector();
			this.addChild(selector);
			selector.x = 10;
			selector.y = 10;
			// set a format to the date output
			selector.format = "d / m / Y";
			
			// Create a label for displaying the output of the CodeDateSelector
			output = new CodeLabel();
			this.addChild(output);
			output.x = 200;
			output.y = 10;

			// Use a ValueBinder to set the date in the output
			new ValueBinder(selector, output, "label");


			// CodeDateSelector with only dates in the future
			selector = new CodeDateSelector(new Date());
			this.addChild(selector);
			selector.x = 10;
			selector.y = 40;
			// set a format to the date output
			selector.format = "d / m / Y";
			
			// Create a label for displaying the output of the CodeDateSelector
			output = new CodeLabel();
			this.addChild(output);
			output.x = 200;
			output.y = 40;

			// Use a ValueBinder to set the date in the output
			new ValueBinder(selector, output, "label");


			// CodeDateSelector with only dates in the past
			selector = new CodeDateSelector(null, new Date());
			this.addChild(selector);
			selector.x = 10;
			selector.y = 70;
			// set a format to the date output
			selector.format = "d / m / Y";
			
			// select today as current date
			selector.value = new Date();
			
			// Create a label for displaying the output of the CodeDateSelector
			output = new CodeLabel();
			this.addChild(output);
			output.x = 200;
			output.y = 70;

			// Use a ValueBinder to set the date in the output
			new ValueBinder(selector, output, "label");

		}
	}
}
