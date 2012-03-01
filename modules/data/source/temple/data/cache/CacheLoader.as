/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.data.cache 
{
	import temple.core.debug.addToDebugManager;
	import temple.core.display.CoreLoader;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * The CacheLoader stores the data (bytes) of the loaded images or SWF into the LoaderCache by URL.
	 * If the data of an URL is already in the LoaderCache it gets the bytes from the LoaderCache instead of reloading the image or SWF.
	 * 
	 * @see temple.data.cache.LoaderCache
	 * 
	 * @includeExample CacheLoaderExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CacheLoader extends CoreLoader implements ICacheable
	{
		private var _cacheURLLoader:CacheURLLoader;
		private var _reloadAfterError:Boolean = true;
		private var _context:LoaderContext;

		public function CacheLoader(logErrors:Boolean = true, cache:Boolean = true, reloadAfterError:Boolean = true)
		{
			super(logErrors);
			
			this._cacheURLLoader = new CacheURLLoader(null, false, logErrors, cache);
			this._cacheURLLoader.addEventListener(Event.COMPLETE, this.handleURLLoaderComplete);
			this._cacheURLLoader.addEventListener(Event.OPEN, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(Event.INIT, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(Event.UNLOAD, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(ProgressEvent.PROGRESS, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(IOErrorEvent.IO_ERROR, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(IOErrorEvent.DISK_ERROR, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(IOErrorEvent.NETWORK_ERROR, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(IOErrorEvent.VERIFY_ERROR, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.dispatchEvent);
			this._cacheURLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.dispatchEvent);
			
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError);
						
			addToDebugManager(this._cacheURLLoader, this);
			
			
			this.cache = cache;
			this._reloadAfterError = reloadAfterError;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isLoading():Boolean
		{
			return super.isLoading || this._cacheURLLoader.isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isLoaded():Boolean
		{
			return super.isLoaded && !this.isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get url():String
		{
			return super.url || (this._cacheURLLoader ? this._cacheURLLoader.url : null);
		}

		/**
		 * @inheritDoc
		 */
		override public function set debug(value:Boolean):void 
		{
			this._cacheURLLoader.debug = super.debug = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get cache():Boolean
		{
			return this._cacheURLLoader.cache;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set cache(value:Boolean):void
		{
			this._cacheURLLoader.cache = value;
			if (this.debug) this.logDebug("cache: " + value);
		}
		
		/**
		 * When set to true and cache is enabled, the cacheloader will reload the image with cache set to false if there is a SecurityError
		 */
		public function get reloadAfterError():Boolean
		{
			return this._reloadAfterError;
		}

		/**
		 * @private
		 */
		public function set reloadAfterError(value:Boolean):void
		{
			this._reloadAfterError = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest, context:LoaderContext = null):void
		{
			if (this.cache) this.unload();
			
			this._context = context;
			
			if (this.cache)
			{
				if (this.debug) this.logDebug("load: cache enabled ");
				this._cacheURLLoader.load(request);
			}
			else
			{
				if (this.debug) this.logDebug("load: cache disabled");
				super.load(request, context);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function close():void 
		{
			this._cacheURLLoader.close();
		}
		
		/**
		 * Loaded data as ByteArray
		 */
		public function get bytes():ByteArray
		{
			return this._cacheURLLoader.data || this.contentLoaderInfo.bytes;
		}

		private function handleURLLoaderComplete(event:Event):void
		{
			if (this._context) this._context.checkPolicyFile = false;
			this.loadBytes(this._cacheURLLoader.data, this._context);
		}
		
		private function handleSecurityError(event:SecurityErrorEvent):void 
		{
			if (this.cache && this._reloadAfterError)
			{
				this.logWarn("SecurityError: Cache is switched off. Reload...");
				this.cache = false;
				this.load(new URLRequest(this.url));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._cacheURLLoader)
			{
				this._cacheURLLoader.destruct();
				this._cacheURLLoader = null;
			}
			this._context = null;
			super.destruct();
		}
	}
}
