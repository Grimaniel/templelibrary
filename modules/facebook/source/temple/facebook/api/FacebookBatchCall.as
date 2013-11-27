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

package temple.facebook.api
{
	import temple.facebook.data.vo.IFacebookFields;
	import temple.common.interfaces.IDataResult;
	import temple.core.events.CoreEventDispatcher;
	import temple.facebook.data.enum.FacebookRequestMethod;
	import temple.facebook.data.vo.FacebookResult;
	import temple.facebook.data.vo.IFacebookResult;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	import flash.events.Event;

	/**
	 * @author Thijs Broerse
	 */
	internal class FacebookBatchCall extends CoreEventDispatcher implements IFacebookCall
	{
		private var _call:IFacebookCall;
		
		private var _service:IFacebookService;
		private var _callback:Function;
		private var _result:FacebookResult;
		private var _isLoaded:Boolean;
		
		public function FacebookBatchCall(service:IFacebookService, callback:Function, method:String, id:String, objectClass:Class, params:Object, fields:IFacebookFields, forceReload:Boolean)
		{
			_service = service;
			_callback = callback;
			
			_result = new FacebookResult(this, false, []);
			_call = _service.get(onResult, method, id, objectClass, params, fields, forceReload);
		}

		private function onResult(result:IFacebookResult):void
		{
			if (result.success)
			{
				(_result.data as Array).push.apply(null, result.data);
				
				if (_service.hasNext(result.data))
				{
					_service.getNext(result.data, onResult);
				}
				else
				{
					_isLoaded = true;
					_result.success = true;
					dispatchEvent(new Event(Event.COMPLETE));
					
					if (_callback != null)
					{
						var callback:Function = _callback;
						_callback = null;
						callback(_result);
					}
				}
			}
			else if (_callback != null)
			{
				callback = _callback;
				_callback = null;
				callback(result);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get result():IDataResult
		{
			return _result;
		}

		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return _call.isLoading || _call.isLoaded && !_isLoaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}

		/**
		 * @inheritDoc
		 */
		public function force():IFacebookCall
		{
			if (_call.isLoading || _call.isLoaded) return this;
			_call.force();
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function get method():String
		{
			return _call.method;
		}

		/**
		 * @inheritDoc
		 */
		public function get id():String
		{
			return _call.id;
		}

		/**
		 * @inheritDoc
		 */
		public function get params():Object
		{
			return _call.params;
		}

		/**
		 * @inheritDoc
		 */
		public function get requestMethod():FacebookRequestMethod
		{
			return _call.requestMethod;
		}

		/**
		 * @inheritDoc
		 */
		public function cancel():Boolean
		{
			_call.cancel();
			var success:Boolean = _callback != null;
			_callback = null;
			dispatchEvent(new Event(Event.CANCEL));
			
			return success;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_service = null;
			_call = null;
			_callback = null;
			_result = null;
			
			super.destruct();
		}

	}
}
