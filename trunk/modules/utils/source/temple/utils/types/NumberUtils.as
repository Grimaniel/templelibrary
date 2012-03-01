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

	/**
	 * This class contains some functions for Numbers.
	 * 
	 * @author Thijs Broerse, Arjan van Wijk, Bart van der Schoor
	 */
	public final class NumberUtils 
	{

		/**
		 * Creates a random number within a given range.
		 * @param start lowest number of the range
		 * @param end highest number of the range
		 * @return A new random number.
		 * @example
		 * This example creates a random number between 10 and 20:
		 * <listing version="3.0">
		 * var scale:Number = NumberUtils.randomInRange(10, 20);
		 * </listing>
		 */
		public static function randomInRange(start:Number, end:Number):Number 
		{
			var d:Number = end - start;
			return start + (d - Math.random() * d);
		}
		
		/**
		 * Finds the x value of a point on a sine curve of which only the y value is known. The closest x value is returned, ranging between -1 pi and 1 pi.
		 * @param yPosOnCurve y value of point to find on the sine curve
		 * @param curveBottom min y value (bottom) of the sine curve
		 * @param curveTop max y value (top) of the sine curve
		 * @return The offset value as multiplier of pi.
		 * @implementationNote Calls {at link #normalizedValue}.
		 * @example
		 * This code returns the x position of a normal sine curve - running from -1 to 1 - at x position 1 (when the curve is at its highest):
		 * <listing version="3.0">
		 *	NumberUtils.xPosOnSinus(1, -1, 1); // 1.5707963267949 ( = 0.5 * Math.PI )
		 * </listing>
		 */
		public static function xPosOnSinus(yPosOnCurve:Number, curveBottom:Number, curveTop:Number):Number 
		{
			return Math.asin(2 * NumberUtils.normalizedValue(yPosOnCurve, curveBottom, curveTop) - 1);
		}

		/**
		 * Finds the relative position of a number in a range between min and max, and returns its normalized value between 0 and 1.
		 * @param number value to normalize
		 * @param min lowest range value
		 * @param max highest range value
		 * @return The normalized value between 0 and 1.
		 * @example
		 * <listing version="3.0">
		 *	NumberUtils.normalizedValue(25, 0, 100); // 0.25
		 *	NumberUtils.normalizedValue(0, -1, 1); // 0.5
		 * </listing>
		 */
		public static function normalizedValue(number:Number, min:Number, max:Number):Number 
		{
			var diff:Number = max - min;
			if (diff == 0) return min;
			var f:Number = 1 / diff;
			return f * (number - min);
		}

		/**
		 * Calculates the angle of a vector.
		 * @param dx the x component of the vector
		 * @param dy the y component of the vector
		 * @return The the angle of the passed vector in degrees.
		 */
		public static function angle(dx:Number, dy:Number):Number 
		{
			return Math.atan2(dy, dx) * 180 / Math.PI;
		}

		/**
		 * Determines a value between two specified values.
		 * 
		 * @param amount: The level of interpolation between the two values. If {@code 0%}, {@code begin} value is returned; if {@code 100%}, {@code end} value is returned.
		 * @param minimum: The lower value.
		 * @param maximum: The upper value.
		 * @example
		 * <listing version="3.0">
		 *	trace(NumberUtil.interpolate(0.5, 0, 10)); // Traces 5
		 * </listing>
		 */
		public static function interpolate(factor:Number, minimum:Number, maximum:Number):Number 
		{
			return minimum + (maximum - minimum) * factor;
		}

		/**
		 * Formats a number to a specific format.
		 * @param number the number to format
		 * @param thousandDelimiter the characters used to delimit thousands, millions, etcetera; "." if not specified
		 * @param decimalDelimiter the characters used to delimit the fractional portion from the whole number; "," if not specified
		 * @param precision the total number of decimals
		 * @param fillLength  minimal length of the part *before* the decimals delimiter, if the length is less it will be filled up
		 * @param fillChar the character to use to fill with; zero ("0") if not specified
		 * 
		 * @includeExample NumberUtilsFormatExample.as
		 */
		public static function format(number:Number, decimalDelimiter:String = ',', thousandDelimiter:String = '.', precision:Number = NaN, fillLength:Number = NaN, fillChar:String = '0'):String
		{
			if (!isNaN(precision))
			{
				number = NumberUtils.roundToPrecision(number, precision);
			}
			
			var str:String = number.toString();
			var p:int = str.indexOf('.');
			if (number < 0) str = str.substr(1);

			var decimals:String = p != -1 ? str.substr(p + 1) : '';
			while (decimals.length < precision) decimals = decimals + '0';
			
			var floored:String = Math.floor(Math.abs(number)).toString();
			var formatted:String = '';
			
			if (thousandDelimiter)
			{
				var len:uint = Math.ceil(floored.length / 3) - 1;
				for (var i:int = 0;i < len; ++i)
				{
					formatted = thousandDelimiter + floored.substr(floored.length - (3 * (i + 1)), 3) + formatted;
				}
				formatted = floored.substr(0, floored.length - (3 * i)) + formatted;
			}
			else
			{
				formatted = floored;
			}
			
			if (fillLength && fillChar && fillChar != '')
			{
				if (number < 0) fillLength--;
				while (formatted.length < fillLength) formatted = fillChar + formatted;
			}
			
			if (isNaN(precision) || precision > 0) formatted = formatted + (decimals ? decimalDelimiter + decimals : '');
			
			if (number < 0) formatted = "-" + formatted;
			
			return formatted;
		}

		/**
		 * Rounds a Number to the nearest multiple of an input. For example, by rounding
		 * 16 to the nearest 10, you will receive 20. Similar to the built-in function Math.round().
		 * 
		 * @param number the number to round
		 * @param nearest the number whose mutiple must be found
		 * @return the rounded number
		 */
		public static function roundToNearest(number:Number, nearest:Number = 1):Number
		{
			if (nearest == 0)
			{
				return number;
			}
			var roundedNumber:Number = Math.round(NumberUtils.roundToPrecision(number / nearest, 10)) * nearest;
			return NumberUtils.roundToPrecision(roundedNumber, 10);
		}

		/**
		 * Rounds a Number <em>up</em> to the nearest multiple of an input. For example, by rounding
		 * 16 up to the nearest 10, you will receive 20. Similar to the built-in function Math.ceil().
		 * 
		 * @param number the number to round up
		 * @param nearest the number whose mutiple must be found
		 * @return the rounded number
		 */
		public static function roundUpToNearest(number:Number, nearest:Number = 1):Number
		{
			if (nearest == 0)
			{
				return number;
			}
			return Math.ceil(NumberUtils.roundToPrecision(number / nearest, 10)) * nearest;
		}

		/**
		 * Rounds a Number <em>down</em> to the nearest multiple of an input. For example, by rounding
		 * 16 down to the nearest 10, you will receive 10. Similar to the built-in function Math.floor().
		 * 
		 * @param number the number to round down
		 * @param nearest the number whose mutiple must be found
		 * @return the rounded number
		 */
		public static function roundDownToNearest(number:Number, nearest:Number = 1):Number
		{
			if (nearest == 0)
			{
				return number;
			}
			return Math.floor(NumberUtils.roundToPrecision(number / nearest, 10)) * nearest;
		}

		/**
		 * Rounds a number to a certain level of precision. Useful for limiting the number of decimal places on a fractional number.
		 * 
		 * @param number the input number to round.
		 * @param precision	the number of decimal digits to keep
		 * @return the rounded number, or the original input if no rounding is needed
		 */
		public static function roundToPrecision(number:Number, precision:int = 0):Number
		{
			var n:Number = Math.pow(10, precision);
			return Math.round(number * n) / n;
		}
		
		/**
		 * Floors a number to a certain level of precision. Useful for limiting the number of
		 * decimal places on a fractional number.
		 * 
		 * @param number the input number to floor.
		 * @param precision	the number of decimal digits to keep
		 * @return the floored number, or the original input if no flooring is needed
		 */
		public static function floorToPrecision(number:Number, precision:int = 0):Number
		{
			var n:Number = Math.pow(10, precision);
			return Math.floor(number * n) / n;
		}

		/**
		 * Ceils a number to a certain level of precision. Useful for limiting the number of
		 * decimal places on a fractional number.
		 * 
		 * @param number the input number to ceil.
		 * @param precision	the number of decimal digits to keep
		 * @return the ceiled number, or the original input if no ceiling is needed
		 */
		public static function ceilToPrecision(number:Number, precision:int = 0):Number
		{
			var n:Number = Math.pow(10, precision);
			return Math.ceil(number * n) / n;
		}

		/**
		 * Tests equality for numbers that may have been generated by faulty floating point math.
		 * This is not an issue exclusive to the Flash Player, but all modern computing in general.
		 * The value is generally offset by an insignificant fraction, and it may be corrected.
		 * 
		 * <p>Alternatively, this function could be used for other purposes than to correct floating
		 * point errors. Certainly, it could determine if two very large numbers are within a certain
		 * range of difference. This might be useful for determining "ballpark" estimates or similar
		 * statistical analysis that may not need complete accuracy.</p>
		 * 
		 * @param number1 the first number to test
		 * @param number2 the second number to test
		 * @param precision	the number of digits in the fractional portion to keep
		 * @return true, if the numbers are close enough to be considered equal, false if not.
		 */
		public static function fuzzyEquals(number1:Number, number2:Number, precision:int = 5):Boolean
		{
			var difference:Number = number1 - number2;
			var range:Number = Math.pow(10, -precision);
			
			//default precision checks the following:
			//0.00001 < difference > -0.00001

			return difference < range && difference > -range;
		}

		/**
		 * Get the Number out of a string. Can handle . or , as decimal separator (will not match thousand delimitters)
		 * Useful for unit values like '€ 49.95' or '1000 KM'
		 */
		public static function getNumberFromString(string:String):Number
		{
			string = string.match(/[0-9]+[.,]?[0-9]*/)[0];
			// replace , fo .
			string = string.replace(',', '.');
			return Number(string);
		}

		/**
		 * Calculates the smallest possible difference between 2 indexes.
		 * @param index the current index
		 * @param newIndex the new index
		 */
		public static function getNearestRotationIndex(index:int, newIndex:int, total:uint = 360):int
		{
			var curIndex:int = index;
			while (curIndex < 0) curIndex += total;
			while (newIndex < 0) newIndex += total;
			
			var diff:int = Math.abs(curIndex - newIndex);
			
			if (diff > total / 2)
			{
				if (curIndex > newIndex)
				{
					return index + (total - diff);
				}
				else
				{
					return index - (total - diff);
				}
			}
			else
			{
				if (curIndex < newIndex)
				{
					return index + diff;
				}
				else
				{
					return index - diff;
				}
			}
		}

		/**
		 * Clamp a number to a range around zero (from -range to +range)
		 */
		public static function clampPosNeg(input:Number, range:Number, base:Number = 0):Number
		{
			range = Math.abs(range);
			
			input -= base;
			
			if (input < 0 && input < -range)
			{
				return base - range;
			}
			else if (input > 0 && input > range)
			{
				return base + range;
			}
			return base + input;
		}
		
		/**
		 * Get English suffix for an ordinal number: 1 -> 'st' ('1st'), 2 -> 'nd' ('2nd'), 3 -> 'rd' ('3rd'), 4 -> 'th' ('4th')
		 */
		public static function ordinalSuffix(position:int):String
		{
			if (position < 0 ) throwError(new TempleArgumentError(NumberUtils, 'ordinal number less then zero'));
			
			//exceptions
			switch (position)
			{
				case 0:
					return '';
				case 11:
				case 12:
				case 13:
					return 'th';
			}
			//rule
			var rest:int = position % 10;
			switch (rest)
			{
				case 1:
					return 'st';
				case 2:
					return 'nd';
				case 3:
					return 'rd';
			}
			return 'th';
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(NumberUtils);
		}
	}	
}