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
	 * A Facebook Group. The User and Page objects have a groups connection.
	 * 
	 * @see http://developers.facebook.com/docs/reference/api/group/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookGroupData extends IFacebookObjectData
	{
		/**
		 * A flag which indicates if the group was created prior to launch of the current groups product in October 2010
		 */
		function get version():int;

		/**
		 * The URL for the group's icon
		 */
		function get icon():String;
		
		/**
		 * The profile that created this group
		 */
		function get owner():IFacebookProfileData;

		/**
		 * A brief description of the group
		 */
		function get description():String;
		
		/**
		 * The URL for the group's website
		 */
		function get link():String;

		/**
		 * The privacy setting of the group
		 */
		function get privacy():String;
		
		/**
		 * The last time the group was updated
		 */
		function get updated():Date;

		/**
		 * This group's wall.
		 */
		function get feed():Vector.<IFacebookPostData>;
		
		/**
		 * All of the users who are members of this group
		 */
		function get members():Vector.<IFacebookUserData>;
		
		/**
		 * The profile picture of this group.
		 */
		function get picture():IFacebookPictureData;

		/**
		 * The docs in this group.
		 */
		function get docs():Array;
	}
}
