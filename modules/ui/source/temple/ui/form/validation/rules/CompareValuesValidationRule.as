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
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;
	import temple.ui.form.components.ISetValue;
	import temple.utils.Comparor;

	/**
	 * Compares the value of the target with an other value.
	 * 
	 * @see temple.utils.Comparor
	 * @see temple.common.interfaces.IHasValue
	 * 
	 * @author Thijs Broerse
	 */
	public class CompareValuesValidationRule extends AbstractCompareValidationRule implements IValidationRule, IHasValue, ISetValue, IDebuggable
	{
		private var _value:*;
		private var _debug:Boolean;

		public function CompareValuesValidationRule(target:IHasValue, value:*, operator:String = Comparor.EQUAL)
		{
			super(target, operator);
			
			this._value = value;
			
			addToDebugManager(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			return this._value;
		}

		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			this._value = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isValid():Boolean
		{
			if (this.debug) this.logDebug("isValid: " + Comparor.compare(this.target.value, this._value, this.operator) + ": " + this.target.value + " " + this.operator + " " + this._value);
			
			return Comparor.compare(this.target.value, this._value, this.operator);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			this._value = null;
			
			super.destruct();
		}
	}
}
