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
	import temple.core.debug.IDebuggable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.Batch;
	import com.facebook.graph.data.FQLMultiQuery;
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.facebook.graph.net.FacebookRequest;
	import com.facebook.graph.utils.IResultParser;

	import flash.external.ExternalInterface;
	import flash.system.Security;

	/**
	 * Wrapper around <a href="http://code.google.com/p/facebook-actionscript-api/" target="_blank">Adobe ActionScript 3
	 * SDK for Facebook Platform API</a>, so the SDK can be handled as an interface. 
	 * 
	 * <p>Do not make call directly on this adapter, but pass an instance of this class to the
	 * <code>FacebookService</code> and make all calls on the <code>FacebookService</code>.</p>
	 * 
	 * @see temple.facebook.api.FacebookAPI
	 * @see temple.facebook.service.FacebookService
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookAdapter extends CoreObject implements IFacebookAdapter, IDebuggable
	{
		/**
		 * Checks if the Facebook JavaScript (needed for Facebook communication) is available.
		 */
		public static function get available():Boolean
		{
			return ExternalInterface.available && ExternalInterface.call(<script><![CDATA[function (){ return FB != null; } ]]></script>);
		}
		
		private var _secure:Boolean;
		private var _channelUrl:String;
		private var _cookie:Boolean;
		private var _status:Boolean;
		private var _debug:Boolean;

		/**
		 * Creates a new <code>FacebookAdapter</code>. The <code>FacebookAdapter</code> is used by the
		 * <code>FacebookAPI</code> and <code>FacebookService</code> to communicate with the
		 * <a href="http://code.google.com/p/facebook-actionscript-api/" target="_blank">Adobe ActionScript 3 SDK for
		 * Facebook Platform API</a>
		 * 
		 * <p>The <code>FacebookAdapter</code> can only function in an HTML file in a browser which includes the correct 
		 * JavaScript file. The constructor will check this using the <code>FacebookAdapter.available</code> getter and 
		 * throws an error when <code>ExternalInterface</code> or the JavaScript file is not available.</p>
		 * 
		 * @param secure A Boolean which indicates if the adapter should use a secure connection to communicate with Facebook.
		 * 	<p><strong>NOTE:</strong> if you are using a secure connection all files (html, css, js etc.) should use https.
		 * 	If you are not using a secure connection no files should use https. Best practice is to check the
		 * 	url for "https://". <code>stage.loaderInfo.url.indexOf('https:') != -1</code>.</p>
		 * 	
		 * @param channelUrl Specifies the URL of a custom URL channel file. This file must contain a single script
		 * 	element pointing to the JavaScript SDK URL.
		 *	<p><strong>NOTE:</strong> the protocol (http(s)) and (sub)domain must strictly match the protocol and (sub)domain of the
		 *	html file!</p>
		 *
		 * @param cookie enable cookies to allow the server to access the session.
		 * 
		 * @see temple.facebook.api.FacebookAPI
		 * @see temple.facebook.service.FacebookService
		 */
		public function FacebookAdapter(secure:Boolean, channelUrl:String = null, cookie:Boolean = true)
		{
			if (!FacebookAdapter.available)
			{
				throwError(new TempleError(this, "FacebookAdapter is not available, you can't use this Adapter"));
			}
			
			try
			{
				Security.allowDomain('graph.facebook.com');
			}
			catch (error:Error)
			{
				logError(error);
			};
			
			_secure = secure;
			_channelUrl = channelUrl;
			_cookie = cookie;
			_status = true;
			_debug = debug;
		}

		/**
		 * @private
		 * 
		 * @inheritDoc
		 */
		public function init(applicationId:String, callback:Function = null, accessToken:String = null):void
		{
			if (_debug) logDebug("Init: applicationId=" + applicationId + ", accessToken=" + accessToken + ", secure=" + _secure + ", cookie=" + _cookie + ", status=" + _status + ", channelUrl='" + _channelUrl + "'");
			if (_secure) ExternalInterface.call(<script><![CDATA[function (){ FB._https = true; } ]]></script>);

			Facebook.init(applicationId, callback, {cookie:_cookie, status:_status, channelUrl:_channelUrl}, accessToken);
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
