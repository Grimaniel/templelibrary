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
	import temple.facebook.data.enum.FacebookConstant;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.vo.FacebookCheckinData;
	import temple.facebook.data.vo.IFacebookUserData;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	internal class FacebookCheckinAPI extends AbstractFacebookObjectAPI implements IFacebookCheckinAPI
	{
		public function FacebookCheckinAPI(service:IFacebookService)
		{
			super(service, FacebookConnection.CHECKINS, FacebookCheckinData);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getCheckin(checkinId:String, callback:Function = null, fields:FacebookCheckinFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return getItem(checkinId, callback, fields, params, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getCheckins(callback:Function = null, userId:String = 'me', offset:Number = NaN, limit:Number = NaN, fields:FacebookCheckinFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return getItems(callback, userId, offset, limit, fields, params, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function create(placeId:String, latitude:Number, longitude:Number, callback:Function = null, message:String = null, tags:Vector.<IFacebookUserData> = null, link:String = null, picture:String = null):IFacebookCall
		{
			var params:Object = {place: placeId, coordinates: "{\"latitude\": \"" + latitude + "\", \"longitude\": \"" + longitude + "\"}"};
			if (message) params.message = message;
			if (tags)
			{
				var leni:int = tags.length;
				var ids:Vector.<String> = new Vector.<String>(leni, true);
				for (var i:int = 0; i < leni; i++)
				{
					ids[i] = tags[i].id;
				}
				params.tags = ids.join(",");
			}
			if (link) params.link = link;
			if (link) params.picture = picture;
			
			return service.post(FacebookConnection.CHECKINS, callback, FacebookConstant.ME, params, objectClass);
		}
	}
}
