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
	
	public class DateFormatExample extends DocumentClassExample 
	{
		public var mcDateFormatTester1:DateFormatTester;
		public var mcDateFormatTester2:DateFormatTester;
		public var mcDateFormatTester3:DateFormatTester;
		public var mcDateFormatTester4:DateFormatTester;

		public function DateFormatExample()
		{
			super("Temple - DateFormatExample");
			
			// Uncomment to set in Dutch
			//DateUtils.setDutch();
			
			this.mcDateFormatTester1.format = 'd-m-Y';
			this.mcDateFormatTester2.format = 'l jS of F \'y';
			this.mcDateFormatTester3.format = 'j/n/y';
			this.mcDateFormatTester4.format = 'r';
		}
	}
}
