/*
include "../includes/License.as.inc";
 */

package temple.core 
{
	import temple.core.debug.DebugMode;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;

	/**
	 * This class contains information about the Temple Library and some global properties and settings.
	 * 
	 * <p>Note: This class contains only static properties. Therefore this class cannot be instantiated.</p>
	 * 
	 * @includeExample ../templates/DocumentClassExample.as
	 * 
	 * @author MediaMonks: Thijs Broerse, Arjan van Wijk, Quinten Beek, Bart van der Schoor
	 */
	public final class Temple 
	{
		include "./includes/Version.as.inc";
		
		/**
		 * The name of the Temple.
		 */
		public static const NAME:String = "Temple";
		
		/**
		 * The current version of the Temple Library.
		 */
		public static const VERSION:String = "3.5.1";
		
		/**
		 * The Authors of the Temple.
		 */
		public static const AUTHOR:String = "MediaMonks: Thijs Broerse, Arjan van Wijk, Quinten Beek, Bart van der Schoor, Stephan Bezoen, Mark Knol";
		
		/**
		 * Last modified date of the Temple.
		 * (Format: 'yyyy-mm-dd')
		 * 
		 */
		public static const DATE:String = "2013-05-23";

		/**
		 * The official website of the Temple.
		 * <a href="http://code.google.com/p/templelibrary/" target="_blank">http://code.google.com/p/templelibrary/</a>
		 */
		public static const WEBSITE:String = "http://code.google.com/p/templelibrary/";
		
		/**
		 * When set to true, all Temple objects are registered in the <code>Memory</code> class with a weak reference.
		 * Useful for debugging to track all existing objects.
		 * After destructing an object (and force a Garbage Collection) the object should no longer exist.
		 * 
		 * Note: Changing this value must be done here or before the <code>super()</code> inside the constructor of your
		 * application root.
		 * 
		 * @see temple.core.debug.Registry
		 * @see temple.core.debug.Memory
		 */
		public static var registerObjectsInMemory:Boolean = true;

		/**
		 * When set to true and <code>registerObjectsInMemory</code> is set to true, all Temple objects are registered 
		 * with the call stack info. This can be useful for debugging.
		 * 
		 * Note: Changing this value must be done here or before the <code>super()</code> inside the constructor of your
		 * application root.
		 * 
		 * @see temple.core.debug.Registry
		 * @see temple.core.debug.Memory
		 */
		public static var registerObjectsWithStack:Boolean = false;
		
		/**
		 * When debug is not set in the URL, this debugmode is used for the DebugManager.
		 * Possible values are:
		 * <table class="innertable">
		 * 	<tr>
		 * 		<th>DebugMode Constant</th>
		 * 		<th>Description</th>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DebugMode.NONE</td>
		 * 		<td>Debug will be set to false on all debuggable objects. So no debug messages will be logged.</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DebugMode.CUSTOM</td>
		 * 		<td>Debug can be set to each debuggable object individually.</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DebugMode.ALL</td>
		 * 		<td>Debug will be set to true on all debuggable objects. So debug messages will be logged</td>
		 * 	</tr>
		 * </table>
		 * 
		 * @see temple.core.debug.DebugManager
		 * @see temple.core.debug.DebugMode
		 */
		public static var defaultDebugMode:String = DebugMode.CUSTOM;

		/**
		 * Indicates if Temple errors should be ignored. If set to true, Temple errors are still logged, but not thrown.
		 * 
		 * @see temple.core.errors#throwError()
		 */
		public static var ignoreErrors:Boolean = false;
		
		/**
		 * Indicates if the package will be displayed when calling a toString() method on an object or class
		 * Example:
		 * If set to true trace(Temple) will output 'temple.core.Temple'
		 * If set to false trace(Temple) will output 'Temple'
		 * 
		 * @see temple.core.debug.getClassName#getClassName()
		 */
		public static var displayFullPackageInToString:Boolean = false;
		
		private static const _TO_STRING_PROPS:Vector.<String> = Vector.<String>(['registerObjectsInMemory', 'defaultDebugMode', 'ignoreErrors']);
		
		/**
		 * Destructs all objects of the Temple. Useful when unloading an ApplicationDomainRoot object.
		 */
		public static function destruct():void
		{
			Log.warn(Temple, "All objects of the Temple are being destructed");
			Registry.destructAll();
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(Temple, Temple._TO_STRING_PROPS);
		}
	}
}
