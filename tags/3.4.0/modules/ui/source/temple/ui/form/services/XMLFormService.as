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

package temple.ui.form.services 
{
	import temple.data.url.URLData;
	import temple.data.xml.XMLParser;
	import temple.data.xml.XMLService;
	import temple.data.xml.XMLServiceEvent;
	import temple.ui.form.result.FormResult;
	import temple.ui.form.result.IFormResult;

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
	 * The XMLFormService send the submitted data to a URL, the URL response is an XML file which contains data about the success (or fail) or the submit.
	 * 
	 * @includeExample XMLFormServiceExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class XMLFormService extends XMLService implements IFormService
	{
		private var _resultClass:Class;
		private var _url:String;
		private var _method:String = URLRequestMethod.POST;

		/**
		 * Creates a new XMLFormService object.
		 * The XMLFormService post the form data to a URL that returns a XML file. The XML file contains the result of the submission
		 * @param url the URL to post to. There is no default, so it must be set before calling submit.
		 * @param resultClass the Class that parses the result XML, default is FormResult
		 * @param debug indicates if the service is in debug mode
		 */
		public function XMLFormService(url:String = null, resultClass:Class = null, debug:Boolean = false) 
		{
			_url = url;
			
			this.resultClass = resultClass ? resultClass : FormResult;
			
			this.debug = debug;
			
			addEventListener(XMLServiceEvent.COMPLETE, handleXMLServiceEvent);
			addEventListener(XMLServiceEvent.LOAD_ERROR, handleXMLServiceEvent);
			addEventListener(XMLServiceEvent.PARSE_ERROR, handleXMLServiceEvent);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * This method will always return null, since the data is send to a URL and will be handle asynchronously.
		 */
		public function submit(data:Object):IFormResult
		{
			load(new URLData(_url, _url), data, _method);
			
			return null;
		}
		
		/**
		 * The URL to post to
		 */
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			_url = value;
		}

		/**
		 * Set Result class
		 * NOTE: Class must extend IFormResult!
		 */
		public function get resultClass():Class 
		{
			return _resultClass;
		}

		/**
		 * @private
		 */
		public function set resultClass(value:Class):void 
		{
			_resultClass = value;
		}
		
		/**
		 * The URLRequestMethod of the submit. Default: POST
		 */
		public function get method():String
		{
			return _method;
		}
		
		/**
		 * @private
		 */
		public function set method(value:String):void
		{
			_method = value;
		}
		
		/**
		 * @private
		 * 
		 * Process loaded XML
		 * @param data loaded XML data
		 * @param name name of load operation
		 */
		override protected function processData(data:XML, name:String):void 
		{
			var result:IFormResult = XMLParser.parseXML(data, _resultClass, false, debug) as IFormResult;

			// send event we're done
			dispatchEvent(new XMLServiceEvent(XMLServiceEvent.COMPLETE, name, null, result)); 
		}
		
		private function handleXMLServiceEvent(event:XMLServiceEvent):void
		{
			switch (event.type)
			{
				case XMLServiceEvent.COMPLETE:
				{
					dispatchEvent(new FormServiceEvent(FormServiceEvent.RESULT, event.object as IFormResult));
					break;
				}	
				case XMLServiceEvent.LOAD_ERROR:
				case XMLServiceEvent.PARSE_ERROR:
				{
					dispatchEvent(new FormServiceEvent(FormServiceEvent.ERROR, event.object as IFormResult));
					break;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_resultClass = null;
			_url = null;
			_method = null;
			
			super.destruct();
		}
	}
}
