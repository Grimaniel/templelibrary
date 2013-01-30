/*
include "../includes/License.as.inc";
 */

package temple.core.behaviors 
{
	import temple.core.events.ICoreEventDispatcher;

	/**
	 * A behavior adds functionality to an object, the object becomes the behaviors target.
	 * It does not change it target. The implementation of the behavior is derived from the decorator pattern.
	 * A behavior is always targeted on one (and only one) object.
	 * 
	 * @author Thijs Broerse
	 */
	public interface IBehavior extends ICoreEventDispatcher
	{
		/**
		 * Get the target of the behavior.
		 * The target is the object that is influenced by the behavior. The target can only be set in the constructor of
		 * the behavior and can never be changed.
		 */
		function get target():Object;
	}
}
