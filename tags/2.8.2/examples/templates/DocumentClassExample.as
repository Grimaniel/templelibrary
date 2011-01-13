/**
 * @exampleText
 * 
 * <h1>Document class</h1>
 * 
 * <p>This is an example of a document class with the Temple.
 * This class configures some Temple settings, connects to Yalog (for debug messages) and handles Google Analytics tracking (which is not part of the Temple of course).</p>
 * 
 * <p>You can use this class as template for your document class. This class is used as base class for all Temple examples.
 * Since this class makes use of Google Analytics tracking, 'analytics.swc' must be added to the classpath to get it working.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/templates/DocumentClassExample.as" target="_blank">Download source</a></p>
 */

package  
{
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import nl.acidcats.yalog.Yalog;
	import nl.acidcats.yalog.util.YaLogConnector;

	import temple.Temple;
	import temple.core.CoreMovieClip;
	import temple.debug.DebugManager;
	import temple.debug.DebugMode;
	import temple.debug.log.Log;
	import temple.utils.StageSettings;

	import com.google.analytics.GATracker;

	public class DocumentClassExample extends CoreMovieClip 
	{
		// Temple settings. If you do not set them, default values are used.
		// Best practice is to set them in the body of the document class (not in a method or constructor). Since this code will be executed before all other code.
		Temple.registerObjectsInMemory = true; // set this value to false if you want to disable object tracking
		Temple.defaultDebugMode = DebugMode.CUSTOM; // set this value to DebugMode.ALL to enable debugging for all objects
		Temple.displayFullPackageInToString = false;
		Temple.ignoreErrors = false;
		Log.showTrace = true; // set this value to false if you want to disable all traces of the Temple
		Yalog.showTrace = false;
		
		private var _tracker:GATracker;
		
		// Constructor of the Example, we pass the name of the application as an optional parameter, so we can override this value in a subclass.
		public function DocumentClassExample(name:String = "Temple - Example")
		{
			// Connect to Yalog, using the name. Now we can see all log messages on http://yalala.tyz.nl/
			YaLogConnector.connect(name);
			
			// Call super after connection to Yalog, so connection has been made before any message is logged.
			super();
			
			// Set some settings as alignment and scaleMode on the stage using the StageSettings class. You can use the StageSettings before the stage is available.
			new StageSettings(this, StageAlign.TOP_LEFT, StageScaleMode.NO_SCALE);
			
			// Create an Analytics object, so we can track some usage statistics. Note: 'analytics.swc' must be added to the classpath.
			this._tracker = new GATracker(this, "UA-353608-71"); // This is the Analytics account of the Temple, change this to your own account if you want to use Analytics tracking in your project. 
			this._tracker.trackPageview(name);
			
			// For debug purpose we log some info about this SWF and the player, using the DebugMananger
			DebugManager.logInfo();
		}

		public function get tracker():GATracker
		{
			return this._tracker;
		}
	}
}
