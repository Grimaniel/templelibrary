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

package temple.net
{
	import temple.common.events.PendingCallEvent;
	import temple.common.interfaces.IDataResult;
	import temple.common.interfaces.IPendingCall;
	import temple.core.debug.IDebuggable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.data.result.DataResult;
	import temple.utils.types.ArrayUtils;

	import flash.events.Event;


	/**
	 * @author Thijs Broerse
	 */
	public class MultiPendingCall extends CoreEventDispatcher implements IPendingCall, IDebuggable
	{
		private var _queue:Array;
		private var _success:Boolean = true;
		private var _result:IDataResult;
		private var _data:Array;
		private var _callback:Function;
		private var _debug:Boolean;
		
		public function MultiPendingCall(callback:Function = null)
		{
			_callback = callback;
			_queue = [];
			
			toStringProps.push("isLoading", "isLoaded", "length", "result");
		}

		public function add(call:IPendingCall):void
		{
			if (isLoaded)
			{
				throwError(new TempleError(this, "MultiPendingCall is already finished, can't add calls anymore"));
			}
			else if (!call.isLoaded)
			{
				_queue.push(call);
				call.addEventListener(Event.COMPLETE, handleCallComplete);
			}
		}

		public function get isLoading():Boolean
		{
			return _queue.length > 0;
		}

		public function get isLoaded():Boolean
		{
			return _result != null;
		}

		public function cancel():Boolean
		{
			var leni:int = _queue.length;
			for (var i:int = 0; i < leni; i++)
			{
				IPendingCall(_queue[i]).cancel();
			}
			return true;
		}

		public function get result():IDataResult
		{
			return _result;
		}

		public function get length():int
		{
			return _queue ? _queue.length : 0;
		}
		
		public function get debug():Boolean
		{
			return _debug;
		}

		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		private function handleCallComplete(event:Event):void
		{
			var call:IPendingCall = IPendingCall(event.target);
			
			if (debug) logDebug("handleCallComplete: " + call);
			
			ArrayUtils.removeValueFromArray(_queue, call);
			call.removeEventListener(PendingCallEvent.RESULT, handleCallComplete);
			
			if (!call.result.success)
			{
				_success = false;
			}
			_data ||= [];
			_data.push(call.result.data);
			
			if (_queue.length == 0)
			{
				_result = new DataResult(_data, _success);
				
				if (debug) logDebug("Ready");
				
				if (_callback != null)
				{
					_callback(_result);
				}
				dispatchEvent(new PendingCallEvent(PendingCallEvent.RESULT, this));
				destruct();
			}
		}

		override public function destruct():void
		{
			if (_queue)
			{
				while (_queue.length) IPendingCall(_queue.shift()).removeEventListener(PendingCallEvent.RESULT, handleCallComplete);
				_queue = null;
			}
			_callback = null;
			_data = null;
			_result = null;
			
			super.destruct();
		}
	}
}
