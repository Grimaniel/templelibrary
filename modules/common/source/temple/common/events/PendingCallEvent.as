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
package temple.common.events
{
	import temple.common.interfaces.IPendingCall;
	import temple.core.debug.objectToString;

	import flash.events.Event;

	/**
	 * Event used to notify the state of a asynchronous (<code>IPendingCall</code>) call.
	 * 
	 * @see temple.common.interfaces.IPendingCall
	 * 
	 * @author Thijs Broerse
	 */
	public class PendingCallEvent extends Event
	{
		/**
		 * Dispatched when the call is invoked.
		 */
		public static const CALL:String = "PendingCallEvent.call";
		
		/**
		 * Dispatched when the call is complete.
		 */
		public static const RESULT:String = "PendingCallEvent.result";
		
		private var _call:IPendingCall;
		
		public function PendingCallEvent(type:String, call:IPendingCall, bubbles:Boolean = false)
		{
			super(type, bubbles);
			
			this._call = call;
		}

		/**
		 * A reference to the related call.
		 */
		public function get call():IPendingCall
		{
			return this._call;
		}
		
		override public function clone():Event
		{
			return new PendingCallEvent(this.type, this.call, this.bubbles);
		}
		
		override public function toString():String
		{
			return objectToString(this, Vector.<String>(["type", "call", "bubbles"]));
		}
	}
}
