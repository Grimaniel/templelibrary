/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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

package temple.utils 
{
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;
	import temple.debug.getClassName;
	import temple.debug.log.Log;

	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Thijs Broerse
	 */
	public final class BuildMode 
	{
		/**
		 * Returns true if the SWF is built in debug mode
		 */
		public static function isDebugBuild():Boolean
		{
			var stack:String = new Error().getStackTrace();
			return stack ? stack.search(/:[0-9]+]$/m) > -1 : false;
		}

		/**
		 * Returns true if the SWF is built in release mode
		 */
		public static function isReleaseBuild():Boolean
		{
			return !BuildMode.isDebugBuild();
		}
		
		/**
		 * Returns the date when the SWF is compiled.
		 */
		public static function getCompilationDate(displayObject:DisplayObject):Date
		{
			if (!displayObject) throwError(new TempleArgumentError(BuildMode, "No displayObject"));

			var bytes:ByteArray = displayObject.loaderInfo.bytes;
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
			
			return null;
		}

		public static function toString():String
		{
			return getClassName(BuildMode);
		}
	}
}
