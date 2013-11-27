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
	 * Stores the data of a Facebook photo.
	 * 
	 * @see temple.facebook.api.IFacebookAPI#photos
	 * @see http://developers.facebook.com/docs/reference/api/photo/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookPhotoData extends IFacebookLocatedData, IFacebookImageData
	{
		/**
		 * The profile (user or page) that posted this photo
		 */
		function get from():IFacebookProfileData;

		/**
		 * The tagged users and their positions in this photo
		 */
		function get tags():Vector.<IFacebookPhotoTagData>;
		
		/**
		 * Returns the <code>IFacebookPhotoTagData</code> of a specific user or <code>null</code> if the user is not
		 * tagged in the photo 
		 */
		function getTag(user:IFacebookUserData):IFacebookPhotoTagData;

		/**
		 * The tagged users in the name of the photo
		 */
		function get nameTags():Vector.<IFacebookTagData>;
		
		/**
		 * The icon that Facebook displays when photos are published to the Feed
		 */
		function get icon():String;
		
		/**
		 * The album, thumbnail and normal -sized view of the photo.
		 */
		function get picture():IFacebookPhotoPictureData;

		/**
		 * The thumbnail-sized source of the photo
		 */
		function get thumbnail():String;
		
		/**
		 * The 4 different stored representations of the photo
		 */
		function get images():Vector.<IFacebookImageData>;
		
		/**
		 * The full-sized source of the photo
		 */
		function get link():String;
		
		/**
		 * The time the photo was initially published
		 */
		function get created():Date;
		
		/**
		 * The last time the photo or its caption was updated
		 */
		function get updated():Date;
		
		/**
		 * The position of this photo in the album.
		 * If this property isn't filled yet, the value will be -1 
		 */
		function get position():int;

		/**
		 * Original image
		 */
		function get imageOriginal():IFacebookImageData;

		/**
		 * The full-sized version of the photo being queried. The image can have a maximum width or height of 720px. This value may be blank.
		 */
		function get imageBig():IFacebookImageData;

		/**
		 * The medium version of the photo being queried. The image can have a maximum width or height of 180px. This value may be blank.
		 */
		function get imageMedium():IFacebookImageData;

		/**
		 * The album view version of the photo being queried. The image can have a maximum width or height of 130px. This value may be blank.
		 */
		function get imageNormal():IFacebookImageData;

		/**
		 * The thumbnail version of the photo being queried. The image can have a maximum width of 75px and a maximum height of 225px. This may be blank.
		 */
		function get imageSmall():IFacebookImageData;
		
		/**
		 * Returns the largest available image with a specific size.
		 * 
		 * @param maxWidth the maximum width of the image
		 * @param maxHeight the maximum height of the image
		 * @param orSmallest if set to true, the smallest image will be returned when no image is found. Otherwise null
		 * is returned.
		 */
		function getLargestImage(maxWidth:Number = NaN, maxHeight:Number = NaN, orSmallest:Boolean = false):IFacebookImageData

		/**
		 * All of the comments on this photo.
		 * Note: this value is only filled if you explicit requests this field
		 */
		function get comments():Vector.<IFacebookCommentData>;

		/**
		 * All of the likes on this photo.
		 * Note: this value is only filled if you explicit requests this field
		 */
		function get likes():Vector.<IFacebookProfileData>;

		/**
		 * The album the photo belongs to.
		 */
		function get album():IFacebookAlbumData;

		/**
		 * The position of the user when this photo is used as cover
		 */
		function get offsetY():int;
	}
}
