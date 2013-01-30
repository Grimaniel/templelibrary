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

package temple.speech.utils
{
	import cmodule.libFlac.CLibInit;

	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	/**
	 * @author Michiel Brinkers
	 */
	public class FlacEncoder
	{
		private static var _lib:CLibInit;
		private static var _converter:Object;
		
		/**
		 * Returns a static instance of the C Library
		 */
		private static function getLib():CLibInit
		{
			return _lib ||= new CLibInit();
		}
		
		/**
		 * Returns a static instance of the Converter Library
		 */
		private static function getConverter():Object
		{
			return _converter ||= getLib().init();
		}
		
		/**
		 * Converts raw microphone wave data to flac.
		 * 
		 * @param input Microphone wave data
		 * @param rate Rate of the input data in Hz. Output rate will be the same.
		 * @param compression Compression level. 0 is no compression, 8 is max compression. Default is 0.
		 * @return Converted ByteArray if succefull. null if failed. 
		 */
		public static function encode(input:ByteArray, rate:uint=44100, compression:uint=0):ByteArray
		{
			input.position = 0;
			
			var output:ByteArray = new ByteArray();
			
			if ( !getConverter().encode(input, output, rate, compression) )
			{
				output = null;
			}
			
			return output;
		}
				
		/**
		 * Set's a sprite which will be used to output internal logging data from the library
		 * into an automatically generated TextField inside the sprite. Useful for debugging.
		 */
		public static function setDebugSprite(sprite:Sprite):void
		{
			getLib().setSprite(sprite);
		}	
	}
}
