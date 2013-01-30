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

package temple.data.xml 
{
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.core.net.CoreURLLoader;
	import temple.data.collections.DestructibleArray;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * @eventType temple.data.xml.XMLLoaderEvent.COMPLETE
	 */
	[Event(name="XMLLoaderEvent.complete", type="temple.data.xml.XMLLoaderEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLLoaderEvent.ALL_COMPLETE
	 */
	[Event(name="XMLLoaderEvent.allComplete", type="temple.data.xml.XMLLoaderEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLLoaderEvent.ERROR
	 */
	[Event(name="XMLLoaderEvent.error", type="temple.data.xml.XMLLoaderEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLLoaderEvent.PROGRESS
	 */
	[Event(name="XMLLoaderEvent.progress", type="temple.data.xml.XMLLoaderEvent")]
	

	/**
	 * XMLLoader loads XML files 
	 * 
	 * @author Thijs Broerse
	 */
	[Deprecated]
	public class XMLLoader extends CoreEventDispatcher 
	{
		private var _waitingStack:DestructibleArray;
		private var _loadingStack:DestructibleArray;
		private var _loaderCount:uint;

		/**
		 * @param loaderCount number of parallel loaders
		 */
		public function XMLLoader(loaderCount:uint = 1) 
		{
			_loaderCount = loaderCount;
			
			_waitingStack = new DestructibleArray();
			_loadingStack = new DestructibleArray();
		}
		
		/**
		 * The total number of parallel loaders
		 */
		public function get loaderCount():uint 
		{
			return _loaderCount;
		}

		/**
		 * @private
		 */
		public function set loaderCount(value:uint):void 
		{
			_loaderCount = value;
		}
		
		/**
		 * Load XML
		 * @param url source url of the XML
		 * @param name (optional) unique identifying name
		 * @param variables (optional) URLVariables object to be sent to the server
		 * @param requestMethod (optional) URLRequestMethod POST or GET; default: GET
		 */
		public function loadXML(url:String, name:String = "", variables:URLVariables = null, requestMethod:String = URLRequestMethod.GET):void 
		{
			// Check if url is valid
			if ((url == null) || (url.length == 0)) 
			{
				throwError(new TempleArgumentError(this, "invalid url"));
			}

			var xld:XMLLoaderData = new XMLLoaderData(url, name, variables, requestMethod);
			_waitingStack.push(xld);
			
			loadNext();
		}

		/**
		 * Cancels a load
		 * @return true if cancel was succesfull, otherwise returns false
		 */
		public function cancelLoad(name:String):Boolean
		{
			var xld:XMLLoaderData;
			var leni:int;
			var i:int;
			
			// first check if load is in waitingStack
			leni = _waitingStack.length;
			for (i = 0; i < leni ; i++)
			{
				xld = _waitingStack[i];
				
				if (xld.name == name)
				{
					logInfo("cancelLoad: succesfull removed form waiting stack");
					
					// found, remove from list and return
					xld.destruct();
					_waitingStack.splice(i,1);
					return true;
				}
			}
			// maybe it's in the loadingStack
			leni = _loadingStack.length;
			for (i = 0; i < leni ; i++)
			{
				xld = _loadingStack[i];
				
				if (xld.name == name)
				{
					logInfo("cancelLoad: succesfull removed form loading stack");
					// found, remove form list and return
					xld.destruct();
					_loadingStack.splice(i,1);
					return true;
				}
			}
			// not found, log error
			logError("cancelLoad: could not cancel load '" + name + "'");
			return false;
		}

		/**
		 * Load next xml while the waiting stack is not empty.
		 */
		private function loadNext():void 
		{
			// quit if all loaders taken
			if (_loadingStack.length == _loaderCount) return;
			
			// quit if no waiting data
			if (_waitingStack.length == 0) return;

			// get the data
			var xld:XMLLoaderData = _waitingStack.shift() as XMLLoaderData;
			
			// create loader
			var loader:CoreURLLoader = new CoreURLLoader();
			loader.addEventListener(Event.COMPLETE, handleURLLoaderEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleURLLoaderEvent);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleURLLoaderEvent);
			loader.addEventListener(ProgressEvent.PROGRESS, handleURLLoaderProgressEvent);

			// create request
			var request:URLRequest = new URLRequest(xld.url);
			if (xld.variables != null) request.data = xld.variables;
			request.method = xld.requestMethod;
			
			// store loader in data
			xld.loader = loader;
			
			// store data in loading stack
			_loadingStack.push(xld);
			
			// start loading
			loader.load(request);
		}

		/**
		 * Handle events from URLLoader
		 * @param event Event sent 
		 */
		private function handleURLLoaderEvent(event:Event):void 
		{
			// get loader
			var loader:CoreURLLoader = event.target as CoreURLLoader;
			
			// remove listeners
			loader.removeAllEventListeners();
			
			var e:XMLLoaderEvent;
			
			// get data for loader
			var xld:XMLLoaderData = getDataForLoader(loader);
			if (xld == null) 
			{
				logError("handleURLLoaderEvent: data for loader not found");
				e = new XMLLoaderEvent(XMLLoaderEvent.ERROR, xld.name);
				dispatchEvent(e);
				return;
			}

			// check if an IOError occurred
			if (event is ErrorEvent) 
			{
				// fill error event
				e = new XMLLoaderEvent(XMLLoaderEvent.ERROR, xld.name);
				e.error = ErrorEvent(event).text;
			}
			else 
			{
				try 
				{
					// notify we're done loading this xml
					e = new XMLLoaderEvent(XMLLoaderEvent.COMPLETE, xld.name, new XML(loader.data));
				}
				catch (error:Error) 
				{
					logError("An error has occurred : " + error.message + "\n" + loader.data);
					e = new XMLLoaderEvent(XMLLoaderEvent.ERROR, xld.name, null);
					e.error = error.message;
				}
			}
			dispatchEvent(e);
			
			xld.destruct();
			
			
			// this loader can be destructed after dispatching the event
			// if so, this code cannot be executed
			if (isDestructed != true)
			{
				// remove data from stack
				_loadingStack.splice(_loadingStack.indexOf(xld), 1);
				
				// continue loading
				loadNext();
				
				// check if we're done loading
				if ((_waitingStack.length == 0) && (_loadingStack.length == 0)) 
				{
					dispatchEvent(new XMLLoaderEvent(XMLLoaderEvent.ALL_COMPLETE, xld.name));
				}
			}
		}

		/**
		 * Handle ProgressEvent from URLLoader
		 * @param event ProgressEvent sent
		 */
		private function handleURLLoaderProgressEvent(event:ProgressEvent):void 
		{
			// get loader
			var loader:CoreURLLoader = event.target as CoreURLLoader;
			
			// get data for loader
			var xld:XMLLoaderData = getDataForLoader(loader);
			if (xld == null) 
			{
				logError("handleURLLoaderProgressEvent: data for loader not found");
				return;
			}

			// create & dispatch event with relevant data
			var e:XMLLoaderEvent = new XMLLoaderEvent(XMLLoaderEvent.PROGRESS, xld.name);
			e.bytesLoaded = event.bytesLoaded;
			e.bytesTotal = event.bytesTotal;
			dispatchEvent(e);
		}

		/**
		 * Get the data block in the loading stack for the specified URLLoader
		 * @param loader: URLLoader
		 * @return the data, or null if none was found
		 */
		private function getDataForLoader(loader:CoreURLLoader):XMLLoaderData 
		{
			var len:int = _loadingStack.length;
			for (var i:int = 0;i < len; i++) 
			{
				var xld:XMLLoaderData = _loadingStack[i] as XMLLoaderData;
				if (xld.loader == loader) return xld;
			}
			return null;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_waitingStack)
			{
				_waitingStack.destruct();
				_waitingStack = null;
			}
			if (_loadingStack)
			{
				_loadingStack.destruct();
				_loadingStack = null;
			}
			super.destruct();
		}
	}	
}
import temple.core.destruction.IDestructible;
import temple.core.net.CoreURLLoader;

import flash.net.URLRequestMethod;
import flash.net.URLVariables;

final class XMLLoaderData implements IDestructible
{
	public var url:String;
	public var name:String;
	public var variables:URLVariables;
	public var loader:CoreURLLoader;
	public var requestMethod:String;
	private var _isDestructed:Boolean;

	public function XMLLoaderData(url:String, name:String, variables:URLVariables = null, requestMethod:String = URLRequestMethod.GET) 
	{
		this.url = url;
		this.name = name;
		this.variables = variables;
		this.requestMethod = requestMethod;
	}
	
	public function get isDestructed():Boolean
	{
		return _isDestructed;
	}
	
	public function destruct():void
	{
		variables = null;
		if (loader)
		{
			loader.destruct();
			loader = null;
		}
		
		url = null;
		name = null;
		requestMethod = null;
		
		_isDestructed = true;
	}
}