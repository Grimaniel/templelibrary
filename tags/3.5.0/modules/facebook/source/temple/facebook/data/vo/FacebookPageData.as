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
	public class FacebookPageData extends FacebookObjectData implements IFacebookPageData
	{
		public static const FIELDS:FacebookPageFields = new FacebookPageFields();
		
		public static const CONNECTIONS:Vector.<String> = Vector.<String>([
			FacebookConnection.FEED,
			FacebookConnection.PICTURE,
			FacebookConnection.SETTINGS,
			FacebookConnection.TAGGED,
			FacebookConnection.LINKS,
			FacebookConnection.PHOTOS,
			FacebookConnection.GROUPS,
			FacebookConnection.ALBUMS,
			FacebookConnection.STATUSES,
			FacebookConnection.VIDEOS,
			FacebookConnection.NOTES,
			FacebookConnection.POSTS,
			FacebookConnection.EVENTS,
			FacebookConnection.CHECKINS,
			FacebookConnection.ADMINS,
			FacebookConnection.BLOCKED,
			FacebookConnection.TABS,
			FacebookConnection.QUESTIONS,
			FacebookConnection.MILESTONES,
			FacebookConnection.OFFERS]);
		
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
		}
		
		// Register classes as implementation of Interfaces or types
		FacebookParser.facebook::CLASS_MAP[FacebookObjectType.PAGE] = FacebookPageData;
		FacebookParser.facebook::CLASS_MAP[IFacebookPageData] = FacebookPageData;
		
		facebook var username:String;
		facebook var link:String;
		facebook var category:String;
		facebook var likes:int = -1;
		facebook var location:Object;
		facebook var phone:String;
		facebook var checkins:int = -1;
		facebook var place:String;
		facebook var website:String;
		facebook var cover:String;
		facebook var talking_about_count:int = -1;
		facebook var company_overview:String;
		facebook var is_published:Trivalent;
		facebook var founded:String;
		facebook var picture:String;
		facebook var about:String;
		facebook var is_community_page:Trivalent;
		facebook var were_here_count:int = -1;
		facebook var description:String;
		
		private var _picture:IFacebookPictureData;
		
		public function FacebookPageData(service:IFacebookService)
		{
			super(service, FacebookObjectType.PAGE, CONNECTIONS, true);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get fields():IFacebookFields
		{
			return FacebookPageData.FIELDS;
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
		public function get category():String
		{
			return facebook::category;
		}

		/**
		 * @inheritDoc
		 */
		public function get likes():int
		{
			return facebook::likes;
		}

		/**
		 * @inheritDoc
		 */
		public function get location():Object
		{
			return facebook::location;
		}

		/**
		 * @inheritDoc
		 */
		public function get phone():String
		{
			return facebook::phone;
		}

		/**
		 * @inheritDoc
		 */
		public function get checkins():int
		{
			return facebook::checkins;
		}

		/**
		 * @inheritDoc
		 */
		public function get picture():IFacebookPictureData
		{
			return _picture ||= new FacebookPictureData(this);;
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
		public function get cover():Object
		{
			return facebook::cover;
		}

		/**
		 * @inheritDoc
		 */
		public function get numTalkingAbouts():int
		{
			return facebook::talking_about_count;
		}
	}
}
