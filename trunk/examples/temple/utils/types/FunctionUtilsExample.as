/**
 * @exampleText
 * 
 * <p>This is an example about the FunctionUtilsExample.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/types/FunctionUtilsExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/types/FunctionUtilsExample.swf</a></p>
 */
package  
{
	import nl.acidcats.yalog.util.YaLogConnector;

	import temple.core.CoreSprite;
	import temple.utils.types.FunctionUtils;

	import flash.display.MovieClip;

	public class FunctionUtilsExample extends CoreSprite 
	{
		public function FunctionUtilsExample()
		{
			super();
			
			// Connect to Yalog, so you can see all log message at: http://yala.acidcats.nl/
			YaLogConnector.connect();
			
			log(myPrivateFunction); // function Function() {}
			
			// private function
			log(FunctionUtils.functionToString(myPrivateFunction)); // FunctionUtilsExample.myPrivateFunction()
			
			// static function
			log(FunctionUtils.functionToString(FunctionUtils.functionToString)); // FunctionUtils.functionToString()
			
			// method
			log(FunctionUtils.functionToString(new MovieClip().gotoAndPlay)); // MovieClip.gotoAndPlay()
		}

		private function myPrivateFunction():void 
		{
		}
	}
}
