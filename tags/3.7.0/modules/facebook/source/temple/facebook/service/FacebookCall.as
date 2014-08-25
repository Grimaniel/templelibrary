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

package temple.facebook.service
{
	import flash.utils.getTimer;
	import temple.common.interfaces.IDataResult;
	import temple.core.events.CoreEventDispatcher;
	import temple.facebook.data.enum.FacebookRequestMethod;
	import temple.facebook.data.vo.IFacebookFields;
	import temple.facebook.data.vo.IFacebookResult;

	import flash.events.Event;

	/**
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name = "complete", type = "flash.events.Event")]

	/**
	 * @eventType flash.events.Event.CANCEL
	 */
	[Event(name = "cancel", type = "flash.events.Event")]

	/**
	 * @private
	 * 
	 * @author Arjan van Wijk
	 */
	internal final class FacebookCall extends CoreEventDispatcher implements IFacebookCall
	{
		private var _service:FacebookService;
		private var _method:String;
		private var _id:String;
		private var _callback:Function;
		private var _params:Object;
		private var _requestMethod:FacebookRequestMethod;
		private var _objectClass:Class;
		private var _fields:IFacebookFields;
		private var _forceReload:Boolean;
		private var _result:IFacebookResult;
		private var _isLoading:Boolean;
		
		internal var creationTime:int;
		internal var callTime:int;
		internal var requestTime:int;
		internal var responseTime:int;
		internal var resultTime:int;
		internal var forced:Boolean;

		public function FacebookCall(service:FacebookService, method:String, id:String, callback:Function, params:Object = null, requestMethod:FacebookRequestMethod = null, objectClass:Class = null, fields:IFacebookFields = null, forceReload:Boolean = false, callbackPriority:int = 0)
		{
			_service = service;
			_method = method;
			_id = id;
			_callback = callback;
			_params = params;
			_requestMethod = requestMethod;
			_objectClass = objectClass;
			_fields = fields;
			_forceReload = forceReload;
			
			toStringProps.push("method", "id", "result");
			
			addEventListener(Event.COMPLETE, handleComplete, false, callbackPriority);
		}

		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return _isLoading;
		}

		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return _result != null;
		}
		
		/**
		 * @private
		 */
		internal function setIsLoading(value:Boolean):void
		{
			_isLoading = value;
		}

		/**
		 * @inheritDoc
		 */
		public function cancel():Boolean
		{
			var success:Boolean = _callback != null;
			_callback = null;
			dispatchEvent(new Event(Event.CANCEL));
			
			return success;
		}

		/**
		 * @inheritDoc
		 */
		public function get method():String
		{
			return _method;
		}

		/**
		 * @inheritDoc
		 */
		public function get id():String
		{
			return _id;
		}

		/**
		 * @inheritDoc
		 */
		public function get params():Object
		{
			return _params;
		}

		/**
		 * @inheritDoc
		 */
		public function get requestMethod():FacebookRequestMethod
		{
			return _requestMethod;
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
		public function force():IFacebookCall
		{
			if (_isLoading || isLoaded) return this;
			forced = true;
			_forceReload = true;
			return _service.call(this);
		}

		/**
		 * Returns info message about the call
		 */
		public function getInfo():String
		{
			var info:String = "FacebookCall " + (method ? method : "") + "/" + id;
			
			if (result)
			{
				info += "\nSucces: " + (result.success);
				
				if (result.data)
				{
					info += "\nResults: " + (result.data is Array ? (result.data as Array).length : "1");
				}
			}
			
			if (creationTime)
			{
				var time:Date = new Date();
				time.milliseconds -= getTimer() - creationTime;
				
				info += "\nCreated at " + (time.getHours() + ":" + time.getMinutes() + ":" + time.getSeconds());
				info += "\nCalled in " + (callTime - creationTime) + " ms";
				info += "\nRequested in " + (requestTime - callTime) + " ms";
				info += "\nResponse in " + (responseTime - requestTime) + " ms";
				info += "\nParsed in " + (resultTime - responseTime) + " ms";
				info += "\nTotal duration " + (resultTime - creationTime) + " ms";
			}
			
			return info;
		}

		/**
		 * @private
		 */
		internal function get objectClass():Class
		{
			return _objectClass;
		}

		/**
		 * @private
		 */
		internal function get fields():IFacebookFields
		{
			return _fields;
		}

		/**
		 * @private
		 */
		internal function get forceReload():Boolean
		{
			return _forceReload;
		}
		
		internal function execute(result:IFacebookResult):void
		{
			_result = result;
			_isLoading = false;
			
			dispatchEvent(new Event(Event.COMPLETE));
			
			destruct();
		}
		
		private function handleComplete(event:Event):void
		{
			removeEventListener(Event.COMPLETE, handleComplete);
			
			if (_callback != null)
			{
				var callback:Function = _callback;
				_callback = null;
				callback(_result);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_service = null;
			_callback = null;
			_fields = null;
			_objectClass = null;
			_params = null;
			_result = null;
			
			super.destruct();
		}
	}
}
