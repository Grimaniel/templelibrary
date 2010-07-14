/**
 * @exampleText
 * 
 * <h1>FunctionUtils</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/utils/types/FunctionUtils.html">FunctionUtils</a>.</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/types/FunctionUtilsExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/types/FunctionUtilsExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/types/FunctionUtilsExample.as" target="_blank">Download source</a></p>
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
			// Connect to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			YaLogConnector.connect("Temple - FunctionUtilsExample");
			
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
