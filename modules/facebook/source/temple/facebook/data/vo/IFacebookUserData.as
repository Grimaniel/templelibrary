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
	import temple.data.Trivalent;
	
	/**
	 * Stores the data of a Facebook user.
	 * 
	 * @see http://developers.facebook.com/docs/reference/api/user/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookUserData extends IFacebookObjectData
	{
		/**
		 * The user's first name
		 */
		function get firstName():String;
		
		/**
		 * The user's middle name
		 */
		function get middleName():String;
		
		/**
		 * The user's last name
		 */
		function get lastName():String;
		
		/**
		 * The user's Facebook username
		 */
		function get username():String;
		
		/**
		 * The user's gender
		 */
		function get gender():String;
		
		/**
		 * The user's locale
		 */
		function get locale():String;
		
		/**
		 * The user's languages
		 */
		function get languages():Vector.<IFacebookObjectData>;
		
		/**
		 * The URL of the profile for the user on Facebook
		 */
		function get link():String;
		
		/**
		 * An anonymous, but unique identifier for the user
		 */
		function get thirdPartyId():String;
		
		/**
		 * The user's timezone offset from UTC
		 */
		function get timezone():Number;

		/**
		 * The last time the user's profile was updated
		 */
		function get updated():Date;
		
		/**
		 * The user's account verification status
		 */
		function get verified():Trivalent;
		
		/**
		 * The blurb that appears under the user's profile picture
		 */
		function get about():String;
		
		/**
		 * The user's biography
		 */
		function get bio():String;
		
		/**
		 * The user's birthday
		 */
		function get birthday():Date;
		
		/**
		 * A list of the user's education history
		 */
		function get education():Vector.<IFacebookCollegeData>;
		
		/**
		 * The proxied or contact email address granted by the user
		 */
		function get email():String;
		
		/**
		 * The user's hometown
		 */
		function get hometown():IFacebookObjectData;
		
		/**
		 * The genders the user is interested in
		 */
		function get interestedIn():Array;
		
		/**
		 * The user's current location
		 */
		function get location():IFacebookProfileData;
		
		/**
		 * The user's political view
		 */
		function get political():String;
		
		/**
		 * The user's favorite athletes; this field is deprecated and will be removed in the near future
		 */
		[Deprecated]
		function get favoriteAthletes():Array;
		
		/**
		 * The user's favorite teams; this field is deprecated and will be removed in the near future
		 */
		[Deprecated]
		function get favoriteTeams():Array;
		
		/**
		 * The user's favorite quotes
		 */
		function get quotes():String;
		
		/**
		 * The user's relationship status
		 */
		function get relationshipStatus():String;
		
		/**
		 * The user's religion
		 */
		function get religion():String;
		
		/**
		 * The user's significant other
		 */
		function get significantOther():IFacebookUserData;
		
		/**
		 * The size of the video file and the length of the video that a user can upload
		 */
		function get videoUploadLimits():IFacebookVideoUploadLimitData;
		
		/**
		 * The URL of the user's personal website
		 */
		function get website():String;
		
		/**
		 * A list of the user's work history
		 */
		function get work():Vector.<IFacebookWorkData>;
		
		/**
		 * A list of the user's sports
		 */
		function get sports():Vector.<IFacebookObjectData>;

		/**
		 * The user's profile picture.
		 */
		function get picture():IFacebookPictureData;
		
		/**
		 * The number of notes created by the user being queried.
		 * Note: only available in FQL
		 * -1 means unknown or not set yet
		 */
		function get numNotes():int;

		/**
		 * The number of Wall posts for the user being queried.
		 * Note: only available in FQL
		 * -1 means unknown or not set yet
		 */
		function get numWallposts():int;
		
		/**
		 * Count of all the pages this user has liked.
		 * Note: only available in FQL
		 * -1 means unknown or not set yet
		 */
		function get numLikes():int;

		/**
		 * Count of all the user's friends.
		 * Note: only available in FQL
		 * -1 means unknown or not set yet
		 */
		function get numFriends():int;

		/**
		 * The number of mutual friends shared by the user in the query and the session user.
		 * Note: only available in FQL
		 * -1 means unknown or not set yet
		 */
		function get numMutialFriends():int;

		/**
		 * The user's cover photo (must be explicitly requested using)
		 */
		function get cover():IFacebookPhotoData;
	}
}
