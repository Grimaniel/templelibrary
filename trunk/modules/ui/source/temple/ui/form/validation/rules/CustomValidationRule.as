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
	 * A validation rule which allows you to pass a method which is called when the rule is validated. The method must
	 * return a <code>Boolean</code> which indicates if the rule is valid.
	 * 
	 * @author Thijs Broerse
	 */
	public class CustomValidationRule extends AbstractValidationRule implements IValidationRule 
	{
		private var _rule:Function;
		private var _params:Array;

		/**
		 * Create your own custom validation.
		 * This validation rule can not be added to the form bij using the 'addFormElement' method, since the 2nd argument is mandetory
		 * For adding a CustomValidationRule to the form, use form.validator.addValidationRule
		 * 
		 * @param target: The form element with needs to be validated (ig an InputField), target must implement IValidatable
		 * @param rule: The funtion that need be called on validation. The function needs to return a Boolean, where true means valid and false not valid.
		 * @param params (optional): the arguments for the rule that are applied on the function when called
		 */
		public function CustomValidationRule(target:IHasValue, rule:Function, params:Array = null)
		{
			super(target);
			
			this._rule = rule;
			this._params = params;
		}

		/**
		 * @inheritDoc
		 */
		public function isValid():Boolean
		{
			if (this._params)
			{
				return this._rule.apply(null, this._params);
			}
			return this._rule();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			this._rule = null;
			this._params = null;
			
			super.destruct();
		}
	}
}
