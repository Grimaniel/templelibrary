/*
include "../includes/License.as.inc";
 */

package temple.core.destruction 
{

	/**
	 * Interface for object that can automatic be destructed if an Error occurs.
	 * 
	 * @author Thijs Broerse
	 */
	public interface IDestructibleOnError extends IDestructible
	{
		/**
		 * if set to true this object wil automatically be destructed when an Error occurs.
		 * (<code>IOError</code> or <code>SecurityError</code>)
		 */
		function get destructOnError():Boolean;
		
		/**
		 * @private
		 */
		function set destructOnError(value:Boolean):void
	}
}
