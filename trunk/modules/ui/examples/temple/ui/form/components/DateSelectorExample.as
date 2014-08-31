/**
 * @exampleText
 * 
 * <a name="DateSelector"></a>
 * <h1>DateSelector</h1>
 * 
 * <p>This is an example about the usage of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/form/components/DateSelector.html">DateSelector</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/components/DateSelectorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/components/DateSelectorExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/form/components/DateSelectorExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.utils.localization.DutchDateLabels;
	import temple.utils.localization.DateLabelFormat;
	import temple.ui.form.Form;
	import temple.ui.form.components.DateSelector;
	import temple.ui.form.components.InputField;

	public class DateSelectorExample extends DocumentClassExample 
	{
		public var mcDateSelector1:DateSelector;
		public var mcDateSelector2:DateSelector;
		public var mcDateSelector3:DateSelector;
		public var mcDateSelector4:DateSelector;
		
		public function DateSelectorExample()
		{
			super("DateSelectorExample");
			
			// put elements in form to test tabbing
			
			var form:Form = new Form();
			form.add(mcDateSelector1);
			form.add(mcDateSelector2);
			form.add(mcDateSelector3);
			form.add(mcDateSelector4);
			form.reset();
			
			mcDateSelector2.monthFormat = DateLabelFormat.FULL;
			mcDateSelector3.monthFormat = DateLabelFormat.SHORT;
			
			mcDateSelector4.monthLabels = DutchDateLabels;
			mcDateSelector4.monthFormat = DateLabelFormat.FULL;
		}
	}
}
