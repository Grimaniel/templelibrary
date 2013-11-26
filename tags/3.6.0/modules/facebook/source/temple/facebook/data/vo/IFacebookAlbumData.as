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
	 * Stores the data of a Facebook photo album.
	 * 
	 * @see temple.facebook.api.IFacebookAPI#photos
	 * @see http://developers.facebook.com/docs/reference/api/album/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookAlbumData extends IFacebookObjectData
	{
		/**
		 * The profile that created this album
		 */
		function get from():IFacebookUserData;
		
		/**
		 * The type of the album: profile, mobile, wall, normal or album
		 * 
		 * @see temple.facebook.data.enum.FacebookAlbumType
		 */
		function get albumType():String;
		
		/**
		 * The description of the album
		 */
		function get description():String;
		
		/**
		 * The location of the album
		 */
		function get location():String;
		
		/**
		 * A link to this album on Facebook
		 */
		function get link():String;
		
		/**
		 * The album cover photo ID
		 */
		function get coverPhotoId():String;
		
		/**
		 * The album cover photo
		 */
		function get coverPhoto():IFacebookPhotoData;
		
		/**
		 * The privacy settings for the album
		 */
		function get privacy():String;
		
		/**
		 * The number of photos in this album.
		 * If this property isn't filled yet, the value will be -1 
		 */
		function get count():int;
		
		/**
		 * The time the photo album was initially created
		 */
		function get created():Date;
		
		/**
		 * The last time the photo album was updated
		 */
		function get updated():Date;

		/**
		 * The album's cover photo, the first picture uploaded to an album becomes the cover photo for the album.
		 */
		function get picture():IFacebookPhotoPictureData;
	}
}
