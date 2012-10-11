/*
include "../includes/License.as.inc";
 */

package temple.core.events
{
	import temple.core.debug.objectToString;
	import temple.core.templelibrary;

	import flash.events.Event;

	/**
	 * Base class for all Events in the Temple.
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreEvent extends Event
	{
		include "../includes/Version.as.inc";
		
		private const _toStringProps:Vector.<String> = Vector.<String>(['type', 'bubbles', 'cancelable', 'eventPhase']);
		
		private var _emptyPropsInToString:Boolean = true;
		
		public function CoreEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new CoreEvent(this.type, this.bubbles, this.cancelable);
		}
		
		include "../includes/ToStringPropsMethods.as.inc";
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return objectToString(this, this.toStringProps, !this.emptyPropsInToString);
		}
	}
}
