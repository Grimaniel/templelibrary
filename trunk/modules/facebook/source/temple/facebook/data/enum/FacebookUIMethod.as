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

package temple.facebook.data.enum
{
	/**
	 * This class contains the possible methods for the <code>IFacebookDialogAPI</code>.
	 * 
	 * @see temple.facebook.api.FacebookAPI#dialogs
	 * @see temple.facebook.api.IFacebookDialogAPI
	 * @see http://developers.facebook.com/docs/reference/javascript/FB.ui/
	 * 
	 * @author Thijs Broerse
	 */
	public final class FacebookUIMethod
	{
		/**
		 * Prompt the user to publish an individual story to a profile's feed. This does not require any extended permissions.
		 */
		public static const FEED_DIALOG:String = "feed";
		
		/**
		 * Prompt the user to add a friend. If the friend had previously sent a request to the user, then the dialog allows the user to confirm the friend instead of sending a new friend request.
		 */
		public static const FRIENDS_DIALOG:String = "friends";
		
		/**
		 * Prompt the user to grant permissions to your application.
		 */
		public static const OAUTH_DIALOG:String = "oauth";
		
		/**
		 * Prompt the user to buy more Facebook Credits or buy an item in an app. This does not require any extended permissions. This dialog is only supported in page mode and JS SDK. It is not available in iframe or popup mode, neither on mobile phone. Before you use the Pay Dialog you need to set up your app to use Facebook Credits and make your callback URL work following the Credits API documentation.
		 */
		public static const PAY_DIALOG:String = "pay";
		
		/**
		 * Prompt the user to send a request to one or more friends. These requests must be managed and deleted by the application that created them using the graph API.
		 */
		public static const REQUESTS_DIALOG:String = "apprequests";

		/**
		 * The Send Dialog lets people to send content to specific friends. They’ll have the option to privately share a link as a Facebook message, Group post or email.
		 */
		public static const SEND_DIALOG:String = "send";
	}
}
