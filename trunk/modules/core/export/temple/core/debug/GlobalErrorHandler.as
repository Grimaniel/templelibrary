/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
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
	 * 	var geh:GlobalErrorHandler = new GlobalErrorHandler(loaderInfo, true);
	 * 	geh.preventDefault = true;
	 * 	geh.addEventListener(GlobalErrorEvent.GLOBAL_ERROR, handleGlobalError);
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
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.5.1";
		
		private var _preventDefault:Boolean;
		private var _debug:Boolean;
		
		public function GlobalErrorHandler(loaderInfo:LoaderInfo, debug:Boolean = true, preventDefault:Boolean = false)
		{
			_debug = debug;
			_preventDefault = preventDefault;
			
			if (loaderInfo.hasOwnProperty("uncaughtErrorEvents"))
			{
				loaderInfo["uncaughtErrorEvents"].addEventListener("uncaughtError", handleUncaughtError);
			}
		}

		private function handleUncaughtError(event:*):void
		{
			dispatchEvent(new GlobalErrorEvent(GlobalErrorEvent.GLOBAL_ERROR, event.error));
			
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				if (_debug) Log.error("Uncaught Error :: " + error.name + "::" + error.errorID + "::" + error.message + "::\n" + error.getStackTrace(), toString());
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				if (_debug) Log.error("Uncaught ErrorEvent :: " + errorEvent.text, toString());
			}
			else
			{
				if (_debug) Log.error("Unknown Error(Event) :: " + event.error, toString());
			}

			if (_preventDefault) Event(event).preventDefault();
		}
		
		/**
		 * Get or set the default Error behavior.
		 * When set to true, the default error-popup in the DebugPlayer is not shown
		 * When set to false (default), the error-popup is shown.
		 */
		public function get preventDefault():Boolean
		{
			return _preventDefault;
		}
		
		/**
		 * @private
		 */
		public function set preventDefault(value:Boolean):void
		{
			_preventDefault = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
	}
}
