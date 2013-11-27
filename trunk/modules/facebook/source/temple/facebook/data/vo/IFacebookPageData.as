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
	 * Stores the data of a Facebook page.
	 * 
	 * @see http://developers.facebook.com/docs/reference/api/page/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookPageData extends IFacebookObjectData
	{
		/**
		 * Link to the page on Facebook
		 */
		function get link():String;
		
		/**
		 * Category of the page
		 */
		function get category():String;
		
		/**
		 * The Page's categories
		 */
		function get categories():Vector.<IFacebookObjectData>

		/**
		 * The number of users who like the Page
		 * If this property isn't filled yet, the value will be -1.
		 */
		function get likes():int;

		/**
		 * The Page's street address, latitude, and longitude (when available)
		 */
		function get location():IFacebookLocationData;
		
		/**
		 * The phone number (not always normalized for country code) for the Page.
		 */
		function get phone():String;
		
		/**
		 * The total number of users who have checked in to the Page.
		 */
		function get checkins():int;
		
		/**
		 * The Page's profile picture.
		 */
		function get picture():IFacebookPictureData;
		
		/**
		 * Link to the external website for the page
		 */
		function get website():String;
		
		/**
		 * The JSON object including cover_id (the ID of the photo), source (the URL for the cover photo), and offset_y (the percentage offset from top [0-100])
		 */
		function get cover():Object;

		/**
		 * The number of people that are talking about this page (last seven days)
		 */
		function get numTalkingAbouts():int;
		
		/**
		 * Alternates for this page
		 */
		function get alternates():Vector.<IFacebookPageData>;

	}
}
