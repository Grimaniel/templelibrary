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

package temple.utils.propertyproxy 
{

	/**
	 * Limits (min/max) a value before it's set on a property of an object.
	 * 
	 * @author Thijs Broerse
	 */
	public class LimitPropertyProxy extends SimplePropertyProxy 
	{
		private var _min:Number;
		private var _max:Number;

		public function LimitPropertyProxy(min:Number = NaN, max:Number = NaN)
		{
			this._min = min;
			this._max = max;
		}
		
		/**
		 * The minimal value of the property
		 */
		public function get min():Number
		{
			return this._min;
		}
		
		/**
		 * @private
		 */
		public function set min(value:Number):void
		{
			this._min = value;
		}
		
		/**
		 * The maximal value of the property
		 */
		public function get max():Number
		{
			return this._max;
		}
		
		/**
		 * @private
		 */
		public function set max(value:Number):void
		{
			this._max = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function setValue(target:Object, property:String, value:*):void
		{
			if (!isNaN(value))
			{
				if (!isNaN(this._min)) value = Math.max(value, this._min);
				if (!isNaN(this._max)) value = Math.min(value, this._max);
			}
			super.setValue(target, property, value);
		}
		
	}
}
