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
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.utils.Comparor;

	/**
	 * Compares the values of two objects.
	 * 
	 * @see temple.utils.Comparor
	 * @see temple.common.interfaces.IHasValue
	 * 
	 * @author Thijs Broerse
	 */
	public class CompareTargetValuesValidationRule extends AbstractCompareValidationRule implements IValidationRule
	{
		private var _compareTarget:IHasValue;
		
		public function CompareTargetValuesValidationRule(target:IHasValue, compareTarget:IHasValue, operator:String = Comparor.EQUAL) 
		{
			super(target, operator);
			
			this.compareTarget = compareTarget;
		}
		
		/**
		 * 
		 */
		public function get compareTarget():IHasValue
		{
			return this._compareTarget;
		}
		
		/**
		 * @private
		 */
		public function set compareTarget(value:IHasValue):void
		{
			if (!value) throwError(new TempleArgumentError(this, "value can not be null"));
			this._compareTarget = value;
			
			if (this._compareTarget == this.target)
			{
				this.logWarn("compareTarget is the same object as the target");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function isValid():Boolean
		{
			return Comparor.compare(this.target.value, this._compareTarget.value, this.operator);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			this._compareTarget = null;
			super.destruct();
		}
	}
}
