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

package temple.facebook.service 
{
	import temple.common.events.PendingCallEvent;
	import temple.common.interfaces.IPendingCall;
	import temple.core.debug.IDebuggable;
	import temple.core.destruction.Destructor;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.data.collections.HashMap;
	import temple.data.index.Indexer;
	import temple.facebook.adapters.IFacebookAdapter;
	import temple.facebook.data.FacebookParser;
	import temple.facebook.data.IFacebookParser;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.enum.FacebookConstant;
	import temple.facebook.data.enum.FacebookDisplayMode;
	import temple.facebook.data.enum.FacebookError;
	import temple.facebook.data.enum.FacebookFieldAlias;
	import temple.facebook.data.enum.FacebookRequestMethod;
	import temple.facebook.data.enum.FacebookUIMethod;
	import temple.facebook.data.facebook;
	import temple.facebook.data.vo.FacebookAppRequestData;
	import temple.facebook.data.vo.FacebookApplicationData;
	import temple.facebook.data.vo.FacebookErrorData;
	import temple.facebook.data.vo.FacebookFQLMultiQuery;
	import temple.facebook.data.vo.FacebookPostData;
	import temple.facebook.data.vo.FacebookResult;
	import temple.facebook.data.vo.FacebookUserData;
	import temple.facebook.data.vo.IFacebookApplicationData;
	import temple.facebook.data.vo.IFacebookErrorData;
	import temple.facebook.data.vo.IFacebookFields;
	import temple.facebook.data.vo.IFacebookObjectData;
	import temple.facebook.data.vo.IFacebookProfileData;
	import temple.facebook.data.vo.IFacebookResult;
	import temple.facebook.data.vo.IFacebookUserData;
	import temple.facebook.events.FacebookEvent;
	import temple.facebook.events.FacebookPermissionEvent;
	import temple.facebook.utils.FacebookFQLMultiQueryParser;
	import temple.facebook.utils.FacebookPermissionMap;
	import temple.utils.FrameDelay;
	import temple.utils.types.DateUtils;

	import com.facebook.graph.data.FacebookAuthResponse;
	import com.facebook.graph.data.FacebookSession;

	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * Dispatched when the user is logged in into Facebook.
	 * 
	 * @eventType temple.facebook.events.FacebookEvent.LOGIN
	 */
	[Event(name = "FacebookEvent.login", type = "temple.facebook.events.FacebookEvent")]

	/**
	 * Dispatched when the user logs out from Facebook.
	 * 
	 * @eventType temple.facebook.events.FacebookEvent.LOGOUT
	 */
	[Event(name = "FacebookEvent.logout", type = "temple.facebook.events.FacebookEvent")]

	/**
	 * Dispatched when the FacebookService is initialized
	 * 
	 * @eventType flash.events.Event.INIT
	 */
	[Event(name = "init", type = "flash.events.Event")]

	/**
	 * Dispatched when the user allowes some permissions
	 * 
	 * @eventType temple.facebook.events.FacebookPermissionEvent.ALLOWED
	 */
	[Event(name = "FacebookPermissionEvent.allowed", type = "temple.facebook.events.FacebookPermissionEvent")]

	/**
	 * Dispatched when the user denies some permissions
	 * 
	 * @eventType temple.facebook.events.FacebookPermissionEvent.DENIED
	 */
	[Event(name = "FacebookPermissionEvent.denied", type = "temple.facebook.events.FacebookPermissionEvent")]

	/**
	 * Dispatched when the allowed permissions are updated
	 * 
	 * @eventType temple.facebook.events.FacebookPermissionEvent.UPDATE
	 */
	[Event(name = "FacebookPermissionEvent.update", type = "temple.facebook.events.FacebookPermissionEvent")]

	/**
	 * Wrapper around the "Adobe ActionScript 3 SDK for Facebook Platform API".
	 * 
	 * Als je niet alle functionaliteit van de API nodig hebt en filesize is belangrijk, dan kan je alleen de service gebruiken zonder de API.
	 * Je moet dan wel zelf aangeven als wat voor type je de results geparsed wilt hebben. Dit kan bij de call (get/post) zelf of door van te voren
	 * VO classes te registreren voor bepaalde method. link naar 'registerVO()'
	 * 
	 * Wordt afgehandeld door de service:
	 * - inloggen en permissies
	 * - strong typed results
	 * - caching van calls
	 * - caching van FacebookObjecten
	 * 
	 * 
	 * Note: Channel URL (bij constructor of login) moet absoluut path zijn en het domein (ook subdomain en http of https) moet gelijk zijn aan die van de applicatie.
	 * example van channel.html toevoegen
	 * 
	 * Note: login kan alleen na click ivm popup blockers, calls die door autoPermissions een login kunnen veroorzaken dus altijd achter een click zetten
	 * 
	 * Note: pas als de init complete is geweest kunnen andere calls plaats vinden. Calls die gedaan worden voor de init worden gequeueud en na init alsnog uitgevoerd.
	 * 
	 * Note: als de init niet komt, dan checken:
	 * 		- channelURL (absolute path, same as application, include protocol) specially in ie7
	 * 		- applicationId
	 * 		- matcht de url met de settings
	 *
	 * @see temple.facebook.adapters.FacebookAdapter 
	 * @see http://developers.facebook.com/docs/reference/api/
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookService extends CoreEventDispatcher implements IFacebookService, IDebuggable
	{
		private var _adapter:IFacebookAdapter;
		private var _application:FacebookApplicationData;
		private var _me:IFacebookUserData;
		private var _cacheMap:HashMap;
		private var _parseMap:Dictionary;
		private var _secure:Boolean;
		private var _voRegistry:HashMap;
		private var _permissions:Vector.<String>;
		private var _optionalPermissions:Vector.<String>;
		private var _autoPermissions:Boolean;
		private var _initialized:Boolean;
		private var _queue:Vector.<FacebookCall>;
		private var _allowed:Object;
		private var _synchronous:Boolean;
		private var _currentCall:IFacebookCall;
		private var _checkPermissionsAfterLogin:Boolean = true;
		private var _parser:FacebookParser;
		private var _initCallback:Function;

		/**
		 * Create a new FacebookService.
		 * 
		 * <p>Allthough this is not a Singleton, you should create only one instance of the FacebookAPI
		 * since it uses the orginal Facebook class (where this FacebookAPI is based on) is a Singleton.</p>
		 * 
		 * @param adapter an IFacebookAdapter which is a wrapper around the "Adobe ActionScript 3 SDK for Facebook
		 * 	Platform API". There are different adaptars for web, desktop and mobile.
		 * @param autoPermissions is set to true, the FacebookService will automatically handle all Facebook permissions
		 * @param cache if set to true, all calls will be cached.
		 */
		public function FacebookService(adapter:IFacebookAdapter, autoPermissions:Boolean = true, cache:Boolean = true)
		{
			if (adapter == null) throwError(new TempleArgumentError(this, "adapter cannot be null"));
			
			toStringProps.push('application', 'adapter');
			
			_adapter = adapter;
			_autoPermissions = autoPermissions;
			_permissions = new Vector.<String>();
			_optionalPermissions = new Vector.<String>();
			_queue = new Vector.<FacebookCall>();
			_parseMap = new Dictionary(true);
			this.cache = cache;
			this.secure = secure;
			_voRegistry = new HashMap();
			_parser = new FacebookParser(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get adapter():IFacebookAdapter
		{
			return _adapter;
		}
		
		/**
		 * @inheritDoc
		 */
		public function init(applicationId:String, callback:Function = null, accessToken:String = null):void
		{
			if (!_application || _application.id != applicationId)
			{
				_initCallback = callback;
				_application = _parser.parse({id: applicationId}, FacebookApplicationData, FacebookFieldAlias.GRAPH) as FacebookApplicationData;
				_adapter.init(applicationId, onInit, accessToken);
			}
		}

		private function onInit(success:Object, fail:Object):void
		{
			if (debug) logDebug("onInit: success=" + success);
			
			if (success && success.uid)
			{
				// Create the FacebookUserData object for this user
				_me = _parser.parse("user" in success ? success.user : success.uid, FacebookUserData, FacebookFieldAlias.GRAPH) as FacebookUserData;
				dispatchEvent(new FacebookEvent(FacebookEvent.LOGIN));
			
				if (debug) logDebug("onInit: user is already logged in. Get permissions.");
				
				_checkPermissions();
			}
			else if (fail)
			{
				logError(fail);
			}
			else
			{
				if (_queue.length)
				{
					var call:FacebookCall = _queue.shift();
					new FrameDelay(call.method == FacebookConstant.LOGIN ? loginCall : this.call, 1, [call]);
				}
			}
			_initialized = true;
			if (debug) logDebug("onInit: initialized");
			dispatchEvent(new Event(Event.INIT));
			if (_initCallback != null)
			{
				_initCallback(new FacebookResult(null, fail == null, success));
				_initCallback = null;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function loadPolicyFiles():void
		{
			Security.loadPolicyFile('https://graph.facebook.com/crossdomain.xml');
			Security.loadPolicyFile('https://fbcdn-profile-a.akamaihd.net/crossdomain.xml');
			Security.loadPolicyFile('https://m.ak.fbcdn.net/crossdomain.xml');
		}


		/**
		 * @inheritDoc
		 */
		public function get application():IFacebookApplicationData
		{
			return _application;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get permissions():Vector.<String>
		{
			return _permissions;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get optionalPermissions():Vector.<String>
		{
			return _optionalPermissions;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isInitialized():Boolean
		{
			return _initialized;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoggedIn():Boolean
		{
			return _me != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get permissionsLoaded():Boolean
		{
			return _allowed != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get accessToken():String
		{
			if (_adapter)
			{
				if (_adapter.authResponse) return _adapter.authResponse.accessToken;
				if (_adapter.session) return _adapter.session.accessToken;
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get signedRequest():String
		{
			return _adapter && _adapter.authResponse ? _adapter.authResponse.signedRequest : null;
		}

		/**
		 * @inheritDoc
		 */
		public function get expireDate():Date
		{
			if (_adapter)
			{
				if (_adapter.authResponse) return _adapter.authResponse.expireDate;
				if (_adapter.session) return _adapter.session.expireDate;
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getImageUrl(id:String, size:String = null):String
		{
			var url:String = _adapter.getImageUrl(id, size);
			if (accessToken) url += (url.indexOf("?") == -1 ? "?" : "&") + "access_token=" + accessToken;
			return url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get me():IFacebookUserData
		{
			return _me;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get parser():IFacebookParser
		{
			return _parser;
		}

		/**
		 * @inheritDoc
		 */
		public function login(callback:Function = null, permissions:Vector.<String> = null):IFacebookCall
		{
			return loginCall(new FacebookCall(this, FacebookConstant.LOGIN, FacebookConstant.ME, callback, permissions));
		}
		
		private function loginCall(call:FacebookCall):IFacebookCall
		{
			if (debug) logDebug("loginCall: " + call);
			
			dispatchEvent(new PendingCallEvent(PendingCallEvent.CALL, call));
			call.addEventListenerOnce(Event.COMPLETE, handleCallComplete);
			
			if (!_initialized)
			{
				if (debug) logInfo("not initialized yet, queue call");
				_queue.push(call);
			}
			else
			{
				var permissions:Vector.<String> = call.params as Vector.<String> || new Vector.<String>();
				
				for each (var permission:String in _permissions)
				{
					if (permissions.indexOf(permission) == -1) permissions.push(permission);
				}
				
				if (debug) logInfo("login, permissions=" + permissions);
				
				// check if permissions are already allowed
				var login:Boolean;
				if (isLoggedIn)
				{
					loop: for each (permission in permissions)
					{
						switch (isAllowed(permission)) 
						{
							case 1:
								// allowed, next
								break;
							
							case 0:
								// not allowed
								if (debug) logDebug("'" + permission + "' not allowed, login");
								login = true;
								break loop;

							case -1:
								// don't know. Just login
								if (debug) logDebug("Don't know if '" + permission + "' is not allowed, login");
								login = true;
								break loop;
						}
					}
				}
				
				if (!isLoggedIn || login)
				{
					// Add optional permissions
					for each (permission in _optionalPermissions)
					{
						if (permissions.indexOf(permission) == -1) permissions.push(permission);
					}
					
					/**
					 * For some reason the 'availablePermissions' property is not filled with the first callback. The availablePermissions is filled later.
					 * For that reason we just wait a frame the let the availablePermissions get filled. Not sure if this is the best solution.
					 */
					_adapter.login(function(success:Object, fail:Object):void { new FrameDelay(onLogin, 1, [success, fail, call]); }, permissions);
				}
				else
				{
					if (debug) logDebug("login: all required permissions are already allowed, continue");
					call.execute(new FacebookResult(call, true));
				}
			}
			return call;
		}
		
		private function onLogin(success:Object, fail:Object, call:FacebookCall):void 
		{
			if (debug) logDebug("onLogin: " + success);
			
			var permission:String, permissions:Vector.<String>;
			if (success is FacebookAuthResponse)
			{
				var response:FacebookAuthResponse = FacebookAuthResponse(success);
				
				if (!_me && response.uid)
				{
					_me = _parser.parse(response.uid, FacebookUserData) as IFacebookUserData;
					dispatchEvent(new FacebookEvent(FacebookEvent.LOGIN));
				}
				
				if (_checkPermissionsAfterLogin)
				{
					if (debug) logDebug("onLogin: Check permissions");
					
					_checkPermissions(function (result:IFacebookResult):void
					{
						if (result.success)
						{
							var denied:Vector.<String> = new Vector.<String>();
							// Check if the requested permissions are allowed
							for each (permission in call.params)
							{
								if (!isAllowed(permission))
								{
									denied.push(permission);
								}
							}
							if (denied.length)
							{
								if (debug) logDebug("denied: " + denied);
								dispatchEvent(new FacebookPermissionEvent(FacebookPermissionEvent.DENIED, denied));
								// Not allowed, return error
								onResult(null, FacebookError.ACCESS_DENIED, call);
								return;
							}
							dispatchEvent(new FacebookPermissionEvent(FacebookPermissionEvent.ALLOWED, Vector.<String>(call.params ? (call.params as Vector.<String>).concat() : new Vector.<String>())));
						}
						onResult(success, fail, call);
					});
				}
				else
				{
					_allowed ||= {};
					permissions = new Vector.<String>();
					for each (permission in call.params)
					{
						_allowed[permission] = 1;
						permissions.push(permission);
					}
					if (debug) logDebug("Allowed permissions: " + permissions.join(", "));
					dispatchEvent(new FacebookPermissionEvent(FacebookPermissionEvent.ALLOWED, permissions));
					
					onResult(success, fail, call);
				}
			}
			else if (success is FacebookSession)
			{
				var session:FacebookSession = FacebookSession(success);
				
				if (!_me)
				{
					_me = _parser.parse(session.user, FacebookUserData) as IFacebookUserData;
					dispatchEvent(new FacebookEvent(FacebookEvent.LOGIN));
				}
				
				_allowed ||= {};
				permissions = new Vector.<String>();
				for each (permission in session.availablePermissions)
				{
					_allowed[permission] = 1;
					permissions.push(permission);
				}
				if (debug) logDebug("Allowed permissions: " + permissions.join(", "));
				dispatchEvent(new FacebookPermissionEvent(FacebookPermissionEvent.ALLOWED, permissions.concat()));
				
				onResult(success, fail, call);
			}
			else
			{
				// Called failed without fail object, so we create one
				onResult(success, fail || {}, call);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function logout(callback:Function = null):IFacebookCall
		{
			return logoutCall(new FacebookCall(this, FacebookConstant.LOGOUT, FacebookConstant.ME, callback));
		}
		
		private function logoutCall(call:FacebookCall):IFacebookCall
		{
			if (debug) logDebug("logoutCall: " + call);
			
			dispatchEvent(new PendingCallEvent(PendingCallEvent.CALL, call));
			call.addEventListenerOnce(Event.COMPLETE, handleCallComplete);

			_adapter.logout(function(success:Boolean):void { onLogout(success, call); });
			
			dispatchEvent(new FacebookEvent(FacebookEvent.LOGOUT));

			return call;
		}
		
		private function onLogout(success:Boolean, call:FacebookCall):void 
		{
			if (debug) logDebug("onLogout: " + success);
			
			if (success)
			{
				// Clear current call
				if (_currentCall)
				{
					_currentCall.cancel();
					_currentCall.destruct();
					_currentCall = null;
				}
				
				// Clear queue
				while (_queue.length) _queue.shift().destruct();
				
				// Clear cache
				if (_cacheMap) _cacheMap.clear();
				for (var key : Object in _parseMap)
				{
					ParseData(_parseMap[key]).destruct();
					delete _parseMap[key];
				}
				
				// Clear allowed permissions
				_allowed = null;
				
				// Cleared objects from Indexer
				Indexer.clear(IFacebookObjectData);
				Indexer.clear(IFacebookProfileData);
				
				// Store application, since this won't change
				Indexer.add(_application, IFacebookObjectData);
			}
			
			onResult(success, success ? null : true, call);
		}

		/**
		 * private used method for checking permissions
		 */
		private function _checkPermissions(callback:Function = null):void
		{
			_adapter.api(FacebookConstant.ME + "/" + FacebookConnection.PERMISSIONS, function (success:Object, fail:Object):void
			{
				if (success && success is Array)
				{
					_allowed ||= {};
					var permissions:Vector.<String> = new Vector.<String>();
					var allowed:Object = success[0];
					for (var permission:String in allowed)
					{
						_allowed[permission] = allowed[permission];
						permissions.push(permission);
					}
					if (debug) logDebug("_checkPermissions, allowed: " + permissions);
					dispatchEvent(new FacebookPermissionEvent(FacebookPermissionEvent.UPDATE, permissions));
				}
				if (callback != null)
				{
					callback(new FacebookResult(null, success != null, success || fail));
				}
				else
				{
					if (_initialized && _queue.length)
					{
						var facebookCall:FacebookCall = _queue.shift();
						new FrameDelay(facebookCall.method == FacebookConstant.LOGIN ? loginCall : call, 1, [facebookCall]);
					}
				}
			});
		}

		/**
		 * @inheritDoc
		 */
		public function get(callback:Function = null, method:String = null, id:String = FacebookConstant.ME, objectClass:Class = null, params:Object = null, fields:IFacebookFields = null, forceReload:Boolean = false):IFacebookCall
		{
			objectClass ||= _voRegistry[method];
			
			return call(new FacebookCall(this, method, id, callback, params, FacebookRequestMethod.GET, objectClass, fields, forceReload));
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObjects(ids:Vector.<String>, callback:Function = null, objectClass:Class = null, params:Object = null, fields:IFacebookFields = null, forceReload:Boolean = false):IFacebookCall
		{
			params ||= {};
			params.ids = ids.join(",");
			
			return call(new FacebookCall(this, null, null, callback, params, FacebookRequestMethod.GET, objectClass, fields, forceReload));
		}
		
		/**
		 * @inheritDoc
		 */
		public function post(method:String, callback:Function = null, id:String = FacebookConstant.ME, params:Object = null, objectClass:Class = null):IFacebookCall
		{
			return call(new FacebookCall(this, method, id, callback, params, FacebookRequestMethod.POST, objectClass, null, true));
		}
		
		/**
		 * @inheritDoc
		 */
		public function deleteObject(method:String, callback:Function = null, id:String = 'me', params:Object = null):IFacebookCall
		{
			return call(new FacebookCall(this, method, id, callback, params, FacebookRequestMethod.DELETE, null, null, true));
		}
		
		/**
		 * @inheritDoc
		 */
		public function fql(query:String, callback:Function = null, objectClass:Class = null, fields:IFacebookFields = null, id:String = null):IFacebookCall
		{
			return call(new FacebookCall(this, query, id, callback, null, FacebookRequestMethod.FQL, objectClass, fields));
		}
		
		/**
		 * @inheritDoc
		 */
		public function fqlMultiQuery(queries:FacebookFQLMultiQuery, callback:Function = null):IFacebookCall
		{
			return call(new FacebookCall(this, null, null, callback, queries, FacebookRequestMethod.FQL_MULTI_QUERY));
		}
		
		/**
		 * @private
		 */
		internal function call(call:FacebookCall):IFacebookCall
		{
			if (debug)
			{
				logDebug(call.requestMethod + ": /" + (call.id ? call.id + "/" : "") + (call.method || ""));
				if (!call.creationTime) call.creationTime = getTimer();
			}
			
			if (!_initialized && !call.forced)
			{
				if (debug) logInfo("not initialized yet, queue call");
				_queue.push(call);
				return call;
			}
			else if (_synchronous && !call.forced)
			{
			 	if (_currentCall && _currentCall != call)
				{
					if (debug) logInfo("synchrone enabled, add to queue. Current call: " + _currentCall);
					_queue.push(call);
					return call;
				}
				_currentCall = call;
			}
			
			if (!call.isLoading)
			{
				call.setIsLoading(true);
				if (debug && !call.callTime) call.callTime = getTimer();
				dispatchEvent(new PendingCallEvent(PendingCallEvent.CALL, call));
				call.addEventListenerOnce(Event.COMPLETE, handleCallComplete);
			}
			
			if (call.forced && _queue.indexOf(call) != -1)
			{
				_queue.splice(_queue.indexOf(call), 1);
			}
			
			var id:String = call.id;
			var method:String = (id ? "/" + id : "") + "/" + (call.method || "");
			
			// replace id for me if it is the users id
			if (_me && id == _me.id) id = FacebookConstant.ME;
			
			// Is cache enabled for this call?
			if (cache && !call.forceReload)
			{
				// Try to get the data from the cacheMap or from the indexer.
				var data:* = _cacheMap[method];
				// This call isn't cached, but maybe we already loaded this object with an other call.
				if (!data && !call.method)
				{
					data = Indexer.get(IFacebookObjectData, call.id);
					// Cast to the correct type
					if (data && call.objectClass) data = data as call.objectClass;
				}
				// Check if we have all the fields we want
				if (data && !(data is Array) && call.fields)
				{
					for each (var field:String in call.fields.getFieldsList(FacebookFieldAlias.NONE))
					{
						if (!data[field])
						{
							if (debug) logDebug("call: field '" + field + "' is missing in cached data, force reload");
							data = null;
							break;
						}
					}
				}
				if (data)
				{
					if (debug) logDebug("call: get result from cache");
					_currentCall = null;
					
					// if data is an Array, make a copy so we can't modify the cached result
					if (data is Array) data = (data as Array).slice();
					
					new FrameDelay(call.execute, 1, [new FacebookResult(call, true, data)]);
					return call;
				}
				// data not found in cache, continue.
			}
			
			if (_autoPermissions && !call.forced)
			{
				// make a copy of the permissions array and append all permissions needed for this call
				var permissions:Vector.<String> = _permissions.slice();
				
				// Get permissions
				var permission:String = FacebookPermissionMap.getForMethod(this, call.method, id, call.requestMethod);
				if (permission && permissions.indexOf(permission) == -1)
				{
					permissions.push(permission);
				}
				if (call.fields)
				{
					var fieldsPermissions:Vector.<String> = call.fields.getPermissions(call.method != FacebookConnection.FRIENDS && id == FacebookConstant.ME);
					if (fieldsPermissions) permissions = permissions.concat(fieldsPermissions);
				}
				if (debug) logDebug("call: permissions = " + permissions);
				
				var login:Boolean;
				// check if we already have permissions otherwise, first login again with new permissions
				for each (permission in permissions)
				{
					if (!isAllowed(permission))
					{
						if (debug) logDebug("call: '" + permission + "' not allowed, login");
						login = true;
						break;
					}
				}
				
				if (!isLoggedIn || login)
				{
					var scope:FacebookService = this;
					
					this.login(function (result:IFacebookResult): void
					{
						if (debug) logDebug("logged in: " + result);
						
						if (result.success)
						{
							var permission:String = FacebookPermissionMap.getForMethod(scope, call.method, id, call.requestMethod);
							if (isLoggedIn && (!permission || isAllowed(permission)))
							{
								if (debug) logDebug("Permission '" + permission + "' allowed, retry previous call");
								// temporary switch off autopermissions
								var autoPermissions:Boolean = _autoPermissions;
								_autoPermissions = false;
								scope.call(call);
								_autoPermissions = autoPermissions; 
							}
							else
							{
								if (debug)
								{
									if (!isLoggedIn)
									{
										logWarn("Not logged in, fail");
									}
									else
									{
										logWarn("Permission '" + permission + "' denied, fail");
									}
								}
								scope._currentCall = null;
								call.execute(new FacebookResult(call, false, null, FacebookError.ACCESS_DENIED, FacebookError.ACCESS_DENIED));
							}
						}
						else
						{
							call.execute(result);
						}
					}, permissions);
					return call;
				}
			}
			
			if (call.requestMethod == FacebookRequestMethod.FQL)
			{
				_adapter.fqlQuery(call.method, function(success:Object, fail:Object):void { onResult(success, fail, call); }, call.params);
			}
			else if (call.requestMethod == FacebookRequestMethod.FQL_MULTI_QUERY)
			{
				_adapter.fqlMultiQuery(FacebookFQLMultiQuery(call.params).facebook::queries, function(success:Object, fail:Object):void
				{
					onResult(success, fail, call);
				}, new FacebookFQLMultiQueryParser(this, FacebookFQLMultiQuery(call.params)));
			}
			else
			{
				var metadata:Boolean = debug;
				var params:* = call.params;
				// convert dates to string (format 2011-10-18T12:13:34)
				if (params)
				{
					for (var key:String in params)
					{
						if (params[key] is Date) params[key] = DateUtils.format("Y-m-d\\TH:i:s", params[key]);
					}
				}
				if (call.fields)
				{
					params ||= {};
					params.fields = call.fields.getFieldsString(FacebookFieldAlias.GRAPH);
					if (debug) logDebug("get: fields = " + params.fields);
				}
				var requestMethod:String;
				if (call.requestMethod == FacebookRequestMethod.DELETE)
				{
					requestMethod = FacebookRequestMethod.POST.value;
					params ||= {};
					params.method = 'delete';
				}
				else
				{
					requestMethod = call.requestMethod ? call.requestMethod.value : null;
					if (!call.objectClass && call.id && !getObject(id)) metadata = true;
				}
				if (debug) call.requestTime = getTimer();
				
				_adapter.api(method + (method.indexOf('?') == -1 ? '?' : '&') + "date_format=U&" + (_secure ? "return_ssl_resources=1&" : "") + (metadata ? "metadata=1&" : ""), function(success:Object, fail:Object):void { onResult(success, fail, call); }, params, requestMethod);
			}
			return call;
		}

		/**
		 * @inheritDoc
		 */
		public function ui(method:String, data:Object, callback:Function = null, display:FacebookDisplayMode = null):IFacebookCall
		{
			display ||= FacebookDisplayMode.POPUP;

			var call:FacebookCall = new FacebookCall(this, method, null, callback);
			_adapter.ui(method, data, function (response:*):void
			{
				if (debug) logDebug("UI Response: " + dump(response));
				
				var success:Boolean;
				var data:* = response;
				
				switch (method)
				{
					case FacebookUIMethod.FEED_DIALOG:
					{
						success = Boolean(response && response.post_id);
						if (success)
						{
							data = parser.parse(response.post_id, FacebookPostData);
						}
						break;
					}
					case FacebookUIMethod.REQUESTS_DIALOG:
					{
						success = Boolean(response && response.request_ids);
						if (success)
						{
							data = parser.parse(response.request_ids, FacebookAppRequestData);
						}
						break;
					}
					case FacebookUIMethod.FRIENDS_DIALOG:
					{
						success = Boolean(response && response.action);
						break;
					}
					case FacebookUIMethod.PAY_DIALOG:
					{
						success = Boolean(response && response.order_id);
						break;
					}
					case FacebookUIMethod.OAUTH_DIALOG:
					{
						success = Boolean(response && !response.error);
						break;
					}
					case FacebookUIMethod.SEND_DIALOG:
					{
						success = Boolean(response && response.success);
						break;
					}
					default:
					{
						success = Boolean(response);
						logWarn("ui: can't devine if response is successful (" + method + ")");
						break;
					}
				}
				if (debug)
				{
					if (success)
					{
						logDebug("success");
					}
					else
					{
						logError("fail");
					}
				}
				
				call.execute(new FacebookResult(call, success, data));
			}
			, display.value);
			return call;
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerVO(method:String, voClass:Class):void
		{
			_voRegistry[method] = voClass;
			if (debug) logDebug("registerVO: '" + method + "' to " + voClass);
		}

		private function onResult(success:Object, fail:Object, call:FacebookCall):void
		{
			if (debug)
			{
				call.responseTime = getTimer();
				logDebug("onResult: call=" + call + ", success=" + success + ", fail=" + fail);
			}
			
			if (fail && !success)
			{
				logError(call.method + ": " + dump(fail));
				
				if ('error' in fail)
				{
					var error:IFacebookErrorData = _parser.parse(fail.error, FacebookErrorData) as IFacebookErrorData;
					var message:String = error.message;
					var code:String = error.code.toString();
				}
				if (call) call.execute(new FacebookResult(call, false, error || fail, message, code));
			}
			else if (success && 'error_code' in success)
			{
				logError(call.method + ": " + success.error_msg);
				if (call) call.execute(new FacebookResult(call, false, success, success.error_msg, success.error_code));
			}
			else if (success === false)
			{
				logError(call.method);
				if (call) call.execute(new FacebookResult(call, false, success));
			}
			else if (success && 'uid' in success && success.uid == null)
			{
				if (call)
				{
					logError(call.method + ": success, but no uid (canceled login?)");
					call.execute(new FacebookResult(call, false, success));
				}
			}
			else
			{
				if (debug) logDebug("onResult: " + (call && call.method ? call.method : this) + ": " + (success ? (success is Array ?  (success as Array).length + " objects" : dump(success, 1)) : ""));
				
				if (call)
				{
					var data:* = success;
					
					if (call.method == FacebookConnection.PERMISSIONS && success is Array)
					{
						_allowed = {};
						var permissions:Vector.<String> = new Vector.<String>();
						var allowed:Object = success[0];
						for (var permission:String in allowed)
						{
							_allowed[permission] = allowed[permission];
							permissions.push(permission);
						}
						if (debug) logDebug("onResult, allowed:\n" + permissions);
						dispatchEvent(new FacebookPermissionEvent(FacebookPermissionEvent.UPDATE, permissions));
					}
					else
					{
						var objectClass:Class = call.objectClass;
						
						if (!objectClass && ('type' in data || 'metadata' in data && 'type' in data.metadata))
						{
							var type:String = ('type' in data) ? data.type : data.metadata.type;
				
							if (type in FacebookParser.facebook::CLASS_MAP)
							{
								objectClass = FacebookParser.facebook::CLASS_MAP[type];
							}
							else
							{
								logWarn("No class defined for type '" + type + "'");
							}
						}
						
						if (objectClass)
						{
							if (debug) logDebug("onResult: parse to " + objectClass);
							
							// If loaded with a list of ids, convert to Array
							if (call.params && call.params.ids)
							{
								data = [];
								for each (var object : * in success) data.push(object);
							}
							
							data = _parser.parse(data, objectClass, call.requestMethod == FacebookRequestMethod.FQL || call.requestMethod == FacebookRequestMethod.FQL_MULTI_QUERY ? FacebookFieldAlias.FQL : FacebookFieldAlias.GRAPH, getObject(call.id));
							
							if (_cacheMap)
							{
								// store data in cache. If data is an Array, make a copy so we can't modify the cached result
								_cacheMap["/" + call.id + "/" + (call.method || "")] = data is Array ? (data as Array).slice() : data;
								if (debug) logDebug("onResult: data stored in cache");
							}
						}
					}
					// store unparsed data
					_parseMap[data] = new ParseData(success, call.objectClass);
					if (debug) call.resultTime = getTimer();
					call.execute(new FacebookResult(call, true, data || success));
				}
			}
			_currentCall = null;
			if (_initialized && _queue.length)
			{
				call = _queue.shift();
				new FrameDelay(call.method == FacebookConstant.LOGIN ? loginCall : this.call, 1, [call]);
			}
		}
		
		/**
		 * A Boolean which indicates if permissions will be retreived automatically (true) or not (false).
		 * @default true
		 */
		public function get autoPermissions():Boolean
		{
			return _autoPermissions;
		}

		/**
		 * @private
		 */
		public function set autoPermissions(value:Boolean):void
		{
			_autoPermissions = value;
		}
		
		/**
		 * When set to true https will be used for all URLs
		 */
		public function get secure():Boolean
		{
			return _secure;
		}

		/**
		 * @private
		 */
		public function set secure(value:Boolean):void
		{
			_secure = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get cache():Boolean
		{
			return Boolean(_cacheMap);
		}

		/**
		 * @inheritDoc
		 */
		public function set cache(value:Boolean):void
		{
			if (value)
			{
				_cacheMap ||= new HashMap();
			}
			else if (_cacheMap)
			{
				_cacheMap.destruct();
				_cacheMap = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function isAllowed(permission:String):int
		{
			return _allowed && _allowed[permission] ? 1 : (permission.indexOf('.') != -1 ? -1 : 0);
		}
		
		/**
		 * @inheritDoc
		 */
		public function areAllowed(permissions:Vector.<String>):Boolean
		{
			for each (var permission:String in permissions)
			{
				if (!isAllowed(permission)) return false;
			}
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAllowedPermissions():Vector.<String>
		{
			var allowed:Vector.<String> = new Vector.<String>();
			
			for (var permission:String in _allowed)
			{
				allowed.push(permission);
			}
			return allowed;
		}

		/**
		 * @inheritDoc
		 */
		public function get requiredPermissionsAllowed():Boolean
		{
			return areAllowed(permissions);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObject(id:String, createIfNull:Boolean = false, type:Class = null):IFacebookObjectData
		{
			if (id == FacebookConstant.ME) return _me;
			
			return (createIfNull ? _parser.parse(id, type) : Indexer.get(IFacebookObjectData, id)) as IFacebookObjectData;
		}

		/**
		 * @inheritDoc
		 */
		public function getProfile(id:String, createIfNull:Boolean = false):IFacebookProfileData
		{
			return (createIfNull ? _parser.parse(id, IFacebookProfileData) : Indexer.get(IFacebookProfileData, id)) as IFacebookProfileData;
		}
		
		/**
		 * A Boolean which indicates if all calls will be handled synchronously (true) or asynchronously (false). Default: asynchronously (false)
		 * @default false
		 */
		public function get synchronous():Boolean
		{
			return _synchronous;
		}
		
		/**
		 * @private
		 */
		public function set synchronous(value:Boolean):void
		{
			_synchronous = value;
		}
		
		/**
		 * The call which is currently being loaded.
		 * Only available when synchrone is enabled.
		 */
		public function get currentCall():IFacebookCall
		{
			return _currentCall;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get checkPermissionsAfterLogin():Boolean
		{
			return _checkPermissionsAfterLogin;
		}

		/**
		 * @inheritDoc
		 */
		public function set checkPermissionsAfterLogin(value:Boolean):void
		{
			_checkPermissionsAfterLogin = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getUnparsedResult(data:Object):Object
		{
			return data in _parseMap ? ParseData(_parseMap[data]).unparsed : null;
		}

		public function getRawResult(data:Object):Object
		{
			return _adapter.getRawResult(getUnparsedResult(data));
		}

		/**
		 * @inheritDoc
		 */
		public function hasNext(data:Object):Boolean
		{
			return _adapter.hasNext(getUnparsedResult(data));
		}

		/**
		 * @inheritDoc
		 */
		public function hasPrevious(data:Object):Boolean
		{
			return _adapter.hasPrevious(getUnparsedResult(data));
		}

		/**
		 * @inheritDoc
		 */
		public function getNext(data:Object, callback:Function):IFacebookCall
		{
			var parseData:ParseData = ParseData(_parseMap[data]);
			var call:FacebookCall = new FacebookCall(this, null, null, callback, null, null, parseData ? parseData.parseClass : null);
			if (parseData)
			{
				_adapter.nextPage(parseData.unparsed, function(success:Object, fail:Object):void { onResult(success, fail, call); });
			}
			else
			{
				new FrameDelay(call.execute, 1, [new FacebookResult(call, false, null, "no next page")]);
			}
			return call;
		}

		/**
		 * @inheritDoc
		 */
		public function getPrevious(data:Object, callback:Function):IFacebookCall
		{
			var parseData:ParseData = ParseData(_parseMap[data]);
			var call:FacebookCall = new FacebookCall(this, null, null, callback, null, null, parseData ? parseData.parseClass : null);
			if (parseData)
			{
				_adapter.previousPage(parseData.unparsed, function(success:Object, fail:Object):void { onResult(success, fail, call); });
			}
			else
			{
				new FrameDelay(call.execute, 1, [new FacebookResult(call, false, null, "no next page")]);
			}
			return call;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _adapter.debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_adapter.debug = value;
		}
		
		private function handleCallComplete(event:Event):void
		{
			if (debug) logDebug("handleCallComplete: " + event.target + "\n" + FacebookCall(event.target).getInfo());
			dispatchEvent(new PendingCallEvent(PendingCallEvent.RESULT, IPendingCall(event.target)));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_application = null;
			_currentCall = null;
			_me = null;
			_adapter = null;
			
			if (_cacheMap)
			{
				_cacheMap.destruct();
				_cacheMap = null;
			}
			if (_voRegistry)
			{
				_voRegistry.destruct();
				_voRegistry = null;
			}
			if (_permissions)
			{
				_permissions.length = 0;
				_permissions = null;
			}
			if (_optionalPermissions)
			{
				_optionalPermissions.length = 0;
				_optionalPermissions = null;
			}
			if (_parser)
			{
				_parser.destruct();
				_parser = null;
			}
			_queue = Destructor.destruct(_queue);
			_allowed = null;
			
			super.destruct();
		}

	}
}
import temple.core.destruction.IDestructible;

final class ParseData implements IDestructible
{
	internal var unparsed:Object;
	internal var parseClass:Class;

	public function ParseData(unparsed:Object, parseClass:Class)
	{
		this.unparsed = unparsed;
		this.parseClass = parseClass;
	}

	public function get isDestructed():Boolean
	{
		return unparsed == null && parseClass == null;
	}
	
	public function destruct():void
	{
		unparsed = null;
		parseClass = null;
	}
}