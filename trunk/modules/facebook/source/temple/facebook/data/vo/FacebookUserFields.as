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
	
	/**
	 * Fields object for users.
	 * 
	 * <p>Set every propery you want to receive to true. Note: you will only receive the property if the user has filled in
	 * the property!</p>
	 * 
	 * @see temple.facebook.api.IFacebookAPI#getUser()
	 * @see temple.facebook.api.IFacebookAPI#friends
	 * @see temple.facebook.api.IFacebookFriendAPI#getFriends()
	 * @see temple.facebook.data.vo.IFacebookUserData
	 * @see http://developers.facebook.com/docs/reference/api/user/
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookUserFields extends AbstractFacebookFields
	{
		/**
		 * The user's Facebook ID
		 */
		[Alias(fql="uid")]
		public var id:Boolean;
		
		/**
		 * The user's full name
		 */
		public var name:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#firstName
		 */
		[Alias(graph="first_name", fql="first_name")]
		public var firstName:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#middleName
		 */
		[Alias(graph="middle_name", fql="middle_name")]
		public var middleName:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#lastName
		 */
		[Alias(graph="last_name", fql="last_name")]
		public var lastName:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#username
		 */
		public var username:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#gender
		 */
		[Alias(fql="sex")]
		public var gender:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#locale
		 */
		public var locale:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#languages
		 */
		public var languages:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#link
		 */
		[Alias(fql="not-available")]
		public var link:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#thirdPartyId
		 */
		[Alias(graph="third_party_id")]
		public var thirdPartyId:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#timezone
		 */
		public var timezone:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#updated
		 */
		[Alias(fql="not-available", graph="updated_time")]
		public var updated:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#verified
		 */
		public var verified:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#about
		 */
		[Alias(fql="about_me")]
		public var about:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#bio
		 */
		[Alias(fql="not-available")]
		public var bio:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#birthday
		 */
		[Alias(fql="birthday_date")]
		public var birthday:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#education
		 */
		[Alias(fql="education_history")]
		public var education:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#email
		 */
		public var email:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#hometown
		 */
		[Alias(fql="hometown_location")]
		public var hometown:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#interestedIn
		 */
		[Alias(graph="interested_in", fql="interests")]
		public var interestedIn:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#location
		 */
		[Alias(fql="current_location")]
		public var location:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#political
		 */
		public var political:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#favoriteTeams
		 */
		[Alias(graph="favorite_teams")]
		public var favoriteTeams:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#quotes
		 */
		public var quotes:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#relationshipStatus
		 */
		[Alias(graph="relationship_status")]
		public var relationshipStatus:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#religion
		 */
		public var religion:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#significantOther
		 */
		[Alias(graph="significant_other", fql="significant_other_id")]
		public var significantOther:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#videoUploadLimits
		 */
		[Alias(graph="video_upload_limits")]
		public var videoUploadLimits:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#website
		 */
		public var website:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#work
		 */
		public var work:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#sports
		 */
		public var sports:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#image
		 */
		[Alias(fql="pic", graph="not-available")]
		public var picture:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#numNotes
		 */
		[Alias(fql="notes_count", graph="not-available")]
		public var numNotes:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#numWallposts
		 */
		[Alias(fql="wall_count", graph="not-available")]
		public var numWallposts:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#numLikes
		 */
		[Alias(fql="likes_count", graph="not-available")]
		public var numLikes:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#numFriends
		 */
		[Alias(fql="friend_count", graph="not-available")]
		public var numFriends:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#numMutialFriends
		 */
		[Alias(fql="mutual_friend_count", graph="not-available")]
		public var numMutialFriends:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#cover
		 */
		public var cover:Boolean;
		
		public function FacebookUserFields(selectAll:Boolean = false)
		{
			super(selectAll);
		}

		/**
		 * @inheritDoc
		 */
		override public function getPermissions(me:Boolean = true):Vector.<String>
		{
			var permissions:Vector.<String> = new Vector.<String>();
			
			if (languages && me) permissions.push(FacebookPermission.USER_LIKES);
			if (bio) permissions.push(me ? FacebookPermission.USER_ABOUT_ME : FacebookPermission.FRIENDS_ABOUT_ME);
			if (birthday) permissions.push(me ? FacebookPermission.USER_BIRTHDAY : FacebookPermission.FRIENDS_BIRTHDAY);
			if (education) permissions.push(me ? FacebookPermission.USER_EDUCATION_HISTORY : FacebookPermission.FRIENDS_EDUCATION_HISTORY);
			if (email && me) permissions.push(FacebookPermission.EMAIL);
			if (hometown) permissions.push(me ? FacebookPermission.USER_HOMETOWN : FacebookPermission.FRIENDS_HOMETOWN);
			if (interestedIn) permissions.push(me ? FacebookPermission.USER_RELATIONSHIP_DETAILS : FacebookPermission.FRIENDS_RELATIONSHIP_DETAILS);
			if (location) permissions.push(me ? FacebookPermission.USER_LOCATION : FacebookPermission.FRIENDS_LOCATION);
			if (political) permissions.push(me ? FacebookPermission.USER_RELIGION_POLITICS : FacebookPermission.FRIENDS_RELIGION_POLITICS);
			if (favoriteTeams) permissions.push(me ? FacebookPermission.USER_LIKES : FacebookPermission.FRIENDS_LIKES);
			if (quotes) permissions.push(me ? FacebookPermission.USER_ABOUT_ME : FacebookPermission.FRIENDS_ABOUT_ME);
			if (relationshipStatus) permissions.push(me ? FacebookPermission.USER_RELATIONSHIPS : FacebookPermission.FRIENDS_RELATIONSHIPS);
			if (religion) permissions.push(me ? FacebookPermission.USER_RELIGION_POLITICS : FacebookPermission.FRIENDS_RELIGION_POLITICS);
			if (significantOther)
			{
				if (me) permissions.push(FacebookPermission.USER_RELATIONSHIPS, FacebookPermission.USER_RELATIONSHIP_DETAILS);
				else permissions.push(FacebookPermission.FRIENDS_RELATIONSHIPS, FacebookPermission.FRIENDS_RELATIONSHIP_DETAILS);
			}
			if (website) permissions.push(me ? FacebookPermission.USER_WEBSITE : FacebookPermission.FRIENDS_WEBSITE);
			if (work) permissions.push(me ? FacebookPermission.USER_WORK_HISTORY : FacebookPermission.FRIENDS_WORK_HISTORY);
			
			return permissions;
		}
	}
}