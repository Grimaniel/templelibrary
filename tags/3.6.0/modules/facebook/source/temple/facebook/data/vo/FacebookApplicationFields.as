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
	import temple.facebook.data.vo.AbstractFacebookFields;

	/**
	 * Fields object for Facebook applications.
	 * 
	 * <p>Set every propery you want to receive to true.</p>
	 * 
	 * @see temple.facebook.api.IFacebookAPI#getApplicationData()
	 * @see temple.facebook.data.vo.IFacebookApplicationData
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookApplicationFields extends AbstractFacebookFields
	{
		/**
		 * The application ID
		 */
		public var id:Boolean; 

		/**
		 * The title of the application
		 */
		public var name:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#description
		 */
		public var description:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#category
		 */
		public var category:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#company
		 */
		public var company:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#icon
		 */
		[Alias(graph="icon_url")]
		public var icon:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#subcategory
		 */
		public var subcategory:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#link
		 */
		public var link:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#logo
		 */
		[Alias(graph="logo_url")]
		public var logo:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#created
		 */
		[Alias(graph="created_time")]
		public var created:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#creator
		 */
		[Alias(graph="creator_uid")]
		public var creator:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookApplicationData#namespace
		 */
		public var namespace:Boolean;
		
		public function FacebookApplicationFields(selectAll:Boolean = false)
		{
			super(selectAll);
		}
	}
}
