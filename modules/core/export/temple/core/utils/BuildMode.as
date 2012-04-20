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

package temple.core.utils 
{
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.templelibrary;

	/**
	 * Utility class for checking if the SWF is compiled for debug mode.
	 * 
	 * @author Thijs Broerse
	 */
	public final class BuildMode 
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.2";
		
		/**
		 * Returns true if the SWF is built in debug mode.
		 * Note: only works in a debug player.
		 */
		public static function isDebugBuild():Boolean
		{
			var stack:String = new Error().getStackTrace();
			return stack ? stack.search(/:[0-9]+]$/m) > -1 : false;
		}

		/**
		 * Returns true if the SWF is built in release mode.
		 * Note: only works in a debug player.
		 */
		public static function isReleaseBuild():Boolean
		{
			return !BuildMode.isDebugBuild();
		}
		
		/**
		 * Returns the date when the SWF is compiled.
		 * Note: this only works for files compiled using mxmlc or FCSH. The Flash IDE does not add the compilation date.
		 */
		public static function getCompilationDate(displayObject:DisplayObject):Date
		{
			if (!displayObject) throwError(new TempleArgumentError(BuildMode, "No displayObject"));
			
			if (displayObject.loaderInfo.hasOwnProperty('bytes'))
			{
				var bytes:ByteArray = displayObject.loaderInfo['bytes'] as ByteArray;
				bytes.endian = Endian.LITTLE_ENDIAN;
				// Signature + Version + FileLength + FrameSize + FrameRate + FrameCount
				bytes.position = 3 + 1 + 4 + (Math.ceil(((bytes[8] >> 3) * 4 - 3) / 8) + 1) + 2 + 2;
				while (bytes.position != bytes.length)
				{
					var tagHeader:uint = bytes.readUnsignedShort();
					if (tagHeader >> 6 == 41)
					{
						// ProductID + Edition + MajorVersion + MinorVersion + BuildLow + BuildHigh
						bytes.position += 4 + 4 + 1 + 1 + 4 + 4;
						var milli:Number = bytes.readUnsignedInt();
						var date:Date = new Date();
						date.setTime(milli + bytes.readUnsignedInt() * 4294967296);
						return date;
					}
					else
					{
						bytes.position += (tagHeader & 63) != 63 ? (tagHeader & 63) : bytes.readUnsignedInt() + 4;
					}
				}
				Log.warn("No ProductInfo tag found", BuildMode);
			}
			
			return null;
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(BuildMode);
		}
	}
}
