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
	 * Fields object for pages.
	 * 
	 * <p>Set every propery you want to receive to true.</p>
	 * 
	 * @see temple.facebook.api.IFacebookAPI#getPage()
	 * @see temple.facebook.data.vo.IFacebookPageData
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookPageFields extends AbstractFacebookFields
	{
		/**
		 * Returns a list of all fields of a <code>IFacebookPageData</code> object
		 */
		public static function all():Vector.<String>
		{
			return AbstractFacebookFields.all(FacebookPageFields);
		}
		
		/**
		 * The Page's ID
		 */
		[Alias(fql="page_id")]
		public var id:Boolean;
		
		/**
		 * The Page's name
		 */
		public var name:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#link
		 */
		public var link:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#category
		 */
		[Alias(fql="type")]
		public var category:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#likes
		 */
		public var likes:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#location
		 */
		public var location:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#phone
		 */
		public var phone:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#checkins
		 */
		public var checkins:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#picture
		 */
		public var picture:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#cover
		 */
		public var cover:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#website
		 */
		public var website:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookPageData#alternates
		 */
		public var alternates:Boolean;
		
		/**
		 * @param fields an optional list of fields with must be set to <code>true</code> automatically
		 */
		public function FacebookPageFields(fields:Vector.<String> = null, limit:int = 0)
		{
			super(fields, limit);
		}
	}
}
