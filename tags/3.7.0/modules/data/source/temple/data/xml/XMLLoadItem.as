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
	import temple.common.interfaces.ICancellable;
	import temple.core.events.CoreEventDispatcher;
	import temple.core.net.ILoader;
	import temple.data.encoding.IDecoder;

	import flash.events.Event;


	/**
	 * Used by the XMLManager to store information about the URL of a XML
	 * 
	 * @author Thijs Broerse
	 */
	public class XMLLoadItem extends CoreEventDispatcher implements ILoader, ICancellable
	{
		private var _name:String;
		private var _url:String;
		internal var _sendData:Object;
		internal var _method:String;
		internal var _xml:XML;
		internal var _cache:Boolean;
		internal var _decoder:IDecoder;
		private var _xmlObjectDataList:Array;
		private var _isLoading:Boolean;
		internal var _isLoaded:Boolean;

		public function XMLLoadItem(name:String, url:String, xmlObjectData:XMLObjectData, sendData:Object, method:String, cache:Boolean, decoder:IDecoder) 
		{
			toStringProps.push('name');
			_name = name;
			_url = url;
			_xmlObjectDataList = new Array;
			addXMLObjectData(xmlObjectData);
			_sendData = sendData;
			_method = method;
			_cache = cache;
			_decoder = decoder;
			_isLoading = true;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get sendData():Object
		{
			return _sendData;
		}
		
		public function get method():String
		{
			return _method;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		internal function get cache():Boolean
		{
			return _cache;
		}
		
		internal function get decoder():IDecoder
		{
			return _decoder;
		}
		
		internal function setLoaded():void
		{
			_isLoaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return _isLoading;
		}

		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}

		internal function addXMLObjectData(xmlObjectData:XMLObjectData):void
		{
			_isLoading = false;
			_xmlObjectDataList.push(xmlObjectData);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Cancel a load
		 * @return true if cancel was succesfull, otherwise returns false
		 */
		public function cancel():Boolean
		{
			_isLoading = false;
			return XMLManager.getInstance().cancelLoad(_name);
		}

		internal function findXMLObjectData(objectClass:Class, node:String):XMLObjectData
		{
			for each (var data:XMLObjectData in _xmlObjectDataList) 
			{
				if (data.objectClass == objectClass && data.node == node)
				{
					return data;
				}
			}
			return null;
		}

		public function get xmlObjectDataList():Array
		{
			return _xmlObjectDataList;
		}
		
		public function get data():Array
		{
			var a:Array = new Array();
			for each (var data:XMLObjectData in _xmlObjectDataList) 
			{
				a.push(data.object ? data.object : data.list);
			}
			return a;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_isLoading) cancel();
			_sendData = null;
			_xml = null;
			_decoder = null;
			if (_xmlObjectDataList)
			{
				for each (var xmlObject : XMLObjectData in _xmlObjectDataList) 
				{
					xmlObject.destruct();
				}
				_xmlObjectDataList = null;
			}
			
			super.destruct();
		}
	}
}
