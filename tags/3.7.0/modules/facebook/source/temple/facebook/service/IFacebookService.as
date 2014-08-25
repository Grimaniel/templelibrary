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
	import temple.facebook.adapters.IFacebookAdapter;
	import temple.core.debug.IDebuggable;
	import temple.core.events.ICoreEventDispatcher;
	import temple.data.cache.ICacheable;
	import temple.facebook.data.IFacebookParser;
	import temple.facebook.data.enum.FacebookDisplayMode;
	import temple.facebook.data.vo.FacebookFQLMultiQuery;
	import temple.facebook.data.vo.IFacebookApplicationData;
	import temple.facebook.data.vo.IFacebookFields;
	import temple.facebook.data.vo.IFacebookObjectData;
	import temple.facebook.data.vo.IFacebookProfileData;
	import temple.facebook.data.vo.IFacebookUserData;

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
	 * Interface for the <code>FacebookService</code>
	 * 
	 * @see FacebookService;
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookService extends IDebuggable, ICacheable, ICoreEventDispatcher
	{
		/**
		 * Returns a reference to the <code>IFacebookAdapter</code>
		 */
		function get adapter():IFacebookAdapter;
		
		/**
		 * Returns the Application data, but only if this is loaded first using the <code>getApplicationData()</code>
		 * method this object will be filled.
		 */
		function get application():IFacebookApplicationData;
		
		/**
		 * List of requested permissions. You can add more permissions by simply pushing these permissions to the list.
		 * 
		 * @example
	  	 * <listing version="3.0">
	 	 * _facebookAPI.permissions.push(FacebookPermission.PUBLISH_STREAM);
	 	 * </listing>
	 	 * 
	 	 * @see temple.facebook.data.enum.FacebookPermission
		 */
		function get permissions():Vector.<String>;
		
		/**
		 * List of optional permissions. You can add more permissions by simply pushing these permissions to the list.
		 * 
		 * <p>Optional permissions are only asked for when one or more of the other permissions is asked. If all other
		 * permissions are already allowed, the optional permissions are ignored.</p>
		 * 
		 * @example
	 	 * <listing version="3.0">
	 	 * _facebookAPI.optionalPermissions.push(FacebookPermission.PUBLISH_STREAM);
	 	 * </listing>
	 	 * 
	 	 * @see temple.facebook.data.enum.FacebookPermission
		 */
		function get optionalPermissions():Vector.<String>;
		
		/**
		 * A Boolean which indicates if the service is already initialized and ready to use.
		 * Calls done before the service is initialized are queued and executed after initialization.
		 * An <code>Event.INIT</code> will be dispatched when the service is initialized.
		 */
		function get isInitialized():Boolean;

		/**
		 * A Boolean which indicates if the user is logged in to Facebook.
		 * Note: this Boolean is only set after initialization. So check <code>isInitialized()</code> first!
		 * A <code>FacebookEvent.LOGIN</code> will be dispatch when the user is logged in.
		 */
		function get isLoggedIn():Boolean;

		/**
		 * A Boolean which indicates if the permissions have been loaded at least once.
		 */
		function get permissionsLoaded():Boolean;
		
		/**
		 * @copy com.facebook.graph.data.FacebookAuthResponse#accessToken
		 */
		function get accessToken():String;

		/**
		 * @copy com.facebook.graph.data.FacebookAuthResponse#signedRequest
		 */
		function get signedRequest():String;
		
		/**
		 * @copy com.facebook.graph.data.FacebookAuthResponse#expireDate
		 */
		function get expireDate():Date;
		
		/**
		 * Returns a reference to the current Facebook user. Only when the user is logged in. When the user isn't loaded
		 * using the <code>getUser()</code> method, the properties of the user might be empty.
		 * 
		 * @see temple.facebook.api.IFacebookAPI#getUser()
		 */
		function get me():IFacebookUserData;
		
		/**
		 * Parses the untyped results from Facebook to typed objects.
		 */
		function get parser():IFacebookParser;

		/**
		 * Initializes Facebook
		 * 
		 * @param applicationId The application ID you created at http://www.facebook.com/developers/apps.php
		 * @param accessToken A valid Facebook access token. If you have a previously saved access token, you can pass
		 * it in here.
		 * 
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.init
		 * @see http://www.facebook.com/developers/apps.php
		 */
		function init(applicationId:String, callback:Function = null, accessToken:String = null):void;

		/**
		 * Loads the Facebook PolicyFiles (crossdomains.xml). Needed if you want to smooth, cache or draw Facebook images.
		 * You only need to call this once. 
		 */
		function loadPolicyFiles():void;

		/**
		 * Login into Facebook.
		 * @see http://developers.facebook.com/docs/authentication/permissions/
		 */
		function login(callback:Function = null, permissions:Vector.<String> = null):IFacebookCall;

		/**
		 * Logout from Facebook.
		 * Clears cache and kills all queued call.
		 */
		function logout(callback:Function = null):IFacebookCall;

		/**
		 * Get data from Facebook.
		 * @param callback a function that must be called when the data is retreived from Facebook and parsed.
		 * Note: this function must accept one, and only one, argument of type IFacebookResult.
		 * @param method the Facebook method to call
		 * 	@see temple.facebook.data.enum.FacebookConnection
		 * @param id and optional ID of the object which must be get
		 * @param objectClass an optional class which is used for parsing the data to. This class must implement
		 * IObjectParsable. This class can also be provided using the registerVO method.
		 * @param params an optional object for extra parameters
		 * @param fields an object which defines which fields must be returned. This fields object is also used for
		 * automatically permissions retrieving.
		 * @param forceReload if set to true, the service will always reload the requested data, even when cache is
		 * enabled.
		 * 
		 * @see temple.facebook.data.enum.FacebookConnection
		 */
		function get(callback:Function = null, method:String = null, id:String = 'me', objectClass:Class = null, params:Object = null, fields:IFacebookFields = null, forceReload:Boolean = false):IFacebookCall;
		
		/**
		 * Get multiple objects wiht one call
		 */
		function getObjects(ids:Vector.<String>, callback:Function = null, objectClass:Class = null, params:Object = null, fields:IFacebookFields = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Post data to Facebook.
		 * 
		 * @see temple.facebook.data.enum.FacebookConnection
		 */
		function post(method:String, callback:Function = null, id:String = 'me', params:Object = null, objectClass:Class = null):IFacebookCall;

		/**
		 * Deletes an object from Facebook.
		 * The current user must have granted extended permission to delete the corresponding object, or an error will
		 * be returned.
		 *
		 * @param method The ID and connection of the object to delete.
		 * For example, /POST_ID/like to remove a like from a message.
		 *
		 * @see http://developers.facebook.com/docs/api#deleting
		 * @see com.facebook.graph.net.FacebookDesktop#api()
		 */
		function deleteObject(method:String, callback:Function = null, id:String = 'me', params:Object = null):IFacebookCall;
		
		/**
		 * Executes an FQL query on api.facebook.com
		 * 
		 * @param query the FQL query to call on Facebook
		 * @param callback a callback method which is called when the FQL is finished
		 * @param objectClass a class which is used for parsing the result
		 * @param fields an object which defines which fields must be returned. This fields object is only used for
		 * automatically permissions retrieving. The fields you actually want to be in the return value muste be added
		 * in the FQL query.
		 * @param id used to retreive the correct permissions from the fields object
		 * 
		 * @see http://developers.facebook.com/docs/reference/fql/
		 */
		function fql(query:String, callback:Function = null, objectClass:Class = null, fields:IFacebookFields = null, id:String = null):IFacebookCall;

		function fqlMultiQuery(queries:FacebookFQLMultiQuery, callback:Function = null):IFacebookCall;
		
		/**
		 * Shows a Facebook sharing dialog.
		 *
		 * @param method The related method for this dialog (ex. stream.publish).
		 * @param data Data to pass to the dialog, date will be JSON encoded.
		 * @param callback (Optional) Method to call when complete
		 * @param display (Optional) The type of dialog to show (page, iframe or popup).
		 * 
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.ui
		 * @see temple.facebook.data.enum.FacebookUIMethod
		 * @see temple.facebook.data.enum.FacebookDisplayMode
		 */
		function ui(method:String, data:Object, callback:Function = null, display:FacebookDisplayMode = null):IFacebookCall

		/**
	     * Utility method to format a picture URL, in order to load an image from Facebook.
	     *
	     * @param id The ID you wish to load an image from.
	     * @param type The size of image to display from Facebook (square, small, or large).
	     *
	     * @see http://developers.facebook.com/docs/api#pictures
	     * @see temple.facebook.data.enum.FacebookPictureSize
	     */
		function getImageUrl(id:String, size:String = null):String;
		
		/**
		 * Registers a Data Value Object Class to a specific call
		 */
		function registerVO(method:String, voClass:Class):void;
		
		/**
		 * Checks if a specific permission is allowed.
		 * 
		 * Returns 1 of the permission is allowed.
		 * Returns 0 of the permission is not allowed.
		 * Returns -1 if it is not known if the permission is allowed.
		 * 
		 * @param permission the permission to check
		 */
		function isAllowed(permission:String):int;

		/**
		 * Checks if a these permissions are allowed. If (at least) one of the permissions isn't allowed, the method
		 * returns false.
		 */
		function areAllowed(permissions:Vector.<String>):Boolean;

		/**
		 * Returns a list with all allowed permissions
		 */
		function getAllowedPermissions():Vector.<String>;

		/**
		 * Checks if all permissions, pushed in <code>permissions</code> are allowed.
		 * 
		 * @see #permissions
		 */
		function get requiredPermissionsAllowed():Boolean;
		
		/**
		 * Returns a IFacebookObjectData with a specific ID, if this object is loaded before.
		 * If you specify a type, the object can be created on the fly.
		 * 
		 * @param id the id of the object
		 * @param createIfNull if set to true, the object will be created when if doesn't exists
		 * @param type the type of the object. This is needed when the object must be created on the fly.
		 */
		function getObject(id:String, createIfNull:Boolean = false, type:Class = null):IFacebookObjectData;
		
		/**
		 * Returns a IFacebookProfileData with a specific ID, if this object is loaded before.
		 * 
		 * @param id the id of the profile
		 * @param createIfNull if set to true, the object will be created when if doesn't exists
		 */
		function getProfile(id:String, createIfNull:Boolean = false):IFacebookProfileData;
		
		/**
		 * If set to true the service will do an extra call to check the allowed permissions.
		 */
		function get checkPermissionsAfterLogin():Boolean;

		/**
		 * @private
		 */
		function set checkPermissionsAfterLogin(value:Boolean):void;
		
		/**
		 * Returns a reference to unparsed result related to the (parsed) data.
		 */
		function getUnparsedResult(data:Object):Object;
		
		/**
		 * Returns a reference to the entire raw object Facebook returns (including paging, etc.).
		 *
		 * @param data The result object.
		 *
		 * @see http://developers.facebook.com/docs/api#reading
		 */
		function getRawResult(data:Object):Object;
		
		/**
		 * Asks if another page exists
		 * after this result object.
		 *
		 * @param data The result object.
		 *
		 * @see http://developers.facebook.com/docs/api#reading
		 */
		function hasNext(data:Object):Boolean;
		
		/**
		 * Asks if a page exists before this result object.
		 *
		 * @param data The result object.
		 *
		 * @see http://developers.facebook.com/docs/api#reading
		 */
		function hasPrevious(data:Object):Boolean;
		
		/**
		 * Retrieves the next page that is associated with result object passed in.
		 *
		 * @param data The result object.
		 * @param callback a function that must be called when the data is retreived from Facebook and parsed.
		 * Note: this function must accept one, and only one, argument of type IFacebookResult.
		 * 
		 * @see com.facebook.graph.net.FacebookDesktop#request()
		 * @see http://developers.facebook.com/docs/api#reading
		 */
		function getNext(data:Object, callback:Function):IFacebookCall;
		
		/**
		 * Retrieves the previous page that is associated with result object passed in.
		 *
		 * @param data The result object.
		 * @param callback a function that must be called when the data is retreived from Facebook and parsed.
		 * Note: this function must accept one, and only one, argument of type IFacebookResult.
		 *
		 * @see com.facebook.graph.net.FacebookDesktop#request()
		 * @see http://developers.facebook.com/docs/api#reading
		 */
		function getPrevious(data:Object, callback:Function):IFacebookCall;
	}
}
