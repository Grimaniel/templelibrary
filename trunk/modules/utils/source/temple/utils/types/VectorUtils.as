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

package temple.utils.types 
{
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	import flash.utils.getQualifiedClassName;

	/**
	 * This class contains some functions for Vectors.
	 * 
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
		public static function clone(vector:*):*
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
		 * Sorts the elements in a vector according to one or more fields in the vector.
		 * This method works the same as the Array.sortOn method.
		 */
		public static function sortOn(vector:*, names:*, options:* = 0, ...args:*):void
		{
			var a:Array = VectorUtils.toArray(vector);
			a.sortOn.apply(null, [names, options].concat(args));
			
			var fixed:Boolean = vector.fixed;
			vector.fixed = false;
			vector.length = 0;
			vector.push.apply(null, a);
			vector.fixed = fixed;
		}
		
		/**
		 * Shuffles a Vector (sort random) 
		 */
		public static function shuffle(vector:*):void 
		{
			if (!VectorUtils.isVector(vector)) throwError(new TempleArgumentError(VectorUtils, vector + " is not a Vector " + getQualifiedClassName(vector)));
			
			var i:uint = vector.length;
		    if (i == 0)
			{
				return;
			}
			var j:int;
			var temp:*;
		    while (--i)
			{
		        j = Math.floor(Math.random() * (i + 1));
		        temp = vector[i];
		        vector[i] = vector[j];
		        vector[j] = temp;
		    }
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
