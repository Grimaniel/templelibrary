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
	 * Stores the data of a Facebook event.
	 * 
	 * @see temple.facebook.api.IFacebookAPI#events
	 * @see http://developers.facebook.com/docs/reference/api/event/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookEventData extends IFacebookObjectData
	{
		/**
		 * The profile that created the event
		 */
		function get owner():IFacebookUserData;
		
		/**
		 * The long-form description of the event
		 */
		function get description():String;

		/**
		 * The start time of the event, as you want it to be displayed on facebook
		 */
		function get start():Date;

		/**
		 * The end time of the event, as you want it to be displayed on facebook
		 */
		function get end():Date;

		/**
		 * The location for this event
		 */
		function get location():String;

		/**
		 * The location of this event
		 */
		function get venue():Object;

		/**
		 * The visibility of this event.
		 * 
		 * @see temple.facebook.data.enum.FacebookEventPrivacy
		 */
		function get privacy():String;
		
		/**
		 * The last time the event was updated
		 */
		function get updated():Date;
		
		/**
		 * The user's profile picture.
		 */
		function get picture():IFacebookPictureData;

		/**
		 * The tagline or summary of the event.
		 */
		function get tagline():String;
		
		/**
		 * All of the users who have been not yet responded to their invitation to this event.
		 * Note: this value is only filled if you explicit requests this field.
		 */
		function get noreply():Vector.<IFacebookRSVPData>;

		/**
		 * All of the users who have been invited to this event.
		 * Note: this value is only filled if you explicit requests this field.
		 */
		function get invited():Vector.<IFacebookRSVPData>;

		/**
		 * All of the users who are attending this event.
		 * Note: this value is only filled if you explicit requests this field.
		 */
		function get attending():Vector.<IFacebookRSVPData>;

		/**
		 * All of the users who have been responded "Maybe" to their invitation to this event.
		 * Note: this value is only filled if you explicit requests this field.
		 */
		function get maybe():Vector.<IFacebookRSVPData>;
		
		/**
		 * All of the users who declined their invitation to this event.
		 * Note: this value is only filled if you explicit requests this field.
		 */
		function get declined():Vector.<IFacebookRSVPData>;
		
		/**
		 * The videos uploaded to an event.
		 * Note: this value is only filled if you explicit requests this field.
		 */
		function get videos():Vector.<IFacebookVideoData>;
		
		/**
		 * This event's wall.
		 * Note: this value is only filled if you explicit requests this field.
		 */
		function get feed():Vector.<IFacebookPostData>;

		/**
		 * The timezone of the event
		 */
		function get timezone():String;
	}
}
