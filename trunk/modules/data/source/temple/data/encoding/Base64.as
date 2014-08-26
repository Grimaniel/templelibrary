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

/* 
 * Copyright (C) 2012 Jean-Philippe Auclair 
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php 
 * Base64 library for ActionScript 3.0. 
 * By: Jean-Philippe Auclair : http://jpauclair.net 
 * Based on article: http://jpauclair.net/2010/01/09/base64-optimized-as3-lib/ 
 */  

package temple.data.encoding 
{

	import flash.utils.ByteArray;
	
	/**
	 * Base64 is a group of similar encoding schemes that represent binary data in an ASCII string format by translating
	 * it into a radix-64 representation.
	 * 
	 * @see http://en.wikipedia.org/wiki/Base64
	 * 
	 * @author Jean-Philippe Auclair
	 */
	public class Base64 
	{
		/**
		 * A Boolean flag to control whether the sequence of characters specified for Base64Encoder.newLine are inserted
		 * every 76 characters to wrap the encoded output.
		 */
		public static var insertNewLines:Boolean = true;
		
		/**
		 * The character codepoint to be inserted into the encoded output to denote a new line if insertNewLines is true.
		 */
		public static var newLine:int = 10;
		
		private static const _ENCODE_CHARS:Vector.<int> = encoreChars();  
		private static const _DECODE_CHARS:Vector.<int> = decodeChars();
		
		/**
		 * This value represents a safe number of characters (i.e. arguments) that can be passed to
		 * String.fromCharCode.apply() without exceeding the AVM+ stack limit.
		 */
		private static const _MAX_BUFFER_SIZE:uint = 32767;
		
		/**
		 * The '=' char
		 */
		private static const _ESCAPE_CHAR_CODE:Number = 61;
		
		/**
		 * Encodes a ByteArray in Base64.
		 * 
		 * @param data The ByteArray to encode.
		 */
		public static function encode(data:ByteArray):String
		{
			var out:ByteArray = new ByteArray();
			// Presetting the length keep the memory smaller and optimize speed since there is no "grow" needed
			out.length = (2 + data.length - ((data.length + 2) % 3)) * 4 / 3;
			// Preset length // 1.6 to 1.5 ms
			var i:int = 0;
			var r:int = data.length % 3;
			var len:int = data.length - r;
			var c:uint;
			// read (3) character AND write (4) characters
			var outPos:int = 0;
			while (i < len)
			{
				// Read 3 Characters (8bit * 3 = 24 bits)
				c = data[int(i++)] << 16 | data[int(i++)] << 8 | data[int(i++)];

				out[int(outPos++)] = _ENCODE_CHARS[int(c >>> 18)];
				out[int(outPos++)] = _ENCODE_CHARS[int(c >>> 12 & 0x3f)];
				out[int(outPos++)] = _ENCODE_CHARS[int(c >>> 6 & 0x3f)];
				out[int(outPos++)] = _ENCODE_CHARS[int(c & 0x3f)];
			}

			if (r == 1) // Need two "=" padding
			{
				// Read one char, write two chars, write padding
				c = data[int(i)];

				out[int(outPos++)] = _ENCODE_CHARS[int(c >>> 2)];
				out[int(outPos++)] = _ENCODE_CHARS[int((c & 0x03) << 4)];
				out[int(outPos++)] = 61;
				out[int(outPos++)] = 61;
			}
			else if (r == 2) // Need one "=" padding
			{
				c = data[int(i++)] << 8 | data[int(i)];

				out[int(outPos++)] = _ENCODE_CHARS[int(c >>> 10)];
				out[int(outPos++)] = _ENCODE_CHARS[int(c >>> 4 & 0x3f)];
				out[int(outPos++)] = _ENCODE_CHARS[int((c & 0x0f) << 2)];
				out[int(outPos++)] = 61;
			}

			return out.readUTFBytes(out.length);
		}

		/**
		 * Decodes a Base64 string to a ByteArray
		 */
		public static function decode(string:String):ByteArray
		{
			var c1:int;
			var c2:int;
			var c3:int;
			var c4:int;
			var i:int = 0;
			var len:int = string.length;

			var byteString:ByteArray = new ByteArray();
			byteString.writeUTFBytes(string);
			var outPos:int = 0;
			while (i < len)
			{
				// c1
				c1 = _DECODE_CHARS[int(byteString[i++])];
				if (c1 == -1)
					break;

				// c2
				c2 = _DECODE_CHARS[int(byteString[i++])];
				if (c2 == -1)
					break;

				byteString[int(outPos++)] = (c1 << 2) | ((c2 & 0x30) >> 4);

				// c3
				c3 = byteString[int(i++)];
				if (c3 == 61)
				{
					byteString.length = outPos;
					return byteString;
				}

				c3 = _DECODE_CHARS[int(c3)];
				if (c3 == -1)
					break;

				byteString[int(outPos++)] = ((c2 & 0x0f) << 4) | ((c3 & 0x3c) >> 2);

				// c4
				c4 = byteString[int(i++)];
				if (c4 == 61)
				{
					byteString.length = outPos;
					return byteString;
				}

				c4 = _DECODE_CHARS[int(c4)];
				if (c4 == -1)
					break;

				byteString[int(outPos++)] = ((c3 & 0x03) << 6) | c4;
			}
			byteString.length = outPos;
			return byteString;
		}
		
		/**
		 * Encodes the characters of a String in Base64.
		 * 
		 * @param data The String to encode.
		 */
		public static function encodeString(string:String):String
		{
			var i:uint;

			var length:uint = string.length;
			
			var buffers:Array = [[]];
    		var count:uint;
    		var line:uint;
    		var work:Vector.<uint> = new <uint>[0, 0, 0];

			while (i < length)
			{
				work[count] = string.charCodeAt(i);
				count++;

				if (count == work.length || length - i == 1)
				{
					encodeBlock(buffers, count, line, work);
					count = 0;
					work[0] = 0;
					work[1] = 0;
					work[2] = 0;
				}
				i++;
			}
			if (count > 0) encodeBlock(buffers, count, line, work);

			var result:String = "";

			for (i = 0, length = buffers.length; i < length; i++)
			{
				var buffer:Array = buffers[i] as Array;
				result += String.fromCharCode.apply(null, buffer);
			}

			return result;
		}

		/**
		 * @private
		 */
		private static function encodeBlock(buffers:Array, count:uint, line:uint, work:Vector.<uint>):void
		{
			var currentBuffer:Array = buffers[buffers.length - 1] as Array;
			if (currentBuffer.length >= _MAX_BUFFER_SIZE)
			{
				currentBuffer = [];
				buffers.push(currentBuffer);
			}

			currentBuffer.push(_ENCODE_CHARS[(work[0] & 0xFF) >> 2]);
			currentBuffer.push(_ENCODE_CHARS[((work[0] & 0x03) << 4) | ((work[1] & 0xF0) >> 4)]);

			if (count > 1)
			{
				currentBuffer.push(_ENCODE_CHARS[((work[1] & 0x0F) << 2) | ((work[2] & 0xC0) >> 6)]);
			}
			else
			{
				currentBuffer.push(_ESCAPE_CHAR_CODE);
			}

			if (count > 2)
			{
				currentBuffer.push(_ENCODE_CHARS[work[2] & 0x3F]);
			}
			else
			{
				currentBuffer.push(_ESCAPE_CHAR_CODE);
			}

			if (insertNewLines)
			{
				if ((line += 4) == 76)
				{
					currentBuffer.push(newLine);
					line = 0;
				}
			}
		}

		private static function encoreChars():Vector.<int>
		{
			var encodeChars:Vector.<int> = new Vector.<int>(64, true);
			const chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
			for (var i:int = 0; i < 64; i++) encodeChars[i] = chars.charCodeAt(i);
			return encodeChars;
		}

		private static function decodeChars():Vector.<int>
		{
			return new <int>[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
		} 
	}
}