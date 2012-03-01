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
	import temple.utils.types.StringUtils;

	/**
	 * This class contains some functions for Time.
	 * 
	 * @author Thijs Broerse
	 */
	public final class TimeUtils 
	{
		/**
		 * Convert a string to seconds, with these formats supported:
		 * 00:03:00.1 / 03:00.1 / 180.1s / 3.2m / 3.2h / 00:01:53,800
		 **/
		public static function stringToSeconds(string:String, delimiter:String = ':'):Number 
		{
			var arr:Array = string.split(delimiter);
			var sec:Number = 0;
			if (string.substr(-1) == 's') 
			{
				sec = Number(string.substr(0, string.length - 1));
			}
			else if (string.substr(-1) == 'm') 
			{
				sec = Number(string.substr(0, string.length - 1)) * 60;
			}
			else if (string.substr(-1) == 'h') 
			{
				sec = Number(string.substr(0, string.length - 1)) * 3600;
			}
			else if (arr.length > 1) 
			{
				if (arr[2] && String(arr[2]).indexOf(',') != -1) arr[2] = String(arr[2]).replace(/\,/,".");
				
				sec = Number(arr[arr.length - 1]);
				sec += Number(arr[arr.length - 2]) * 60;
				if (arr.length == 3) 
				{
					sec += Number(arr[arr.length - 3]) * 3600;
				}
			} 
			else 
			{
				sec = Number(string);
			}
			return sec;
		}

		/** 
		 * Convert number to MIN:SS string.
		 */
		public static function secondsToString(seconds:Number, delimiter:String = ':'):String 
		{
			return StringUtils.padLeft(Math.floor(seconds / 60).toString(), 2, "0") + delimiter + StringUtils.padLeft(Math.floor(seconds % 60).toString(), 2, "0");
		}

		/**
		 * Format milliseconds as mm:ss.mmm 
		 */
		public static function formatTime(milliseconds:Number, delimiter:String = ':'):String
		{
			return StringUtils.padLeft(Math.floor(milliseconds / 60000).toString(), 2, "0") + delimiter + StringUtils.padLeft((Math.floor(milliseconds * .001) % 60).toString(), 2, "0") + '.' + StringUtils.padLeft((Math.round(Math.floor(milliseconds % 1000))).toString(), 3, "0");
		}

		/**
		 * Format milliseconds as mm:ss
		 * 
		 * @includeExample TimeUtilsExample.as
		 */
		public static function formatMinutesSeconds(milliseconds:Number, delimiter:String = ':'):String
		{
			return StringUtils.padLeft(Math.floor(milliseconds / (60000)).toString(), 2, "0") + delimiter + StringUtils.padLeft((Math.floor(milliseconds / 1000) % 60).toString(), 2, "0");
		}

		/**
		 * Format milliseconds as m:ss
		 * 
		 * @includeExample TimeUtilsExample.as
		 */
		public static function formatMinutesSecondsAlt(milliseconds:Number, delimiter:String = ':'):String
		{
			return (Math.floor(milliseconds / 60000)).toString() + delimiter + StringUtils.padLeft((Math.floor(milliseconds / 1000) % 60).toString(), 2, "0");
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(TimeUtils);
		}
	}
}
