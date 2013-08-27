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
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.IXMLParsable;
	import temple.data.result.Result;

	/**
	 * Contains information about an error of a specific field of the submission of a <code>Form</code>.
	 * 
	 * <p>A <code>IFormFieldError</code> is part of a <code>FormResult</code>.</p>
	 * 
	 * @see temple.ui.form.result.IFormFieldError
	 * @see temple.ui.form.Form
	 * @see temple.ui.form.result.FormResult
	 * @see temple.ui.form.result.IFormResult
	 * 
	 * @author Thijs Broerse
	 */
	public class FormFieldError extends Result implements IFormFieldError, IXMLParsable 
	{
		private var _name:String;
		private var _field:IHasValue;

		public function FormFieldError(name:String = null, field:IHasValue = null, message:String = null, code:String = null)
		{
			super(false, message, code);
			toStringProps.push('name', 'message', 'code');
			emptyPropsInToString = false;
			_name = name;
			_field = field;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}
			
		/**
		 * @inheritDoc 
		 */
		public function get field():IHasValue
		{
			return _field;
		}
		
		/**
		 * @private
		 */
		public function set field(value:IHasValue):void
		{
			_field = value;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function parseXML(xml:XML):Boolean
		{
			field = xml.@field;
			code = xml.@code;
			message = xml;
			
			return true;
		}

		/**
		 * @inheritDoc 
		 */
		override public function destruct():void
		{
			_field = null;
			_name = null;
			
			super.destruct();
		}

	}
}
