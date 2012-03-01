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
	 * Recalculates the value between the min and the max. Where a value of 0 will become the min and 1 the max.
	 * 
	 * @author Thijs Broerse
	 */
	public class RangePropertyProxy extends SimplePropertyProxy
	{
		private var _min:Number;
		private var _max:Number;
		
		public function RangePropertyProxy(min:Number, max:Number)
		{
			this._min = min;
			this._max = max;
			
			this.toStringProps.push("min", "max");
		}

		public function get min():Number
		{
			return this._min;
		}

		public function set min(value:Number):void
		{
			this._min = value;
		}

		public function get max():Number
		{
			return this._max;
		}

		public function set max(value:Number):void
		{
			this._max = value;
		}
		
		public function getValue(target:Object, property:String):Number
		{
			return (target[property]- this._min) / (this._max - this._min);
		}

		override public function setValue(target:Object, property:String, value:*):void
		{
			super.setValue(target, property, this._min + (this._max - this._min) * value);
		}
	}
}
