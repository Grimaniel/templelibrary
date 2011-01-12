/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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

package temple.utils.types 
{
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;
	import temple.debug.getClassName;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Thijs Broerse
	 */
	public final class VectorUtils 
	{
		/**
		 * Checks if the object is a Vector
		 */
		public static function isVector(object:Object):Boolean
		{
			 return getQualifiedClassName(object).indexOf("__AS3__.vec::Vector.") === 0;
		}
		
		/**
		 *	Remove all instances of the specified value from the vector,
		 * 	@param vector The vector from which the value will be removed
		 *	@param value The object that will be removed from the vector.
		 */		
		public static function removeValueFromVector(vector:*, value:Object):void
		{
			if (!VectorUtils.isVector(vector)) throwError(new TempleArgumentError(VectorUtils, vector + " is not a Vector " + getQualifiedClassName(vector)));
			
			for (var i:Number = vector.length - 1;i > -1; i--)
			{
				if (vector[i] === value)
				{
					vector.splice(i, 1);
				}
			}
		}

		/**
		 * Converts a Vector to an Array
		 */
		public static function toArray(vector:*):Array 
		{
			if (!VectorUtils.isVector(vector)) throwError(new TempleArgumentError(VectorUtils, vector + " is not a Vector " + getQualifiedClassName(vector)));
			
			var array:Array = new Array(vector.length);
			var i:int=vector.length;
			while (i--)
			{
			    array[i] = vector[i];
			}
			return array;
		}

		public static function toString():String
		{
			return getClassName(VectorUtils);
		}
	}
}
