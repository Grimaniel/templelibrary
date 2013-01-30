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
	import temple.core.events.CoreEventDispatcher;

	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * Class for storing information about the cached data.
	 * 
	 * @author Bart van der Schoor, Thijs Broerse
	 */
	internal class LoaderCacheItem extends CoreEventDispatcher implements ILoaderCacheItem
	{
		private var _url:String;
		private var _bytes:ByteArray;
		private var _time:uint;
		private var _purgeable:Boolean = true;
		
		public function LoaderCacheItem(url:String)
		{
			_url = url;
			toStringProps.push('url', 'isLoaded');
		}

		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytes():ByteArray
		{
			_time = getTimer();
			return _bytes;
		}
		
		/**
		 * @private
		 */
		public function set bytes(value:ByteArray):void
		{
			_bytes = value;
			_time = getTimer();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return _bytes == null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return _bytes != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get time():uint
		{
			return _time;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get purgeable():Boolean
		{
			return _purgeable;
		}
		
		/**
		 * @private
		 */
		public function set purgeable(value:Boolean):void
		{
			_purgeable = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (isDestructed) return;
			
			_bytes = null;
			
			super.destruct();
			
			if (_url) LoaderCache.clear(_url);
			
			// clearing URL must be done after DestructEvent is dispatched, so we can check the URL in the handler.
			_url = null;
		}
	}
}
