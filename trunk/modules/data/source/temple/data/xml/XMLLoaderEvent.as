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
	import temple.core.debug.objectToString;

	import flash.events.Event;

	/**
	 * Event dispatched by the XMLLoader
	 * 
	 * @see temple.data.xml.XMLLoader
	 * 
	 * @author Thijs Broerse
	 */
	public class XMLLoaderEvent extends Event 
	{
		/**
		 * Event sent when loading of a single XML is complete
		 */
		public static const COMPLETE:String = "XMLLoaderEvent.complete";

		/**
		 * Event sent when the stack of loading XMLs is empty
		 */
		public static const ALL_COMPLETE:String = "XMLLoaderEvent.allComplete";

		/**
		 * Event sent when an error has occurred
		 */
		public static const ERROR:String = "XMLLoaderEvent.error";

		/**
		 * Event sent during loading of XML
		 */
		public static const PROGRESS:String = "XMLLoaderEvent.progress";

		private static const _TO_STRING_PROPS:Vector.<String> = Vector.<String>(['name', 'type', 'error', 'bytesLoaded', 'bytesTotal']);

		private var _name:String;
		private var _data:XML;
		private var _error:String;
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;

		/**
		 * Creates a new XMLLoaderEvent.
		 * @param type see above
		 * @param name identifier name
		 * @param data the XML data object (only at COMPLETE)
		 */
		public function XMLLoaderEvent(type:String, name:String, data:XML = null) 
		{
			super(type);
			
			_name = name;
			_data = data;
		}
		
		/**
		 * The identifier name
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * The XML data, only available at COMPLETE
		 */
		public function get data():XML
		{
			return _data;
		}
		
		public function set data(value:XML):void
		{
			_data = value;
		}
		
		public function get error():String
		{
			return _error;
		}
		
		public function set error(value:String):void
		{
			_error = value;
		}
		
		public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}
		
		public function set bytesLoaded(value:uint):void
		{
			_bytesLoaded = value;
		}
		
		public function get bytesTotal():uint
		{
			return _bytesTotal;
		}
		
		public function set bytesTotal(value:uint):void
		{
			_bytesTotal = value;
		}
		
		/**
		 * Creates a copy of an existing XMLLoaderEvent.
		 */
		override public function clone():Event 
		{
			return new XMLLoaderEvent(type, name, data);
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String 
		{
			return objectToString(this, _TO_STRING_PROPS);
		}
	}
}
