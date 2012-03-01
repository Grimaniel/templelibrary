/*
include "../includes/License.as.inc";
 */

package temple.core.behaviors 
{

	/**
	 * Interface for all Events dispachted by a Behavior
	 * 
	 * @see temple.core.behaviors.IBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public interface IBehaviorEvent
	{
		/**
		 * A reference of the behavior
		 */
		function get behavior():IBehavior;
		
		/**
		 * Get the target of the behavior.
		 * The behaviorTarget is the object that is influenced by the behavior
		 */
		function get behaviorTarget():Object;

		/**
		 * The event target. This property contains the target node. This property contains the behavior, not the
		 * behaviors target. To get the behaviors target use behaviorTarget
		 */
		function get target():Object;

		/**
		 * The type of event. The type is case-sensitive.
		 */
		function get type():String;
	}
}
