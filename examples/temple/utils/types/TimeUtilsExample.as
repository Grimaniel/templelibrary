/**
 * @exampleText
 * 
 * <h1>TimeUtils</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/utils/types/TimeUtils.html">TimeUtils</a>.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/types/TimeUtilsExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/types/TimeUtilsExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/types/TimeUtilsExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import nl.acidcats.yalog.util.YaLogConnector;
	import temple.utils.types.TimeUtils;
	import temple.core.CoreSprite;

	public class TimeUtilsExample extends CoreSprite 
	{
		public function TimeUtilsExample()
		{
			// Connect to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			YaLogConnector.connect("Temple - TimeUtilsExample");
			
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
