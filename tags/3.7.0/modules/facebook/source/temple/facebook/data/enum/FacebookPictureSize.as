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

package temple.facebook.data.enum
{
	/**
	 * Possible sizes for Facebook pictures. Not every size is available for every picture.
	 * 
	 * <p>Used in URL like:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	http://graph.facebook.com/{id}/picture?type={size}
	 * </listing>
	 * 
	 * <p><code>IFacebookUserData</code> only supports small, normal, large, square.</p>
	 * 
	 * @see temple.facebook.service.IFacebookService#getImageUrl()
	 * @see http://developers.facebook.com/docs/api#pictures
	 * 
	 * @author Thijs Broerse
	 */
	public final class FacebookPictureSize
	{
		/**
		 * 50 * 50 pixels.
		 * 
		 * Not for availabe for photos.
		 */
		public static const SQUARE:String = "square";
		
		/**
		 * 50 pixels wide, variable height.
		 * 
		 * Not for availabe for photos.
		 */
		public static const SMALL:String = "small";

		/**
		 * 100 pixels wide, variable height.
		 * 
		 * For photos: about 720 pixels wide, variable height.
		 */
		public static const NORMAL:String = "normal";
		
		/**
		 * about 200 pixels wide, variable height.
		 */
		public static const LARGE:String = "large";

		/**
		 * About 130 pixels wide, variable height.
		 * 
		 * Only for availabe for photos.
		 */
		public static const ALBUM:String = "album";

		/**
		 * About 75 pixels wide, 50 pixels height.
		 * 
		 * Only for availabe for photos.
		 */
		public static const THUMBNAIL:String = "thumbnail";
	}
}
