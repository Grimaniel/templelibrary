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
	import temple.facebook.data.vo.FacebookCheckinFields;
	import temple.facebook.data.vo.IFacebookUserData;
	import temple.facebook.service.IFacebookCall;

	/**
	 * A Checkin represents a single visit by a user to a location. The User and Page objects have checkin connections.
	 * 
	 * @see ../../../../readme.html Read me
	 * 
	 * @see temple.facebook.api.IFacebookAPI#checkins
	 * @see temple.facebook.api.FacebookAPI#checkins
	 * @see temple.facebook.data.vo.IFacebookCheckinData
	 * @see http://developers.facebook.com/docs/reference/api/checkin/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookCheckinAPI
	{
		/**
		 * Get a checkin.
		 * 
		 * If successful, the result contains an IFacebookCheckinData object.
		 * 
		 * @param checkinId the id of the checkin.
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param fields a FacebookCheckinFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookCheckinData
		 */
		function getCheckin(checkinId:String, callback:Function = null, fields:FacebookCheckinFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * If successful, the result contains an Array with IFacebookCheckinData objects.
		 * 
		 * Get all the checkins of a user.
		 * @param callback a callback method which must be called when the data is ready. This callback must accept one (and only one) argument of type IFacebookResult. If the call was successful the success Boolean of the result is true and the photos are in the data property of the result object.
		 * @param userId the id of the user.
		 * @param offset the position of the first item in the list
		 * @param limit the maximum amount of items.
		 * @param fields a FacebookCheckinFields object with all the requested fields set to true.
		 * @param params option params to send with the request.
		 * @param forceReload when caching is enabled you can force the service to reload the data and not get the cached data when setting this value to true.
		 * 
		 * @see temple.facebook.data.vo.IFacebookCheckinData
		 */
		function getCheckins(callback:Function = null, userId:String = 'me', offset:Number = NaN, limit:Number = NaN, fields:FacebookCheckinFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall;
		
		/**
		 * Checkin a user.
		 * 
		 * @param placeId The ID of the Place Page, for example "<code>110506962309835</code>" for Facebook HQ
		 * @param longitude The locations longitude
		 * @param latitude The locations latitude
		 * @param callback a mehod which is called when the creation is complete
		 * @param message Checkin description
		 * @param tags List of tagged friends
		 * @param link Checkin link 
		 * @param picture Checkin picture 
		 */
		function create(placeId:String, latitude:Number, longitude:Number, callback:Function = null, message:String = null, tags:Vector.<IFacebookUserData> = null, link:String = null, picture:String = null):IFacebookCall;
	}
}
