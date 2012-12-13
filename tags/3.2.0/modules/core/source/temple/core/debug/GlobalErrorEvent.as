/*
include "../includes/License.as.inc";
 */

package temple.core.debug
{
	import flash.events.Event;
	import temple.core.events.CoreEvent;
	import temple.core.templelibrary;
	
	/**
	 * Event dispatched by the GlobalErrorHandler when a global error has occurred.
	 * 
	 * @see temple.core.debug.GlobalErrorHandler
	 * 
	 * @author Arjan van Wijk
	 */
	public class GlobalErrorEvent extends CoreEvent
	{
		include "../includes/Version.as.inc";
		
		public static const GLOBAL_ERROR:String = "GlobalErrorEvent.globalError";
		
		private var _error:*;
		
		public function GlobalErrorEvent(type:String, error:*)
		{
			super(type);
			this._error = error;
			this.toStringProps.splice(1, 0, 'error');
		}

		/**
		 * The catched Error or ErrorEvent
		 */
		public function get error():*
		{
			return this._error;
		}
		
		override public function clone():Event
		{
			return new GlobalErrorEvent(this.type, this._error);
		}
	}
}
