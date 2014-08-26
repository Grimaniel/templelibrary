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
	import temple.core.destruction.DestructEvent;
	import temple.core.net.CoreURLLoader;
	import temple.utils.FrameDelay;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * The CacheLoader stores the data (bytes) of the loaded file into the LoaderCache by URL.
	 * If the data of an URL is already in the LoaderCache it gets the bytes from the LoaderCache instead of reloading the file.
	 * 
	 * @author Thijs Broerse
	 */
	public class CacheURLLoader extends CoreURLLoader implements ICacheable
	{
		private var _cache:Boolean;
		private var _cacheData:ILoaderCacheItem;
		private var _owner:Boolean;
		
		public function CacheURLLoader(request:URLRequest = null, destructOnError:Boolean = true, logErrors:Boolean = true, cache:Boolean = true)
		{
			super(null, URLLoaderDataFormat.BINARY, destructOnError, logErrors);
			
			_cache = cache;
			
			if (request) new FrameDelay(load, 1, [request]);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get url():String
		{
			return _cacheData ? _cacheData.url : super.url;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isLoading():Boolean
		{
			return _cache ? _cacheData && !_cacheData.isLoaded : super.isLoading;
		}

		/**
		 * @inheritDoc
		 */
		override public function get isLoaded():Boolean
		{
			return _cache ? _cacheData && _cacheData.isLoaded : super.isLoaded;
		}

		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest):void
		{
			// check if our current load is competed
			if (_owner && _cacheData && _cacheData.isLoading)
			{
				// we didn't finished the current load, delete it
				LoaderCache.clear(url);
				try
				{
					super.close();
				}
				catch (error:Error)
				{
					// ignore
				}
			}
			
			_owner = false;
			clearCacheData();
			
			if (_cache) _cacheData = LoaderCache.get(request.url);
			
			if (_cache && _cacheData)
			{
				if (_cacheData.isLoaded)
				{
					if (debug) logDebug("load: get data from cache, url:" + url);
					data = LoaderCache.get(url).bytes;
					dispatchEvent(new Event(Event.COMPLETE));
				}
				else
				{
					if (debug) logDebug("load: data is currently loading, wait... " + _cacheData.url);
					_cacheData.addEventListener(Event.COMPLETE, handleCacheDataComplete);
					_cacheData.addEventListener(Event.OPEN, dispatchEvent);
					_cacheData.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
					_cacheData.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
					_cacheData.addEventListener(IOErrorEvent.IO_ERROR, handleCacheDataError);
					_cacheData.addEventListener(IOErrorEvent.DISK_ERROR, handleCacheDataError);
					_cacheData.addEventListener(IOErrorEvent.NETWORK_ERROR, handleCacheDataError);
					_cacheData.addEventListener(IOErrorEvent.VERIFY_ERROR, handleCacheDataError);
					_cacheData.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleCacheDataError);
					_cacheData.addEventListener(DestructEvent.DESTRUCT, handleCacheDataDestuct);
					dispatchEvent(new Event(Event.OPEN));
				}
			}
			else
			{
				if (_cache)
				{
					_cacheData = LoaderCache.create(request.url);
					_owner = true;
					addEventListener(Event.OPEN, _cacheData.dispatchEvent);
					addEventListener(ProgressEvent.PROGRESS, _cacheData.dispatchEvent);
					addEventListener(IOErrorEvent.IO_ERROR, _cacheData.dispatchEvent);
					addEventListener(IOErrorEvent.DISK_ERROR, _cacheData.dispatchEvent);
					addEventListener(IOErrorEvent.NETWORK_ERROR, _cacheData.dispatchEvent);
					addEventListener(IOErrorEvent.VERIFY_ERROR, _cacheData.dispatchEvent);
					addEventListener(SecurityErrorEvent.SECURITY_ERROR, _cacheData.dispatchEvent);
					if (debug) logDebug("load: new LoaderCacheData created: " + _cacheData);
				}
				addEventListenerOnce(Event.COMPLETE, handleComplete);
				dataFormat = URLLoaderDataFormat.BINARY;
				super.load(request);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function close():void
		{
			// check if our current load is competed
			if (_owner && _cacheData && _cacheData.isLoading)
			{
				// we didn't finished the current load, delete it
				LoaderCache.clear(_cacheData.url);
			}
			super.close();
		}

		/**
		 * @inheritDoc
		 */
		public function get cache():Boolean
		{
			return _cache;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set cache(value:Boolean):void
		{
			_cache = value;
			if (debug) logDebug("cache: " + value);
		}

		private function handleComplete(event:Event):void
		{
			if (_cache && _owner)
			{
				if (debug) logDebug("handleComplete: store data in cache, url:" + url);
				LoaderCache.set(url, data);
			}
			clearCacheData();
		}

		private function handleCacheDataComplete(event:Event):void 
		{
			data = _cacheData.bytes;
			clearCacheData();
			dispatchEvent(event);
		}
		
		private function handleCacheDataError(event:ErrorEvent):void 
		{
			if (debug) logWarn(event.type + ": \"" + event.text + "\"");
			clearCacheData();
			LoaderCache.clear(url);
			dispatchEvent(event);
		}
		
		private function clearCacheData():void 
		{
			if (_cacheData)
			{
				_cacheData.removeEventListener(Event.COMPLETE, handleCacheDataComplete);
				_cacheData.removeEventListener(Event.OPEN, dispatchEvent);
				_cacheData.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent);
				_cacheData.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
				_cacheData.removeEventListener(IOErrorEvent.IO_ERROR, handleCacheDataError);
				_cacheData.removeEventListener(IOErrorEvent.DISK_ERROR, handleCacheDataError);
				_cacheData.removeEventListener(IOErrorEvent.NETWORK_ERROR, handleCacheDataError);
				_cacheData.removeEventListener(IOErrorEvent.VERIFY_ERROR, handleCacheDataError);
				_cacheData.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleCacheDataError);
				_cacheData.removeEventListener(DestructEvent.DESTRUCT, handleCacheDataDestuct);
				_cacheData = null;
				_owner = false;
			}
		}
		
		private function handleCacheDataDestuct(event:DestructEvent):void 
		{
			// reload
			if (debug) logDebug("handleCacheDataDestuct: LoaderCacheData has been destructed, reload.");
			if (isLoading) load(new URLRequest(url)); 
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (_cacheData)
			{
				if (_owner) LoaderCache.clear(url);
				clearCacheData();
			}
			super.destruct();
		}
	}
}
