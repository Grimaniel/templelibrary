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

package temple.ui.form.services 
{
	import temple.data.url.URLData;
	import temple.data.xml.XMLParser;
	import temple.data.xml.XMLService;
	import temple.data.xml.XMLServiceEvent;
	import temple.ui.form.result.FormResult;
	import temple.ui.form.result.IFormResult;
	import temple.ui.form.services.IFormService;

	import flash.net.URLRequestMethod;

	/**
	 * @eventType temple.ui.form.services.FormServiceEvent.SUCCESS
	 */
	[Event(name = "FormServiceEvent.success", type = "temple.ui.form.services.FormServiceEvent")]

	/**
	 * @eventType temple.ui.form.services.FormServiceEvent.RESULT
	 */
	[Event(name = "FormServiceEvent.result", type = "temple.ui.form.services.FormServiceEvent")]

	/**
	 * @eventType temple.ui.form.services.FormServiceEvent.ERROR
	 */
	[Event(name = "FormServiceEvent.error", type = "temple.ui.form.services.FormServiceEvent")]
	
	/**
	 * @author Thijs Broerse
	 */
	public class FormXMLService extends XMLService implements IFormService
	{
		protected var _resultClass:Class;
		protected var _urlData:URLData;
		protected var _method:String = URLRequestMethod.POST;

		/**
		 * Creates a new FormXMLService object.
		 * The FormXMLService post the form data to a URL that returns a XML file. The XML file contains the result of the submission
		 * @param urlData the URLData to post to. There is no default, so it must be set before calling submit.
		 * @param resultClass the Class that parses the result XML, default is FormResult
		 * @param debug indicates if the service is in debug mode
		 */
		public function FormXMLService(urlData:URLData = null, resultClass:Class = null, debug:Boolean = false) 
		{
			super();
			
			if(urlData) this.urlData = urlData;
			
			this.resultClass = resultClass ? resultClass : FormResult;
			
			this.debug = debug;
			
			this.addEventListener(XMLServiceEvent.COMPLETE, this.handleXMLServiceEvent);
			this.addEventListener(XMLServiceEvent.LOAD_ERROR, this.handleXMLServiceEvent);
			this.addEventListener(XMLServiceEvent.PARSE_ERROR, this.handleXMLServiceEvent);
		}
		
		/**
		 * @inheritDoc
		 */
		public function submit(data:Object):IFormResult
		{
			this.load(this._urlData, data, this._method);
			
			return null;
		}
		
		/**
		 * The URLData to post to
		 */
		public function get urlData():URLData
		{
			return this._urlData;
		}
		
		/**
		 * @private
		 */
		public function set urlData(urlData:URLData):void
		{
			this._urlData = urlData;
		}

		/**
		 * Set Result class
		 * NOTE: Class must extend IFormResult!
		 */
		public function get resultClass():Class 
		{
			return this._resultClass;
		}

		/**
		 * @private
		 */
		public function set resultClass(value:Class):void 
		{
			this._resultClass = value;
		}
		
		/**
		 * The URLRequestMethod of the submit. Default: POST
		 */
		public function get method():String
		{
			return this._method;
		}
		
		/**
		 * @private
		 */
		public function set method(value:String):void
		{
			this._method = value;
		}
		
		/**
		 * Process loaded XML
		 * @param data loaded XML data
		 * @param name name of load operation
		 */
		override protected function processData(data:XML, name:String):void 
		{
			var result:IFormResult = XMLParser.parseXML(data, _resultClass, false, this.debug) as IFormResult;

			// send event we're done
			this.dispatchEvent(new XMLServiceEvent(XMLServiceEvent.COMPLETE, name, null, result)); 
		}
		
		private function handleXMLServiceEvent(event:XMLServiceEvent):void
		{
			switch(event.type)
			{
				case XMLServiceEvent.COMPLETE:
				{
					this.dispatchEvent(new FormServiceEvent(FormServiceEvent.RESULT, event.object as IFormResult));
					break;
				}	
				case XMLServiceEvent.LOAD_ERROR:
				case XMLServiceEvent.PARSE_ERROR:
				{
					this.dispatchEvent(new FormServiceEvent(FormServiceEvent.ERROR, event.object as IFormResult));
					break;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._resultClass = null;
			this._urlData = null;
			
			super.destruct();
		}
	}
}
