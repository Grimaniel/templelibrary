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
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.enum.FacebookObjectType;
	import temple.facebook.data.facebook;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookAlbumData extends FacebookObjectData implements IFacebookAlbumData
	{
		public static const FIELDS:FacebookAlbumFields = new FacebookAlbumFields();
		
		public static const CONNECTIONS:Vector.<String> = Vector.<String>([FacebookConnection.PHOTOS, FacebookConnection.LIKES, FacebookConnection.COMMENTS, FacebookConnection.PICTURE]);
		
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
			facebook.registerVO(FacebookConnection.ALBUMS, FacebookAlbumData);
		}

		facebook var type:String;
		facebook var count:int = -1;
		facebook var cover_photo:String;
		facebook var created_time:Date;
		facebook var link:String;
		facebook var privacy:String;
		facebook var updated_time:Date;
		facebook var from:IFacebookUserData;
		facebook var description:String;
		facebook var location:String;
		facebook var can_upload:Trivalent;
		facebook var likes:Vector.<IFacebookProfileData>;
		facebook var comments:Vector.<IFacebookCommentData>;
		facebook var place:Object;
		
		private var _picture:IFacebookPhotoPictureData;
		private var _coverPhoto:IFacebookPhotoData;
		
		public function FacebookAlbumData(service:IFacebookService)
		{
			super(service, FacebookObjectType.ALBUM, CONNECTIONS);
			
			toStringProps.push("count");
		}
		
		override public function get fields():IFacebookFields
		{
			return FacebookAlbumData.FIELDS;
		}
		
		public function get albumType():String
		{
			return facebook::type;
		}
		
		public function get count():int
		{
			return facebook::count;
		}

		public function get coverPhoto():IFacebookPhotoData
		{
			return _coverPhoto ||= (facebook::cover_photo ? service.parser.parse(facebook::cover_photo, FacebookPhotoData) as IFacebookPhotoData : null);
		}
		
		public function get coverPhotoId():String
		{
			return facebook::cover_photo;
		}

		public function get created():Date
		{
			return facebook::created_time;
		}

		public function get link():String
		{
			return facebook::link;
		}

		public function get privacy():String
		{
			return facebook::privacy;
		}

		public function get updated():Date
		{
			return facebook::updated_time;
		}
		
		public function get from():IFacebookUserData
		{
			return facebook::from;
		}
		
		public function get description():String
		{
			return facebook::description;
		}

		public function get location():String
		{
			return facebook::location;
		}
		
		public function get picture():IFacebookPhotoPictureData
		{
			return _picture ||= new FacebookPhotoPictureData(this);
		}
	}
}
