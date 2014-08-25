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
	public class FacebookApplicationData extends FacebookObjectData implements IFacebookApplicationData
	{
		public static const FIELDS:FacebookApplicationFields = new FacebookApplicationFields();
		
		public static const CONNECTIONS:Vector.<String> = Vector.<String>([
					FacebookConnection.ACCOUNTS,
					FacebookConnection.ALBUMS,
					FacebookConnection.BANNED,
					FacebookConnection.FEED,
					FacebookConnection.INSIGHTS,
					FacebookConnection.LINKS,
					FacebookConnection.PICTURE,
					FacebookConnection.PHOTOS,
					FacebookConnection.VIDEOS,
					FacebookConnection.NOTES,
					FacebookConnection.EVENTS,
					FacebookConnection.POSTS,
					FacebookConnection.REVIEWS,
					FacebookConnection.STATICRESOURCES,
					FacebookConnection.STATUSES,
					FacebookConnection.SUBSCRIPTIONS,
					FacebookConnection.TAGGED,
					FacebookConnection.TRANSLATIONS,
					FacebookConnection.SCORES,
					FacebookConnection.ACHIEVEMENTS]);
		
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
			facebook.registerVO(FacebookConnection.ACCOUNTS, FacebookApplicationData);
		}
		
		// Register classes as implementation of Interfaces or types
		FacebookParser.facebook::CLASS_MAP[FacebookObjectType.APPLICATION] = FacebookApplicationData;

		facebook var description:String;
		facebook var category:String;
		facebook var company:String;
		facebook var icon_url:String;
		facebook var subcategory:String;
		facebook var link:String;
		facebook var logo_url:String;
		facebook var created_time:Date;
		facebook var creator_uid:String;
		facebook var namespace:String;
		facebook var url:String;
		facebook var monthly_active_users:int = -1;
		facebook var monthly_active_users_rank:int = -1;
		facebook var weekly_active_users:int = -1;
		facebook var daily_active_users:int = -1;
		facebook var daily_active_users_rank:int = -1;
		facebook var migrations:Array;
		facebook var access_token:String;
		facebook var perms:Array;
		facebook var restrictions:Object;
		facebook var app_domains:Array;
		facebook var auth_dialog_data_help_url:String;
		facebook var auth_dialog_description:String;
		facebook var auth_dialog_headline:String;
		facebook var auth_dialog_perms_explanation:String;
		facebook var auth_referral_user_perms:String;
		facebook var auth_referral_friend_perms:String;
		facebook var auth_referral_default_activity_privacy:String;
		facebook var auth_referral_enabled:String;
		facebook var auth_referral_extended_perms:String;
		facebook var auth_referral_response_type:String;
		facebook var canvas_fluid_height:int;
		facebook var canvas_fluid_width:int;
		facebook var canvas_url:String;
		facebook var contact_email:String;
		facebook var deauth_callback_url:String;
		facebook var iphone_app_store_id:String;
		facebook var hosting_url:String;
		facebook var mobile_web_url:String;
		facebook var page_tab_default_name:String;
		facebook var page_tab_url:String;
		facebook var privacy_policy_url:String;
		facebook var secure_canvas_url:String;
		facebook var secure_page_tab_url:String;
		facebook var server_ip_whitelist:String;
		facebook var social_discovery:String;
		facebook var terms_of_service_url:String;
		facebook var user_support_email:String;
		facebook var user_support_url:String;
		facebook var website_url:String;

		private var _creator:IFacebookUserData;
		
		public function FacebookApplicationData(service:IFacebookService)
		{
			super(service, FacebookObjectType.APPLICATION, FacebookApplicationData.CONNECTIONS);
			toStringProps.push('link');
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get fields():IFacebookFields
		{
			return FacebookApplicationData.FIELDS;
		}

		/**
		 * @inheritDoc
		 */
		public function get description():String
		{
			return facebook::description;
		}

		/**
		 * @inheritDoc
		 */
		public function get category():String
		{
			return facebook::category;
		}

		/**
		 * @inheritDoc
		 */
		public function get company():String
		{
			return facebook::company;
		}

		/**
		 * @inheritDoc
		 */
		public function get icon():String
		{
			return facebook::icon_url;
		}

		/**
		 * @inheritDoc
		 */
		public function get subcategory():String
		{
			return facebook::subcategory;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get link():String
		{
			return facebook::link || facebook::url;
		}

		/**
		 * @inheritDoc
		 */
		public function get logo():String
		{
			return facebook::logo_url;
		}

		/**
		 * @inheritDoc
		 */
		public function get created():Date
		{
			return facebook::created_time;
		}

		/**
		 * @inheritDoc
		 */
		public function get creator():IFacebookUserData
		{
			return _creator ||= facebook::creator_uid ? service.parser.parse(facebook::creator_uid, FacebookUserData) as IFacebookUserData : null;
		}

		/**
		 * @inheritDoc
		 */
		public function get accessToken():String
		{
			return facebook::access_token;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get namespace():String
		{
			return facebook::['namespace'];
		}
	}
}
