/*
include "../includes/License.as.inc";
 */

package temple.core.destruction 
{
	import temple.core.templelibrary;
	
	import flash.events.Event;

	/**
	 * Event for destruction. Just before an object is destructed it will dispatch a DestructEvent.destruct event.
	 * 
	 * @author Thijs Broerse
	 */
	public class DestructEvent extends Event 
	{
		include "../includes/Version.as.inc";
		
		/**
		 * Dispatched just before the object is destructed.
		 */
		public static const DESTRUCT:String = "DestructEvent.destruct";
		
		public function DestructEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event
		{
			return new DestructEvent(this.type);
		}
	}
}
