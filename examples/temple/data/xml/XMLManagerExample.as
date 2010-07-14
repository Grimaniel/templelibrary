/**
 * @exampleText
 * 
 * <h1>XMLManager</h1>
 * 
 * <p>This is an example about how to use the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/data/xml/XMLManager.html">XMLManager</a>. The XMLManager is used for easily loading and parsing XML files to typed objects.</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/xml/XMLManagerExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/xml/XMLManagerExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/xml/XMLManagerExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import temple.utils.types.ObjectUtils;
	import temple.debug.log.Log;
	import nl.acidcats.yalog.util.YaLogConnector;

	import temple.core.CoreSprite;
	import temple.data.xml.XMLManager;

	import vo.PersonData;

	public class XMLManagerExample extends CoreSprite 
	{
		public function XMLManagerExample()
		{
			// Connect to Yalog, so we can see the output of the log in Yalala: http://yalala.tyz.nl/
			YaLogConnector.connect("Temple - XMLManagerExample");
			
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
