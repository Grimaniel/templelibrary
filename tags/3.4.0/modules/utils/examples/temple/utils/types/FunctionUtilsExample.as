/**
 * @exampleText
 * 
 * <a name="FunctionUtils"></a>
 * <h1>FunctionUtils</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/doc/temple/utils/types/FunctionUtils.html">FunctionUtils</a>.</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/types/FunctionUtilsExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/types/FunctionUtilsExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.utils.types.FunctionUtils;

	import flash.display.MovieClip;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class FunctionUtilsExample extends DocumentClassExample 
	{
		public function FunctionUtilsExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - FunctionUtilsExample");
			
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
