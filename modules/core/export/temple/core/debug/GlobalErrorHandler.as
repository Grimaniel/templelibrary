/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *
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
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.0";
		
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
