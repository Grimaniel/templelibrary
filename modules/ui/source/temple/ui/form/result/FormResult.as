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

package temple.ui.form.result 
{
	import temple.common.interfaces.IDataResult;
	import temple.common.interfaces.IResult;
	import temple.data.result.DataResult;
	import temple.data.xml.XMLParser;

	/**
	 * Contains information about the result of the submission of a <code>Form</code>.
	 * 
	 * @author Thijs
	 */
	public class FormResult extends DataResult implements IFormResult
	{
		/**
		 * Converts an IResult to a FormFormResult
		 */
		public static function createFromResult(result:IResult):IFormResult
		{
			return result is IFormResult ? IFormResult(result) : new FormResult(result.success, result.message, result.code, result is IDataResult ? IDataResult(result).data : null);
		}
		
		private var _errors:Vector.<IFormFieldError>;

		public function FormResult(success:Boolean = false, message:String = null, code:String = null, data:* = null, errors:Vector.<IFormFieldError> = null) 
		{
			super(data, success, message, code);
			
			this._errors = errors;
		}

		/**
		 * Default parser
		 * Result XML is formed as:
		 * 
		 * success:
		 * 	<result>
		 *		<success>true</success>
		 *		<message code='A'>success message</message>
		 *	</result>
		 *	
		 * error:
		 *	<result>
		 *		<success>false</success>
		 *		<message code='B'>error message</message>
		 *		<errors>
		 *			<error field='email' code='ABC'>Invalid Emailaddress</error>
		 *			<error field='name' code='DEF'>User already in database</error>
		 *		</errors>
		 *	</result>
		 * 
		 * 
		 */
		public function parseXML(xml:XML):Boolean 
		{
			this._success = xml.child('success') == "true" || xml.child('success') == "1";
			this._message = xml.child('message');
			this._code = xml.child('message').@code;
			this._errors = new Vector.<IFormFieldError>(XMLParser.parseList(xml.errors.error, FormFieldError));
			
			return true;
		}

		/**
		 * @inheritDoc 
		 */
		public function get errors():Vector.<IFormFieldError>
		{
			return this._errors;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function destruct():void
		{
			this._errors = null;
			
			super.destruct();
		}
	}
}
