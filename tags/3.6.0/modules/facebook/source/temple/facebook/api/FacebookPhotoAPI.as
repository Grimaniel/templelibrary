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

package temple.facebook.api
{
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.data.FileData;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.enum.FacebookConstant;
	import temple.facebook.data.enum.FacebookFieldAlias;
	import temple.facebook.data.enum.FacebookTable;
	import temple.facebook.data.vo.FacebookAlbumData;
	import temple.facebook.data.vo.FacebookAlbumFields;
	import temple.facebook.data.vo.FacebookPhotoData;
	import temple.facebook.data.vo.FacebookPhotoFields;
	import temple.facebook.data.vo.IFacebookFields;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;

	/**
	 * @author Thijs Broerse
	 */
	internal class FacebookPhotoAPI extends AbstractFacebookObjectAPI implements IFacebookPhotoAPI
	{
		public function FacebookPhotoAPI(service:IFacebookService)
		{
			super(service, FacebookConnection.PHOTOS, FacebookPhotoData);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPhoto(id:String, callback:Function = null, fields:FacebookPhotoFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return getItem(id, callback, fields, params, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getPhotos(callback:Function = null, id:String = 'me', offset:Number = NaN, limit:Number = NaN, fields:FacebookPhotoFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return getItems(callback, id, offset, limit, fields, params, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function upload(photo:*, message:String = null, callback:Function = null, albumID:String = 'me', noStory:Boolean = false):IFacebookCall
		{
			var params:Object;
			
			switch (true)
			{
				case photo is FileData:
				{
					var fileData:FileData = FileData(photo);
					params = {photo: fileData.data, fileName: fileData.name || '', contentType:fileData.type};
					break;
				}
				case photo is Bitmap:
				case photo is BitmapData:
				{
					params = {photo: photo, fileName:'photo'};
					break;
				}
				case photo is ByteArray:
				{
					params = {photo: photo, fileName:'photo', contentType:'png'};
					break;
				}
				case photo is FileReference:
				{
					params = {photo: photo};
					break;
				}
				case photo is String:
				{
					params = {url: photo};
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "photo has an unsupported format " + photo));
				}
			}
			if (params)
			{
				if (message != null) params.message = message;
				if (noStory) params.no_story = "1";
				
				return service.post(method, callback, albumID, params, FacebookPhotoData);
			}
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function openProfilePictureURL(photoId:String, target:String = "_blank"):void
		{
			navigateToURL(new URLRequest("http://www.facebook.com/photo.php?fbid=" + photoId + "&makeprofile=1"), target);
		}

		/**
		 * @inheritDoc
		 */
		public function getProfilePhotos(callback:Function = null, fields:IFacebookFields = null, userId:String = 'me'):IFacebookCall
		{
			return service.fql("SELECT " + (fields ? fields.getFields(FacebookFieldAlias.FQL) : "object_id, caption, src_small, src_big, src, images") + " FROM " + FacebookTable.PHOTO + " " +
									"WHERE album_object_id IN (SELECT object_id FROM " + FacebookTable.ALBUM + " WHERE owner=" + (userId == FacebookConstant.ME ? "me()" : "'" + userId + "'") + " AND type='profile') ORDER BY position"
									, callback, FacebookPhotoData, fields, userId);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAlbum(id:String, callback:Function = null, fields:FacebookAlbumFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return service.get(callback, null, id, FacebookAlbumData, params, fields, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getAlbums(callback:Function = null, id:String = 'me', offset:Number = NaN, limit:Number = NaN, fields:FacebookAlbumFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			if (!isNaN(offset))	(params ||= {}).offset = uint(offset);
			if (!isNaN(limit)) (params ||= {}).limit = uint(limit);
			
			return service.get(callback, FacebookConnection.ALBUMS, id, FacebookAlbumData, params, fields, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getAlbumsByName(name:String, callback:Function = null, fields:FacebookAlbumFields = null, userId:String = 'me'):IFacebookCall
		{
			return service.fql("SELECT " + (fields ? fields.getFields(FacebookFieldAlias.FQL) : "object_id, name") + " FROM " + FacebookTable.ALBUM + " WHERE owner=" + (userId == FacebookConstant.ME ? "me()" : "'" + userId + "'" ) + " AND name='" + name + "'", callback, FacebookAlbumData, fields, FacebookConstant.ME);
		}

		/**
		 * @inheritDoc
		 */
		public function createAlbum(name:String, message:String, callback:Function = null, userId:String = 'me'):IFacebookCall
		{
			return service.post(method, callback, userId, {name: name, message:message}, FacebookAlbumData);
		}
	}
}
