/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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

package temple.data.loader.cache 
{
	import temple.core.CoreURLLoader;
	import temple.destruction.DestructEvent;
	import temple.utils.FrameDelay;
	import temple.utils.types.ObjectUtils;

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
		private var _cacheData:LoaderCacheData;
		private var _owner:Boolean;
		
		public function CacheURLLoader(request:URLRequest = null, destructOnError:Boolean = true, logErrors:Boolean = true, cache:Boolean = true)
		{
			super(null, destructOnError, logErrors);
			
			this._cache = cache;
			
			if (request) new FrameDelay(this.load, 1, [request]);
		}

		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest):void
		{
			// check if our current load is competed
			if (this._owner && this._cacheData && this._cacheData.isLoading)
			{
				// we didn't finished the current load, delete it
				LoaderCache.clear(this._url);
				try
				{
					super.close();
				}
				catch (error:Error)
				{
					// ignore
				}
			}
			
			this._url = request.url;
			this._isLoading = true;
			this._isLoaded = false;
			this._owner = false;
			this.clearCacheData();
			if (this._cache && (this._cacheData = LoaderCache.get(this._url)))
			{
				if (this._cacheData.isLoaded)
				{
					if (this.debug) this.logDebug("load: get data from cache, url:" + this._url);
					this.data = LoaderCache.get(this._url).bytes;
					this._isLoaded = true;
					this._isLoading = false;
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
				else
				{
					if (this.debug) this.logDebug("load: data is currently loading, wait... " + this._cacheData.url);
					this._cacheData.addEventListener(Event.COMPLETE, this.handleCacheDataComplete);
					this._cacheData.addEventListener(Event.OPEN, this.dispatchEvent);
					this._cacheData.addEventListener(ProgressEvent.PROGRESS, this.dispatchEvent);
					this._cacheData.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.dispatchEvent);
					this._cacheData.addEventListener(IOErrorEvent.IO_ERROR, this.handleCacheDataError);
					this._cacheData.addEventListener(IOErrorEvent.DISK_ERROR, this.handleCacheDataError);
					this._cacheData.addEventListener(IOErrorEvent.NETWORK_ERROR, this.handleCacheDataError);
					this._cacheData.addEventListener(IOErrorEvent.VERIFY_ERROR, this.handleCacheDataError);
					this._cacheData.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleCacheDataError);
					this._cacheData.addEventListener(DestructEvent.DESTRUCT, this.handleCacheDataDestuct);
					this.dispatchEvent(new Event(Event.OPEN));
				}
			}
			else
			{
				if (this._cache)
				{
					this._cacheData = LoaderCache.create(this._url);
					this._owner = true;
					this.addEventListener(Event.OPEN, this._cacheData.dispatchEvent);
					this.addEventListener(ProgressEvent.PROGRESS, this._cacheData.dispatchEvent);
					this.addEventListener(IOErrorEvent.IO_ERROR, this._cacheData.dispatchEvent);
					this.addEventListener(IOErrorEvent.DISK_ERROR, this._cacheData.dispatchEvent);
					this.addEventListener(IOErrorEvent.NETWORK_ERROR, this._cacheData.dispatchEvent);
					this.addEventListener(IOErrorEvent.VERIFY_ERROR, this._cacheData.dispatchEvent);
					this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this._cacheData.dispatchEvent);
					if (this.debug) this.logDebug("load: new LoaderCacheData created: " + ObjectUtils.traceObject(LoaderCache.get(this._url), 0));
				}
				this.addEventListenerOnce(Event.COMPLETE, this.handleComplete);
				this.dataFormat = URLLoaderDataFormat.BINARY;
				super.load(request);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function close():void
		{
			// check if our current load is competed
			if (this._owner && this._cacheData && this._cacheData.isLoading)
			{
				// we didn't finished the current load, delete it
				LoaderCache.clear(this._url);
			}
			super.close();
		}

		/**
		 * @inheritDoc
		 */
		public function get cache():Boolean
		{
			return this._cache;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set cache(value:Boolean):void
		{
			this._cache = value;
			if (this.debug) this.logDebug("cache: " + value);
		}

		private function handleComplete(event:Event):void
		{
			if (this._cache && this._owner)
			{
				if (this.debug) this.logDebug("handleURLLoaderComplete: store data in cache, url:" + this.url);
				LoaderCache.set(this.url, this.data);
			}
			this.clearCacheData();
		}

		private function handleCacheDataComplete(event:Event):void 
		{
			this._isLoading = false;
			this._isLoaded = true;
			this.data = this._cacheData.bytes;
			this.clearCacheData();
			this.dispatchEvent(event);
		}
		
		private function handleCacheDataError(event:ErrorEvent):void 
		{
			if (this.debug) this.logWarn(event.type + ": \"" + event.text + "\"");
			this._isLoading = false;
			this._isLoaded = false;
			this.clearCacheData();
			LoaderCache.clear(this._url);
			this.dispatchEvent(event);
		}
		
		private function clearCacheData():void 
		{
			if (this._cacheData)
			{
				this._cacheData.removeEventListener(Event.COMPLETE, this.handleCacheDataComplete);
				this._cacheData.removeEventListener(Event.OPEN, this.dispatchEvent);
				this._cacheData.removeEventListener(ProgressEvent.PROGRESS, this.dispatchEvent);
				this._cacheData.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.dispatchEvent);
				this._cacheData.removeEventListener(IOErrorEvent.IO_ERROR, this.handleCacheDataError);
				this._cacheData.removeEventListener(IOErrorEvent.DISK_ERROR, this.handleCacheDataError);
				this._cacheData.removeEventListener(IOErrorEvent.NETWORK_ERROR, this.handleCacheDataError);
				this._cacheData.removeEventListener(IOErrorEvent.VERIFY_ERROR, this.handleCacheDataError);
				this._cacheData.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleCacheDataError);
				this._cacheData.removeEventListener(DestructEvent.DESTRUCT, this.handleCacheDataDestuct);
				this._cacheData = null;
				this._owner = false;
			}
		}
		
		private function handleCacheDataDestuct(event:DestructEvent):void 
		{
			// reload
			if (this.debug) this.logDebug("handleCacheDataDestuct: LoaderCacheData has been destructed, reload.");
			if (this._isLoading) this.load(new URLRequest(this._url)); 
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (this._cacheData)
			{
				if (this._owner) LoaderCache.clear(this._url);
				this.clearCacheData();
			}
			super.destruct();
		}
	}
}
