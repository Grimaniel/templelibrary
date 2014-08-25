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
			super(null, null, logErrors);
			
			_cacheURLLoader = new CacheURLLoader(null, false, logErrors, cache);
			_cacheURLLoader.addEventListener(Event.COMPLETE, handleURLLoaderComplete);
			_cacheURLLoader.addEventListener(Event.OPEN, dispatchEvent);
			_cacheURLLoader.addEventListener(Event.INIT, dispatchEvent);
			_cacheURLLoader.addEventListener(Event.UNLOAD, dispatchEvent);
			_cacheURLLoader.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			_cacheURLLoader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_cacheURLLoader.addEventListener(IOErrorEvent.DISK_ERROR, dispatchEvent);
			_cacheURLLoader.addEventListener(IOErrorEvent.NETWORK_ERROR, dispatchEvent);
			_cacheURLLoader.addEventListener(IOErrorEvent.VERIFY_ERROR, dispatchEvent);
			_cacheURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			_cacheURLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
						
			addToDebugManager(_cacheURLLoader, this);
			
			this.cache = cache;
			_reloadAfterError = reloadAfterError;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isLoading():Boolean
		{
			return super.isLoading || _cacheURLLoader.isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isLoaded():Boolean
		{
			return super.isLoaded && !isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get url():String
		{
			return super.url || (_cacheURLLoader && (isLoaded || isLoading) ? _cacheURLLoader.url : null);
		}

		/**
		 * @inheritDoc
		 */
		override public function set debug(value:Boolean):void 
		{
			_cacheURLLoader.debug = super.debug = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get cache():Boolean
		{
			return _cacheURLLoader.cache;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set cache(value:Boolean):void
		{
			_cacheURLLoader.cache = value;
			if (debug) logDebug("cache: " + value);
		}
		
		/**
		 * When set to true and cache is enabled, the cacheloader will reload the image with cache set to false if there is a SecurityError
		 */
		public function get reloadAfterError():Boolean
		{
			return _reloadAfterError;
		}

		/**
		 * @private
		 */
		public function set reloadAfterError(value:Boolean):void
		{
			_reloadAfterError = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest, context:LoaderContext = null):void
		{
			if (cache) unload();
			
			_context = context;
			
			if (cache)
			{
				if (debug) logDebug("load: cache enabled ");
				_cacheURLLoader.load(request);
			}
			else
			{
				if (debug) logDebug("load: cache disabled");
				super.load(request, context);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function close():void 
		{
			_cacheURLLoader.close();
		}
		
		/**
		 * Loaded data as ByteArray
		 */
		public function get bytes():ByteArray
		{
			return bytesLoaded ? (_cacheURLLoader.data || contentLoaderInfo.bytes) : null;
		}

		private function handleURLLoaderComplete(event:Event):void
		{
			if (_context) _context.checkPolicyFile = false;
			loadBytes(_cacheURLLoader.data, _context);
		}
		
		private function handleSecurityError(event:SecurityErrorEvent):void 
		{
			if (cache && _reloadAfterError)
			{
				logWarn("SecurityError: Cache is switched off. Reload...");
				cache = false;
				load(new URLRequest(url));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_cacheURLLoader)
			{
				_cacheURLLoader.destruct();
				_cacheURLLoader = null;
			}
			_context = null;
			super.destruct();
		}
	}
}
