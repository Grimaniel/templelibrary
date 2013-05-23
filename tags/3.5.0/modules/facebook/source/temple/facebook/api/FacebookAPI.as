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
	import temple.common.events.PendingCallEvent;
	import temple.core.destruction.Destructor;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.facebook.adapters.IFacebookAdapter;
	import temple.facebook.data.IFacebookParser;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.enum.FacebookConstant;
	import temple.facebook.data.enum.FacebookDisplayMode;
	import temple.facebook.data.vo.FacebookAlbumData;
	import temple.facebook.data.vo.FacebookAppRequestData;
	import temple.facebook.data.vo.FacebookApplicationData;
	import temple.facebook.data.vo.FacebookApplicationFields;
	import temple.facebook.data.vo.FacebookCheckinData;
	import temple.facebook.data.vo.FacebookCommentData;
	import temple.facebook.data.vo.FacebookEventData;
	import temple.facebook.data.vo.FacebookFQLMultiQuery;
	import temple.facebook.data.vo.FacebookFriendRequestData;
	import temple.facebook.data.vo.FacebookGroupData;
	import temple.facebook.data.vo.FacebookLikeData;
	import temple.facebook.data.vo.FacebookMusicListenData;
	import temple.facebook.data.vo.FacebookPageData;
	import temple.facebook.data.vo.FacebookPageFields;
	import temple.facebook.data.vo.FacebookPhotoData;
	import temple.facebook.data.vo.FacebookPhotoTagData;
	import temple.facebook.data.vo.FacebookPostData;
	import temple.facebook.data.vo.FacebookUserData;
	import temple.facebook.data.vo.FacebookUserFields;
	import temple.facebook.data.vo.IFacebookApplicationData;
	import temple.facebook.data.vo.IFacebookFields;
	import temple.facebook.data.vo.IFacebookObjectData;
	import temple.facebook.data.vo.IFacebookProfileData;
	import temple.facebook.data.vo.IFacebookUserData;
	import temple.facebook.events.FacebookEvent;
	import temple.facebook.events.FacebookPermissionEvent;
	import temple.facebook.service.FacebookService;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	import flash.events.Event;

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
	 * Main entry point for communication with <a href="http://www.facebook.com" target="_blank">Facebook</a>.
	 * 
	 * <p>This FacebookAPI is based on the 
	 * <a href="http://code.google.com/p/facebook-actionscript-api/" target="_blank">Adobe ActionScript 3 SDK for 
	 * Facebook Platform API</a>, but with some big improvements, like:
	 * </p>
	 * <ul>
	 * 	<li><strong>Automatic Facebook login, with required permissions</strong></li>
	 * 	<li><strong>Strong typed result objects</strong></li>
	 * 	<li><strong>Detailed method calls</strong></li>
	 * 	<li><strong>Interface based, no Singletons</strong></li>
	 * 	<li><strong>Call caching</strong></li>
	 * 	<li><strong>Advanced object caching</strong></li>
	 * 	<li><strong>Usage of Callbacks <em>and</em> Events</strong></li>
	 * 	<li><strong>One API for several environments: web, mobile, desktop, standalone or Flash IDE</strong></li>
	 * 	<li><strong>Same result objects for both Graph and FQL calls</strong></li>
	 * </ul>
	 * 
	 * <strong>Automatic Facebook login</strong>
	 * <p>
	 * 	This feature is handled by the <code>FacebookService</code>. The <code>FacebookService</code> will check for
	 * 	each call if extended permissions are required. If there are permissions needed and the user didn't allow those
	 * 	permissions already, the <code>FacebookService</code> will automatically login with Facebook with the required
	 * 	permissions.
	 * </p>
	 * <p>
	 * 	After the login, the <code>FacebookService</code> will do the requested call. If the user already allowed the
	 * 	needed permissions, the login is skipped. By enabling the <code>autoPermissions</code> (enabled by default)
	 * 	the user only needs to accept the permissions right before the call is done and you (as developer) never have to
	 * 	digg into the documentation to figure out which permissions are required for the calls you need to do. You are
	 * 	still able to request for permissions manually using the <code>login</code> method.
	 * </p>
	 * 
	 * <strong>Strong typed result objects</strong>
	 * <p>
	 * 	The result data retreived from Facebook will automatically been parsed to strong typed object. This will make
	 * 	your code more neat and stable, and allows you to use auto-completion in your code editor.
	 * </p>
	 * 
	 * <strong>Detailed method calls</strong>
	 * <p>
	 * 	For almost every call the FacebookAPI has a build in method with the required and optional arguments. These
	 * 	methods also do some type checking and validation, which makes you application more strict and stable.
	 * </p>
	 * 
	 * <strong>Interface based, no Singletons</strong>
	 * <p>
	 * 	You can type almost every object as Interface and there is no Singleton implementation. Working with Interfaces
	 * 	results in cleaner code and can reduce filesize when you work with multiple SWF files.
	 * </p>
	 * 
	 * <strong>Call caching</strong>
	 * <p>
	 * 	The <code>FacebookService</code> has a build in caching system. If <code>cache</code> is enabled the
	 * 	<code>FacebookService</code> will retreive the data from it's cache instead of doing a new Facebook call when
	 * 	the call is done before. This will improve the speed and response time of your application. Ofcourse you are
	 * 	still able to force a Facebook call by setting <code>forceReload</code> to <code>true</code> which is one of the
	 * 	arguments in every GET-method.
	 * </p>
	 * 
	 * <strong>Advanced object caching</strong>
	 * <p>
	 * All Facebook object will be cached, in a local database, based on their id (which is unique) and are reused. The 
	 * <code>FacebookAPI</code> will never create the same Facebook Object again, but will reuse the object it already
	 * has. If Facebook provides more information, this information will be applied on this object. Reusing these
	 * objects doesn't only result in a faster application, but will also provide you with more information like you
	 * would expect with a normal Facebook call.   
	 * </p>
	 * 
	 * <strong>Usage of Callbacks <em>and</em> Events</strong>
	 * <p>
	 * 	As the 'regular' Facebook API only support callbacks, this FacebookAPI support callbacks and Events. Every
	 * 	method returns an <code>IFacebookCall</code> object which dispatches a <code>Event.COMPLETE</code> event when
	 * 	the call is completed.
	 * 	The FacebookService and FacebookAPI will dispatch a <code>PendingCallEvent.CALL</code> event when a call starts.
	 * 	The FacebookService and FacebookAPI will dispatch a <code>PendingCallEvent.RESULT</code> event when a call is
	 * 	completed.
	 * </p>
	 * <p>
	 *	The FacebookAPI also support callbacks. Every method has a <code>callback</code> argument of type
	 *	<code>Function</code>. The supplied function must accept one (and only one) argument of type
	 *	<code>IFacebookResult</code>. If a call succeeded, the <code>success</code> property of the result will be true,
	 *	if the call supplies data, the requested data is in the <code>data</code> property of the result. If the call
	 *	failed, the <code>success</code> property of the result will be false. The <code>code</code> or
	 *	<code>message</code> can contain more information about the failure.
	 * </p>
	 * <listing version="3.0">
	 * // getting the friends of the user, using a callback
	 * _facebook.friends.getFriends(onFriends);
	 * 	
	 * function onFriends(result:IFacebookResult):void
	 * {
	 * 	// Callback won't automatically been released when the object is destructed
	 * 	// So first we need to check if the currect object is still alive 
	 * 	if (isDestructed) return;
	 * 	
	 * 	if (result.success)
	 * 	{
	 * 		var friends:Vector.&lt;IFacebookUserData&gt; = Vector.&lt;IFacebookUserData&gt;(result.data);
	 * 	}
	 * 	else
	 * 	{
	 * 		Log.error("Getting friends failed: " + result.message);
	 * 	}
	 * } 
	 * </listing>
	 * <listing version="3.0">
	 * // getting the friends of the user, using events
	 * _facebook.friends.getFriends().addEventListener(Event.COMPLETE, handleFriendsComplete);
	 * 	
	 * function handleFriendsComplete(event:Event):void
	 * {
	 * 	var result:IFacebookResult = IFacebookResult(IFacebookCall(event.target).result);
	 * 	
	 * 	if (result.success)
	 * 	{
	 * 		var friends:Vector.&lt;IFacebookUserData&gt; = Vector.&lt;IFacebookUserData&gt;(result.data);
	 * 	}
	 * 	else
	 * 	{
	 * 		Log.error("Getting friends failed: " + result.message);
	 * 	}
	 * } 
	 * </listing>
	 * 
	 * <strong>One API for several environments: web, mobile, desktop, standalone or Flash IDE</strong>
	 * 
	 * <p>The <code>FacebookAPI</code> uses an adapter as middle layer between the <code>FacebookService</code> and the
	 * Facebook API by Adobe. By using a different adapter you can switch between different environments. For using in
	 * the web you should use the <code>FacebookAdapter</code>, for mobile the <code>FacebookMobileAdapter</code> 
	 * (available in the facebook-mobile module) and for desktop the <code>FacebookDesktopAdapter</code>
	 * (available in the facebook-desktop module).</p>
	 * 
	 * <p>It is also possible to connect with Facebook when running the SWF standalone or in the Flash IDE. Therefore
	 * you should use the <code>FacebookStandaloneAdapter</code> in combination with the
	 * <code>FacebookAccessTokenProvider</code></p><!-- TODO: add links -->
	 * 
	 * <strong>Same result objects for both Graph and FQL calls</strong>
	 * 
	 * <p>Since all objects from Facebook are converted to strong typed objects by the FacebookService, results from
	 * both the <code>Graph API</code> as <code>FQL</code> are the same. Facebook uses different naming for properties
	 * in FQL, but these are automatically converted by the <code>FacebookAPI</code>.</p>
	 * 
	 * @see ../../../../readme.html Read me
	 * 
	 * @see temple.facebook.service.FacebookService
	 * @see temple.facebook.service.IFacebookService
	 * 
	 * @includeExample FriendsExample.as
	 * @includeExample PhotosExample.as
	 * @includeExample DialogsExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookAPI extends CoreEventDispatcher implements IFacebookAPI
	{
		private var _service:IFacebookService;
		private var _photos:FacebookPhotoAPI;
		private var _events:FacebookEventAPI;
		private var _comments:FacebookCommentAPI;
		private var _friends:FacebookFriendAPI; 
		private var _posts:FacebookPostAPI;
		private var _dialogs:FacebookDialogAPI;
		private var _canvas:FacebookCanvasAPI;
		private var _checkins:FacebookCheckinAPI;
		private var _music:FacebookMusicAPI;
		private var _scores:FacebookScoreAPI;
		private var _openGraph:FacebookOpenGraphAPI;
		
		/**
		 * Create a new FacebookAPI.
		 * 
		 * <p>Allthough this is not a Singleton, you should create only one instance of the FacebookAPI
		 * since it uses the orginal Facebook class (where this FacebookAPI is based on) is a Singleton.</p>
		 * 
		 * @param adapter an IFacebookAdapter which is a wrapper around the "Adobe ActionScript 3 SDK for Facebook
		 * 	Platform API". There are different adaptars for web, desktop and mobile.
		 * @param autoPermissions is set to true, the FacebookService will automatically handle all Facebook permissions
		 * @param cache if set to true, all calls will be cached.
		 * 
		 * @example
		 * <listing version="3.0">
		 * var facebook:IFacebookAPI = new FacebookAPI(new FacebookAdapter(loaderInfo.url.indexOf('https:') != -1));
		 * facebook.init("application id");
		 * </listing>
		 * 
		 * @see temple.facebook.adapters.FacebookAdapter
		 */
		public function FacebookAPI(adapter:IFacebookAdapter, autoPermissions:Boolean = true, cache:Boolean = true)
		{
			_service = new FacebookService(adapter, autoPermissions, cache);
			_service.addEventListener(Event.INIT, dispatchEvent);
			_service.addEventListener(FacebookEvent.LOGIN, dispatchEvent);
			_service.addEventListener(FacebookEvent.LOGOUT, dispatchEvent);
			_service.addEventListener(FacebookPermissionEvent.ALLOWED, dispatchEvent);
			_service.addEventListener(FacebookPermissionEvent.DENIED, dispatchEvent);
			_service.addEventListener(FacebookPermissionEvent.UPDATE, dispatchEvent);
			_service.addEventListener(PendingCallEvent.CALL, dispatchEvent);
			_service.addEventListener(PendingCallEvent.RESULT, dispatchEvent);
			
			// Register VO's
			FacebookAlbumData.register(service);
			FacebookAppRequestData.register(service);
			FacebookApplicationData.register(service);
			FacebookCommentData.register(service);
			FacebookEventData.register(service);
			FacebookFriendRequestData.register(service);
			FacebookLikeData.register(service);
			FacebookPageData.register(service);
			FacebookPhotoData.register(service);
			FacebookPhotoTagData.register(service);
			FacebookPostData.register(service);
			FacebookUserData.register(service);
			FacebookCheckinData.register(service);
			FacebookMusicListenData.register(service);
			FacebookGroupData.register(service);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get service():IFacebookService
		{
			return _service;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get adapter():IFacebookAdapter
		{
			return _service.adapter;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get parser():IFacebookParser
		{
			return _service.parser;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get application():IFacebookApplicationData
		{
			return _service ? _service.application : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get permissions():Vector.<String>
		{
			return _service ? _service.permissions : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isInitialized():Boolean
		{
			return _service ? _service.isInitialized : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoggedIn():Boolean
		{
			return _service ? _service.isLoggedIn : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get permissionsLoaded():Boolean
		{
			return _service ? _service.permissionsLoaded : false;
		}

		/**
		 * @inheritDoc
		 */
		public function get accessToken():String
		{
			return _service ? _service.accessToken : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get signedRequest():String
		{
			return _service ? _service.signedRequest : null;
		}

		/**
		 * @inheritDoc
		 */
		public function get expireDate():Date
		{
			return _service ? _service.expireDate : null;
		}

		/**
		 * @inheritDoc
		 * 
		 * @see temple.facebook.api.IFacebookAPI#getUser()
		 */
		public function get me():IFacebookUserData
		{
			return  _service ? _service.me : null;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see temple.facebook.data.vo.IFacebookPhotoData
		 * @see temple.facebook.data.vo.IFacebookAlbumData
		 * 
		 * @includeExample PhotosExample.as
		 */
		public function get photos():IFacebookPhotoAPI
		{
			return _photos ||= new FacebookPhotoAPI(_service);
		}

		/**
		 * @inheritDoc
		 * 
		 * @see temple.facebook.data.vo.IFacebookEventData
		 */
		public function get events():IFacebookEventAPI
		{
			return _events ||= new FacebookEventAPI(_service);
		}

		/**
		 * @inheritDoc
		 * 
		 * @see temple.facebook.data.vo.IFacebookCommentData
		 */
		public function get comments():IFacebookCommentAPI
		{
			return _comments ||= new FacebookCommentAPI(_service);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see temple.facebook.data.vo.IFacebookUserData
		 * @see temple.facebook.data.vo.IFacebookFriendListData
		 * 
		 * @includeExample FriendsExample.as
		 */
		public function get friends():IFacebookFriendAPI
		{
			return _friends ||= new FacebookFriendAPI(_service);
		}

		/**
		 * @inheritDoc
		 * 
		 * @see temple.facebook.data.vo.IFacebookPostData
		 */
		public function get posts():IFacebookPostAPI
		{
			return _posts ||= new FacebookPostAPI(_service);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.ui/
		 * 
		 * @includeExample DialogsExample.as
		 */
		public function get dialogs():IFacebookDialogAPI
		{
			return _dialogs ||= new FacebookDialogAPI(_service);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see http://developers.facebook.com/docs/guides/canvas/
		 */
		public function get canvas():IFacebookCanvasAPI
		{
			return _canvas ||= new FacebookCanvasAPI(_service);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see http://developers.facebook.com/docs/guides/canvas/
		 * @see temple.facebook.data.vo.IFacebookCheckinData
		 */
		public function get checkins():IFacebookCheckinAPI
		{
			return _checkins ||= new FacebookCheckinAPI(_service);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see http://developers.facebook.com/docs/opengraph/music/
		 */
		public function get music():IFacebookMusicAPI
		{
			return _music ||= new FacebookMusicAPI(_service);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see http://developers.facebook.com/docs/score/
		 */
		public function get scores():IFacebookScoreAPI
		{
			return _scores ||= new FacebookScoreAPI(_service);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see https://developers.facebook.com/docs/concepts/opengraph/
		 */
		public function get openGraph():IFacebookOpenGraphAPI
		{
			return _openGraph ||= new FacebookOpenGraphAPI(_service);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.init
		 * @see http://www.facebook.com/developers/apps.php
		 */
		public function init(applicationId:String, callback:Function = null, accessToken:String = null):void
		{
			_service.init(applicationId, callback, accessToken);
		}
		
		/**
		 * @inheritDoc
		 */
		public function loadPolicyFiles():void
		{
			_service.loadPolicyFiles();
		}

		/**
		 * @inheritDoc
		 */
		public function login(callback:Function = null, permissions:Vector.<String> = null):IFacebookCall
		{
			return _service.login(callback, permissions);
		}
		
		/**
		 * @inheritDoc
		 */
		public function logout(callback:Function = null):IFacebookCall
		{
			return _service.logout(callback);
		}

		/**
		 * @inheritDoc
		 */
		public function get(callback:Function = null, method:String = null, id:String = 'me', objectClass:Class = null, params:Object = null, fields:IFacebookFields = null, forceReload:Boolean = false):IFacebookCall
		{
			return _service.get(callback, method, id, objectClass, params, fields, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObjects(ids:Vector.<String>, callback:Function = null, objectClass:Class = null, params:Object = null, fields:IFacebookFields = null, forceReload:Boolean = false):IFacebookCall
		{
			return _service.getObjects(ids, callback, objectClass, params, fields, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function post(method:String, callback:Function = null, id:String = 'me', params:Object = null, objectClass:Class = null):IFacebookCall
		{
			return _service.post(method, callback, id, params, objectClass);
		}

		/**
		 * @inheritDoc
		 */
		public function ui(method:String, data:Object, callback:Function = null, display:FacebookDisplayMode = null):IFacebookCall
		{
			return _service.ui(method, data, callback, display);
		}
		
		/**
		 * @inheritDoc
		 */
		public function deleteObject(method:String, callback:Function = null, id:String = 'me', params:Object = null):IFacebookCall
		{
			return _service.deleteObject(method, callback, id, params);
		}
		
		/**
		 * @inheritDoc
		 */
		public function fql(query:String, callback:Function = null, objectClass:Class = null, fields:IFacebookFields = null, id:String = null):IFacebookCall
		{
			return _service.fql(query, callback, objectClass, fields, id);
		}
		
		/**
		 * @inheritDoc
		 */
		public function fqlMultiQuery(queries:FacebookFQLMultiQuery, callback:Function = null):IFacebookCall
		{
			return _service.fqlMultiQuery(queries, callback);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getImageUrl(id:String, size:String = null):String
		{
			return _service.getImageUrl(id, size);
		}

		/**
		 * @private
		 */
		public function registerVO(method:String, voClass:Class):void
		{
			_service.registerVO(method, voClass);
		}

		/**
		 * @inheritDoc
		 */
		public function get cache():Boolean
		{
			return _service.cache;
		}

		/**
		 * @inheritDoc
		 */
		public function set cache(value:Boolean):void
		{
			_service.cache = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isAllowed(permission:String):int
		{
			return _service.isAllowed(permission);
		}
		
		/**
		 * @inheritDoc
		 */
		public function areAllowed(permissions:Vector.<String>):Boolean
		{
			return _service.areAllowed(permissions);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAllowedPermissions():Vector.<String>
		{
			return _service.getAllowedPermissions();
		}

		/**
		 * @inheritDoc
		 */
		public function get requiredPermissionsAllowed():Boolean
		{
			return _service ? _service.requiredPermissionsAllowed : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPermissions(callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			return _service.get(callback, FacebookConnection.PERMISSIONS, FacebookConstant.ME, null, null, null, forceReload);
		}
		
				/**
		 * @inheritDoc
		 */
		public function getObject(id:String, createIfNull:Boolean = false, type:Class = null):IFacebookObjectData
		{
			if (id == null) return throwError(new TempleArgumentError(this, "id cannot be null"));
			return _service.getObject(id, createIfNull, type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getProfile(id:String, createIfNull:Boolean = false):IFacebookProfileData
		{
			if (id == null) return throwError(new TempleArgumentError(this, "id cannot be null"));
			return _service.getProfile(id, createIfNull);
		}

		
		/**
		 * @inheritDoc
		 */
		public function getApplicationData(callback:Function = null, fields:FacebookApplicationFields = null, forceReload:Boolean = false):IFacebookCall
		{
			return _service.get(callback, null, application.id, FacebookApplicationData, null, fields, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getUser(callback:Function = null, id:String = 'me', fields:FacebookUserFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return _service.get(callback, null, id, FacebookUserData, params, fields, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getUsers(ids:Vector.<String>, callback:Function = null, fields:FacebookUserFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return _service.getObjects(ids, callback, FacebookUserData, params, fields, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPage(id:String, callback:Function = null, fields:FacebookPageFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return _service.get(callback, null, id, FacebookPageData, params, fields, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function like(id:String, callback:Function = null):IFacebookCall
		{
			return _service.post(FacebookConnection.LIKES, callback, id);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLike(id:String, callback:Function = null, user:String = 'me', forceReload:Boolean = false):IFacebookCall
		{
			return _service.get(callback, FacebookConnection.LIKES + "/" + id, user, FacebookLikeData, null, null, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAppRequests(callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			return _service.get(callback, FacebookConnection.APPREQUESTS, FacebookConstant.ME, FacebookAppRequestData, null, null, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getUnparsedResult(data:Object):Object
		{
			return _service.getUnparsedResult(data);
		}

		/**
		 * @inheritDoc
		 */
		public function getRawResult(data:Object):Object
		{
			return _service.getRawResult(data);
		}

		/**
		 * @inheritDoc
		 */
		public function hasNext(data:Object):Boolean
		{
			return _service.hasNext(data);
		}

		/**
		 * @inheritDoc
		 */
		public function hasPrevious(data:Object):Boolean
		{
			return _service.hasPrevious(data);
		}

		/**
		 * @inheritDoc
		 */
		public function nextPage(data:Object, callback:Function):IFacebookCall
		{
			return _service.nextPage(data, callback);
		}

		/**
		 * @inheritDoc
		 */
		public function previousPage(data:Object, callback:Function):IFacebookCall
		{
			return _service.previousPage(data, callback);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _service.debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_service.debug = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_service = Destructor.destruct(_service);
			_photos = Destructor.destruct(_photos);
			_events = Destructor.destruct(_events);
			_comments = Destructor.destruct(_comments);
			_friends = Destructor.destruct(_friends);
			_posts = Destructor.destruct(_posts);
			_dialogs = Destructor.destruct(_dialogs);
			_canvas = Destructor.destruct(_canvas);
			_checkins = Destructor.destruct(_checkins);
			_music = Destructor.destruct(_music);
			_scores = Destructor.destruct(_scores);
			_openGraph = Destructor.destruct(_openGraph);
			
			super.destruct();
		}
	}
}
