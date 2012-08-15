/**
 * @exampleText
 * 
 * <a name="TimeUtils"></a>
 * <h1>TimeUtils</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/doc/temple/utils/TimeUtils.html">TimeUtils</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/TimeUtilsExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/TimeUtilsExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.utils.TimeUtils;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class TimeUtilsExample extends DocumentClassExample 
	{
		public function TimeUtilsExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - TimeUtilsExample");
			
			this.logInfo(TimeUtils.formatMinutesSeconds(10 * 1000));
			this.logInfo(TimeUtils.formatMinutesSeconds(60 * 1000));
			this.logInfo(TimeUtils.formatMinutesSeconds(65 * 1000));
			this.logInfo(TimeUtils.formatMinutesSeconds(24260));

			this.logInfo(TimeUtils.formatMinutesSecondsAlt(10 * 1000));
			this.logInfo(TimeUtils.formatMinutesSecondsAlt(60 * 1000));
			this.logInfo(TimeUtils.formatMinutesSecondsAlt(65 * 1000));
			this.logInfo(TimeUtils.formatMinutesSecondsAlt(24260));
		}
	}
}
