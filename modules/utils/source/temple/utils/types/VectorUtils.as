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

package temple.utils.types 
{
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

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
		 * Get a random element form the vector
		 */
		public static function randomElement(vector:*):*
		{
			if (!VectorUtils.isVector(vector)) throwError(new TempleArgumentError(VectorUtils, vector + " is not a Vector " + getQualifiedClassName(vector)));
			
			if (vector.length > 0)
			{
				return vector[Math.floor(Math.random() * vector.length)];
			}
			return null;
		}
		
		/**
		 *	Remove all instances of the specified value from the vector,
		 * 	@param vector The vector from which the value will be removed
		 *	@param value The object that will be removed from the vector.
		 *	
		 *	@return the number of removed items
		 */		
		public static function removeValueFromVector(vector:*, value:Object):uint
		{
			if (!VectorUtils.isVector(vector)) throwError(new TempleArgumentError(VectorUtils, vector + " is not a Vector " + getQualifiedClassName(vector)));
			
			var total:int = 0;
			for (var i:Number = vector.length - 1;i > -1; i--)
			{
				if (vector[i] === value)
				{
					vector.splice(i, 1);
					total++;
				}
			}
			return total;
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
		
		/**
		 *	Creates a copy of the specified Vector.
		 *
		 *	<p>Note that the vector returned is a new vector but the items within the
		 *	vector are not copies of the items in the original vector (but rather 
		 *	references to the same items)</p>
		 * 
		 * 	@param vector The vector that will be cloned
		 *
		 *	@return A new vector of the same type which contains the same items as the vector passed in.
		 */			
		public static function clone(vector:*):Array
		{
			if (!VectorUtils.isVector(vector)) throwError(new TempleArgumentError(VectorUtils, vector + " is not a Vector " + getQualifiedClassName(vector)));
			
			return vector.slice();
		}

		/**
		 * Checks if vectors are the same or clones of each other.
		 */
		public static function areEqual(vector1:*, vector2:*):Boolean
		{
			if (!VectorUtils.isVector(vector1)) throwError(new TempleArgumentError(VectorUtils, vector1 + " is not a Vector " + getQualifiedClassName(vector1)));
			if (!VectorUtils.isVector(vector2)) throwError(new TempleArgumentError(VectorUtils, vector2 + " is not a Vector " + getQualifiedClassName(vector2)));
			if (vector1 == vector2)
			{
				return true;
			}
			if (vector1.length != vector2.length)
			{
				return false;
			}
			for (var i:int = vector1.length -1; i >= 0; --i)
			{
				if (vector1[i] != vector2[i])
				{
					return false;
				}
			}
			return true;
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(VectorUtils);
		}
	}
}
