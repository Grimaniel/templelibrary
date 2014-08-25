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

	import com.facebook.graph.data.Batch;
	import com.facebook.graph.data.FQLMultiQuery;
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.facebook.graph.net.FacebookRequest;
	import com.facebook.graph.utils.IResultParser;
	
	/**
	 * Dummy implementation of the <code>IFacebookAdapter</code>. This class doesn't make any connection with Facebook,
	 * but only logs a message when a method is called. Use this adapter for development when it is not possible to
	 * make a Facebook connection.
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookDummyAdapter extends CoreObject implements IFacebookAdapter
	{
		private var _debug:Boolean;
		
		public function init(applicationId:String, callback:Function = null, accessToken:String = null):void
		{
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function set locale(value:String):void
		{
			logDebug("locale: " + value);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function login(callback:Function, permissions:Vector.<String> = null):void
		{
			logDebug("login: ");
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function logout(callback:Function):void
		{
			logDebug("logout: ");
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function ui(method:String, data:Object, callback:Function = null, display:String = null):void
		{
			logDebug("ui: " + method);
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function api(method:String, callback:Function = null, params:* = null, requestMethod:String = 'GET'):void
		{
			logDebug("api: " + method);
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function getRawResult(data:Object):Object
		{
			return null;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function hasNext(data:Object):Boolean
		{
			return false;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function hasPrevious(data:Object):Boolean
		{
			return false;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function nextPage(data:Object, callback:Function):FacebookRequest
		{
			return null;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function previousPage(data:Object, callback:Function):FacebookRequest
		{
			return null;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function postData(method:String, callback:Function = null, params:Object = null):void
		{
			logDebug("postData: " + method);
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function uploadVideo(method:String, callback:Function = null, params:* = null):void
		{
			logDebug("uploadVideo: " + method);
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function fqlQuery(query:String, callback:Function = null, values:Object = null):void
		{
			logDebug("fqlQuery: " + query);
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function fqlMultiQuery(queries:FQLMultiQuery, callback:Function = null, parser:IResultParser = null):void
		{
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function batchRequest(batch:Batch, callback:Function = null):void
		{
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function callRestAPI(methodName:String, callback:Function, values:* = null, requestMethod:String = 'GET'):void
		{
			logDebug("callRestAPI: " + methodName);
			callback({}, null);
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function getImageUrl(id:String, type:String = null):String
		{
			return null;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function deleteObject(method:String, callback:Function = null):void
		{
			logDebug("deleteObject: " + method);
			callback({}, null);
		}
		
		
		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function get authResponse():FacebookAuthResponse
		{
			return null;
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
