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
	import temple.facebook.data.vo.FacebookAlbumFields;
	import temple.facebook.data.vo.FacebookPhotoFields;
	import temple.facebook.data.vo.IFacebookFields;
	import temple.facebook.service.IFacebookCall;

	/**
	 * API for handling photos and albums on Facebook.
	 * 
	 * @see ../../../../readme.html Read me
	 * 
	 * @see temple.facebook.api.IFacebookAPI#photos
	 * @see temple.facebook.api.FacebookAPI#photos
	 * @see temple.facebook.data.vo.IFacebookPhotoData
	 * @see temple.facebook.data.vo.IFacebookAlbumData
	 * @see http://developers.facebook.com/docs/reference/api/photo/
	 * @see http://developers.facebook.com/docs/reference/api/album/
	 * 
	 * @includeExample PhotosExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookPhotoAPI
	{
		/**
		 * Get a photo.
		 * 
		 * If successful, the result contains a IFacebookPhotoData object.
		 * 
		 * @param id the id of the item.
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param fields a FacebookPhotoFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookPhotoData
		 */
		function getPhoto(id:String, callback:Function = null, fields:FacebookPhotoFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Get all the photos of a user or an album.
		 * 
		 * If successful, the result contains an Array with IFacebookPhotoData objects.
		 * 
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param id the id of the user or album.
		 * @param offset the position of the first item in the list
		 * @param limit the maximum amount of items.
		 * @param fields a FacebookPhotoFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookPhotoData
		 * 
		 * @includeExample PhotosExample.as
		 */
		function getPhotos(callback:Function = null, id:String = 'me', offset:Number = NaN, limit:Number = NaN, fields:FacebookPhotoFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;
		
		/**
		 * Upload a photo to Facebook.
		 * 
		 * @param source the photo to upload. Supported formats are: Bitmap, BitmapData, FileReference, ByteArray, FileData or String (which is a URL to the photo).
		 * @param message the message to add to the photo.
		 * @param callback a callback which is called when the upload is complete. The callback must accept one, and only one, argument of type IFacebookResult
		 * @param albumId the id of the album to add the photo to. If albumID is 'me' the photo will be added to your wall.
		 * @param fileName an optional name for the photo.
		 * @param noStory when a photo is upload, by default there is a wallpost created. When you want to share this uploaded photo in your own wallpost you can choose to hide this upload from your timeline.
		 * 
		 * Note: you need 'publish_stream' permission if you want Facebook to make a wallpost for this photo.
		 */
		function upload(photo:*, message:String = null, callback:Function = null, albumId:String = 'me', noStory:Boolean = false):IFacebookCall;

		/**
		 * Opens a new Facebook window for setting a photo as profile picture.
		 * 
		 * @param photoId the id of the photo.
		 * @param target the window where the URL must be opened.
		 */
		function openProfilePictureURL(photoId:String, target:String = "_blank"):void;

		/**
		 * Get all the photos the user has had as profile picture.
		 * 
		 * @param callback a callback which is called when the upload is complete. The callback must accept one, and only one, argument of type IFacebookResult
		 * @param fields a IFacebookFields object with all the requested fields set to true.
		 * @param userId the id of the user to get the profile photos from.
		 * 
		 * @includeExample PhotosExample.as
		 */
		function getProfilePhotos(callback:Function = null, fields:IFacebookFields = null, userId:String = 'me'):IFacebookCall;
		
		/**
		 * Get a single album.
		 * 
		 * If successful, the result contains a IFacebookAlbumData object.
		 * 
		 * @param id the id of the item.
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param fields a FacebookAlbumFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookAlbumData
		 */
		function getAlbum(id:String, callback:Function = null, fields:FacebookAlbumFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Get all the albums of a user.
		 * 
		 * If successful, the result contains an Array with IFacebookAlbumData objects.
		 * 
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param id the id of the user.
		 * @param offset the position of the first item in the list
		 * @param limit the maximum amount of items.
		 * @param fields a FacebookAlbumFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookAlbumData
		 */
		function getAlbums(callback:Function = null, id:String = 'me', offset:Number = NaN, limit:Number = NaN, fields:FacebookAlbumFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;
		
		/**
		 * Get multiple albums, based on their name.
		 * 
		 * If successful, the result contains an Array with IFacebookAlbumData objects.
		 * 
		 * @param name the name of the album to get
		 * @param callback a method which is called when the call is ready.
		 * @param fields an object which the requested fields set to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookAlbumData
		 */
		function getAlbumsByName(name:String, callback:Function = null, fields:FacebookAlbumFields = null, userId:String = 'me'):IFacebookCall;
		
		/**
		 * Create an album on Facebook
		 * @param name the name of the album
		 * @param message the message of the album
		 * @param callback a method which is called when the call is ready.
		 * @param userId the id of the user where this album must belong to.
		 * 
		 * @see temple.facebook.data.vo.IFacebookAlbumData
		 */
		function createAlbum(name:String, message:String, callback:Function = null, userId:String = 'me'):IFacebookCall;
	}
}
