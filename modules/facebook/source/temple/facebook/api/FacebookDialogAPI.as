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
	import temple.core.CoreObject;
	import temple.facebook.data.enum.FacebookConstant;
	import temple.facebook.data.enum.FacebookDisplayMode;
	import temple.facebook.data.enum.FacebookUIMethod;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	/**
	 * @author Thijs Broerse
	 */
	internal class FacebookDialogAPI extends CoreObject implements IFacebookDialogAPI
	{
		private var _service:IFacebookService;
		private var _displayMode:FacebookDisplayMode;
		
		public function FacebookDialogAPI(service:IFacebookService)
		{
			_service = service;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get displayMode():FacebookDisplayMode
		{
			return _displayMode;
		}

		/**
		 * @inheritDoc
		 */
		public function set displayMode(value:FacebookDisplayMode):void
		{
			_displayMode = value;
		}

		/**
		 * @inheritDoc
		 */
		public function feedDialog(callback:Function = null, to:String = null, link:String = null, picture:String = null, source:String = null, name:String = null, caption:String = null, description:String = null, properties:Object = null, actions:Object = null, ref:String = null, display:FacebookDisplayMode = null, from:String = null):IFacebookCall
		{
			var vars:Object = {};
			
			if (from) vars.from = from;
			if (to && to != FacebookConstant.ME) vars.to = to;
			if (link) vars.link = link;
			if (picture) vars.picture = picture;
			if (source) vars.source = source;
			if (name) vars.name = name;
			if (caption) vars.caption = caption;
			if (description) vars.description = description;
			if (properties) vars.properties = properties;
			if (actions) vars.actions = actions;
			if (ref) vars.ref = ref;
			
			if (_service.debug) logDebug("feedDialog: " + dump(vars));
			
			return _service.ui(FacebookUIMethod.FEED_DIALOG, vars, callback, display || _displayMode);
		}

		/**
		 * @inheritDoc
		 */
		public function friendsDialog(id:String, callback:Function = null, display:FacebookDisplayMode = null):IFacebookCall
		{
			return _service.ui(FacebookUIMethod.FRIENDS_DIALOG, {app_id:_service.application.id, id:id}, callback, display || _displayMode);
		}

		/**
		 * @inheritDoc
		 */
		public function oauthDialog(redirectUri:String, permissions:Vector.<String> = null, display:FacebookDisplayMode = null):IFacebookCall
		{
			var data:Object = {client_id:_service.application.id, redirect_uri:redirectUri};
			
			if (permissions) data.scope = permissions.join(",");
			
			return _service.ui(FacebookUIMethod.OAUTH_DIALOG, data, null, display || _displayMode);
		}

		/**
		 * @inheritDoc
		 */
		public function payDialog(display:FacebookDisplayMode = null):IFacebookCall
		{
			return _service.ui(FacebookUIMethod.PAY_DIALOG, {}, null, display || _displayMode);
		}
		
		/**
		 * @inheritDoc
		 */
		public function requestDialog(message:String, to:String = null, callback:Function = null, filters:Array = null, excludeIds:Array = null, maxRecipients:uint = 0, data:String = null, title:String = null, display:FacebookDisplayMode = null):IFacebookCall
		{
			var vars:Object = {message:message};
			if (to) vars.to = to;
			if (filters) vars.filters = filters;
			if (excludeIds) vars.exclude_ids = excludeIds;
			if (maxRecipients) vars.max_recipients = maxRecipients;
			if (data) vars.data = data;
			if (title) vars.title = title; 
			
			if (_service.debug) logDebug("requestDialog: " + dump(vars));
			
			return _service.ui(FacebookUIMethod.REQUESTS_DIALOG, vars, callback, display || _displayMode);
		}

		/**
		 * @inheritDoc
		 */
		public function sendDialog(link:String, to:String = null, callback:Function = null, display:FacebookDisplayMode = null):IFacebookCall
		{
			var vars:Object = {link: link};
			if (to) vars.to = to;
			
			return _service.ui(FacebookUIMethod.SEND_DIALOG, vars, callback, display || _displayMode);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_service = null;
			_displayMode = null;
			super.destruct();
		}
	}
}
