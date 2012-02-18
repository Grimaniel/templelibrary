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
