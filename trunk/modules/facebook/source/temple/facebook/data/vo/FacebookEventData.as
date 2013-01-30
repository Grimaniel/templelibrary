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
	public class FacebookEventData extends FacebookObjectData implements IFacebookEventData
	{
		public static const FIELDS:FacebookEventFields = new FacebookEventFields();
		
		public static const CONNECTIONS:Vector.<String> = Vector.<String>([
						FacebookConnection.FEED,
						FacebookConnection.NOREPLY,
						FacebookConnection.INVITED,
						FacebookConnection.ATTENDING,
						FacebookConnection.MAYBE,
						FacebookConnection.DECLINED,
						FacebookConnection.PICTURE]);
		
		/**
		 * Offset in hours between users time zone and pacific time. Needed since the dates of an event is in pacific time.
		 * 
		 * Use -7 for the Netherlands
		 * 
		 * @see http://www.senab.co.uk/2011/06/24/facebook-event-times/
		 */
		public static var TIMEZONE_OFFSET:int = -7;
		
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
			facebook.registerVO(FacebookConnection.EVENTS, FacebookEventData);
		}
		
		// Register classes as implementation of Interfaces
		FacebookParser.facebook::CLASS_MAP[IFacebookEventData] = IFacebookEventData;
		FacebookParser.facebook::CLASS_MAP[IFacebookRSVPData] = FacebookRSVPData;
		FacebookParser.facebook::CLASS_MAP[IFacebookPostData] = FacebookPostData;
		FacebookParser.facebook::CLASS_MAP[IFacebookCommentData] = FacebookCommentData;
		FacebookParser.facebook::CLASS_MAP[IFacebookTagData] = FacebookTagData;

		facebook var owner:String;
		facebook var description:String;
		facebook var start_time:Date;
		facebook var end_time:Date;
		facebook var location:String;
		facebook var venue:Object;
		facebook var privacy:String;
		facebook var updated_time:Date;
		facebook var picture:String;
		facebook var tagline:String;
		facebook var rsvp_status:String;
		facebook var timezone:String;
		
		facebook var feed:Vector.<IFacebookPostData>;
		facebook var noreply:Vector.<IFacebookRSVPData>;
		facebook var invited:Vector.<IFacebookRSVPData>;
		facebook var attending:Vector.<IFacebookRSVPData>;
		facebook var maybe:Vector.<IFacebookRSVPData>;
		facebook var declined:Vector.<IFacebookRSVPData>;
		facebook var videos:Vector.<IFacebookVideoData>;
		
		private var _picture:IFacebookPictureData;
		private var _owner:IFacebookUserData;
		
		public function FacebookEventData(service:IFacebookService)
		{
			super(service, FacebookObjectType.EVENT, FacebookEventData.CONNECTIONS, true);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get fields():IFacebookFields
		{
			return FacebookEventData.FIELDS;
		}

		/**
		 * @inheritDoc
		 */
		public function get owner():IFacebookUserData
		{
			return _owner;
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
		public function get start():Date
		{
			return facebook::start_time;
		}

		/**
		 * @inheritDoc
		 */
		public function get end():Date
		{
			return facebook::end_time;
		}

		/**
		 * @inheritDoc
		 */
		public function get location():String
		{
			return facebook::location;
		}

		/**
		 * @inheritDoc
		 */
		public function get venue():Object
		{
			return facebook::venue;
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
		public function get picture():IFacebookPictureData
		{
			return _picture ||= new FacebookPictureData(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get tagline():String
		{
			return facebook::tagline;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get noreply():Vector.<IFacebookRSVPData>
		{
			return facebook::noreply;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get invited():Vector.<IFacebookRSVPData>
		{
			return facebook::invited;
		}

		/**
		 * @inheritDoc
		 */
		public function get attending():Vector.<IFacebookRSVPData>
		{
			return facebook::attending;
		}

		/**
		 * @inheritDoc
		 */
		public function get maybe():Vector.<IFacebookRSVPData>
		{
			return facebook::maybe;
		}

		/**
		 * @inheritDoc
		 */
		public function get declined():Vector.<IFacebookRSVPData>
		{
			return facebook::declined;
		}

		/**
		 * @inheritDoc
		 */
		public function get videos():Vector.<IFacebookVideoData>
		{
			return facebook::videos;
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
		public function get timezone():String
		{
			return facebook::timezone;
		}
	}
}
