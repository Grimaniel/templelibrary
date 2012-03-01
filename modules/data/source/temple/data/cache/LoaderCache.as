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
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.utils.CoreTimer;
	import temple.data.collections.HashMap;

	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * The LoaderCache stores the data (bytes) for the CacheLoader and the CacheURLLoader by URL.
	 * 
	 * @author Thijs Broerse, Bart van der Schoor
	 */
	public final class LoaderCache 
	{
		private static const _cache:HashMap = new HashMap("LoaderCache");

		private static var _maxSeconds:Number;
		private static var _autoPurgeTimer:CoreTimer;

		/**
		 * Get data from cache.
		 */
		public static function get(url:String):LoaderCacheData
		{
			return LoaderCache._cache[url] as LoaderCacheData;
		}

		/**
		 * Creates a new LoaderCacheData for a specific url. Data can be filled later.
		 */
		public static function create(url:String):LoaderCacheData 
		{
			if (LoaderCache._cache[url] != undefined)
			{
				throwError(new TempleError(LoaderCache, "LoaderCacheData for url \"" + url + "\" already exists"));
			}
			return LoaderCache._cache[url] = new LoaderCacheData(url);
		}

		/**
		 * Store an data in cache
		 */
		public static function set(url:String, data:ByteArray):void
		{
			if (LoaderCache._cache[url] == undefined)
			{
				LoaderCache._cache[url] = new LoaderCacheData(url);
			}
			LoaderCacheData(LoaderCache._cache[url]).bytes = data;
		}

		/**
		 * Clear cache
		 * @param url if null all data is removed, else only the data store with the provided url is removed
		 */
		public static function clear(url:String = null):void
		{
			if (url == null)
			{
				for (url in LoaderCache._cache)
				{
					LoaderCache.clear(url);
				}
			}
			else if (LoaderCache._cache[url])
			{
				var data:LoaderCacheData = LoaderCacheData(LoaderCache._cache[url]);
				delete LoaderCache._cache[url];
				data.destruct();
			}
		}

		/**
		 * Remove unused data
		 */
		public static function purge(maxSeconds:Number):void
		{
			var limit:Number = getTimer() - (maxSeconds * 1000);
			for each (var data:LoaderCacheData in LoaderCache._cache)
			{
				if (data.purgeable && data.time < limit)
				{
					Log.debug('LoaderCache.purge(maxAgeSeconds:' + maxSeconds + ') on data.time:' + data.time + ', limit:' + limit, LoaderCache);
					LoaderCache.clear(data.url);
				}
			}
		}

		/**
		 * Auto Remove unused data
		 */
		public static function setAutoPurge(maxSeconds:Number, intervalSeconds:Number = 1):void
		{
			LoaderCache._maxSeconds = maxSeconds;
			
			if (LoaderCache._autoPurgeTimer)
			{
				LoaderCache._autoPurgeTimer.destruct();
			}
			LoaderCache._autoPurgeTimer = new CoreTimer(intervalSeconds * 1000);
			LoaderCache._autoPurgeTimer.addEventListener(TimerEvent.TIMER, LoaderCache.handlePurgeTimer);
			LoaderCache._autoPurgeTimer.start();
		}

		/**
		 * Stop Auto Removing unused data
		 */
		public static function stopAutoPurge():void
		{
			if (LoaderCache._autoPurgeTimer)
			{
				LoaderCache._autoPurgeTimer.destruct();
				LoaderCache._autoPurgeTimer = null;
			}
		}

		private static function handlePurgeTimer(event:TimerEvent):void
		{
			LoaderCache.purge(LoaderCache._maxSeconds);
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(LoaderCache);
		}
	}
}
