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
	import temple.data.index.Indexer;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.enum.FacebookObjectType;
	import temple.facebook.data.facebook;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookPostData extends FacebookObjectData implements IFacebookPostData
	{
		public static const FIELDS:FacebookPostFields = new FacebookPostFields();
		
		public static const CONNECTIONS:Vector.<String> = Vector.<String>([
						FacebookConnection.COMMENTS,
						FacebookConnection.LIKES,
						FacebookConnection.PICTURE,
						FacebookConnection.TAGGED]);
		
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
			facebook.registerVO(FacebookConnection.FEED, FacebookPostData);
			facebook.registerVO(FacebookConnection.POSTS, FacebookPostData);
			facebook.registerVO(FacebookConnection.STATUSES, FacebookPostData);
			facebook.registerVO(FacebookConnection.LINKS, FacebookPostData);
			facebook.registerVO(FacebookConnection.HOME, FacebookPostData);
		}

		facebook var from:IFacebookProfileData;
		facebook var to:Vector.<IFacebookProfileData>;
		facebook var message:String;
		facebook var message_tags:Vector.<IFacebookTagData>;
		facebook var with_tags:Vector.<IFacebookTagData>;
		facebook var picture:String;
		facebook var link:String;
		facebook var caption:String;
		facebook var description:String;
		facebook var source:String;
		facebook var properties:Array;
		facebook var icon:String;
		facebook var actions:Array;
		facebook var privacy:Object;
		facebook var likes:Vector.<IFacebookUserData>;
		facebook var comments:Vector.<IFacebookCommentData>;
		facebook var object_id:String;
		facebook var application:IFacebookApplicationData;
		facebook var created_time:Date;
		facebook var updated_time:Date;
		facebook var targeting:Object;
		facebook var type:String;
		facebook var place:IFacebookProfileData;
		facebook var story:String;
		facebook var shares:Object;
		facebook var status_type:String;
		
		private var _object:IFacebookObjectData;
		
		public function FacebookPostData(service:IFacebookService)
		{
			super(service, FacebookObjectType.POST);
			
			toStringProps.push("from");
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get fields():IFacebookFields
		{
			return FacebookPostData.FIELDS;
		}

		/**
		 * @inheritDoc
		 */
		public function get from():IFacebookProfileData
		{
			return facebook::from;
		}

		/**
		 * @inheritDoc
		 */
		public function get to():Vector.<IFacebookProfileData>
		{
			return facebook::to;
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
		public function get messageTags():Vector.<IFacebookTagData>
		{
			return facebook::message_tags;
		}

		/**
		 * @inheritDoc
		 */
		public function get picture():String
		{
			return facebook::picture;
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
		public function get caption():String
		{
			return facebook::caption;
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
		public function get source():String
		{
			return facebook::source;
		}

		/**
		 * @inheritDoc
		 */
		public function get properties():Array
		{
			return facebook::properties;
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
		public function get actions():Array
		{
			return facebook::actions;
		}

		/**
		 * @inheritDoc
		 */
		public function get privacy():Object
		{
			return facebook::privacy;
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
		public function get comments():Vector.<IFacebookCommentData>
		{
			return facebook::comments;
		}

		/**
		 * @inheritDoc
		 */
		public function get object():IFacebookObjectData
		{
			return _object ||= Indexer.get(IFacebookObjectData, facebook::object_id) as IFacebookObjectData;
		}

		/**
		 * @inheritDoc
		 */
		public function get objectId():String
		{
			return facebook::object_id;
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
		public function get updated():Date
		{
			return facebook::updated_time;
		}

		/**
		 * @inheritDoc
		 */
		public function get targeting():Object
		{
			return facebook::targeting;
		}

		/**
		 * @inheritDoc
		 */
		public function get postType():String
		{
			return facebook::type;
		}
	}
}
