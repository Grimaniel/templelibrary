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
	import temple.ui.form.Form;
	import temple.ui.form.components.DateSelector;
	import temple.ui.form.components.InputField;

	public class DateSelectorExample extends DocumentClassExample 
	{
		public var mcInputField1:InputField;
		public var mcDateSelector:DateSelector;
		public var mcInputField2:InputField;
		
		public function DateSelectorExample()
		{
			super("DateSelectorExample");
			
			// put elements in form to test tabbing
			
			var form:Form = new Form();
			form.addElement(mcInputField1);
			form.addElement(mcDateSelector);
			form.addElement(mcInputField2);
			form.reset();
		}
	}
}
