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

package temple.facebook.api
{
	import temple.facebook.data.vo.FacebookEventFields;
	import temple.facebook.data.vo.IFacebookUserData;
	import temple.facebook.service.IFacebookCall;

	/**
	 * API for handling events on Facebook.
	 * 
	 * @see ../../../../readme.html Read me
	 * 
	 * @see temple.facebook.api.IFacebookAPI#events
	 * @see temple.facebook.api.FacebookAPI#events
	 * @see temple.facebook.data.vo.IFacebookEventData
	 * @see http://developers.facebook.com/docs/reference/api/event/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookEventAPI
	{
		/**
		 * Get an event.
		 * 
		 * If successful, the result contains an IFacebookEventData object.
		 * 
		 * @param eventId the id of the event.
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param fields a FacebookEventFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookEventData
		 */
		function getEvent(eventId:String, callback:Function = null, fields:FacebookEventFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Get all the events of a user.
		 * 
		 * If successful, the result contains an Array with IFacebookEventData objects.
		 * 
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param userId the id of the user.
		 * @param offset the position of the first item in the list
		 * @param limit the maximum amount of items.
		 * @param fields a FacebookEventFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookEventData
		 */
		function getEvents(callback:Function = null, userId:String = 'me', offset:Number = NaN, limit:Number = NaN, fields:FacebookEventFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;
		
		/**
		 * Create a Facebook Event
		 */
		function create(name:String, start:Date, callback:Function = null, end:Date = null, description:String = null, location:String = null, privacy:String = null):IFacebookCall;
		
		/**
		 * Get list of invitees for an event
		 */
		function getInvites(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Check whether a specific user has been invited to an event
		 * Note: result data is an Array
		 */
		function getInvite(eventId:String, userId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Invite users for an event
		 * @param event the event for the invitation
		 * @param users a list of IFacebookUserData objects you want to invite
		 */
		function inviteUsers(eventId:String, users:Vector.<IFacebookUserData>, callback:Function = null):IFacebookCall;

		/**
		 * Invite users for an event
		 * @param event the event for the invitation
		 * @param users a list of ids of users you want to invite
		 */
		function inviteUsersById(eventId:String, users:Vector.<String>, callback:Function = null):IFacebookCall;

		/**
		 * RSVP the user as 'attending' 
		 */
		function attend(eventId:String, callback:Function = null):IFacebookCall;

		/**
		 * RSVP the user as 'maybe' 
		 */
		function maybe(eventId:String, callback:Function = null):IFacebookCall;

		/**
		 * RSVP the user as 'declined' 
		 */
		function decline(eventId:String, callback:Function = null):IFacebookCall;
		
		/**
		 * All of the users who are attending this event.
		 */
		function getAttendingUsers(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * All of the users who have been responded "Maybe" to their invitation to this event.
		 */
		function getMaybeUsers(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * All of the users who declined their invitation to this event.
		 */
		function getDeclinedUsers(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * All of the users who have not yet responded to their invitation to this event.
		 */
		function getNotRepliedUsers(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Get the RSVP of a user to a specific event.
		 * Note: result data is an Array
		 */
		function getRSVP(userId:String, eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Get all RSVPs of a user.
		 * 
		 * If successful, the result contains an <code>Array</code> of <code>IFacebookRSVPData</code> objects. 
		 * 
		 * @see temple.facebook.data.vo.IFacebookRSVPData
		 * 
		 */
		function getRSVPs(userId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Get multiple events, based on their name.
		 * @param name the name of the event to get
		 * @param callback a method which is called when the call is ready.
		 * @param fields an object which the requested fields set to true.
		 */
		function getEventsByName(name:String, callback:Function = null, fields:FacebookEventFields = null):IFacebookCall;
	}
}
