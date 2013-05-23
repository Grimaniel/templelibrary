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
	 * @see http://developers.facebook.com/docs/score/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookScoreAPI
	{
		/**
		 * The application AccessToken. Note: this is NOT the same as a user AccessToken.
		 * 
		 * To obtain an App Access Token, perform an HTTP GET on:
		 * 
		 * https://graph.facebook.com/oauth/access_token?client_id=YOUR_APP_ID&amp;client_secret=YOUR_APP_SECRET&amp;grant_type=client_credentials
		 * 
		 * @see http://developers.facebook.com/docs/authentication/applications/
		 */
		function get appAccessToken():String

		/**
		 * @private
		 */
		function set appAccessToken(value:String):void;

		/**
		 * Read the scores for a user for your app.
		 * 
		 * <p>If the user has granted your app with the user_games_activity permission then this api will give you latest
		 * scores for all apps for that user. Otherwise it will give you scores only for your app.
		 * The friends_games_activity permission will enable you to access scores for users' friends for all apps by
		 * issuing an HTTP GET request to /FRIEND_ID/scores.</p>
		 */
		function getScore(callback:Function, userId:String = "me", forceReload:Boolean = false):IFacebookCall;
		
		/**
		 * Create or update a score for a user.
		 * 
		 * Note: <code>appAccessToken</code> must be set first!
		 * 
		 * @see #appAccessToken
		 */
		function post(score:int, callback:Function = null, userId:String = "me"):IFacebookCall;
	}
}
