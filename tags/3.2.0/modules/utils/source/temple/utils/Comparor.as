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

package temple.utils 
{
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	/**
	 * The Comparor compares two values, based on an operator.  
	 * 
	 * @author Thijs Broerse
	 */
	public final class Comparor 
	{
		/**
		 * Tests two expressions for equality.
		 */
		public static const EQUAL:String = "==";
		
		/**
		 * Tests for the exact opposite of the equality (==) operator
		 */
		public static const NOT_EQUAL:String = "!=";
		
		/**
		 * Tests two expressions for equality, but does not perform automatic data conversion.
		 */
		public static const STRICKTLY_EQUAL:String = "===";
		
		/**
		 * Tests for the exact opposite of the strict equality (===) operator.
		 */
		public static const STRICKTLY_NOT_EQUAL:String = "!==";
		
		/**
		 * Compares two expressions and determines whether value1 is greater than value2; if it is, the result is true.
		 */
		public static const GREATER_THAN:String = ">";
		
		/**
		 * 	Compares two expressions and determines whether value1 is greater than or equal to value2 (true) or expression1 is less than value2 (false)
		 */
		public static const GREATER_THAN_OR_EQUAL_TO:String = ">=";

		/**
		 * Compares two expressions and determines whether value1 is less than value2; if so, the result is true.
		 */
		public static const LESS_THAN:String = "<";
		
		/**
		 * Compares two expressions and determines whether value1 is less than or equal to value2; if it is, the result is true.
		 */
		public static const LESS_THAN_OR_EQUAL_TO:String = "<=";
		
		/**
		 * Evaluates whether a property is part of a specific object.
		 */
		public static const IN:String = "in";
		
		/**
		 * Evaluates whether a property is not part of a specific object.
		 */
		public static const NOT_IN:String = "!in";
		
		/**
		 * Evaluates whether an object is compatible with a specific data type, class, or interface.
		 */
		public static const IS:String = "is";

		/**
		 * Evaluates whether an object is not compatible with a specific data type, class, or interface.
		 */
		public static const NOT_IS:String = "!is";
		
		/**
		 * Returns true if both value1 and value2 are true
		 */
		public static const AND:String = "&&";

		/**
		 * Returns true if both value1 and value2 are false
		 */
		public static const NAND:String = "!&&";

		/**
		 * Returns true if or value1 or value2 is true
		 */
		public static const OR:String = "||";

		/**
		 * Returns true if or value1 or value2 is false
		 */
		public static const NOR:String = "!||";
		
		/**
		 * Returns true is value1 % value2 has not a rest value
		 */
		public static const MODULO:String = "%";

		/**
		 * Returns true is value1 % value2 has a rest value
		 */
		public static const NOT_MODULO:String = "!%";
		
		/**
		 * Returns true if value1 has a property value2
		 */
		public static const HAS_OWN_PROPERTY:String = "hasOwnProperty";

		/**
		 * Compares value1 with value2 based on an operator. Returns true if they do, false if they don't
		 * @param value1 the first value to compare
		 * @param value2 the seconds value to compare
		 * @param operator how value1 and value2 should compare, like equals (==), not equals (!=), greater than (>) etc.
		 */
		public static function compare(value1:*, value2:*, operator:String = Comparor.EQUAL):Boolean 
		{
			switch (operator)
			{
				case Comparor.EQUAL: return value1 == value2;
				case Comparor.NOT_EQUAL: return value1 != value2;
				
				case Comparor.STRICKTLY_EQUAL: return value1 === value2;
				case Comparor.STRICKTLY_NOT_EQUAL: return value1 !== value2;
				
				case Comparor.GREATER_THAN: return value1 > value2;
				case Comparor.GREATER_THAN_OR_EQUAL_TO: return value1 >= value2;

				case Comparor.LESS_THAN: return value1 < value2;
				case Comparor.LESS_THAN_OR_EQUAL_TO: return value1 <= value2;

				case Comparor.IN: return value1 in value2;
				case Comparor.NOT_IN: return !(value1 in value2);
				case Comparor.IS: return value1 is value2;
				case Comparor.NOT_IS: return !(value1 is value2);

				case Comparor.AND: return value1 && value2;
				case Comparor.NAND: return !(value1 && value2);
				case Comparor.OR: return value1 || value2;
				case Comparor.NOR: return !(value1 || value2);

				case Comparor.MODULO:	return !(value1 % value2);
				case Comparor.NOT_MODULO:	return !!(value1 % value2);

				case Comparor.HAS_OWN_PROPERTY: return value1 && Object(value1).hasOwnProperty(value2);
				
				default: throwError(new TempleError(Comparor, "Invalid value for operator: '" + operator + "'"));
			}
			return false;
		}
		
		public static function toString() : String
		{
			return objectToString(Comparor);
		}
	}
}
