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

package temple.common.events
{
	import temple.common.interfaces.IPendingCall;
	import temple.core.events.CoreEvent;

	import flash.events.Event;

	/**
	 * Event used to notify the state of a asynchronous (<code>IPendingCall</code>) call.
	 * 
	 * @see temple.common.interfaces.IPendingCall
	 * 
	 * @author Thijs Broerse
	 */
	public class PendingCallEvent extends CoreEvent
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
			
			_call = call;
			
			toStringProps.splice(1, 0, "call");
		}

		/**
		 * A reference to the related call.
		 */
		public function get call():IPendingCall
		{
			return _call;
		}
		
		override public function clone():Event
		{
			return new PendingCallEvent(type, call, bubbles);
		}
	}
}
