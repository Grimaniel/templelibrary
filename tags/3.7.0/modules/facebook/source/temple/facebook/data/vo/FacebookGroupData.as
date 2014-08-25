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
	public class FacebookGroupData extends FacebookObjectData implements IFacebookGroupData
	{
		public static const FIELDS:FacebookUserFields = new FacebookUserFields();
		
		public static const CONNECTIONS:Vector.<String> = Vector.<String>([
			FacebookConnection.FEED,
			FacebookConnection.MEMBERS,
			FacebookConnection.PICTURE,
			FacebookConnection.DOCS]);
		
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
			facebook.registerVO(FacebookConnection.GROUPS, FacebookGroupData);
		}
		
		// Register classes as implementation of Interfaces or types
		FacebookParser.facebook::CLASS_MAP[FacebookObjectType.GROUP] = FacebookGroupData;
		FacebookParser.facebook::CLASS_MAP[IFacebookGroupData] = FacebookGroupData;
		
		facebook var icon:String;
		facebook var owner:IFacebookProfileData;
		facebook var description:String;
		facebook var link:String;
		facebook var privacy:String;
		facebook var updated_time:Date;
		facebook var bookmark_order:int = -1;
		facebook var version:int = -1;
		facebook var administrator:Trivalent;
		facebook var unread:int = -1;
		facebook var email:String;
		facebook var feed:Vector.<IFacebookPostData>;
		facebook var members:Vector.<IFacebookUserData>;
		facebook var picture:IFacebookPictureData;
		facebook var docs:Array;
		
		public function FacebookGroupData(service:IFacebookService, type:String = null, connections:Vector.<String> = null)
		{
			super(service, type, connections);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get version():int
		{
			return facebook::version;
		}

		/**
		 * @inheritDoc
		 */
		public function get icon():String
		{
			return facebook::icon;
		}

		/**
		 * @inheritDoc
		 */
		public function get owner():IFacebookProfileData
		{
			return facebook::owner;
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
		public function get link():String
		{
			return facebook::link;
		}

		/**
		 * @inheritDoc
		 */
		public function get privacy():String
		{
			return facebook::privacy;
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
		public function get feed():Vector.<IFacebookPostData>
		{
			return facebook::feed;
		}

		/**
		 * @inheritDoc
		 */
		public function get members():Vector.<IFacebookUserData>
		{
			return facebook::members;
		}

		/**
		 * @inheritDoc
		 */
		public function get picture():IFacebookPictureData
		{
			return facebook::picture;
		}

		/**
		 * @inheritDoc
		 */
		public function get docs():Array
		{
			return facebook::docs;
		}
	}
}
