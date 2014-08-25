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

	/**
	 * Fields object for photo albums.
	 * 
	 * <p>Set every propery you want to receive to true.</p>
	 * 
	 * @see temple.facebook.api.IFacebookAPI#photos
	 * @see temple.facebook.api.IFacebookPhotoAPI#getAlbums()
	 * @see temple.facebook.data.vo.IFacebookAlbumData
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookAlbumFields extends AbstractFacebookFields
	{
		/**
		 * Returns a list of all fields of a <code>IFacebookAlbumData</code>
		 */
		public static function all():Vector.<String>
		{
			return AbstractFacebookFields.all(FacebookAlbumFields);
		}
		
		/**
		 * The id of the Album
		 */
		[Alias(fql="object_id")]
		public var id:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#from
		 */
		[Alias(fql="owner")]
		public var from:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookObjectData#name
		 */
		public var name:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#description
		 */
		public var description:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#location
		 */
		public var location:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#link
		 */
		public var link:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#coverPhoto
		 */
		[Alias(fql="not-available", graph="not-available")]
		public var coverPhoto:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#coverPhotoId
		 */
		[Alias(fql="cover_object_id", graph="cover_photo")]
		public var coverPhotoId:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#privacy
		 */
		[Alias(fql="visible")]
		public var privacy:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#count
		 */
		[Alias(fql="size")]
		public var count:Boolean;
		
		/**
		 * The type of the album: <code>profile</code>, <code>mobile</code>, <code>wall</code>, <code>normal</code> or <code>album</code>
		 * 
		 * @see temple.facebook.data.enum.FacebookAlbumType
		 */
		public var type:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#created
		 */
		[Alias(fql="created", graph="created_time")]
		public var created:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#updated
		 */
		[Alias(fql="modified", graph="updated_time")]
		public var updated:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#picture
		 */
		[Alias(fql="not-available")]
		public var picture:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookAlbumData#albumType
		 */
		[Alias(graph="type", fql="type")]
		public var albumType:Boolean;
		
		public function FacebookAlbumFields(fields:Vector.<String> = null, limit:int = 0)
		{
			super(fields, limit);
		}
	}
}
