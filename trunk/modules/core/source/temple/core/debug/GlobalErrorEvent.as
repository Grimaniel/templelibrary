/*
include "../includes/License.as.inc";
 */

package temple.core.debug
{
	import temple.core.events.CoreEvent;
	
	import flash.events.Event;
	
	/**
	 * Event dispatched by the GlobalErrorHandler when a global error has occurred.
	 * 
	 * @see temple.core.debug.GlobalErrorHandler
	 * 
	 * @author Arjan van Wijk
	 */
	public class GlobalErrorEvent extends CoreEvent
	{
		public static const GLOBAL_ERROR:String = "GlobalErrorEvent.globalError";
		
		private var _error:*;
		
		public function GlobalErrorEvent(type:String, error:*)
		{
			super(type);
			_error = error;
			toStringProps.splice(1, 0, 'error');
		}

		/**
		 * The catched Error or ErrorEvent
		 */
		public function get error():*
		{
			return _error;
		}
		
		override public function clone():Event
		{
			return new GlobalErrorEvent(type, _error);
		}
	}
}
