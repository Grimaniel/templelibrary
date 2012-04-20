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
 * Base64 - 1.1.0
 * 
 * Copyright (c) 2006 Steve Webster
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions: 
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package temple.data.encoding 
{
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import flash.utils.ByteArray;

	/**
	 * Base64 is a group of similar encoding schemes that represent binary data in an ASCII string format by translating
	 * it into a radix-64 representation.
	 * 
	 * @see http://en.wikipedia.org/wiki/Base64
	 * 
	 * @author Steve Webster
	 */
	public class Base64 
	{
		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

		public static const version:String = "1.1.0";

		public static function encode(data:String):String 
		{
			// Convert string to ByteArray
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			
			// Return encoded ByteArray
			return encodeByteArray(bytes);
		}

		public static function encodeByteArray(data:ByteArray):String 
		{
			// Initialise output
			var output:String = "";
			
			// Create data and output buffers
			var dataBuffer:Array;
			var outputBuffer:Array = new Array(4);
			
			// Rewind ByteArray
			data.position = 0;
			
			// while there are still bytes to be processed
			while (data.bytesAvailable > 0) 
			{
				// Create new data buffer and populate next 3 bytes from data
				dataBuffer = new Array();
				for (var i:uint = 0;i < 3 && data.bytesAvailable > 0;i++) 
				{
					dataBuffer[i] = data.readUnsignedByte();
				}
				
				// Convert to data buffer Base64 character positions and 
				// store in output buffer
				outputBuffer[0] = (dataBuffer[0] & 0xfc) >> 2;
				outputBuffer[1] = ((dataBuffer[0] & 0x03) << 4) | ((dataBuffer[1]) >> 4);
				outputBuffer[2] = ((dataBuffer[1] & 0x0f) << 2) | ((dataBuffer[2]) >> 6);
				outputBuffer[3] = dataBuffer[2] & 0x3f;
				
				// If data buffer was short (i.e not 3 characters) then set
				// end character indexes in data buffer to index of '=' symbol.
				// This is necessary because Base64 data is always a multiple of
				// 4 bytes and is basses with '=' symbols.
				for (var j:uint = dataBuffer.length;j < 3;j++) 
				{
					outputBuffer[j + 1] = 64;
				}
				
				// Loop through output buffer and add Base64 characters to 
				// encoded data string for each character.
				for (var k:uint = 0;k < outputBuffer.length;k++) 
				{
					output += BASE64_CHARS.charAt(outputBuffer[k]);
				}
			}
			
			// Return encoded data
			return output;
		}

		public static function decode(data:String):String 
		{
			// Decode data to ByteArray
			var bytes:ByteArray = decodeToByteArray(data);
			
			// Convert to string and return
			return bytes.readUTFBytes(bytes.length);
		}

		public static function decodeToByteArray(data:String):ByteArray 
		{
			// Initialise output ByteArray for decoded data
			var output:ByteArray = new ByteArray();
			
			// Create data and output buffers
			var dataBuffer:Array = new Array(4);
			var outputBuffer:Array = new Array(3);

			// While there are data bytes left to be processed
			for (var i:uint = 0;i < data.length;i += 4) 
			{
				// Populate data buffer with position of Base64 characters for
				// next 4 bytes from encoded data
				for (var j:uint = 0;j < 4 && i + j < data.length;j++) 
				{
					dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
				}
      			
				// Decode data buffer back into bytes
				outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 0x30) >> 4);
				outputBuffer[1] = ((dataBuffer[1] & 0x0f) << 4) + ((dataBuffer[2] & 0x3c) >> 2);		
				outputBuffer[2] = ((dataBuffer[2] & 0x03) << 6) + dataBuffer[3];
				
				// Add all non-padded bytes in output buffer to decoded data
				for (var k:uint = 0;k < outputBuffer.length;k++) 
				{
					if (dataBuffer[k + 1] == 64) break;
					output.writeByte(outputBuffer[k]);
				}
			}
			
			// Rewind decoded data ByteArray
			output.position = 0;
			
			// Return decoded data
			return output;
		}

		public function Base64() 
		{
			throwError(new TempleError(this, "Base64 class is static container only"));
		}
	}
}