/*
include "../includes/License.as.inc";
 */

package temple.core.debug 
{

	/**
	 * This class contains possible values for debugMode. DebugMode is used by the DebugManager.
	 * 
	 * @see temple.core.debug.DebugManager
	 * 
	 * @author Arjan van Wijk
	 */
	public final class DebugMode
	{
		/**
		 * Debug will be set to false on all debuggable object. So no debug messages will be logged.
		 */
		public static const NONE:String = 'none';
		
		/**
		 * Debug can be set to each debuggable object individually.
		 */
		public static const CUSTOM:String = 'custom';
		
		/**
		 * Debug will be set to true on all debuggable object. So debug messages will be logged.
		 */
		public static const ALL:String = 'all';
	}
}
