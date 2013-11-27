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
	/**
	 * Stores the data of a Facebook post or a status message.
	 * 
	 * @see temple.facebook.api.IFacebookAPI#posts
	 * @see temple.facebook.data.vo.IFacebookUserData#posts
	 * @see temple.facebook.data.vo.IFacebookUserData#statuses
	 * 
	 * @see http://developers.facebook.com/docs/reference/api/post/
	 * @see http://developers.facebook.com/docs/reference/api/status/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookPostData extends IFacebookLocatedData
	{
		/**
		 * Information about the user who posted the message
		 */
		function get from():IFacebookProfileData;
		
		/**
		 * Profiles mentioned or targeted in this post
		 */
		function get to():Vector.<IFacebookProfileData>;

		/**
		 * The message
		 */
		function get message():String;

		/**
		 * Tags used in the message
		 */
		function get messageTags():Vector.<IFacebookTagData>;
		
		/**
		 * Objects (Users, Pages, etc) tagged as being with the publisher of the post ("Who are you with?" on Facebook)
		 */
		function get withTags():Vector.<IFacebookProfileData>;
		
		/**
		 * If available, a link to the picture included with this post
		 */
		function get picture():String;
		
		/**
		 * The link attached to this post
		 */
		function get link():String;

		/**
		 * The caption of the link
		 */
		function get caption():String;
		
		/**
		 * A description of the link
		 */
		function get description():String;
		
		/**
		 * A URL to a Flash movie or video file to be embedded within the post
		 */
		function get source():String;
		
		/**
		 * A list of properties for an uploaded video, for example, the length of the video
		 * TODO: convert to Vector
		 */
		function get properties():Array;

		/**
		 * A link to an icon representing the type of this post
		 */
		function get icon():String;
		
		/**
		 * A list of available actions on the post (including commenting, liking, and an optional app-specified action)
		 * TODO: convert to Vector
		 */
		function get actions():Array;
		
		/**
		 * The privacy settings of the Post
		 */
		function get privacy():Object;
		
		/**
		 * Likes for this post
		 */
		function get likes():Vector.<IFacebookUserData>;
		
		/**
		 * Comments for this post
		 */
		function get comments():Vector.<IFacebookCommentData>;

		/**
		 * The Facebook object for an uploaded photo or video
		 */
		function get object():IFacebookObjectData;

		/**
		 * The Facebook object id for an uploaded photo or video
		 */
		function get objectId():String;
		
		/**
		 * Information about the application this post came from
		 */
		function get application():IFacebookApplicationData;

		/**
		 * The time the post was initially published
		 */
		function get created():Date;

		/**
		 * The time of the last comment on this post
		 */
		function get updated():Date;

		/**
		 * Location and language restrictions for Page posts only
		 */
		function get targeting():Object;

		/**
		 * A string indicating the type for this post 
		 */
		function get postType():String;
	}
}
