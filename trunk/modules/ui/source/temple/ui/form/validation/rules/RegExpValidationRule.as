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

package temple.ui.form.validation.rules 
{
	import temple.common.interfaces.IHasValue;

	/**
	 * IValidationRule implementation that checks whether or not a string matches a regular expression. Use this with the Validator class and IValidatable implementations that return a String.
	 * 
	 * @author Thijs Broerse
	 */
	public class RegExpValidationRule extends AbstractValidationRule implements IOptionalValidationRule 
	{
		private var _regExp:RegExp;
		private var _isValidIfMatch:Boolean;
		private var _optional:Boolean;

		/**
		 * Constructor
		 * @param target IHasValue object
		 * @param expression regular expression to validate with.
		 * @param validIfMatch if true, value of IValidatable is considered valid if it matches the regular expression; otherwise it is considered invalid
		 */
		public function RegExpValidationRule(target:IHasValue, expression:RegExp, validIfMatch:Boolean = true, optional:Boolean = false):void 
		{
			super(target);
			
			this._regExp = expression;
			this._isValidIfMatch = validIfMatch;
			this._optional = optional;
		}

		/**
		 * @inheritDoc
		 */
		public function isValid():Boolean 
		{
			var value:String = this.target.value as String;
			if (this._optional && !value) return true;
			var testResult:Boolean = this._regExp.test(value);
			return this._isValidIfMatch ? testResult : !testResult;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get optional():Boolean
		{
			return this._optional;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set optional(value:Boolean):void
		{
			this._optional = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			this._regExp = null;
			
			super.destruct();
		}
	}
}
