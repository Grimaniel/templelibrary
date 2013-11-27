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
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.CoreObject;
	import temple.facebook.data.facebook;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookRSVPData extends CoreObject implements IFacebookRSVPData
	{
		facebook var rsvp_status:String;
		
		private var _user:IFacebookUserData;
		private var _event:IFacebookEventData;
		
		private var _service:IFacebookService;
		
		public function FacebookRSVPData(service:IFacebookService, user:IFacebookUserData = null, event:IFacebookEventData = null, status:String = null)
		{
			super();
			
			_service = service;
			_user = user;
			_event = event;
			
			facebook::rsvp_status = status;
			
			toStringProps.push("user", "event", "status");
		}
		
		/**
		 * @inheritDoc
		 */
		public function couple(parent:Object):Class
		{
			if (parent is IFacebookUserData && !_user)
			{
				_user = IFacebookUserData(parent);
				return FacebookEventData;
			}
			else if (parent is IFacebookEventData && !_event)
			{
				_event = IFacebookEventData(parent);
				return FacebookUserData;
			}
			else
			{
				throwError(new TempleArgumentError(this, "Coupling failed " + parent));
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get user():IFacebookUserData
		{
			return _user;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get event():IFacebookEventData
		{
			return _event;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return facebook::rsvp_status;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get start():Date
		{
			return _event ? _event.start : null;
		}
	}
}
