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
	import temple.facebook.data.enum.FacebookDisplayMode;
	import temple.facebook.service.IFacebookCall;
	
	/**
	 * API for Facebook Dialog windows.
	 * 
	 * @see ../../../../readme.html Read me
	 * 
	 * @see temple.facebook.api.IFacebookAPI#dialogs
	 * @see temple.facebook.api.FacebookAPI#dialogs
	 * @see http://developers.facebook.com/docs/reference/javascript/FB.ui/
	 * @see temple.facebook.data.enum.FacebookDisplayMode
	 * 
	 * @includeExample DialogsExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookDialogAPI
	{
		/**
		 * Default value for displayMode, when no explicit value is provided with a call.
		 */
		function get displayMode():FacebookDisplayMode;

		/**
		 * @private
		 */
		function set displayMode(value:FacebookDisplayMode):void;
		
		/**
		 * The Feed Dialog prompts the user to publish an individual story to a profile's feed. This does not require
		 * any extended permissions.
		 * 
		 * @param callback an optional function which is called when the request is completed. This function should
		 *	accept one, and only one, argument of type IFacebookResult
		 * @param to The ID or username of the profile that this story will be published to. If this is unspecified, it
		 * 	defaults to the the value of <code>from</code>.
		 * @param link The link attached to this post
		 * @param picture The URL of a picture attached to this post.
		 * @param source The URL of a media file (e.g., a SWF or video file) attached to this post. If both
		 * 	<code>source</code> and <code>picture</code> are specified, only <code>source</code> is used.
		 * @param name The name of the link attachment.
		 * @param caption The caption of the link (appears beneath the link name).
		 * @param description The description of the link (appears beneath the link caption).
		 * @param properties An object of key/value pairs which will appear in the stream attachment beneath the
		 * 	description, with each property on its own line. Keys must be strings, and values can be either strings or
		 * 	objects with the keys <code>text</code> and <code>href</code>.
		 * @param actions An array of action links which will appear next to the "Comment" and "Like" link under posts.
		 * 	Each action link should be represented as an object with keys <code>name</code> and <code>link</code>.
		 * @param ref A text reference for the category of feed post. This category is used in Facebook Insights to help
		 *  you measure the performance of different types of post.
		 * @param display (Optional) The type of dialog to show (page, iframe or popup).
		 * @param from The ID or username of the user posting the message. If this is unspecified, it defaults to the
		 * 	current user. If specified, it must be the ID of the user or of a page that the user administers.
		 * 
		 * @see http://developers.facebook.com/docs/reference/dialogs/feed/
		 */
		function feedDialog(callback:Function = null, to:String = null, link:String = null, picture:String = null, source:String = null, name:String = null, caption:String = null, description:String = null, properties:Object = null, actions:Object = null, ref:String = null, display:FacebookDisplayMode = null, from:String = null):IFacebookCall;

		/**
		 * @private
		 * 
		 * Prompt the user to add a friend. If the friend had previously sent a request to the user, then the dialog
		 * allows the user to confirm the friend instead of sending a new friend request.
		 * 
		 * @param id The ID or username of the target user to add as a friend.
		 * @param callback an optional function which is called when the request is completed. This function should
		 * 	accept one, and only one, argument of type IFacebookResult
		 * @param display (Optional) The type of dialog to show (page, iframe or popup).
		 * 
		 * @see http://developers.facebook.com/docs/reference/dialogs/friends/
		 */
		function friendsDialog(id:String, callback:Function = null, display:FacebookDisplayMode = null):IFacebookCall;

		/**
		 * @private
		 * 
		 * Prompt the user to grant permissions to your application. Use this dialog whenever your application needs to 
		 * request additional permissions from your users.
		 * 
		 * @param redirectUri The URL to redirect to after the user clicks a button in the dialog. The URL you specify
		 * 	must be a URL of with the same Base Domain as specified in your app's settings, a Canvas URL of the form
		 * 	https://apps.facebook.com/YOUR_APP_NAMESPACE or a Page Tab URL of the form
		 * 	https://www.facebook.com/PAGE_USERNAME/app_YOUR_APP_ID
		 * @param permissions A list of permission names which you would like the user to grant your application. Only
		 * the permissions which the user has not already granted your application will be shown.
		 * 
		 * @see http://developers.facebook.com/docs/reference/dialogs/oauth/
		 */
		function oauthDialog(redirectUri:String, permissions:Vector.<String> = null, display:FacebookDisplayMode = null):IFacebookCall;

		/**
		 * @private
		 * 
		 * The payment dialog prompts the user to buy more Facebook Credits or buy an item in a facebook canvas
		 * application. This feature does not require any extended permissions to implement, but does require a few 
		 * additional steps to get successfully up and running. This dialog is only supported in our Dialog page mode 
		 * via our Graph API, but is also available in our JavaScript SDK. It is not available in iframe, popup mode, or
		 *  mobile via our SDKs. Before you use the Pay Dialog you need to set up your appliction to use Facebook 
		 *  Credits by registering and associating your company, in addition to setting up your callback file according 
		 *  to the Credits API documentation.
		 * 
		 * TODO:
		 * 
		 * @see http://developers.facebook.com/docs/reference/dialogs/pay/
		 */
		function payDialog(display:FacebookDisplayMode = null):IFacebookCall;

		/**
		 * @private
		 * 
		 * Prompt the user to send a request to one or more friends. These requests must be managed and deleted by the 
		 * application that created them using the graph API.
		 * 
		 * @param message The request the receiving user will see. It appears as a question posed by the sending user. 
		 * 	The maximum length is 255 characters.
		 * @param to A user ID or username. This may or may not be a friend of the user. If this is specified, the user 
		 * 	will not have a choice of recipients. If this is omitted, the user will see a friend selector and will be 
		 * 	able to select a maximum of 50 recipients. (Due to URL length restrictions, the maximum number of recipients
		 * 	is 25 in IE7 and also in IE8+ when using a non-iframe dialog.)
		 * @param callback an optional function which is called when the request is completed. This function should 
		 * 	accept one, and only one, argument of type IFacebookResult
		 * @param filters Optional, which shows a selector that includes the ability for a user to browse all friends, 
		 * 	but also filter to friends using the application and friends not using the application. Can also be all, 
		 * 	app_users and app_non_users. This controls what set of friends the user sees if a friend selector is shown. 
		 * 	If all, app_users ,or app_non_users is specified, the user will only be able to see users in that list and 
		 * 	will not be able to filter to another list. Additionally, an application can suggest custom filters as 
		 * 	dictionaries with a name key and a user_ids key, which respectively have values that are a string and a list
		 * 	of user ids. name is the name of the custom filter that will show in the selector. user_ids is the list of 
		 * 	friends to include, in the order they are to appear.
		 * @param excludeIds A array of user IDs that will be excluded from the dialog.
		 * @param maxRecipients An integer that specifies the maximum number of friends that can be chosen by the user 
		 * 	in the friend selector.
		 * @param data Optional, additional data you may pass for tracking. This will be stored as part of the request 
		 * 	objects created.
		 * @param title Optional, the title for the friend selector dialog. Maximum length is 50 characters.
		 * @param display (Optional) The type of dialog to show (page, iframe or popup).
		 * 
		 * @see http://developers.facebook.com/docs/reference/dialogs/requests/
		 */
		function requestDialog(message:String, to:String = null, callback:Function = null, filters:Array = null, excludeIds:Array = null, maxRecipients:uint = 0, data:String = null, title:String = null, display:FacebookDisplayMode = null):IFacebookCall;

		/**
		 * The Send Dialog lets people to send content to specific friends. They’ll have the option to privately share a
		 * link as a Facebook message, Group post or email.
		 * 
		 * TODO
		 * 
		 * @see http://developers.facebook.com/docs/reference/dialogs/send/
		 */
		function sendDialog(display:FacebookDisplayMode = null):IFacebookCall;
	}
}
