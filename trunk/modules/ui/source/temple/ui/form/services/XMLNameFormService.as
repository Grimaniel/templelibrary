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
