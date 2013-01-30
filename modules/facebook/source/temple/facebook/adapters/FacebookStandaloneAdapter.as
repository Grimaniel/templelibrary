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

package temple.facebook.adapters
{
	import com.facebook.graph.data.FacebookSession;
	import temple.core.CoreObject;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.data.collections.HashMap;
	import temple.utils.TimeOut;
	import temple.utils.types.VectorUtils;

	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.Batch;
	import com.facebook.graph.data.FQLMultiQuery;
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.facebook.graph.net.FacebookRequest;
	import com.facebook.graph.utils.IResultParser;

	import flash.events.StatusEvent;
	import flash.net.LocalConnection;

	/**
	 * @author Thijs Broerse
	 */
	public class FacebookStandaloneAdapter extends CoreObject implements IFacebookAdapter
	{
		private var _userId:String;
		private var _accessToken:String;
		private var _debug:Boolean;
		private var _sender:LocalConnection;
		private var _receiver:LocalConnection;
		private var _connectionName:String;
		private var _callbacks:HashMap;
		private var _callbackCounter:uint;
		private var _timeOut:TimeOut;

		public function FacebookStandaloneAdapter()
		{
			_connectionName = "_AccessTokenReceiver" + int(Math.random() * 10e10);
			_receiver = new LocalConnection();
			_receiver.addEventListener(StatusEvent.STATUS, handleLocalConnectionStatus, false, 0, true);
			_receiver.allowDomain("*");
			_receiver.allowInsecureDomain("*");
			_receiver.connect(_connectionName);
			_receiver.client = this;
			
			_sender = new LocalConnection();
			_sender.addEventListener(StatusEvent.STATUS, handleLocalConnectionStatus, false, 0, true);
			
			_callbacks = new HashMap("FacebookStandaloneAdapterCallbacks");
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function init(applicationId:String, callback:Function = null, accessToken:String = null):void
		{
			if (debug) logDebug("init, applicationId=" + applicationId);
			var key:String = "key" + (_callbackCounter++);
			_callbacks[key] = callback;
			_sender.send("_AccessTokenProvider", "sendAccessToken", _connectionName, "sendAccessTokenCallback", key);
			
			if (_timeOut) _timeOut.destruct();
			
			_timeOut = new TimeOut(function ():void
			{
				logWarn("Not connected to AccessTokenProvider yet!");
				
				_timeOut = new TimeOut(function ():void
				{
					init(applicationId, callback, accessToken);
				}
				, 5000);
			}
			, 5000);
		}

		/**
		 * @private
		 * 
		 * callback for LocalConnection
		 */
		public function sendAccessTokenCallback(accessToken:String, userId:String, key:String):void
		{
			if (_timeOut)
			{
				_timeOut.destruct();
				_timeOut = null;
			}
			// store accessToken
			Facebook.init(null, null, {status: false}, accessToken);
			
			_accessToken = accessToken;
			_userId = userId;
			
			var callback:Function = _callbacks[key] as Function;
			
			if (callback != null)
			{
				delete _callbacks[key];
				
				var response:FacebookAuthResponse = new FacebookAuthResponse();
				response.uid = _userId;
				response.accessToken = _accessToken;
				new TimeOut(callback, 500, [response, null]);
			}
			else
			{
				throwError(new TempleArgumentError(this, "No callback found with key '" + key + "'"));
			}
		}


		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function login(callback:Function, permissions:Vector.<String> = null):void
		{
			if (debug) logDebug("login: " + permissions);
			
			var key:String = "key" + (_callbackCounter++);
			_callbacks[key] = callback;
			_sender.send("_AccessTokenProvider", "loginFacebook", _connectionName, "sendAccessTokenCallback", key, VectorUtils.toArray(permissions));
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function logout(callback:Function):void
		{
			if (debug) logDebug("logout: ");
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function ui(method:String, data:Object, callback:Function = null, display:String = null):void
		{
			if (debug) logDebug("ui: " + method);
			var key:String = "key" + (_callbackCounter++);
			_callbacks[key] = callback;
			_sender.send("_AccessTokenProvider", "ui", _connectionName, "localConnectionCallback", key, method, data);
		}
		
		/**
		 * @private
		 * 
		 * @private
		 */
		public function localConnectionCallback(key:String, args:*):void
		{
			var callback:Function = _callbacks[key];
			
			if (callback != null)
			{
				delete _callbacks[key];
				callback.apply(null, args);
			}
			else
			{
				throwError(new TempleArgumentError(this, "No callback found with key '" + key + "'"));
			}
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function api(method:String, callback:Function = null, params:* = null, requestMethod:String = 'GET'):void
		{
			if (debug) logDebug("api: " + method);
			
			if (_accessToken && (!params || !params.access_token)) (params ||= {}).access_token = _accessToken;
			
			Facebook.api(method, callback, params, requestMethod);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function getRawResult(data:Object):Object
		{
			return Facebook.getRawResult(data);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function hasNext(data:Object):Boolean
		{
			return Facebook.hasNext(data);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function hasPrevious(data:Object):Boolean
		{
			return Facebook.hasPrevious(data);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function nextPage(data:Object, callback:Function):FacebookRequest
		{
			return Facebook.nextPage(data, callback);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function previousPage(data:Object, callback:Function):FacebookRequest
		{
			return Facebook.previousPage(data, callback);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function postData(method:String, callback:Function = null, params:Object = null):void
		{
			Facebook.postData(method, callback, params);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function uploadVideo(method:String, callback:Function = null, params:* = null):void
		{
			Facebook.uploadVideo(method, callback, params);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function fqlQuery(query:String, callback:Function = null, values:Object = null):void
		{
			Facebook.fqlQuery(query, callback, values);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function fqlMultiQuery(queries:FQLMultiQuery, callback:Function = null, parser:IResultParser = null):void
		{
			Facebook.fqlMultiQuery(queries, callback, parser);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function batchRequest(batch:Batch, callback:Function = null):void
		{
			Facebook.batchRequest(batch, callback);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function callRestAPI(methodName:String, callback:Function, values:* = null, requestMethod:String = 'GET'):void
		{
			Facebook.callRestAPI(methodName, callback, values, requestMethod);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function getImageUrl(id:String, type:String = null):String
		{
			return Facebook.getImageUrl(id, type);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function deleteObject(method:String, callback:Function = null):void
		{
			Facebook.deleteObject(method, callback);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function set locale(value:String):void
		{
			Facebook.locale = value;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function get authResponse():FacebookAuthResponse
		{
			return Facebook.authResponse;
		}
		
		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function get session():FacebookSession
		{
			return null;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		private function handleLocalConnectionStatus(event:StatusEvent):void 
		{
		}
	}
}
