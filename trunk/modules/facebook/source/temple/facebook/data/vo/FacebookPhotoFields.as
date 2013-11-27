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
	import temple.facebook.data.enum.FacebookPermission;

	/**
	 * Fields object for photos.
	 * 
	 * <p>Set every propery you want to receive to true.</p>
	 * 
	 * @see temple.facebook.api.IFacebookAPI#photos
	 * @see temple.facebook.api.IFacebookPhotoAPI#getPhotos()
	 * @see temple.facebook.data.vo.IFacebookPhotoData
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookPhotoFields extends FacebookLocationFields
	{
		/**
		 * Returns a list of all fields of a <code>IFacebookPhotoData</code> object
		 */
		public static function all():Vector.<String>
		{
			return AbstractFacebookFields.all(FacebookPhotoFields);
		}
		
		/**
		 * The id of the Photo
		 */
		[Alias(fql="object_id")]
		public var id:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#from
		 */
		[Alias(fql="owner")]
		public var from:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#tags
		 */
		[Alias(fql="not-available")]
		public var tags:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookObjectData#name
		 */
		[Alias(fql="caption")]
		public var name:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#icon
		 */
		[Alias(fql="not-available")]
		public var icon:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#picture
		 */
		[Alias(graph="picture", fql="src_small")]
		public var thumbnail:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookImageData#source
		 */
		[Alias(fql="src_big")]
		public var source:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookImageData#height
		 */
		[Alias(fql="src_height")]
		public var height:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookImageData#width
		 */
		[Alias(fql="src_width")]
		public var width:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#images
		 */
		public var images:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#imageOriginal
		 */
		[Alias("images")]
		public var imageOriginal:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#imageMedium
		 */
		[Alias("images")]
		public var imageMedium:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#imageNormal
		 */
		[Alias("images")]
		public var imageNormal:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#imageBig
		 */
		[Alias("images")]
		public var imageBig:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#imageSmall
		 */
		[Alias("images")]
		public var imageSmall:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#link
		 */
		public var link:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#photo
		 */
		public var photo:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#picture
		 */
		public var picture:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#created
		 */
		[Alias(fql="created", graph="created_time")]
		public var created:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#updated
		 */
		[Alias(fql="modified", graph="updated_time")]
		public var updated:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#position
		 */
		public var position:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#comments
		 */
		[Alias(fql="not-available")]
		public var comments:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#likes
		 */
		[Alias(fql="not-available")]
		public var likes:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookPhotoData#album
		 */
		[Alias(graph="not-available", fql="album_object_id")]
		public var album:Boolean;

		/**
		 * @param fields an optional list of fields with must be set to <code>true</code> automatically
		 */
		public function FacebookPhotoFields(fields:Vector.<String> = null, limit:int = 0)
		{
			super(fields, limit);
		}
		
		override public function getPermissions(me:Boolean = true):Vector.<String>
		{
			if (me) return Vector.<String>([FacebookPermission.USER_PHOTOS]);
			
			return Vector.<String>([FacebookPermission.FRIENDS_PHOTOS]);
		}
	}
}
