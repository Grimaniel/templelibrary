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

	/**
	 * This class contains some functions for Array's.
	 * 
	 * @author Arjan van Wijk, Thijs Broerse, Bart van de Schoor
	 */
	public final class ArrayUtils 
	{
		/**
		 * Checks if an array contains a specific value
		 */
		public static function inArray(array:Array, value:*):Boolean
		{
			return (array.indexOf(value) != -1);
		}		/**
		 * Checks if an element in the array has a field with a specific value
		 */
		public static function inArrayField(array:Array, field:String, value:*):Boolean
		{
			for each (var i:* in array) 
			{
				if (i[field] == value) return true;
			}
			return false;
		}
		/**
		 * Get a random element form the array
		 */
		public static function randomElement(array:Array):*
		{
			if (array.length > 0)
			{
				return array[Math.floor(Math.random() * array.length)];
			}
			return null;
		}

		/**
		 * Shuffles an array (sort random) 
		 */
		public static function shuffle(array:Array):void 
		{
			var i:uint = array.length;
		    if (i == 0)
			{
				return;
			}
			var j:int;
			var temp:*;
		    while (--i)
			{
		        j = Math.floor(Math.random() * (i + 1));
		        temp = array[i];
		        array[i] = array[j];
		        array[j] = temp;
		    }
		}
		
		/**
		 * copies the source array to the target array, without remove the reference
		 */
		public static function copy(array:Array, target:Array):void
		{
			var leni:int = target.length = array.length;
			for (var i:int = 0;i < leni; i++) 
			{
				target[i] = array[i];
			}
		}
		
		/**
		 * recursively clone an Array and it's sub-Array's (doesn't clone content objects)
		 */
		public static function deepArrayClone(array:Array):Array
		{	
			var ret:Array = array.concat();
			var iLim:uint = ret.length;
			var i:uint;
			for (i = 0;i < iLim;i++)
			{
				if (ret[i] is Array)
				{
					ret[i] = ArrayUtils.deepArrayClone(ret[i]);
				}
			}
			return ret;
		}

		/**
		 * Calculates the average value of all elements in an array
		 * Works only for array's with numeric values
		 */
		public static function average(array:Array):Number
		{
			if (array == null || array.length == 0) return NaN;
			var total:Number = 0;
			for each (var n : Number in array) total += n;
			return total / array.length;
		}


		/**
		 * Remove all instances of the specified value from the array,
		 * @param array The array from which the value will be removed
		 * @param value The item that will be removed from the array.
		 *	
		 * @return the number of removed items
		 */		
		public static function removeValueFromArray(array:Array, value:*):uint
		{
			var total:int = 0;
			for (var i:int = array.length - 1;i > -1; i--)
			{
				if (array[i] === value)
				{
					array.splice(i, 1);
					total++;
				}
			}
			return total;
		}

		/**
		 * Removes a single (first occurring) value from an Array.
		 * @param array The array from which the value will be removed
		 * @param value The item that will be removed from the array.
		 *	
		 * @return a Boolean which indicates if a value is removed
		 */
		public static function removeValueFromArrayOnce(array:Array, value:*):Boolean
		{
			var len:uint = array.length;

			for (var i:int = len;i > -1; i--)
			{
				if (array[i] === value)
				{
					array.splice(i, 1);
					return true;
				}
			}
			return false;
		}

		/**
		 * Create a new array that only contains unique instances of objects
		 * in the specified array.
		 * 
		 * <p>Basically, this can be used to remove duplication object instances
		 * from an array</p>
		 * 
		 * @param array The array which contains the values that will be used to
		 * create the new array that contains no duplicate values.
		 * 
		 * @return A new array which only contains unique items from the specified
		 * array.
		 */	
		public static function createUniqueCopy(array:Array):Array
		{
			var newArray:Array = new Array();

			var len:int = array.length;
			var item:Object;
			
			for (var i:uint = 0;i < len; ++i)
			{
				item = array[i];
				
				if (ArrayUtils.inArray(newArray, item))
				{
					continue;
				}
				
				newArray.push(item);
			}
			
			return newArray;
		}

		/**
		 * Creates a copy of the specified array.
		 * 
		 * <p>Note that the array returned is a new array but the items within the
		 * array are not copies of the items in the original array (but rather 
		 * references to the same items)</p>
		 * 
		 * @param array The array that will be cloned.
		 * 
		 * @return A new array which contains the same items as the array passed
		 * in.
		 */			
		public static function clone(array:Array):Array
		{	
			return array.slice();
		}

		/**
		 * Compares two arrays and returns a boolean indicating whether the arrays
		 * contain the same values at the same indexes.
		 * 
		 * @param array1 The first array that will be compared to the second.
		 * @param array2 The second array that will be compared to the first.
		 * 
		 * @return True if the arrays contains the same values at the same indexes.
		 * 	False if they do not.
		 */		
		public static function areEqual(array1:Array, array2:Array):Boolean
		{
			if (array1 == array2)
			{
				return true;
			}
			if (array1.length != array2.length)
			{
				return false;
			}
			for (var i:int = array1.length -1; i >= 0; --i)
			{
				if (array1[i] != array2[i])
				{
					return false;
				}
			}
			return true;
		}

		/**
		 * Returns the amount of (not empty) items in an Array.
		 */
		public static function filledLength(array:Array):uint 
		{
			var length:uint;
			
			var leni:int = array.length;
			for (var i:int = 0; i < leni; i++)
			{
				if (array[i] != undefined) length++;
			}
			return length;
		}

		/**
		 * Returs the items that are unique in the first array
		 */
		public static function getUniqueFirst(array1:Array, array2:Array):Array
		{
			var ret:Array = new Array();
			
			for (var i:int = 0; i < array1.length; i++)
			{
				if (array2.indexOf(array1[i]) == -1) ret.push(array1[i]);
			}
			
			return ret;
		}
		
		/**
		 * Returs the items that are in both arrays
		 */
		public static function intersect(array1:Array, array2:Array):Array
		{
			var ret:Array = new Array();
			var i:int;
			
			for (i = 0; i < array1.length; i++)
			{
				if (array2.indexOf(array1[i]) != -1) ret.push(array1[i]);
			}
			for (i = 0; i < array2.length; i++)
			{
				if (array1.indexOf(array2[i]) != -1) ret.push(array2[i]);
			}
			
			ret = ArrayUtils.createUniqueCopy(ret);
			
			return ret;
		}
		
		/**
		 * Adds an element to an Array
		 * @param element the element to add
		 * @param amount number of times the element must be added
		 * @param array the array where the element is added to. If null, a new Array is created
		 * 
		 * @return the array or the newly create array, with the element
		 */
		public static function addElements(element:*, amount:uint, array:Array = null):Array
		{
			array ||= [];
			for(var i:uint = 0;i < amount;i++)
			{
				array.push(element);
			}
			return array;
		}

		/**
		 * Simple joins a Array to a String
		 */
		public static function simpleJoin(array:Array, sort:Boolean=true, pre:String=' - ', post:String='\n', empty:String = '(empty)'):String
		{
			if(!array)
			{
				return '(null array)';
			}
			if(array.length == 0)
			{
				return empty;
			}
			if(sort)
			{
				array = array.concat().sort();
			}
			return pre + array.join(post + pre) + post;
		}
		
		/**
		 * Returns a new Array from an Array without the empty (null, '' or undifined) elements.
		 */
		public static function removeEmptyElements(array:Array):Array
		{
			var results:Array = new Array();
			for (var i:int = 0; i < array.length; ++i)
			{
				if (array[i] != '' && array[i] != null && array[i] != undefined) results.push(array[i]);
			}
			
			return results;
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(ArrayUtils);
		}
	}
}
