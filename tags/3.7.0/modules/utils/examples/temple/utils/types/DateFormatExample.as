/**
 * @exampleText
 * 
 * <a name="DateFormat"></a>
 * <h1>DateFormat</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/doc/temple/utils/types/DateUtils.html#format()">DateUtils.format()</a> method.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/types/DateFormatExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/types/DateFormatExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.form.components.ComboBox;
	import temple.utils.iso.Language;
	import temple.utils.localization.DutchDateLabels;
	import temple.utils.localization.EnglishDateLabels;
	import temple.utils.localization.IDateLabels;

	import flash.events.Event;
	
	public class DateFormatExample extends DocumentClassExample 
	{
		public var mcLanguageComboBox:ComboBox;
		public var mcDateFormatTester1:DateFormatTester;
		public var mcDateFormatTester2:DateFormatTester;
		public var mcDateFormatTester3:DateFormatTester;
		public var mcDateFormatTester4:DateFormatTester;

		public function DateFormatExample()
		{
			super("Temple - DateFormatExample");
			
			mcLanguageComboBox.addItems([EnglishDateLabels, DutchDateLabels], [Language.ENGLISH, Language.DUTCH]);
			mcLanguageComboBox.addEventListener(Event.CHANGE, handleLanguageChange);
			mcLanguageComboBox.value = EnglishDateLabels;
			
			mcDateFormatTester1.format = 'd-m-Y';
			mcDateFormatTester2.format = 'l jS of F \'y';
			mcDateFormatTester3.format = 'j/n/y';
			mcDateFormatTester4.format = 'r';
		}

		private function handleLanguageChange(event:Event):void
		{
			if (mcLanguageComboBox.value && mcLanguageComboBox.value is IDateLabels)
			{
				mcDateFormatTester1.language = mcLanguageComboBox.value;
				mcDateFormatTester2.language = mcLanguageComboBox.value;
				mcDateFormatTester3.language = mcLanguageComboBox.value;
				mcDateFormatTester4.language = mcLanguageComboBox.value;
			}
		}
	}
}
