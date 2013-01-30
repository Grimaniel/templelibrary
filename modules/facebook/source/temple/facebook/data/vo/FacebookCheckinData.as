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
	public class FacebookCheckinData extends FacebookObjectData implements IFacebookCheckinData
	{
		public static const FIELDS:FacebookCheckinFields = new FacebookCheckinFields();
		
		public static const CONNECTIONS:Vector.<String> = Vector.<String>([FacebookConnection.COMMENTS, FacebookConnection.LIKES]);
		
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
			facebook.registerVO(FacebookConnection.CHECKINS, FacebookCheckinData);
		}
		
		FacebookParser.facebook::CLASS_MAP[IFacebookCheckinData] = FacebookCheckinData;
		FacebookParser.facebook::CLASS_MAP[IFacebookApplicationData] = FacebookApplicationData;
		FacebookParser.facebook::CLASS_MAP[IFacebookPageData] = FacebookPageData;

		facebook var from:IFacebookUserData;
		facebook var tags:Vector.<IFacebookUserData>;
		facebook var place:IFacebookPageData;
		facebook var application:IFacebookApplicationData;
		facebook var created_time:Date;
		facebook var likes:Vector.<IFacebookUserData>;
		facebook var message:String;
		facebook var comments:Vector.<IFacebookCommentData>;
		
		public function FacebookCheckinData(service:IFacebookService)
		{
			super(service, FacebookObjectType.CHECKIN, CONNECTIONS);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get fields():IFacebookFields
		{
			return FacebookCheckinData.FIELDS;
		}

		/**
		 * @inheritDoc
		 */
		public function get from():IFacebookUserData
		{
			return facebook::from;
		}

		/**
		 * @inheritDoc
		 */
		public function get tags():Vector.<IFacebookUserData>
		{
			return facebook::tags;
		}

		/**
		 * @inheritDoc
		 */
		public function get place():IFacebookPageData
		{
			return facebook::place;
		}

		/**
		 * @inheritDoc
		 */
		public function get application():IFacebookApplicationData
		{
			return facebook::application;
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
		public function get likes():Vector.<IFacebookUserData>
		{
			return facebook::likes;
		}

		/**
		 * @inheritDoc
		 */
		public function get message():String
		{
			return facebook::message;
		}

		/**
		 * @inheritDoc
		 */
		public function get comments():Vector.<IFacebookCommentData>
		{
			return facebook::comments;
		}
	}
}
