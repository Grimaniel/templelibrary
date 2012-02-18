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
