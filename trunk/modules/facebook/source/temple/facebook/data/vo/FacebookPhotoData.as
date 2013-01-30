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
	import temple.facebook.data.enum.FacebookObjectType;
	import temple.facebook.data.FacebookParser;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.facebook;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookPhotoData extends FacebookObjectData implements IFacebookPhotoData
	{
		public static const FIELDS:FacebookPhotoFields = new FacebookPhotoFields();
		
		public static const CONNECTIONS:Vector.<String> = Vector.<String>([
			FacebookConnection.COMMENTS,
			FacebookConnection.LIKES,
			FacebookConnection.PICTURE,
			FacebookConnection.TAGS]);
		
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
			facebook.registerVO(FacebookConnection.PHOTOS, FacebookPhotoData);
			facebook.registerVO(FacebookConnection.TAGGED, FacebookPhotoData);
		}
		
		// Register classes as implementation of Interfaces
		FacebookParser.facebook::CLASS_MAP[FacebookObjectType.PHOTO] = FacebookPhotoData;
		FacebookParser.facebook::CLASS_MAP[IFacebookPhotoData] = FacebookPhotoData;
		FacebookParser.facebook::CLASS_MAP[IFacebookImageData] = FacebookImageData;
		FacebookParser.facebook::CLASS_MAP[IFacebookCommentData] = FacebookCommentData;
		FacebookParser.facebook::CLASS_MAP[IFacebookPhotoTagData] = FacebookPhotoTagData;
		FacebookParser.facebook::CLASS_MAP[IFacebookProfileData] = FacebookProfileData;
		FacebookParser.facebook::CLASS_MAP[IFacebookTagData] = FacebookTagData;
		FacebookParser.facebook::CLASS_MAP[IFacebookObjectData] = FacebookObjectData;

		facebook var from:IFacebookProfileData;
		facebook var tags:Vector.<IFacebookPhotoTagData>;
		facebook var icon:String;
		facebook var source:String;
		facebook var picture:String;
		facebook var height:Number;
		facebook var width:Number;
		facebook var images:Vector.<IFacebookImageData>;
		facebook var link:String;
		facebook var place:IFacebookProfileData;
		facebook var created_time:Date;
		facebook var updated_time:Date;
		facebook var position:int = -1;
		facebook var comments:Vector.<IFacebookCommentData>;
		facebook var likes:Vector.<IFacebookProfileData>;
		facebook var album:IFacebookAlbumData;
		facebook var name_tags:Vector.<IFacebookTagData>;
		facebook var offset_y:int = -1;
		facebook var post_id:String;
		
		private var _imageOriginal:IFacebookImageData;
		private var _imageBig:IFacebookImageData;
		private var _imageMedium:IFacebookImageData;
		private var _imageNormal:IFacebookImageData;
		private var _imageSmall:IFacebookImageData;
		private var _picture:IFacebookPhotoPictureData;
		
		public function FacebookPhotoData(service:IFacebookService)
		{
			super(service, FacebookObjectType.PHOTO, FacebookPhotoData.CONNECTIONS);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get fields():IFacebookFields
		{
			return FacebookPhotoData.FIELDS;
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
		public function get tags():Vector.<IFacebookPhotoTagData>
		{
			return facebook::tags;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get nameTags():Vector.<IFacebookTagData>
		{
			return facebook::name_tags;
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
		public function get thumbnail():String
		{
			return facebook::picture;
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
		public function get height():Number
		{
			return facebook::height;
		}

		/**
		 * @inheritDoc
		 */
		public function get width():Number
		{
			return facebook::width;
		}

		/**
		 * @inheritDoc
		 */
		public function get images():Vector.<IFacebookImageData>
		{
			return facebook::images;
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
		public function get position():int
		{
			return facebook::position;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get imageOriginal():IFacebookImageData
		{
			return _imageOriginal ||= getLargestImage();
		}

		/**
		 * @inheritDoc
		 */
		public function get imageBig():IFacebookImageData
		{
			return _imageBig ||= getLargestImage(720, 720);
		}

		/**
		 * @inheritDoc
		 */
		public function get imageMedium():IFacebookImageData
		{
			return _imageMedium ||= getLargestImage(180, 180);
		}

		/**
		 * @inheritDoc
		 */
		public function get imageNormal():IFacebookImageData
		{
			return _imageNormal ||= getLargestImage(130, 130);
		}

		/**
		 * @inheritDoc
		 */
		public function get imageSmall():IFacebookImageData
		{
			return _imageSmall ||= getLargestImage(75, 225);
		}

		/**
		 * @inheritDoc
		 */
		public function getLargestImage(maxWidth:Number = NaN, maxHeight:Number = NaN, orSmallest:Boolean = false):IFacebookImageData
		{
			if (facebook::images)
			{
				facebook::images.sort(sortImages);
				var image:IFacebookImageData;
				var leni:int = facebook::images.length;
				for (var i:int = 0; i < leni; i++)
				{
					image = facebook::images[i];
					FacebookImageData(image).facebook::photo ||= this;
					if ((isNaN(maxWidth) || image.width <= maxWidth) && (isNaN(maxHeight) || image.height <= maxHeight))
					{
						return image;
					}
				}
				if (orSmallest) return image;
			}
			return null;
		}
		
		/**
		 * @private
		 */
		public function get photo():IFacebookPhotoData
		{
			return this;
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
		public function get likes():Vector.<IFacebookProfileData>
		{
			return facebook::likes;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get album():IFacebookAlbumData
		{
			return facebook::album;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get picture():IFacebookPhotoPictureData
		{
			return _picture ||= new FacebookPhotoPictureData(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get offsetY():int
		{
			return facebook::offset_y;
		}

		private function sortImages(image1:IFacebookImageData, image2:IFacebookImageData):Number
		{
			return image2.width - image1.width;
		}
	}
}
