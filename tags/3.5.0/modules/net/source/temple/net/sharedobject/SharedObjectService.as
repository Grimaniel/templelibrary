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

package temple.net.sharedobject
{
	import temple.core.events.CoreEventDispatcher;
	import temple.data.collections.HashMap;

	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;

	/**
	 * Wrapper class that supports Quick assses to shared object properties.
	 * 
	 * @example
	 * <listing version="3.0">
	 * SharedObjectService.getInstance('projectName').setProperty('muted', true);
	 * SharedObjectService.getInstance('projectName').getProperty('muted');
	 * 
	 * //also:
	 * 
	 * _sharedObjectSite = new SharedObjectService('projectName', '');
	 * _sharedObjectGame = new SharedObjectService('projectName', '/game');
	 * 
	 * //tip: extend and provide typed accessors with prefilled default-values
	 *
	 * dispatches SharedObjectServiceEvent's when flushing (to check if the flushing fails or displays the dialog window)
	 * 
	 * </listing>
	 * 
	 * @author Arjan van Wijk, Bart van der Schoor
	 */
	public final class SharedObjectService extends CoreEventDispatcher implements ISharedObjectService
	{
		//to compare to returned values
		public static const FP_SO_FLUSH_SUCCESS:String = 'SharedObject.Flush.Success';
		public static const FP_SO_FLUSH_FAIL:String = 'SharedObject.Flush.Failed';
		
		private static var _instances:HashMap;
		
		/**
		 * This class is used as a Multiton. SharedObjects are always saved in the / path
		 * @param name The name of the SharedObject
		 */
		public static function getInstance(name:String = 'default'):ISharedObjectService
		{
			if (SharedObjectService._instances == null) SharedObjectService._instances = new HashMap("SharedObjectService instances");
			if (SharedObjectService._instances[name] == null) SharedObjectService._instances[name] = new SharedObjectService(name);
			
			return SharedObjectService._instances[name];
		}
		
		private var _so:SharedObject;
		private var _data:Object;
		private var _name:String;
		private var _expectedSize:int;
		
		public function SharedObjectService(name:String, path:String='/', expectedSize:int=0)
		{
			_name = name;
			_expectedSize = expectedSize;
			
			try
			{
				_so = SharedObject.getLocal(_name, path);
			}
			catch(e:Error)
			{
				logError('error while reading Shared Object ' + _name + ': ' + e);
			}
			
			if(_so == null)
			{
				logError('cannot retrieve SharedObject ' + _name + ', local fallback');
				_data = new Object();
			}
			else
			{
				_data = _so.data;
				_so.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function setProperty(name:String, value:*):void
		{
			_data[name] = value;
			flush();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getProperty(name:String, alt:*=null):*
		{
			return name in _data ? _data[name] : alt;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasProperty(name:String):*
		{
			return name in _data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeProperty(name:String):void
		{
			if(name in _data)
			{
				delete _data[name];
			}
			flush();
		}

		/**
		 * @inheritDoc
		 */
		public function clear():void 
		{
			if (_so)
			{
				_so.clear();
				_data = _so.data;
			}
			else
			{
				_data = new Object();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function flush(expectedSize:int=0):String
		{
			if (expectedSize != 0 && expectedSize > _expectedSize)
			{
				_expectedSize = expectedSize;
			}
			
			var status:String = SharedObjectServiceEvent.FLUSH_ERROR;
					
			if (_so)
			{
				try
				{
					status = _so.flush(_expectedSize);
				}
				catch(e:Error)
				{
					logError('error while flushing Shared Object ' + _name + ': ' + e);
				}
			}
			else
			{
				status = SharedObjectServiceEvent.FLUSHED;
			}
		
			dispatchEvent(new SharedObjectServiceEvent(status));
			
			return status;
		}

		/**
		 * @inheritDoc
		 */
		public function get so():SharedObject
		{
			return _so;
		}
		
		/**
		 * @inheritDoc
		 */
		public function data():Object 
		{
			return _data;
		}
		
		private function handleNetStatusEvent(event:NetStatusEvent):void
		{
			if(event.info && event.info['code'] == FP_SO_FLUSH_SUCCESS)
			{
				dispatchEvent(new SharedObjectServiceEvent(SharedObjectServiceEvent.FLUSHED));
			}
			else
			{
				dispatchEvent(new SharedObjectServiceEvent(SharedObjectServiceEvent.FLUSH_ERROR));
			}	
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (SharedObjectService._instances)
			{
				delete SharedObjectService._instances[_name];
				
				// check if there are some NotificationCenters left
				for (var key:String in SharedObjectService._instances);
				if (key == null) SharedObjectService._instances = null;
			}
			_data = null;
			if (_so)
			{
				_so.close();
				_so = null;
			}
			super.destruct();
		}
		
	}
}