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
	import flash.events.HTTPStatusEvent;
	import temple.core.CoreLoader;
	import temple.debug.DebugManager;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * The CacheLoader stores the data (bytes) of the loaded images or SWF into the LoaderCache by URL.
	 * If the data of an URL is already in the LoaderCache it gets the bytes from the LoaderCache instead of reloading the image or SWF.
	 * 
	 * @see temple.data.loader.cache.LoaderCache
	 * 
	 * @includeExample CacheLoaderExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CacheLoader extends CoreLoader implements ICacheable
	{
		private var _cacheURLLoader:CacheURLLoader;

		public function CacheLoader(logErrors:Boolean = true, cache:Boolean = true)
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
			
			DebugManager.addAsChild(this._cacheURLLoader, this);
			
			this.cache = cache;
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
		 * @inheritDoc
		 */
		override public function load(request:URLRequest, context:LoaderContext = null):void
		{
			this._isLoading = true;
			this._isLoaded = false;
			this._url = request.url;
			
			if (this.cache)
			{
				if (this.debug) this.logDebug("load: cache enabled ");
				this._cacheURLLoader.load(request);
			}
			else
			{
				if (this._debug) this.logDebug("load: cache disabled");
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

		private function handleURLLoaderComplete(event:Event):void
		{
			this.loadBytes(this._cacheURLLoader.data);
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
			super.destruct();
		}
	}
}
