/*
include "../includes/License.as.inc";
 */

package temple.core.behaviors 
{
	import temple.core.events.CoreEvent;
	import temple.core.templelibrary;

	/**
	 * Abstract implementation of a BehaviorEvent. This class is used as super class for other BehaviorEvents.
	 * This class will never be instantiated directly but will always be derived. So therefore this class is an
	 * 'Abstract' class.
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractBehaviorEvent extends CoreEvent implements IBehaviorEvent
	{
		include "../includes/Version.as.inc";
		
		private var _behavior:IBehavior;

		/**
		 * Creates a new AbstractBehaviorEvent
		 * @param type The type of event.
		 * @param behavior The behavior
		 */
		public function AbstractBehaviorEvent(type:String, behavior:IBehavior, bubbles:Boolean = false)
		{
			super(type, bubbles);
			this._behavior = behavior;
			this.toStringProps.splice(1, 0, 'behaviorTarget');
		}

		/**
		 * @inheritDoc
		 */
		public function get behavior():IBehavior 
		{
			return this._behavior;
		}

		/**
		 * @inheritDoc
		 */
		public function get behaviorTarget():Object
		{
			return this._behavior.target;
		}
	}
}
