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
	 * Fields object for groups.
	 * 
	 * <p>Set every propery you want to receive to true.</p>
	 * 
	 * @see temple.facebook.data.vo.IFacebookGroupData
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookGroupFields extends AbstractFacebookFields
	{
		/**
		 * The group ID
		 */
		public var id:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#version
		 */
		public var version:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#icon
		 */
		public var icon:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#owner
		 */
		public var owner:Boolean;
		
		/**
		 * The name of the group
		 */
		public var name:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#description
		 */
		public var description:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#link
		 */
		public var link:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#updated
		 */
		[Alias(graph="updated_time")]
		public var updated:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#feed
		 */
		public var feed:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#members
		 */
		public var members:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#picture
		 */
		public var picture:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookGroupData#docs
		 */
		public var docs:Boolean;
		
		public function FacebookGroupFields(selectAll:Boolean = false)
		{
			super(selectAll);
		}
	}
}
