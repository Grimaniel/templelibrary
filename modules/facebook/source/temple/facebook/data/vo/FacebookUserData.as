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
	import temple.facebook.data.FacebookParser;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.enum.FacebookObjectType;
	import temple.facebook.data.facebook;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookUserData extends FacebookObjectData implements IFacebookUserData
	{
		public static const FIELDS:FacebookUserFields = new FacebookUserFields();
		
		public static const CONNECTIONS:Vector.<String> = Vector.<String>([
			FacebookConnection.ACCOUNTS,
			FacebookConnection.ADACCOUNTS,
			FacebookConnection.ACHIEVEMENTS,
			FacebookConnection.ACTIVITIES,
			FacebookConnection.ALBUMS,
			FacebookConnection.APPREQUESTS,
			FacebookConnection.BOOKS,
			FacebookConnection.CHECKINS,
			FacebookConnection.EVENTS,
			FacebookConnection.FAMILY,
			FacebookConnection.FEED,
			FacebookConnection.FRIENDLISTS,
			FacebookConnection.FRIENDREQUESTS,
			FacebookConnection.FRIENDS,
			FacebookConnection.GAMES,
			FacebookConnection.GROUPS,
			FacebookConnection.HOME,
			FacebookConnection.INBOX,
			FacebookConnection.INTERESTS,
			FacebookConnection.LIKES,
			FacebookConnection.LINKS,
			FacebookConnection.LOCATIONS,
			FacebookConnection.MESSAGINGFAVORITES,
			FacebookConnection.MOVIES,
			FacebookConnection.MUSIC,
			FacebookConnection.MUTUALFRIENDS,
			FacebookConnection.NOTES,
			FacebookConnection.NOTIFICATIONS,
			FacebookConnection.OUTBOX,
			FacebookConnection.PAYMENTS,
			FacebookConnection.PERMISSIONS,
			FacebookConnection.PHOTOS,
			FacebookConnection.PICTURE,
			FacebookConnection.POKES,
			FacebookConnection.POSTS,
			FacebookConnection.QUESTIONS,
			FacebookConnection.SCORES,
			FacebookConnection.STATUSES,
			FacebookConnection.SUBSCRIBEDTO,
			FacebookConnection.SUBSCRIBERS,
			FacebookConnection.TAGGED,
			FacebookConnection.TELEVISION,
			FacebookConnection.UPDATES, FacebookConnection.VIDEOS]);
		
		/**
		 * Used by Indexer
		 * @see temple.data.index.Indexer#INDEX_CLASS
		 */
		public static function get indexClass():Class
		{
			return IFacebookObjectData;
		}
		
		public static function register(facebook:IFacebookService):void
		{
			facebook.registerVO(FacebookConnection.FRIENDS, FacebookUserData);
			facebook.registerVO(FacebookConnection.FAMILY, FacebookUserData);
			facebook.registerVO(FacebookConnection.MUTUALFRIENDS, FacebookUserData);
		}
		
		// Register classes as implementation of Interfaces or types
		FacebookParser.facebook::CLASS_MAP[FacebookObjectType.USER] = FacebookUserData;
		FacebookParser.facebook::CLASS_MAP[IFacebookUserData] = FacebookUserData;
		FacebookParser.facebook::CLASS_MAP[IFacebookWorkData] = FacebookWorkData;
		FacebookParser.facebook::CLASS_MAP[IFacebookCollegeData] = FacebookCollegeData;
		FacebookParser.facebook::CLASS_MAP[IFacebookVideoUploadLimitData] = FacebookVideoUploadLimitData;
		FacebookParser.facebook::CLASS_MAP[IFacebookLikeData] = FacebookLikeData;
		FacebookParser.facebook::CLASS_MAP[IFacebookAlbumData] = FacebookAlbumData;
		FacebookParser.facebook::CLASS_MAP[IFacebookFriendListData] = FacebookFriendListData;
		// TODO: FacebookParser.facebook::CLASS_MAP[IFacebookVideoData] = FacebookVideoData;

		facebook var link:String;
		facebook var first_name:String;
		facebook var last_name:String;
		facebook var locale:String;
		facebook var location:IFacebookProfileData;
		facebook var verified:Trivalent;
		facebook var about:String;
		facebook var email:String;
		facebook var middle_name:String;
		facebook var username:String;
		facebook var gender:String;
		facebook var languages:Vector.<IFacebookObjectData>;
		facebook var third_party_id:String;
		facebook var timezone:Number;
		facebook var updated_time:Date;
		facebook var bio:String;
		facebook var birthday:IFacebookDateData;
		facebook var education:Vector.<IFacebookCollegeData>;
		facebook var hometown:IFacebookPageData;
		facebook var interested_in:Array;
		facebook var political:String;
		[Deprecated]
		facebook var favorite_athletes:Array;
		[Deprecated]
		facebook var favorite_teams:Array;
		facebook var quotes:String;
		facebook var relationship_status:String;
		facebook var religion:String;
		facebook var significant_other:IFacebookUserData;
		facebook var video_upload_limits:IFacebookVideoUploadLimitData;
		facebook var website:String;
		facebook var work:Vector.<IFacebookWorkData>;
		facebook var sports:Vector.<IFacebookPageData>;
		facebook var installed:Object;
		facebook var cover:IFacebookPhotoData;
		facebook var currency:Object;
		facebook var devices:Array;
		facebook var administrator:Boolean;
		facebook var age_range:String;
		facebook var payment_pricepoints:Object;
		facebook var payment_mobile_pricepoints:Object;
		facebook var security_settings:Object;
		
		// TODO: make this more dynamic
		facebook var picture:Object;
		
		facebook var num_notes:int = -1;
		facebook var num_wallposts:int = -1;
		facebook var num_likes:int = -1;
		facebook var num_friends:int = -1;
		facebook var num_mutial_friends:int = -1;

		facebook var albums:Vector.<IFacebookAlbumData>;
		facebook var checkins:Vector.<IFacebookCheckinData>;
		facebook var events:Vector.<IFacebookRSVPData>;
		facebook var family:Vector.<IFacebookUserData>;
		facebook var feed:Vector.<IFacebookPostData>;
		facebook var friendlists:Vector.<IFacebookFriendListData>;
		facebook var friends:Vector.<IFacebookUserData>;
		facebook var groups:Vector.<IFacebookGroupData>;
		facebook var home:Vector.<IFacebookPostData>;
		facebook var interests:Vector.<IFacebookLikeData>;
		facebook var likes:Vector.<IFacebookLikeData>;
		facebook var locations:Vector.<IFacebookLocatedData>;
		facebook var movies:Vector.<IFacebookLikeData>;
		facebook var music:Vector.<IFacebookLikeData>;
		facebook var photos:Vector.<IFacebookPhotoData>;
		facebook var posts:Vector.<IFacebookPostData>;
		facebook var statuses:Vector.<IFacebookPostData>;
		facebook var tagged:Vector.<IFacebookPostData>;
		facebook var television:Vector.<IFacebookLikeData>;
		//facebook var videos:Vector.<IFacebookVideoData>;
		
		private var _picture:IFacebookPictureData;
		
		public function FacebookUserData(service:IFacebookService, id:String = null, name:String = null)
		{
			super(service, FacebookObjectType.USER, FacebookUserData.CONNECTIONS, true);
			if (id) this.id = id;
			this.name = name;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get fields():IFacebookFields
		{
			return FacebookUserData.FIELDS;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get firstName():String
		{
			return facebook::first_name;
		}

		/**
		 * @inheritDoc
		 */
		public function get lastName():String
		{
			return facebook::last_name;
		}

		facebook function get testVar():String
		{
			return null;
		}

		
		/**
		 * @inheritDoc
		 */
		public function get link():String
		{
			return facebook::link;
		}

		/**
		 * @inheritDoc
		 */
		public function get locale():String
		{
			return facebook::locale;
		}

		/**
		 * @inheritDoc
		 */
		public function get location():IFacebookProfileData
		{
			return facebook::location;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get verified():Trivalent
		{
			return facebook::verified;
		}

		/**
		 * @inheritDoc
		 */
		public function get about():String
		{
			return facebook::about;
		}

		/**
		 * @inheritDoc
		 */
		public function get email():String
		{
			return facebook::email;
		}

		/**
		 * @inheritDoc
		 */
		public function get middleName():String
		{
			return facebook::middle_name;
		}

		/**
		 * @inheritDoc
		 */
		public function get username():String
		{
			return facebook::username;
		}

		/**
		 * @inheritDoc
		 */
		public function get gender():String
		{
			return facebook::gender;
		}

		/**
		 * @inheritDoc
		 */
		public function get languages():Vector.<IFacebookObjectData>
		{
			return facebook::languages;
		}

		/**
		 * @inheritDoc
		 */
		public function get thirdPartyId():String
		{
			return facebook::third_party_id;
		}

		/**
		 * @inheritDoc
		 */
		public function get timezone():Number
		{
			return facebook::timezone;
		}

		/**
		 * @inheritDoc
		 */
		public function get updated():Date
		{
			return facebook::updated_time;
		}

		/**
		 * @inheritDoc
		 */
		public function get bio():String
		{
			return facebook::bio;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get birthday():IFacebookDateData
		{
			return facebook::birthday;
		}

		/**
		 * @inheritDoc
		 */
		public function get education():Vector.<IFacebookCollegeData>
		{
			return facebook::education;
		}

		/**
		 * @inheritDoc
		 */
		public function get hometown():IFacebookPageData
		{
			return facebook::hometown;
		}

		/**
		 * @inheritDoc
		 */
		public function get interestedIn():Array
		{
			return facebook::interested_in;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get political():String
		{
			return facebook::political;
		}
		
		/**
		 * @inheritDoc
		 */
		[Deprecated]
		public function get favoriteAthletes():Array
		{
			return facebook::favorite_athletes;
		}
		
		/**
		 * @inheritDoc
		 */
		[Deprecated]
		public function get favoriteTeams():Array
		{
			return facebook::favorite_teams;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get quotes():String
		{
			return facebook::quotes;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relationshipStatus():String
		{
			return facebook::relationship_status;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get religion():String
		{
			return facebook::religion;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get significantOther():IFacebookUserData
		{
			return facebook::significant_other;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get videoUploadLimits():IFacebookVideoUploadLimitData
		{
			return facebook::video_upload_limits;
		}

		/**
		 * @inheritDoc
		 */
		public function get website():String
		{
			return facebook::website;
		}

		/**
		 * @inheritDoc
		 */
		public function get work():Vector.<IFacebookWorkData>
		{
			return facebook::work;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get sports():Vector.<IFacebookPageData>
		{
			return facebook::sports;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get picture():IFacebookPictureData
		{
			return _picture ||= new FacebookPictureData(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numNotes():int
		{
			return facebook::num_notes;
		}

		/**
		 * @inheritDoc
		 */
		public function get numWallposts():int
		{
			return facebook::num_wallposts;
		}

		/**
		 * @inheritDoc
		 */
		public function get numLikes():int
		{
			return facebook::num_likes;
		}

		/**
		 * @inheritDoc
		 */
		public function get numFriends():int
		{
			return facebook::num_friends;
		}

		/**
		 * @inheritDoc
		 */
		public function get numMutialFriends():int
		{
			return facebook::num_mutial_friends;
		}

		/**
		 * @inheritDoc
		 */
		public function get cover():IFacebookPhotoData
		{
			return facebook::cover;
		}
		
		public function get albums():Vector.<IFacebookAlbumData>
		{
			return facebook::albums;
		}

		/**
		 * @inheritDoc
		 */
		public function get checkins():Vector.<IFacebookCheckinData>
		{
			return facebook::checkins;
		}

		/**
		 * @inheritDoc
		 */
		public function get events():Vector.<IFacebookRSVPData> 
		{
			return facebook::events;		
		}

		/**
		 * @inheritDoc
		 */
		public function get family():Vector.<IFacebookUserData>
		{
			return facebook::family;
		}

		/**
		 * @inheritDoc
		 */
		public function get feed():Vector.<IFacebookPostData>
		{
			return facebook::feed;
		}

		/**
		 * @inheritDoc
		 */
		public function get friendlists():Vector.<IFacebookFriendListData>
		{
			return facebook::friendlists;
		}

		/**
		 * @inheritDoc
		 */
		public function get friends():Vector.<IFacebookUserData>
		{
			return facebook::friends;
		}

		/**
		 * @inheritDoc
		 */
		public function get groups():Vector.<IFacebookGroupData>
		{
			return facebook::groups;
		}

		/**
		 * @inheritDoc
		 */
		public function get home():Vector.<IFacebookPostData>
		{
			return facebook::home;
		}

		/**
		 * @inheritDoc
		 */
		public function get interests():Vector.<IFacebookLikeData>
		{
			return facebook::interests;
		}

		/**
		 * @inheritDoc
		 */
		public function get likes():Vector.<IFacebookLikeData>
		{
			return facebook::likes;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get locations():Vector.<IFacebookLocatedData>
		{
			return facebook::locations;
		}

		/**
		 * @inheritDoc
		 */
		public function get movies():Vector.<IFacebookLikeData>
		{
			return facebook::movies;
		}

		/**
		 * @inheritDoc
		 */
		public function get music():Vector.<IFacebookLikeData>
		{
			return facebook::music;
		}

		/**
		 * @inheritDoc
		 */
		public function get photos():Vector.<IFacebookPhotoData>
		{
			return facebook::photos;
		}

		/**
		 * @inheritDoc
		 */
		public function get posts():Vector.<IFacebookPostData>
		{
			return facebook::posts;
		}

		/**
		 * @inheritDoc
		 */
		public function get statuses():Vector.<IFacebookPostData>
		{
			return facebook::statuses;
		}

		/**
		 * @inheritDoc
		 */
		public function get tagged():Vector.<IFacebookPostData>
		{
			return facebook::tagged;
		}

		/**
		 * @inheritDoc
		 */
		public function get television():Vector.<IFacebookLikeData>
		{
			return facebook::television;
		}

//		/**
//		 * @inheritDoc
//		 */
//		public function get videos():Vector.<IFacebookVideoData>
//		{
//			return facebook::videos;
//		}
	}
}