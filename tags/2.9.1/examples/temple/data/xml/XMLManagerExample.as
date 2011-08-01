/**
 * @exampleText
 * 
 * <a name="XMLManager"></a>
 * <h1>XMLManager</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/data/xml/XMLManager.html">XMLManager</a>. The XMLManager is used for easily loading and parsing XML files to typed objects.</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/xml/XMLManagerExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/xml/XMLManagerExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/xml/XMLManagerExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import temple.data.xml.XMLManager;
	import temple.debug.log.Log;
	import temple.utils.types.ObjectUtils;

	import vo.PersonData;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class XMLManagerExample extends DocumentClassExample 
	{
		public function XMLManagerExample()
		{
			// The super class connects to Yalog, so we can see the output of the log in Yalala: http://yalala.tyz.nl/
			super("Temple - XMLManagerExample");
			
			// load XML named "people" (see urls.xml) and parse it to PersonData objects.
			XMLManager.loadListByName("people", PersonData, "person", this.onData);
		}

		private function onData(list:Array):void
		{
			// This method is called after loading and paring is complete, with the list of all PersonData objects.
			Log.info("XML loaded and parsed: " + ObjectUtils.traceObject(list, 3, false), this);
		}
	}
}
