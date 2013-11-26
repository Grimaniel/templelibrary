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

package temple.facebook.utils
{
	import temple.core.debug.IDebuggable;
	import temple.core.CoreObject;
	import temple.facebook.events.FacebookPermissionEvent;
	import temple.facebook.service.IFacebookService;

	import flash.events.Event;

	/**
	 * @author Thijs Broerse
	 */
	public class FacebookLoginChecker extends CoreObject implements IDebuggable
	{
		private var _facebook:IFacebookService;
		private var _loggedInMethod:Function;
		private var _notLoggedInMethod:Function;
		private var _permissions:Vector.<String>;
		private var _debug:Boolean;

		public function FacebookLoginChecker(facebook:IFacebookService, loggedInMethod:Function, notLoggedInMethod:Function = null, permissions:Vector.<String> = null)
		{
			_facebook = facebook;
			_loggedInMethod = loggedInMethod;
			_notLoggedInMethod = notLoggedInMethod;
			_permissions = permissions;
			
			if (_facebook.isInitialized)
			{
				onInitialized();
			}
			else
			{
				_facebook.addEventListenerOnce(Event.INIT, handleFacebookInit);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		private function handleFacebookInit(event:Event):void
		{
			if (debug) logDebug("handleFacebookInit: ");
			onInitialized();
		}

		private function onInitialized():void
		{
			if (debug) logDebug("onInitialized: isLoggedIn=" + _facebook.isLoggedIn + ", permissionsLoaded=" + _facebook.permissionsLoaded);
			if (_facebook.isLoggedIn)
			{
				if (_facebook.permissionsLoaded)
				{
					onPermissions();
				}
				else
				{
					_facebook.addEventListenerOnce(FacebookPermissionEvent.UPDATE, handleFacebookPermissionUpdate);
				}
			}
			else
			{
				if (debug) logDebug("onInitialized: call notLoggedInMethod");
				// just continue
				_notLoggedInMethod();
				destruct();
			}
		}

		private function handleFacebookPermissionUpdate(event:FacebookPermissionEvent):void
		{
			if (debug) logDebug("handleFacebookPermissionUpdate: ");
			onPermissions();
		}

		private function onPermissions():void
		{
			if (debug) logDebug("onPermissions: requiredPermissionsAllowed=" + _facebook.requiredPermissionsAllowed);
			if (_facebook.requiredPermissionsAllowed && (!_permissions || _facebook.areAllowed(_permissions)))
			{
				if (debug) logDebug("onPermissions: call loggedInMethod");
				_loggedInMethod();
				destruct();
			}
			else
			{
				if (debug) logDebug("onPermissions: call notLoggedInMethod");
				// just continue
				_notLoggedInMethod();
				destruct();
			}
		}

		override public function destruct():void
		{
			if (_facebook)
			{
				_facebook.removeEventListener(Event.INIT, handleFacebookInit);
				_facebook.removeEventListener(FacebookPermissionEvent.UPDATE, handleFacebookPermissionUpdate);
				_facebook = null;
			}
			
			_loggedInMethod = null;
			_notLoggedInMethod = null;
			_permissions = null;
			
			super.destruct();
		}
	}
}
