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
	import temple.facebook.data.vo.FacebookApplicationFields;
	import temple.facebook.data.vo.FacebookPageFields;
	import temple.facebook.data.vo.FacebookUserFields;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;
	
	/**
	 * Dispatched when the user is logged in into Facebook.
	 * 
	 * @eventType temple.facebook.events.FacebookEvent.LOGIN
	 */
	[Event(name = "FacebookEvent.login", type = "temple.facebook.events.FacebookEvent")]

	/**
	 * Dispatched when the user logs out from Facebook.
	 * 
	 * @eventType temple.facebook.events.FacebookEvent.LOGOUT
	 */
	[Event(name = "FacebookEvent.logout", type = "temple.facebook.events.FacebookEvent")]

	/**
	 * Dispatched when the FacebookService is initialized
	 * 
	 * @eventType flash.events.Event.INIT
	 */
	[Event(name = "init", type = "flash.events.Event")]

	/**
	 * Dispatched when the user allowes some permissions
	 * 
	 * @eventType temple.facebook.events.FacebookPermissionEvent.ALLOWED
	 */
	[Event(name = "FacebookPermissionEvent.allowed", type = "temple.facebook.events.FacebookPermissionEvent")]

	/**
	 * Dispatched when the user denies some permissions
	 * 
	 * @eventType temple.facebook.events.FacebookPermissionEvent.DENIED
	 */
	[Event(name = "FacebookPermissionEvent.denied", type = "temple.facebook.events.FacebookPermissionEvent")]

	/**
	 * Dispatched when the allowed permissions are updated
	 * 
	 * @eventType temple.facebook.events.FacebookPermissionEvent.UPDATE
	 */
	[Event(name = "FacebookPermissionEvent.update", type = "temple.facebook.events.FacebookPermissionEvent")]
	
	/**
	 * Use this Interface for typing the FacebookAPI.
	 * 
	 * @see ../../../../readme.html Read me
	 * 
	 * @see FacebookAPI
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookAPI extends IFacebookService
	{
		/**
		 * Returns a reference to the service
		 */
		function get service():IFacebookService;
		
		/**
		 * This API contains all methods related to photos and photo albums.
		 * 
		 * @see temple.facebook.data.vo.IFacebookPhotoData
		 * @see temple.facebook.data.vo.IFacebookAlbumData
		 * 
		 * @includeExample PhotosExample.as
		 */
		function get photos():IFacebookPhotoAPI;

		/**
		 * This API contains all methods related to events.
		 * 
		 * @see temple.facebook.data.vo.IFacebookEventData
		 */
		function get events():IFacebookEventAPI;

		/**
		 * This API contains all methods related to comments.
		 * 
		 * @see temple.facebook.data.vo.IFacebookCommentData
		 */
		function get comments():IFacebookCommentAPI;

		/**
		 * This API contains all methods related to friends, friendLists and other Facebook users.
		 * 
		 * @see temple.facebook.data.vo.IFacebookUserData
		 * @see temple.facebook.data.vo.IFacebookFriendListData
		 * 
		 * @includeExample FriendsExample.as
		 */
		function get friends():IFacebookFriendAPI;

		/**
		 * This API contains all methods related to post.
		 * 
		 * @see temple.facebook.data.vo.IFacebookPostData
		 */
		function get posts():IFacebookPostAPI;

		/**
		 * This API contains all methods for displaying special Facebook Dialog windows.
		 * 
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.ui/
		 * 
		 * @includeExample DialogsExample.as
		 */
		function get dialogs():IFacebookDialogAPI;

		/**
		 * This API contains all methods related to the canvas.
		 * 
		 * @see http://developers.facebook.com/docs/guides/canvas/
		 */
		function get canvas():IFacebookCanvasAPI;

		/**
		 * This API contains all methods related to checkins.
		 * 
		 * @see http://developers.facebook.com/docs/guides/canvas/
		 * @see temple.facebook.data.vo.IFacebookCheckinData
		 */
		function get checkins():IFacebookCheckinAPI;

		/**
		 * This API contains all methods related to music.
		 * 
		 * @see http://developers.facebook.com/docs/opengraph/music/
		 */
		function get music():IFacebookMusicAPI;

		/**
		 * This API contains all methods related to scores.
		 * 
		 * @see http://developers.facebook.com/docs/score/
		 */
		function get scores():IFacebookScoreAPI;

		/**
		 * This API contains logic for using Open Graph
		 * 
		 * @see https://developers.facebook.com/docs/concepts/opengraph/
		 */
		function get openGraph():IFacebookOpenGraphAPI;

		/**
		 * Gets the allowed permissions.
		 */
		function getPermissions(callback:Function = null, forceReload:Boolean = true):IFacebookCall;
		
		/**
		 * Load the data (<code>IFacebookApplicationData</code>) of the application from Facebook.
		 * 
		 * @see temple.facebook.data.vo.IFacebookApplicationData
		 */
		function getApplicationData(callback:Function = null, fields:FacebookApplicationFields = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Get the data of a specific user from Facebook.
		 * 
		 * <p>If successful, the result contains an IFacebookUserData object.</p>
		 * 
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param id the id of the user.
		 * @param fields a FacebookUserFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookUserData
		 */
		function getUser(callback:Function = null, id:String = 'me', fields:FacebookUserFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;
		
		/**
		 * Get multiple users with one call
		 */
		function getUsers(ids:Vector.<String>, callback:Function = null, fields:FacebookUserFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Get the data of a specific page from Facebook.
		 * 
		 * <p>If successful, the result contains an IFacebookPageData object.</p>
		 * 
		 * @param id the id of the page.
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param fields a FacebookPageFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookUserData
		 */
		function getPage(id:String, callback:Function = null, fields:FacebookPageFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Like the given object (if it has a /likes connection).
		 */
		function like(id:String, callback:Function = null):IFacebookCall;
		
		/**
		 * Checks if the user liked an object. If the user liked the object, the <code>IFacebookLikeData</code> is
		 * returned with the result. Otherwise null is returned with the result. 
		 */
		function getLike(id:String, callback:Function = null, user:String = 'me', forceReload:Boolean = false):IFacebookCall;

		/**
		 * Gets all application requests for the current user for this application.
		 */
		function getAppRequests(callback:Function = null, forceReload:Boolean = false):IFacebookCall;
	}
}