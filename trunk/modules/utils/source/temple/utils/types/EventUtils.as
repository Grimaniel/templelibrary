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

package temple.utils.types
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.utils.Enum;

	import flash.events.IEventDispatcher;
	
	/**
	 * This class contains some functions for Events.
	 * 
	 * @author Thijs Broerse
	 */
	public final class EventUtils
	{
		/**
		 * Set a listener to all events of a specific type.
		 * @param eventClass the Event class which contains all the events to add
		 * @param dispatcher the handler object
		 * @param listener the function  which handles the events
		 * 
		 * @example
		 * There is a Form called _form. If you want to listen for all FormEvents you could do:
		 * <listing version="3.0">
		 * 	EventUtils.addAll(FormEvent, this._form, this.handleFormEvent);
		 * </listing>
		 * 
		 * The handler can look like:
		 * <listing version="3.0">
		 * 	private function handleFormEvent(event:FormEvent):void
		 * 	{
		 * 		switch (event.type)
		 * 		{
		 * 			case FormEvent.RESET:
		 * 			{
		 * 				// reset error text
		 * 				this._txtError.text = "";
		 * 				break;
		 * 			}			
		 * 			case FormEvent.VALIDATE_SUCCESS:
		 * 			{
		 * 				// reset error text
		 * 				this._txtError.text = "";
		 * 				break;
		 * 			}			
		 * 			case FormEvent.VALIDATE_ERROR:
		 * 			{
		 * 				// show error in TextField 'txtError'
		 * 				this.txtError.text = event.result.message;
		 * 				break;
		 * 			}			
		 *			case FormEvent.SUBMIT_SUCCESS:
		 *			{
		 *				// Go to confirmation page
		 *				break;
		 *			}			
		 *			case FormEvent.SUBMIT_ERROR:
		 *			{
		 *				// show error in TextField 'txtError'
		 * 				this.txtError.text = event.result.message;
		 *				break;
		 *			}			
		 *			default:
		 *			{
		 *				this.logError("handleFormEvent: unhandled event '" + event.type + "'");
		 *				break;
		 *			}
		 *		}
		 *	}
		 *	</listing>
		 */
		public static function addAll(eventClass:Class, dispatcher:IEventDispatcher, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false, debug:Boolean = false):void
		{
			var types:Array = Enum.getArray(eventClass);
			
			if (types.length)
			{
				for each (var type : String in types)
				{
					dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
					
					if (debug) Log.debug("addAll: addEventListener for '" + type + "' on '" + dispatcher + "'", EventUtils);
				}
			}
			else
			{
				throwError(new TempleArgumentError(EventUtils, "No events found class '" + type + "'"));
			}
		}

		/**
		 * Removes the listener to all events of a specific type.
		 * @param eventClass the Event class which contains all the events to remove
		 * @param dispatcher the handler object
		 * @param listener the function  which handles the events
		 */
		public static function removeAll(eventClass:Class, dispatcher:IEventDispatcher, listener:Function, useCapture:Boolean = false, debug:Boolean = false):void
		{
			var types:Array = Enum.getArray(eventClass);
			
			if (types.length)
			{
				for each (var type : String in types)
				{
					dispatcher.removeEventListener(type, listener, useCapture);
					
					if (debug) Log.debug("addAll: removeEventListener for '" + type + "' on '" + dispatcher + "'", EventUtils);
				}
			}
			else
			{
				throwError(new TempleArgumentError(EventUtils, "No events found class '" + type + "'"));
			}
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(EventUtils);
		}
	}
}
