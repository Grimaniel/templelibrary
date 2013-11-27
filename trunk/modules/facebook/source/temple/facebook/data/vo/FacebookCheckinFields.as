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
	 * Fields object for checkins
	 * 
	 * <p>Set every propery you want to receive to true.</p>
	 * 
	 * @see temple.facebook.api.IFacebookAPI#checkins
	 * @see temple.facebook.api.IFacebookCheckinAPI#getCheckins()
	 * @see temple.facebook.data.vo.IFacebookCheckinData
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookCheckinFields extends FacebookLocationFields
	{
		/**
		 * Returns a list of all fields of a <code>IFacebookCheckinData</code> object
		 */
		public static function all():Vector.<String>
		{
			return AbstractFacebookFields.all(FacebookCheckinFields);
		}
		
		/**
		 * The checkin ID
		 */
		public var id:Boolean;
		
		/**
		 * @private
		 */
		[Alias("not-available")]
		public var name:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookCheckinData#from
		 */
		public var from:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookCheckinData#tags
		 */
		public var tags:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookCheckinData#application
		 */
		public var application:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookCheckinData#created
		 */
		[Alias(graph="created_time")]
		public var created:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookCheckinData#likes
		 */
		public var likes:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookCheckinData#message
		 */
		public var message:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookCheckinData#comments
		 */
		public var comments:Boolean;
		
		/**
		 * @param fields an optional list of fields with must be set to <code>true</code> automatically
		 */
		public function FacebookCheckinFields(fields:Vector.<String> = null, limit:int = 0)
		{
			super(fields, limit);
		}
	}
}
