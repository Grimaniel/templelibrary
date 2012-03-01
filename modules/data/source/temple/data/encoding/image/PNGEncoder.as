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

package temple.data.encoding.image
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * Class that converts BitmapData into a valid PNG
	 * 
	 * @author Adobe
	 */	
	public class PNGEncoder
	{
		/**
		 * Created a PNG image from the specified BitmapData
		 *
		 * @param image The BitmapData that will be converted into the PNG format.
		 * @return a ByteArray representing the PNG encoded image data.
		 */			
		public static function encode(img:BitmapData):ByteArray 
		{
			// Create output byte array
			var png:ByteArray = new ByteArray();
			// Write PNG signature
			png.writeUnsignedInt(0x89504e47);
			png.writeUnsignedInt(0x0D0A1A0A);
			// Build IHDR chunk
			var IHDR:ByteArray = new ByteArray();
			IHDR.writeInt(img.width);
			IHDR.writeInt(img.height);
			IHDR.writeUnsignedInt(0x08060000); 
			// 32bit RGBA
			IHDR.writeByte(0);
			writeChunk(png, 0x49484452, IHDR);
			// Build IDAT chunk
			var IDAT:ByteArray = new ByteArray();
			for (var i:int = 0;i < img.height;i++) 
			{
				// no filter
				IDAT.writeByte(0);
				var p:uint;
				var j:int;
				if ( !img.transparent ) 
				{
					for (j = 0;j < img.width;j++) 
					{
						p = img.getPixel(j, i);
						IDAT.writeUnsignedInt(uint(((p & 0xFFFFFF) << 8) | 0xFF));
					}
				} 
				else 
				{
					for (j = 0;j < img.width;j++) 
					{
						p = img.getPixel32(j, i);
						IDAT.writeUnsignedInt(uint(((p & 0xFFFFFF) << 8) | (p >>> 24)));
					}
				}
			}
			IDAT.compress();
			writeChunk(png, 0x49444154, IDAT);
			// Build IEND chunk
			writeChunk(png, 0x49454E44, null);
			// return PNG
			return png;
		}

		private static var crcTable:Array;
		private static var crcTableComputed:Boolean = false;

		private static function writeChunk(png:ByteArray, type:uint, data:ByteArray):void 
		{
			if (!crcTableComputed) 
			{
				crcTableComputed = true;
				crcTable = [];
				var c:uint;
				for (var n:uint = 0;n < 256;n++) 
				{
					c = n;
					for (var k:uint = 0;k < 8;k++) 
					{
						if (c & 1) 
						{
							c = uint(uint(0xedb88320) ^ uint(c >>> 1));
						} 
						else 
						{
							c = uint(c >>> 1);
						}
					}
					crcTable[n] = c;
				}
			}
			var len:uint = 0;
			if (data != null) 
			{
				len = data.length;
			}
			png.writeUnsignedInt(len);
			var p:uint = png.position;
			png.writeUnsignedInt(type);
			if ( data != null ) 
			{
				png.writeBytes(data);
			}
			var e:uint = png.position;
			png.position = p;
			c = 0xffffffff;
			for (var i:int = 0;i < (e - p);i++) 
			{
				c = uint(crcTable[
	                (c ^ png.readUnsignedByte()) & uint(0xff)] ^ uint(c >>> 8));
			}
			c = uint(c ^ uint(0xffffffff));
			png.position = e;
			png.writeUnsignedInt(c);
		}
	}
}