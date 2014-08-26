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

	/**
	 * This class contains some functions for Integers.
	 * 
	 * @author Thijs Broerse, Arjan van Wijk, Bart van der Schoor
	 */
	public final class IntUtils 
	{

		/**
		 * Rotates x left n bits
		 */
		public static function rol(x:int, n:int):int 
		{
			return (x << n) | (x >>> (32 - n));
		}

		/**
		 * Rotates x right n bits
		 */
		public static function ror(x:int, n:int):uint 
		{
			var nn:int = 32 - n;
			return ( x << nn ) | ( x >>> ( 32 - nn ) );
		}

		/** String for quick lookup of a hex character based on index */
		private static const _HEX_CHARS:String = "0123456789abcdef";

		/**
		 * Outputs the hex value of a int, allowing the developer to specify
		 * the endinaness in the process. Hex output is lowercase.
		 *
		 * @param n The int value to output as hex
		 * @param bigEndian Flag to output the int as big or little endian
		 * @return A string of length 8 corresponding to the hex representation of n ( minus the leading "0x" )
		 */
		public static function toHex(n:int, bigEndian:Boolean = false):String 
		{
			var s:String = "";
			
			if (bigEndian) 
			{
				for (var i:int = 0;i < 4; i++) 
				{
					s += IntUtils._HEX_CHARS.charAt(( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF) + IntUtils._HEX_CHARS.charAt(( n >> ( ( 3 - i ) * 8 ) ) & 0xF);
				}
			}
			else 
			{
				for (var x:int = 0;x < 4; x++) 
				{
					s += IntUtils._HEX_CHARS.charAt(( n >> ( x * 8 + 4 ) ) & 0xF) + IntUtils._HEX_CHARS.charAt(( n >> ( x * 8 ) ) & 0xF);
				}
			}
			
			return s;
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(IntUtils);
		}
	}
}