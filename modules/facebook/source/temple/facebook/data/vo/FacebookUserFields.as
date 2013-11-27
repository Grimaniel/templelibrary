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
		 * Returns a list of all fields of a <code>IFacebookUserData</code> object
		 */
		public static function all():Vector.<String>
		{
			return AbstractFacebookFields.all(FacebookUserFields);
		}
		
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
		public var significantOther:*;
		
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
		[Alias(fql="pic")]
		public var picture:*;
		
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
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#albums
		 */
		public var albums:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#checkins
		 */
		public var checkins:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#events
		 */
		public var events:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#family
		 */
		public var family:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#feed
		 */
		public var feed:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#friendlists
		 */
		public var friendlists:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#friends
		 */
		public var friends:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#groups
		 */
		public var groups:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#home
		 */
		public var home:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#interests
		 */
		public var interests:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#likes
		 */
		public var likes:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#locations
		 */
		public var locations:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#movies
		 */
		public var movies:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#music
		 */
		public var music:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#photos
		 */
		public var photos:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#posts
		 */
		public var posts:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#statuses
		 */
		public var statuses:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#tagged
		 */
		public var tagged:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookUserData#television
		 */
		public var television:*;
		
//		/**
//		 * @copy temple.facebook.data.vo.IFacebookUserData#videos
//		 */
//		public var videos:*;
		
		/**
		 * @param fields an optional list of fields with must be set to <code>true</code> automatically
		 */
		public function FacebookUserFields(fields:Vector.<String> = null, limit:int = 0)
		{
			super(fields, limit);
		}

		/**
		 * @inheritDoc
		 */
		override public function getPermissions(me:Boolean = true):Vector.<String>
		{
			var permissions:Vector.<String> = new Vector.<String>();
			
			if (languages && me || favoriteTeams || likes || movies || music || television) permissions.push(me ? FacebookPermission.USER_LIKES : FacebookPermission.FRIENDS_LIKES);
			
			if (bio || quotes) permissions.push(me ? FacebookPermission.USER_ABOUT_ME : FacebookPermission.FRIENDS_ABOUT_ME);
			if (birthday) permissions.push(me ? FacebookPermission.USER_BIRTHDAY : FacebookPermission.FRIENDS_BIRTHDAY);
			if (education) permissions.push(me ? FacebookPermission.USER_EDUCATION_HISTORY : FacebookPermission.FRIENDS_EDUCATION_HISTORY);
			if (email && me) permissions.push(FacebookPermission.EMAIL);
			if (hometown) permissions.push(me ? FacebookPermission.USER_HOMETOWN : FacebookPermission.FRIENDS_HOMETOWN);
			if (interestedIn) permissions.push(me ? FacebookPermission.USER_RELATIONSHIP_DETAILS : FacebookPermission.FRIENDS_RELATIONSHIP_DETAILS);
			if (location) permissions.push(me ? FacebookPermission.USER_LOCATION : FacebookPermission.FRIENDS_LOCATION);
			if (political) permissions.push(me ? FacebookPermission.USER_RELIGION_POLITICS : FacebookPermission.FRIENDS_RELIGION_POLITICS);
			if (relationshipStatus || significantOther || family) permissions.push(me ? FacebookPermission.USER_RELATIONSHIPS : FacebookPermission.FRIENDS_RELATIONSHIPS);
			if (religion) permissions.push(me ? FacebookPermission.USER_RELIGION_POLITICS : FacebookPermission.FRIENDS_RELIGION_POLITICS);
			if (website) permissions.push(me ? FacebookPermission.USER_WEBSITE : FacebookPermission.FRIENDS_WEBSITE);
			if (work) permissions.push(me ? FacebookPermission.USER_WORK_HISTORY : FacebookPermission.FRIENDS_WORK_HISTORY);
			if (albums || photos || locations) permissions.push(me ? FacebookPermission.USER_PHOTOS : FacebookPermission.FRIENDS_PHOTOS);
			if (checkins || locations) permissions.push(me ? FacebookPermission.USER_CHECKINS : FacebookPermission.FRIENDS_CHECKINS);
			if (events) permissions.push(me ? FacebookPermission.USER_EVENTS : FacebookPermission.FRIENDS_EVENTS);
			if (feed || home || posts || statuses || tagged) permissions.push(FacebookPermission.READ_STREAM);
			if (friendlists) permissions.push(FacebookPermission.READ_FRIENDLISTS);
			if (groups) permissions.push(me ? FacebookPermission.USER_GROUPS : FacebookPermission.FRIENDS_GROUPS);
			if (interests) permissions.push(me ? FacebookPermission.USER_INTERESTS : FacebookPermission.FRIENDS_INTERESTS);
			if (locations) permissions.push(me ? FacebookPermission.USER_STATUS : FacebookPermission.FRIENDS_STATUS);
//			if (videos) permissions.push(me ? FacebookPermission.USER_VIDEOS : FacebookPermission.FRIENDS_VIDEOS);
			
			return permissions;
		}
	}
}