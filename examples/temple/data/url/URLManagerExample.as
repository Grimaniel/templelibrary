/**
 * @exampleText
 * 
 * <h1>URLManager</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/data/url/URLManager.html">URLManager</a>. The URLManager is used to manage the URL's of a project in an XML file. With this XML file you can easily switch between different groups groups of URL's (for different environments).</p>
 * 
 * <p>This example uses Yalala to log debug information. Go to <a href="http://yalala.tyz.nl" target="_blank">http://yalala.tyz.nl</a> to view the debug messages.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/url/URLManagerExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/url/URLManagerExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/url/URLManagerExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import temple.data.url.URLManager;
	import temple.data.xml.XMLServiceEvent;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class URLManagerExample extends DocumentClassExample 
	{
		public function URLManagerExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - URLManagerExample");
			
			// set debug mode to get debug log messages from the URLManager
			URLManager.getInstance().debug = true; 
			
			// add EventListenr
			URLManager.addEventListenerOnce(XMLServiceEvent.COMPLETE, this.handleURLManagerComplete);
			
			// load urls.xml
			URLManager.loadURLs("xml/urls.xml");
		}
		
		private function handleURLManagerComplete(event:XMLServiceEvent):void
		{
			// urls.xml is loaded, let's open an url
			URLManager.openURLByName("website");
		}
	}
}
