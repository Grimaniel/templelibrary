/**
 * @exampleText
 * 
 * <p>This is an example about the TimeUtils.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/TimeUtilsExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/TimeUtilsExample.swf</a></p>
 */
package  
{
	import nl.acidcats.yalog.util.YaLogConnector;
	import temple.utils.types.TimeUtils;
	import temple.core.CoreSprite;

	/**
	 * @author Thijs Broerse
	 */
	public class TimeUtilsExample extends CoreSprite 
	{
		public function TimeUtilsExample()
		{
			super();
			
			YaLogConnector.connect();
			
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
