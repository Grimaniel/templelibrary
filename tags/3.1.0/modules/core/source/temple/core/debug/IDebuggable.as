/*
include "../includes/License.as.inc";
 */

package temple.core.debug
{

	/**
	 * Interface for objects that can debugged. The interface adds a '<code>debug</code>' property. If this value is set
	 * to <code>true</code>, debug information will be logged.
	 * 
	 * <p>IDebuggable objects can be handled by the <code>DebugManager</code></p>
	 * 
	 * @see temple.core.debug.log.Log
	 * @see temple.core.debug.DebugManager
	 * 
	 * @author Thijs Broerse
	 */
	public interface IDebuggable
	{
		/**
		 * A Boolean which indicates the debug mode of the object.
		 * If object is in debug mode, more information is logged.
		 */
		function get debug():Boolean;

		/**
		 * @private
		 */
		function set debug(value:Boolean):void;

	}
}
