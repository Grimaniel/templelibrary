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
	import temple.core.debug.IDebuggable;

	import com.facebook.graph.data.Batch;
	import com.facebook.graph.data.FQLMultiQuery;
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.facebook.graph.net.FacebookRequest;
	import com.facebook.graph.utils.IResultParser;

	/**
	 * Wraps the "Adobe ActionScript 3 SDK for Facebook Platform API" in an Interface.
	 * 
	 * @see temple.facebook.adapters.FacebookAdapter
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookAdapter extends IDebuggable
	{
		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#init()
		 */
		function init(applicationId:String, callback:Function = null, accessToken:String = null):void;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#locale
		 */
		function set locale(value:String):void;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#login()
		 */
		function login(callback:Function, permissions:Vector.<String> = null):void ;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#logout()
		 */
		function logout(callback:Function):void;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#ui()
		 */
		function ui(method:String, data:Object, callback:Function = null, display:String = null):void ;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#api()
		 */
		function api(method:String, callback:Function = null, params:* = null, requestMethod:String = 'GET'):void ;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#getRawResult()
		 */
		function getRawResult(data:Object):Object;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#hasNext()
		 */
		function hasNext(data:Object):Boolean;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#hasPrevious()
		 */
		function hasPrevious(data:Object):Boolean;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#nextPage()
		 */
		function nextPage(data:Object, callback:Function):FacebookRequest;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#previousPage()
		 */
		function previousPage(data:Object, callback:Function):FacebookRequest;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#postData()
		 */
		function postData(method:String, callback:Function = null, params:Object = null):void;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#uploadVideo()
		 */
		function uploadVideo(method:String, callback:Function = null, params:* = null):void;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#fqlQuery()
		 */
		function fqlQuery(query:String, callback:Function = null, values:Object = null):void;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#batchRequest()
		 */
		function fqlMultiQuery(queries:FQLMultiQuery, callback:Function = null, parser:IResultParser = null):void;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#()
		 */
		function batchRequest(batch:Batch, callback:Function = null):void;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#callRestAPI()
		 */
		function callRestAPI(methodName:String, callback:Function, values:* = null, requestMethod:String = 'GET'):void;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#getImageUrl()
		 */
		function getImageUrl(id:String, type:String = null):String;

		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#deleteObject()
		 */
		function deleteObject(method:String, callback:Function = null):void;
		
		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#authResponse
		 */
		function get authResponse():FacebookAuthResponse;
		
		/**
		 * @private
		 * 
		 * @copy com.facebook.graph.Facebook#session
		 */
		function get session():FacebookSession;
	}
}
