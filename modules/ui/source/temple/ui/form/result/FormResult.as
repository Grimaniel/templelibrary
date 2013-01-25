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
			
			_errors = errors;
		}

		/**
		 * @inheritDoc 
		 */
		public function get errors():Vector.<IFormFieldError>
		{
			return _errors;
		}
		
		/**
		 * @private
		 */
		public function set errors(value:Vector.<IFormFieldError>):void
		{
			_errors = value;
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
			success = xml.child('success') == "true" || xml.child('success') == "1";
			message = xml.child('message');
			code = xml.child('message').@code;
			_errors = new Vector.<IFormFieldError>(XMLParser.parseList(xml.errors.error, FormFieldError));
			
			return true;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function destruct():void
		{
			_errors = null;
			
			super.destruct();
		}
	}
}
