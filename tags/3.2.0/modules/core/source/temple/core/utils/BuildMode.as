/*
include "../includes/License.as.inc";
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
		include "../includes/Version.as.inc";
		
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
				
				if (bytes == null) return null;
				
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
