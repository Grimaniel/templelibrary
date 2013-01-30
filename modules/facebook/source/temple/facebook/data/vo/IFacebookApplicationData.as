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
	import temple.facebook.data.vo.IFacebookObjectData;

	/**
	 * Stores the data of a Facebook application.
	 * 
	 * @see http://developers.facebook.com/docs/reference/api/application/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookApplicationData extends IFacebookObjectData
	{
		/**
		 * The description of the application written by the 3rd party developers
		 */
		function get description():String;

		/**
		 * The category of the application
		 */
		function get category():String;

		/**
		 * The company the application belongs to
		 */
		function get company():String;

		/**
		 * The URL of the application's icon
		 */
		function get icon():String;

		/**
		 * The subcategory of the application
		 */
		function get subcategory():String;

		/**
		 * Link to the Facebook Application
		 */
		function get link():String;

		/**
		 * The URL of the application's logo
		 */
		function get logo():String;

		/**
		 * Indicates when the app was created
		 */
		function get created():Date;

		/**
		 * The creator of this app
		 */
		function get creator():IFacebookUserData;

		/**
		 * A String used for authentication
		 * 
		 * @see http://developers.facebook.com/docs/authentication/
		 */
		function get accessToken():String;
		
		/**
		 * The namespace for the app
		 */
		function get namespace():String;
	}
}
