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

package temple.facebook.data.vo
{
	import temple.facebook.data.enum.FacebookPermission;
	import temple.facebook.data.vo.AbstractFacebookFields;

	/**
	 * Fields object for posts.
	 * 
	 * <p>Set every propery you want to receive to true.</p>
	 * 
	 * @see temple.facebook.api.IFacebookAPI#posts
	 * @see temple.facebook.api.IFacebookPostAPI#getPosts()
	 * 
	 * @see temple.facebook.data.vo.IFacebookPostData
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookPostFields extends AbstractFacebookFields
	{
		/**
		 * The post ID
		 */
		public var id:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#from
		 */
		public var from:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#to
		 */
		public var to:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#message
		 */
		public var message:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#messageTags
		 */
		[Alias(graph="message_tags")]
		public var messageTags:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#picture
		 */
		public var picture:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#link
		 */
		public var link:Boolean;
		
		/**
		 * The name of the link
		 */
		public var name:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#caption
		 */
		public var caption:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#description
		 */
		public var description:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#source
		 */
		public var source:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#properties
		 */
		public var properties:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#icon
		 */
		public var icon:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#actions
		 */
		public var actions:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#privacy
		 */
		public var privacy:Boolean;
		
		/**
		 * A string indicating the type for this post (including link, photo, video)
		 */
		public var type:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#likes
		 */
		public var likes:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#comments
		 */
		public var comments:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#objectId
		 */
		[Alias(graph="object_id", fql="object_id")]
		public var objectId:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#object
		 */
		[Alias(graph="object_id", fql="object_id")]
		public var object:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#application
		 */
		public var application:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#created
		 */
		[Alias(graph="created_time", fql="created_time")]
		public var created:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#updated
		 */
		[Alias(graph="updated_time", fql="updated_time")]
		public var updated:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#updated
		 */
		[Alias(graph="type", fql="type")]
		public var postType:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPostData#targeting
		 */
		public var targeting:Boolean;
		
		public function FacebookPostFields(selectAll:Boolean = false)
		{
			super(selectAll);
		}
		
		override public function getPermissions(me:Boolean = true):Vector.<String>
		{
			if (privacy || comments || objectId || application || created || updated)
			{
				return Vector.<String>([FacebookPermission.READ_STREAM]);
			}
			return null;
			
			me;
		}
	}
}
