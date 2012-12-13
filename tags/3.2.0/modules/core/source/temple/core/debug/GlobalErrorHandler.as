/*
include "../includes/License.as.inc";
 */

package temple.core.debug
{
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import temple.core.debug.log.Log;
	import temple.core.events.CoreEventDispatcher;
	import temple.core.templelibrary;


	/**
	 * Class for catching unhandled (global) errors.
	 * 
	 * <p>If an Error is thrown which isn't catched, the <code>GlobalErrorHandler</code> will send an error message to
	 * the <code>Log</code> class.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	var geh:GlobalErrorHandler = new GlobalErrorHandler(this.loaderInfo, true);
	 * 	geh.preventDefault = true;
	 * 	geh.addEventListener(GlobalErrorEvent.GLOBAL_ERROR, this.handleGlobalError);
	 * 	
	 * 	private function handleGlobalError(event:GlobalErrorEvent):void
	 * 	{
     * 	    if (event.error is Error)
     * 	    {
     * 	    	var error:Error = event.error as Error;
     * 	    	// do something with the error
     * 	    }
     * 	    else if (event.error is ErrorEvent)
     * 	    {
     * 	    	var errorEvent:ErrorEvent = event.error as ErrorEvent;
     * 	    	// do something with the error
     * 	    }
     * 	    else
     * 	    {
     * 	    	// a non-Error, non-ErrorEvent type was thrown and uncaught
     * 	    }
     *	}
	 * </listing>
	 * 
	 * @see temple.core.debug.log.Log
	 * 
	 * @author Ajran van Wijk
	 */
	public class GlobalErrorHandler extends CoreEventDispatcher implements IDebuggable
	{
		include "../includes/Version.as.inc";
		
		private var _preventDefault:Boolean;
		private var _debug:Boolean;
		
		public function GlobalErrorHandler(loaderInfo:LoaderInfo, debug:Boolean = true, preventDefault:Boolean = false)
		{
			this._debug = debug;
			this._preventDefault = preventDefault;
			
			if (loaderInfo.hasOwnProperty("uncaughtErrorEvents"))
			{
				loaderInfo["uncaughtErrorEvents"].addEventListener("uncaughtError", this.handleUncaughtError);
			}
		}

		private function handleUncaughtError(event:*):void
		{
			this.dispatchEvent(new GlobalErrorEvent(GlobalErrorEvent.GLOBAL_ERROR, event.error));
			
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				if (this._debug) Log.error("Uncaught Error :: " + error.name + "::" + error.errorID + "::" + error.message + "::\n" + error.getStackTrace(), this.toString());
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				if (this._debug) Log.error("Uncaught ErrorEvent :: " + errorEvent.text, this.toString());
			}
			else
			{
				if (this._debug) Log.error("Unknown Error(Event) :: " + event.error, this.toString());
			}

			if (this._preventDefault) Event(event).preventDefault();
		}
		
		/**
		 * Get or set the default Error behavior.
		 * When set to true, the default error-popup in the DebugPlayer is not shown
		 * When set to false (default), the error-popup is shown.
		 */
		public function get preventDefault():Boolean
		{
			return this._preventDefault;
		}
		
		/**
		 * @private
		 */
		public function set preventDefault(value:Boolean):void
		{
			this._preventDefault = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}
	}
}
