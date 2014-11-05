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
	import temple.utils.localization.DutchDateLabels;
	import temple.utils.localization.DateLabelFormat;
	import temple.utils.ValueBinder;
	import temple.codecomponents.form.components.CodeDateSelector;
	import temple.codecomponents.labels.CodeLabel;
	
	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeDateSelectorExample extends DocumentClassExample
	{
		public function CodeDateSelectorExample()
		{
			super("Temple - CodeDateSelectorExample");
			
			
			var selector:CodeDateSelector;
			var output:CodeLabel;
			
			// Default CodeDateSelector
			selector = new CodeDateSelector();
			addChild(selector);
			selector.x = 10;
			selector.y = 10;
			// set a format to the date output
			selector.format = "d / m / Y";
			selector.monthFormat = DateLabelFormat.SHORT;
			
			// Create a label for displaying the output of the CodeDateSelector
			output = new CodeLabel();
			addChild(output);
			output.x = 200;
			output.y = 12;

			// Use a ValueBinder to set the date in the output
			new ValueBinder(selector, output, "text");
			
			
			// CodeDateSelector with only dates in the future
			selector = new CodeDateSelector(new Date());
			addChild(selector);
			selector.x = 10;
			selector.y = 40;
			// set a format to the date output
			selector.format = "d - m - Y";
			
			// Create a label for displaying the output of the CodeDateSelector
			output = new CodeLabel();
			addChild(output);
			output.x = 200;
			output.y = 42;

			// Use a ValueBinder to set the date in the output
			new ValueBinder(selector, output, "text");
			

			// CodeDateSelector with only dates in the past
			selector = new CodeDateSelector(null, new Date(), 12, 40, 40, 40);
			addChild(selector);
			selector.x = 10;
			selector.y = 70;
			// set a format to the date output
			selector.format = "d / m / Y";
			selector.dayFormat = DateLabelFormat.NUMERIC_LEADING_ZERO;
			selector.monthFormat = DateLabelFormat.NUMERIC_LEADING_ZERO;
			selector.yearFormat = DateLabelFormat.SHORT;
			
			// Create a label for displaying the output of the CodeDateSelector
			output = new CodeLabel();
			addChild(output);
			output.x = 200;
			output.y = 72;

			// Use a ValueBinder to set the date in the output
			new ValueBinder(selector, output, "text");
			
			// select today as current date
			selector.value = new Date();
			
			
			// CodeDateSelector with only reversed years in year ComboBox and Dutch month labels
			selector = new CodeDateSelector(new Date(2020, 0, 1), new Date(1980, 0, 1), 10, 40, 70);
			addChild(selector);
			selector.x = 10;
			selector.y = 100;
			// set a format to the date output
			selector.format = "d / m / Y";
			selector.monthLabels = DutchDateLabels;
			selector.monthFormat = DateLabelFormat.FULL;
			
			// Create a label for displaying the output of the CodeDateSelector
			output = new CodeLabel();
			addChild(output);
			output.x = 200;
			output.y = 102;

			// Use a ValueBinder to set the date in the output
			new ValueBinder(selector, output, "text");
			
			// select today as current date
			selector.value = new Date();

		}
	}
}
