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
	import temple.core.debug.IDebuggable;
	import temple.core.events.CoreEventDispatcher;
	import temple.data.url.URLData;

	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @eventType temple.data.xml.XMLServiceEvent.COMPLETE
	 */
	[Event(name="XMLServiceEvent.complete", type="temple.data.xml.XMLServiceEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLServiceEvent.ALL_COMPLETE
	 */
	[Event(name="XMLServiceEvent.allComplete", type="temple.data.xml.XMLServiceEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLServiceEvent.LOAD_ERROR
	 */
	[Event(name="XMLServiceEvent.loadError", type="temple.data.xml.XMLServiceEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLServiceEvent.PARSE_ERROR
	 */
	[Event(name="XMLServiceEvent.parseError", type="temple.data.xml.XMLServiceEvent")]
	
	/**
	 * Base class for loading XML data, with or without parameters. Extend this class to create a proper service for use
	 * in a MVCS-patterned application. The base class provides functionality for transferring an Object with parameters
	 * to the request, loading the XML, a virtual function for parsing the result, parsing a list, and error handling on
	 * response &amp; parsing. When extending this class, the function
	 * <code>protected function processData (data:XML, name:String) : void;</code> has to be overridden &amp; 
	 * implemented to handle a successful load. When parsing a list of XMl nodes into an array of objects of one class,
	 * the <code>parseList()</code> function can be used.
	 * 
	 * @author Thijs Broerse
	 */
	[Deprecated]
	public class XMLService extends CoreEventDispatcher implements IDebuggable
	{
		protected var _loader:XMLLoader;
		private var _debug:Boolean;

		public function XMLService()
		{
			super();
			
			_loader = new XMLLoader();
			_loader.addEventListener(XMLLoaderEvent.COMPLETE, handleLoaderEvent);
			_loader.addEventListener(XMLLoaderEvent.ALL_COMPLETE, handleLoaderEvent);
			_loader.addEventListener(XMLLoaderEvent.ERROR, handleLoadError);
		}

		/**
		 *	Load from specified location, optionally with specified parameters
		 *	@param urlData url of xml data to be loaded
		 *	@param sendData optional object containing parameters to be posted
		 *	@param method Method to send the sendData object (GET of POST)
		 */
		public function load(urlData:URLData, sendData:Object = null, method:String = URLRequestMethod.GET):void 
		{
			if (urlData == null)
			{
				logError("load: urlData cannot be null");
				return;
			}
			
			// copy input object to URLVariables object			
			var vars:URLVariables;
			if (sendData) 
			{
				vars = new URLVariables();
				for (var s : String in sendData) 
				{
					vars[s] = sendData[s];
				}
			}
			
			if (_debug) logInfo("load: '" + urlData.name + "' from '" + urlData.url + "'");
			
			_loader.loadXML(urlData.url, urlData.name, vars, method);
		}

		/**
		 * Cancel a load by name
		 * @return true if cancel was succesfull, otherwise returns false
		 */
		public function cancelLoad(name:String):Boolean
		{
			return _loader.cancelLoad(name);
		}

		/**
		 * The number of parallel loaders
		 */
		public function get loaderCount():uint 
		{
			return _loader ? _loader.loaderCount : 0;
		}

		/**
		 * @private
		 */
		public function set loaderCount(value:uint):void 
		{
			_loader.loaderCount  = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
			
			if (_debug) logDebug("debug: " + debug);
		}
		
		protected function handleLoaderEvent(event:XMLLoaderEvent):void 
		{
			switch (event.type) 
			{
				case XMLLoaderEvent.COMPLETE: 
				{
					processData(event.data, event.name); 
					break;
				}
				case XMLLoaderEvent.ALL_COMPLETE: 
				{
					dispatchEvent(new XMLServiceEvent(XMLServiceEvent.ALL_COMPLETE, event.name)); 
					break;
				}
				
			}
		}

		/**
		 *	Override this function to perform specific xml parsing
		 */
		protected function processData(data:XML, name:String):void 
		{
			logWarn("processData: override this function");
			
			// just use them to get rid of 'never used' warning
			data;
			name;
		}

		/**
		 *	Handle load error event
		 */
		protected function handleLoadError(event:XMLLoaderEvent):void 
		{
			logError("handleLoadError: " + event.error);
			dispatchEvent(new XMLServiceEvent(XMLServiceEvent.LOAD_ERROR, event.name, null, null, event.error));
		}

		/**
		 *  Helper function
		 *	Parse a list into a vo class
		 *	If an error occurs, handleDataParseError() is called
		 *	@param list: the repeatable xml node
		 *	@param objectClass: the class to use to parse the data
		 *	@param name: the name of the loaded data
		 *	@param sendEvent: if true, a ServiceEvent is sent when parsing is successful
		 *	@return the list of objects of specified class, or null if an error occurred
		 */
		protected function parseList(list:XMLList, objectClass:Class, name:String, sendEvent:Boolean = true):Array 
		{
			var a:Array = XMLParser.parseList(list, objectClass, false, debug);
			
			if (a == null) 
			{
				onDataParseError(name);
				return null;
			}
			
			// send event we're done
			if (sendEvent) dispatchEvent(new XMLServiceEvent(XMLServiceEvent.COMPLETE, name, a, null));
			
			return a;
		}

		/**
		 *	Handle error occurred during parsing of data
		 */
		protected function onDataParseError(name:String):void 
		{
			logError("handleDataParseError: error parsing xml with name '" + name + "'");
			
			var error:String = "The XML was well-formed but incomplete. Be so kind and check it. It goes by the name of " + name;
			var event:XMLServiceEvent = new XMLServiceEvent(XMLServiceEvent.PARSE_ERROR, name, null, null, error);
			dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_loader)
			{
				_loader.destruct();
				_loader = null;
			}
			super.destruct();
		}
	}
}
