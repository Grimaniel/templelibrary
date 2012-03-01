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
		public function RegExpValidationRule(target:IHasValue, expression:RegExp = null, validIfMatch:Boolean = true):void 
		{
			super(target);
			
			this._regExp = expression;
			this._isValidIfMatch = validIfMatch;
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
