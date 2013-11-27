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
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.enum.FacebookConstant;
	import temple.facebook.data.enum.FacebookFieldAlias;
	import temple.facebook.data.enum.FacebookTable;
	import temple.facebook.data.vo.FacebookEventData;
	import temple.facebook.data.vo.FacebookEventFields;
	import temple.facebook.data.vo.FacebookRSVPData;
	import temple.facebook.data.vo.FacebookUserData;
	import temple.facebook.data.vo.IFacebookEventData;
	import temple.facebook.data.vo.IFacebookObjectData;
	import temple.facebook.data.vo.IFacebookUserData;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	internal class FacebookEventAPI extends AbstractFacebookObjectAPI implements IFacebookEventAPI
	{
		public function FacebookEventAPI(service:IFacebookService)
		{
			super(service, FacebookConnection.EVENTS, FacebookEventData);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getEvent(eventId:String, callback:Function = null, fields:FacebookEventFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return getItem(eventId, callback, fields, params, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getEvents(callback:Function = null, userId:String = 'me', offset:Number = NaN, limit:Number = NaN, fields:FacebookEventFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return getItems(callback, userId, offset, limit, fields, params, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function create(name:String, start:Date, callback:Function = null, end:Date = null, description:String = null, location:String = null, privacy:String = null):IFacebookCall
		{
			var params:Object = {name:name, start_time:start};
			if (end) params.end_time = end;
			if (description) params.description = description;
			if (location) params.location = location;
			if (privacy) params.privacy_type = privacy;
			
			return service.post(FacebookConnection.EVENTS, callback, FacebookConstant.ME, params, FacebookEventData);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getInvites(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			return get(eventId, FacebookConnection.INVITED, callback, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getInvite(eventId:String, userId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			return get(eventId, FacebookConnection.INVITED + "/" + userId, callback, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function inviteUsers(eventId:String, users:Vector.<IFacebookUserData>, callback:Function = null):IFacebookCall
		{
			var leni:int = users.length;
			var ids:Vector.<String> = new Vector.<String>(leni, true);
			for (var i:int = 0; i < leni; i++)
			{
				ids[i] = users[i].id;
			}
			return service.post(FacebookConnection.INVITED, callback, eventId, {users:ids.join(",")});
		}

		/**
		 * @inheritDoc
		 */
		public function inviteUsersById(eventId:String, users:Vector.<String>, callback:Function = null):IFacebookCall
		{
			return service.post(FacebookConnection.INVITED, callback, eventId, {users:users.join(",")});
		}

		/**
		 * @inheritDoc
		 */
		public function attend(eventId:String, callback:Function = null):IFacebookCall
		{
			return service.post(FacebookConnection.ATTENDING, callback, eventId);
		}

		/**
		 * @inheritDoc
		 */
		public function maybe(eventId:String, callback:Function = null):IFacebookCall
		{
			return service.post(FacebookConnection.MAYBE, callback, eventId);
		}

		/**
		 * @inheritDoc
		 */
		public function decline(eventId:String, callback:Function = null):IFacebookCall
		{
			return service.post(FacebookConnection.DECLINED, callback, eventId);
		}

		/**
		 * @inheritDoc
		 */
		public function getAttendingUsers(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			return get(eventId, FacebookConnection.ATTENDING, callback, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getMaybeUsers(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			return get(eventId, FacebookConnection.MAYBE, callback, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getDeclinedUsers(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			return get(eventId, FacebookConnection.DECLINED, callback, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getNotRepliedUsers(eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			return get(eventId, FacebookConnection.NOREPLY, callback, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getRSVP(userId:String, eventId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			return getInvite(eventId, userId, callback, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getRSVPs(userId:String, callback:Function = null, forceReload:Boolean = false):IFacebookCall
		{
			if (userId == null)
			{
				throwError(new TempleArgumentError(this, "user cannot be null"));
				return null;
			}
			
			// Check event
			var object:IFacebookObjectData = service.getObject(userId, true, FacebookUserData);
			if (object && !(object is IFacebookUserData)) throwError(new TempleArgumentError(this, "object is not an user: " + object));
			var call:IFacebookCall = service.get(callback, FacebookConnection.EVENTS, userId, FacebookRSVPData, null, null, forceReload);
			
			return call;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getEventsByName(name:String, callback:Function = null, fields:FacebookEventFields = null):IFacebookCall
		{
			var fql:String = "SELECT " + (fields ? fields.getFieldsList(FacebookFieldAlias.FQL) : "eid, name, start_time") + " FROM " + FacebookTable.EVENT + " WHERE name = \"" + name + "\"";
			
			return service.fql(fql, callback, FacebookEventData, fields, FacebookConstant.ME);
		}
		
		private function get(eventId:String, method:String, callback:Function, forceReload:Boolean = false):IFacebookCall
		{
			// Check event
			var object:IFacebookObjectData = service.getObject(eventId, true, FacebookEventData);
			if (object && !(object is IFacebookEventData)) throwError(new TempleArgumentError(this, "object is not an event: " + object));
			
			return service.get(callback, method, eventId, FacebookRSVPData, null, null, forceReload);
		}
	}
}
