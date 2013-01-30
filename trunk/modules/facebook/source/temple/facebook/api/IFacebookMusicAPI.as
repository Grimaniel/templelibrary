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
	import temple.facebook.service.IFacebookCall;
	/**
	 * API for handling music on Facebook
	 * 
	 * @see ../../../../readme.html Read me
	 * 
	 * @see temple.facebook.api.IFacebookAPI#music
	 * @see temple.facebook.api.FacebookAPI#music
	 * @see http://developers.facebook.com/docs/opengraph/music/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookMusicAPI
	{
		/**
		 * Get all the music likes of a user.
		 * 
		 * If successful, the result contains an Array with IFacebookLikeData objects.
		 * 
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param id the id of the user.
		 * @param offset the position of the first item in the list
		 * @param limit the maximum amount of items.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookLikeData
		 */
		function getLikes(callback:Function = null, id:String = 'me', offset:Number = NaN, limit:Number = NaN, params:Object = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Get all the music a user has listened.
		 * 
		 * If successful, the result contains an Array with IFacebookLikeData objects.
		 * 
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param id the id of the user.
		 * @param offset the position of the first item in the list
		 * @param limit the maximum amount of items.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookLikeData
		 */
		function getListens(callback:Function = null, id:String = 'me', offset:Number = NaN, limit:Number = NaN, params:Object = null, forceReload:Boolean = false):IFacebookCall;
		
		
		/**
		 * 
		 */
		function getPlaylist(id:String, callback:Function = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;
		
		/**
		 * 
		 */
		function getSong(id:String, callback:Function = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;
	}
}
