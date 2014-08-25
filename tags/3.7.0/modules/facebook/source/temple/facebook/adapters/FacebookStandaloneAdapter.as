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
	import temple.core.CoreObject;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.Batch;
	import com.facebook.graph.data.FQLMultiQuery;
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.net.FacebookRequest;
	import com.facebook.graph.utils.IResultParser;

	/**
	 * FacebookAdapter for standalone debugging without ExternalInterface. You must provide an accessToken!
	 * 
	 * @see temple.facebook.api.FacebookAPI
	 * @see temple.facebook.service.FacebookService
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookStandaloneAdapter extends CoreObject implements IFacebookAdapter
	{
		private var _accessToken:String;
		private var _debug:Boolean;

		public function FacebookStandaloneAdapter(accessToken:String, debug:Boolean = false)
		{
			_accessToken = accessToken;
			_debug = debug;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function init(applicationId:String, callback:Function = null, accessToken:String = null):void
		{
			accessToken ||= _accessToken;
			
			if (_debug) logDebug("Init: applicationId=" + applicationId + ", accessToken=" + accessToken);
			
			if (!accessToken) throwError(new TempleError(this, "You must provide an accessToken"));

			Facebook.init(null, null, {status: false}, accessToken);
			
			Facebook.api('/me', function (result:Object, error:Object):void
			{
				if (result)
				{
					var response:FacebookAuthResponse = new FacebookAuthResponse();
					response.uid = result.id;
					response.accessToken = _accessToken;
					
					if (callback != null)
					{
						callback(response, null);
					}
				}
				else
				{
					if (callback != null)
					{
						callback(null, error);
					}
				}
			}
			, {fields:"id,name"});
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
		public function login(callback:Function, permissions:Vector.<String> = null):void
		{
			Facebook.login(callback, permissions ? {scope:permissions.join(",")} : null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function logout(callback:Function):void
		{
			Facebook.logout(callback);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function ui(method:String, data:Object, callback:Function = null, display:String = null):void
		{
			Facebook.ui(method, data, callback, display);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function api(method:String, callback:Function = null, params:* = null, requestMethod:String = 'GET'):void
		{
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
			Facebook.fqlQuery(query, callback);
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
	}
}
