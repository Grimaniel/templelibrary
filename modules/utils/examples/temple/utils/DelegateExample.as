/**
 * @exampleText
 * 
 * <a name="Delegate"></a>
 * <h1>Delegate</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/doc/temple/utils/Delegate.html">Delegate</a> class.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/DelegateExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/DelegateExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.core.debug.log.Log;
	import temple.utils.Delegate;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class DelegateExample extends DocumentClassExample 
	{
		public function DelegateExample()
		{
			super("Temple- DelegateExample");
			
			// create a delegate, you can store the delegate in a variable so you can call is later
			var delegate:Function = Delegate.create(myFunction, this, ["some data"]);
			
			// call delegate
			Log.info("Call delegate:", this);
			delegate();


			// call again
			Log.info("Call delegate again:", this);
			delegate();
		}

		private function myFunction(argument:String):void
		{
			Log.info("myFunction call with argument '" + argument + "'", this);
		}
	}
}
