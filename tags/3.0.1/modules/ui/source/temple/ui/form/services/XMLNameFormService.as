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
	import temple.data.url.URLManager;
	import temple.ui.form.result.IFormResult;

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
	 * The XMLNameFormService extends the XMLFormService but instead of supplying the URL, you just pass the name of the URL.
	 * The XMLFormService uses the URLManager to retrieve the actual URL.
	 * 
	 * @see temple.data.url.URLManager
	 * 
	 * @author Thijs Broerse
	 */
	public class XMLNameFormService extends XMLFormService 
	{
		private var _urlName:String;
		
		/**
		 * Create a new XMLNameFormService
		 * @param urlName the name of the URL as defined in the urls.xml and the URLManager
		 * @param resultClass the class which is used to parse the XML result. This class must implement IFormResult. If set to null FormResult will be used.
		 * @param debug a Boolean which indicates if debugging is enabled.
		 */
		public function XMLNameFormService(urlName:String = null, resultClass:Class = null, debug:Boolean = false)
		{
			super(null, resultClass, debug);
			
			this.urlName = urlName;
		}
		
		/**
		 * The name of the URL as defined in the urls.xml and the URLManager
		 */
		public function get urlName():String
		{
			return this._urlName;
		}
		
		/**
		 * @private
		 */
		public function set urlName(value:String):void
		{
			this._urlName = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function submit(data:Object):IFormResult 
		{
			this.load(URLManager.getURLDataByName(this._urlName), data, this.method);
			
			return null;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._urlName = null;
			super.destruct();
		}

	}
}
