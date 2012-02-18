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
	import temple.core.events.CoreEventDispatcher;
	import temple.core.net.ILoader;

	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * Class for storing information about the cached data.
	 * 
	 * @author Bart van der Schoor, Thijs Broerse
	 */
	public class LoaderCacheData extends CoreEventDispatcher implements ILoader
	{
		private var _url:String;
		private var _bytes:ByteArray;
		private var _time:uint;
		private var _purgeable:Boolean = true;
		
		public function LoaderCacheData(url:String)
		{
			this._url = url;
			this.toStringProps.push('url', 'isLoaded');
		}

		/**
		 * The URL of the file that is stored in cache.
		 */
		public function get url():String
		{
			return this._url;
		}
		
		/**
		 * The bytes of the file that is stored in cache.
		 */
		public function get bytes():ByteArray
		{
			this._time = getTimer();
			return this._bytes;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set bytes(value:ByteArray):void
		{
			this._bytes = value;
			this._time = getTimer();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return this._bytes == null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return this._bytes != null;
		}
		
		/**
		 * The last time (in milliseconds) this data is used
		 */
		public function get time():uint
		{
			return this._time;
		}
		
		/**
		 * Indicates if this object is destructed if the LoaderCache purges
		 */
		public function get purgeable():Boolean
		{
			return this._purgeable;
		}
		
		/**
		 * @private
		 */
		public function set purgeable(value:Boolean):void
		{
			this._purgeable = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (this.isDestructed) return;
			
			this._bytes = null;
			
			super.destruct();
			
			if (this._url) LoaderCache.clear(this._url);
			
			// clearing URL must be done after DestructEvent is dispatched, so we can check the URL in the handler.
			//this._url = null;
		}
	}
}
