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
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.utils.TimeUnit;

	/**
	 * This class contains some functions for Dates.
	 * 
	 * @author Thijs Broerse
	 */
	public final class DateUtils 
	{
		public static const WEEKDAYS_NL:Array = ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'];
		public static const WEEKDAYS_EN:Array = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

		public static const WEEKDAYS_SHORT_NL:Array = ['Zo', 'Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za'];
		public static const WEEKDAYS_SHORT_EN:Array = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

		public static const MONTHS_NL:Array = ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'];
		public static const MONTHS_EN:Array = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
		
		public static var WEEKDAYS:Array = DateUtils.WEEKDAYS_EN;
		public static var WEEKDAYS_SHORT:Array = DateUtils.WEEKDAYS_SHORT_EN;
		public static var MONTHS:Array = DateUtils.MONTHS_EN;
		
		public static const DAYS_IN_JANUARY:int = 31;
		public static const DAYS_IN_FEBRUARY:int = 28;
		public static const DAYS_IN_FEBRUARY_LEAP_YEAR:int = 29;
		public static const DAYS_IN_MARCH:int = 31;
		public static const DAYS_IN_APRIL:int = 30;
		public static const DAYS_IN_MAY:int = 31;
		public static const DAYS_IN_JUNE:int = 30;
		public static const DAYS_IN_JULY:int = 31;
		public static const DAYS_IN_AUGUST:int = 31;
		public static const DAYS_IN_SEPTEMBER:int = 30;
		public static const DAYS_IN_OCTOBER:int = 31;
		public static const DAYS_IN_NOVEMBER:int = 30;
		public static const DAYS_IN_DECEMBER:int = 31;
		public static const DAYS_IN_YEAR:int = 365;
		public static const DAYS_IN_LEAP_YEAR:int = 366;
		
		private static const _MONTHS_TO_INTEGERS:Object = {January:0,February:1,March:2,April:3,May:4,June:5,July:6,August:7,September:8,October:9,November:10,December:11,Jan:0,Feb:1,Mar:2,Apr:3,May:4,Jun:5,Jul:6,Aug:7,Sep:8,Oct:9,Nov:10,Dec:11};
	
		/**
		 * Set language to Dutch
		 */
		public static function setDutch():void
		{
			DateUtils.WEEKDAYS = DateUtils.WEEKDAYS_NL;
			DateUtils.WEEKDAYS_SHORT = DateUtils.WEEKDAYS_SHORT_NL;
			DateUtils.MONTHS = DateUtils.MONTHS_NL;
		}

		/**
		 * The number of days appearing in each month. May be used for easy index lookups.
		 * The stored value for February corresponds to a standard year--not a leap year.
		 */
		public static const DAYS_IN_MONTHS:Array = [DAYS_IN_JANUARY, DAYS_IN_FEBRUARY, DAYS_IN_MARCH, DAYS_IN_APRIL,DAYS_IN_MAY, DAYS_IN_JUNE, DAYS_IN_JULY, DAYS_IN_AUGUST, DAYS_IN_SEPTEMBER,DAYS_IN_OCTOBER, DAYS_IN_NOVEMBER, DAYS_IN_DECEMBER];
		
		/**
		 * timezone abbrevitation
		 */
		private static const _TIMEZONES:Array = new Array("IDLW", "NT", "HST", "AKST", "PST", "MST", "CST", "EST", "AST", "ADT", "AT", "WAT", "GMT", "CET", "EET", "MSK", "ZP4", "ZP5", "ZP6", "WAST", "WST", "JST", "AEST", "AEDT", "NZST");

		/**
		 * array to transform the format 0(sun)-6(sat) to 1(mon)-7(sun)
		 */
		private static const _MONDAY_STARTING_WEEK:Array = new Array(7, 1, 2, 3, 4, 5, 6);
		
		/**
		 * Parse a SQL-DATETIME (YYYY-MM-DD HH:MM:SS) to a Date
		 * @param dateTime an SQL-DATETIME (YYYY-MM-DD HH:MM:SS)
		 * @return null of dateTime is null or the date is invalid
		 */
		public static function parseFromSqlDateTime(dateTime:String):Date
		{
			if (dateTime == null)
			{
				return null;
			}
			var date:Date = new Date(Date.parse(dateTime.split('-').join('/')));
			
			if (date.toString() == 'Invalid Date')
			{
				return null;
			}
			else
			{
				return date;
			}
		}
		
		/**
		 * Try to convert a value to a date
		 */
		public static function convertToDate(value:*):Date
		{
			if (value is Number)
			{
				// The backend value is based in seconds
				return new Date((value as Number) * 1000);
			}
			else if (value is String)
			{
				// The date string is empty so return null
				if (value == "" || value == '0000-00-00 00:00:00')
				{
					return null;
				}
				else
				{
					return DateUtils.parseFromSqlDateTime(value);
				}
			}
			else if (value is Date)
			{
				// If it is a Date, just return it (for internal use).
				return value as Date;
			}
			
			return null;
		}
		
		/**
		 * Convert a Date to a SQL-DATETIME (YYYY-MM-DD HH:MM:SS)
		 */
		public static function toSqlDateTime(date:Date):String
		{
			return DateUtils.format('Y-m-d H:i:s', date);
		}
		
		/**
		 *	Returns a two digit representation of the year represented by the 
		 *	specified date.
		 * 
		 * 	@param date The Date instance whose year will be used to generate a two
		 *	digit string representation of the year.
		 * 
		 * 	@return A string that contains a 2 digit representation of the year.
		 *	Single digits will be padded with 0.
		 */	
		public static function getShortYear(date:Date):String
		{
			var string:String = String(date.getFullYear());
			
			if (string.length < 3)
			{
				return string;
			}

			return (string.substr(string.length - 2));
		}

		/**
		 *	Compares two dates and returns an integer depending on their relationship.
		 *
		 *	Returns -1 if d1 is greater than d2.
		 *	Returns 1 if d2 is greater than d1.
		 *	Returns 0 if both dates are equal.
		 * 
		 * 	@param d1 The date that will be compared to the second date.
		 *	@param d2 The date that will be compared to the first date.
		 * 
		 * 	@return An int indicating how the two dates compare.
		 */	
		public static function compareDates(date1:Date, date2:Date):int
		{
			var d1ms:Number = date1.getTime();
			var d2ms:Number = date2.getTime();
			
			if (d1ms > d2ms)
			{
				return -1;
			}
			else if (d1ms < d2ms)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}

		/**
		 *	Returns a short hour (0 - 12) represented by the specified date.
		 *
		 *	If the hour is less than 12 (0 - 11 AM) then the hour will be returned.
		 *
		 *	If the hour is greater than 12 (12 - 23 PM) then the hour minus 12
		 *	will be returned.
		 * 
		 * 	@param date The Date from which to generate the short hour
		 * 
		 * 	@return An int between 0 and 13 ( 1 - 12 ) representing the short hour.
		 */	
		public static function getShortHour(date:Date):int
		{
			var h:int = date.hours;
			
			if (h == 0 || h == 12)
			{
				return 12;
			}
			else if (h > 12)
			{
				return h - 12;
			}
			else
			{
				return h;
			}
		}

		/**
		 *	Returns a string indicating whether the date represents a time in the
		 *	ante meridiem (AM) or post meridiem (PM).
		 *
		 *	If the hour is less than 12 then "AM" will be returned.
		 *
		 *	If the hour is greater than 12 then "PM" will be returned.
		 * 
		 * 	@param date The Date from which to generate the 12 hour clock indicator.
		 * 
		 * 	@return A String ("AM" or "PM") indicating which half of the day the 
		 *	hour represents.
		 */	
		public static function getAMPM(date:Date):String
		{
			return (date.hours > 11) ? "PM" : "AM";
		}

		
		/**
		 * Parses dates that conform to the W3C Date-time Format into Date objects.
		 * This function is useful for parsing RSS 1.0 and Atom 1.0 dates.
		 *
		 * @param string
		 *
		 * @return a Date
		 *
		 * @see http://www.w3.org/TR/NOTE-datetime
		 */		     
		public static function parseW3CDTF(string:String):Date
		{
			var finalDate:Date;
			try
			{
				var dateStr:String = string.substring(0, string.indexOf("T"));
				var timeStr:String = string.substring(string.indexOf("T") + 1, string.length);
				var dateArr:Array = dateStr.split("-");
				var year:Number = Number(dateArr.shift());
				var month:Number = Number(dateArr.shift());
				var date:Number = Number(dateArr.shift());
				
				var multiplier:Number;
				var offsetHours:Number;
				var offsetMinutes:Number;
				var offsetStr:String;
				
				if (timeStr.indexOf("Z") != -1)
				{
					multiplier = 1;
					offsetHours = 0;
					offsetMinutes = 0;
					timeStr = timeStr.replace("Z", "");
				}
				else if (timeStr.indexOf("+") != -1)
				{
					multiplier = 1;
					offsetStr = timeStr.substring(timeStr.indexOf("+") + 1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("+"));
				}
				else // offset is -
				{
					multiplier = -1;
					offsetStr = timeStr.substring(timeStr.indexOf("-") + 1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("-"));
				}
				var timeArr:Array = timeStr.split(":");
				var hour:Number = Number(timeArr.shift());
				var minutes:Number = Number(timeArr.shift());
				var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
				var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var utc:Number = Date.UTC(year, month - 1, date, hour, minutes, seconds, milliseconds);
				var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
				finalDate = new Date(utc - offset);
	
				if (finalDate.toString() == "Invalid Date")
				{
					throwError(new TempleError(DateUtils, "This date does not conform to W3CDTF."));
				}
			}
			catch (e:Error)
			{
				var eStr:String = "Unable to parse the string [" + string + "] into a date. ";
				eStr += "The internal error was: " + e.message;
				throwError(new TempleError(DateUtils, eStr));
			}
			return finalDate;
		}

		/**
		 * Returns a date string formatted according to W3CDTF.
		 *
		 * @param d
		 * @param includeMilliseconds Determines whether to include the
		 * milliseconds value (if any) in the formatted string.
		 *
		 * @returns
		 *
		 * @see http://www.w3.org/TR/NOTE-datetime
		 */		     
		public static function toW3CDTF(d:Date,includeMilliseconds:Boolean = false):String
		{
			var date:Number = d.getUTCDate();
			var month:Number = d.getUTCMonth();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var milliseconds:Number = d.getUTCMilliseconds();
			var sb:String = new String();
			
			sb += d.getUTCFullYear();
			sb += "-";
			
			//thanks to "dom" who sent in a fix for the line below
			if (month + 1 < 10)
			{
				sb += "0";
			}
			sb += month + 1;
			sb += "-";
			if (date < 10)
			{
				sb += "0";
			}
			sb += date;
			sb += "T";
			if (hours < 10)
			{
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10)
			{
				sb += "0";
			}
			sb += seconds;
			if (includeMilliseconds && milliseconds > 0)
			{
				sb += ".";
				sb += milliseconds;
			}
			sb += "-00:00";
			return sb;
		}

		/**
		 * Determines the number of days between the start value and the end value. The result
		 * may contain a fractional part, so cast it to int if a whole number is desired.
		 * 
		 * @param start	the starting date of the range
		 * @param end the ending date of the range
		 * @return the number of dats between start and end
		 */
		public static function countDays(start:Date, end:Date):Number
		{
			return Math.abs(end.valueOf() - start.valueOf()) / (1000 * 60 * 60 * 24);
		}

		/**
		 * Determines if the input year is a leap year (with 366 days, rather than 365).
		 * 
		 * @param year the year value as stored in a Date object.
		 * @return true if the year input is a leap year
		 */
		public static function isLeapYear(year:int):Boolean
		{
			if (year % 100 == 0) return year % 400 == 0;
			return year % 4 == 0;
		}

		/**
		 * Gets the English name of the month specified by index. This is the month value
		 * as stored in a Date object.
		 * 
		 * @param		index	the numeric value of the month
		 * @return		the string name of the month in English
		 */
		public static function getMonthName(index:int):String
		{
			return DateUtils.MONTHS[index];
		}

		/**
		 * Gets the abbreviated month name specified by index. This is the month value
		 * as stored in a Date object.
		 * 
		 * @param index	the numeric value of the month
		 * @return the short string name of the month in English
		 */
		public static function getShortMonthName(index:int):String
		{
			return DateUtils.getMonthName(index).substr(0, 3);
		}

		/**
		 * Rounds a Date value up to the nearest value on the specified time unit.
		 * 
		 * @see temple.utils.TimeUnit
		 */
		public static function roundUp(dateToRound:Date, timeUnit:String = "day"):Date
		{
			dateToRound = new Date(dateToRound.valueOf());
			switch (timeUnit)
			{
				case TimeUnit.YEAR:
				{
					dateToRound.fullYear++;
					dateToRound.month = 0;
					dateToRound.date = 1;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.MONTH:
				{
					dateToRound.month++;
					dateToRound.date = 1;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.DAY:
				{
					dateToRound.date++;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.HOURS:
				{
					dateToRound.hours++;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.MINUTES:
				{
					dateToRound.minutes++;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.SECONDS:
				{
					dateToRound.seconds++;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.MILLISECONDS:
				{
					dateToRound.milliseconds++;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(DateUtils, "roundUp: unknown time unit '" + timeUnit + "'"));
					break;
				}
			}
			return dateToRound;
		}

		/**
		 * Rounds a Date value down to the nearest value on the specified time unit.
		 * 
		 * @see temple.utils.TimeUnit
		 */
		public static function roundDown(dateToRound:Date, timeUnit:String = "day"):Date
		{
			dateToRound = new Date(dateToRound.valueOf());
			switch (timeUnit)
			{
				case TimeUnit.YEAR:
				{
					dateToRound.month = 0;
					dateToRound.date = 1;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.MONTH:
				{
					dateToRound.date = 1;
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.DAY:
				{
					dateToRound.hours = 0;
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.HOURS:
				{
					dateToRound.minutes = 0;
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.MINUTES:
				{
					dateToRound.seconds = 0;
					dateToRound.milliseconds = 0;
					break;
				}
				case TimeUnit.SECONDS:
				{
					dateToRound.milliseconds = 0;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(DateUtils, "roundUp: unknown time unit '" + timeUnit + "'"));
					break;
				}
			}
			return dateToRound;
		}

		/**
		 * Converts a time code to UTC.
		 * 
		 * @param timecode	the input timecode
		 * @return	the UTC value
		 */
		public static function timeCodeToUTC(timecode:String):String 
		{
			switch (timecode) 
			{
				case "GMT":
				case "UT":
				case "UTC":
				case "WET":	
					return "UTC+0000";
				case "CET": 
					return "UTC+0100";
				case "EET": 
					return "UTC+0200";
				case "MSK": 
					return "UTC+0300";
				case "IRT": 
					return "UTC+0330";
				case "SAMT": 
					return "UTC+0400";
				case "YEKT":
				case "TMT":
				case "TJT":	
					return "UTC+0500";
				case "OMST":
				case "NOVT":
				case "LKT": 
					return "UTC+0600";
				case "MMT": 
					return "UTC+0630";
				case "KRAT":
				case "ICT":
				case "WIT":
				case "WAST": 
					return "UTC+0700";
				case "IRKT":
				case "ULAT":
				case "CST":
				case "CIT":
				case "BNT": 
					return "UTC+0800";
				case "YAKT":
				case "JST":
				case "KST":
				case "EIT": 
					return "UTC+0900";
				case "ACST": 
					return "UTC+0930";
				case "VLAT":
				case "SAKT":
				case "GST": 
					return "UTC+1000";
				case "MAGT": 
					return "UTC+1100";
				case "IDLE":
				case "PETT":
				case "NZST": 
					return "UTC+1200";
				case "WAT": 
					return "UTC-0100";
				case "AT": 
					return "UTC-0200";
				case "EBT": 
					return "UTC-0300";
				case "NT": 
					return "UTC-0330";
				case "WBT":
				case "AST": 
					return "UTC-0400";
				case "EST": 
					return "UTC-0500";
				case "CST": 
					return "UTC-0600";
				case "MST": 
					return "UTC-0700";
				case "PST": 
					return "UTC-0800";
				case "YST": 
					return "UTC-0900";
				case "AHST":
				case "CAT":
				case "HST": 
					return "UTC-1000";
				case "NT": 
					return "UTC-1100";
				case "IDLW": 
					return "UTC-1200";
			}
			return "UTC+0000";
		}
		
		public static function isSameDay(compare:Date, to:Date):Boolean
		{
			if (compare.getFullYear() != to.getFullYear()) return false;
			if (compare.getMonth() != to.getMonth()) return false;
			if (compare.getDate() != to.getDate()) return false;
			return true;
		}

		/**
		 * Determines the hours value in the range 1 - 12 for the AM/PM time format.
		 * 
		 * @param value the input Date value
		 * @return the calculated hours value
		 */
		public static function getHoursIn12HourFormat(value:Date):Number
		{
			var hours:Number = value.getHours();
			if (hours == 0)
			{
				return 12;
			}
			
			if (hours > 0 && hours <= 12)
			{
				return hours;
			}
			
			return hours - 12;
		}
		
		/**
		 * Calculate the age
		 * @param birthdate the birthdate to calculate the age for
		 * @param on optional date on which the age is calculated. If null, the current date is used.  
		 */
		public static function age(birthdate:Date, on:Date = null):int
		{
			on ||= new Date();
			var age:int = on.fullYear - birthdate.fullYear;
			
			if (birthdate.month < on.month) return age;
			if (birthdate.month > on.month) return age-1;
			if (birthdate.date <= on.date) return age;
			return age- 1;
		}
		
		/**
		 * Checks if a date is the same as or older then a given years
		 */
		public static function ageCheck(date:Date, years:int):Boolean
		{
			return DateUtils.age(date) >= years;
		}
		
		/**
		 * Formats a Date to a String by using the PHP syntax for formating.
		 * 
		 * @see http://www.php.net/date
		 *
		 * @param String the format pattern
		 * @param Integer the unix-timestamp, optional 
		 * @return the new formated date string
		 * 
		 * @includeExample DateFormatExample.as
		 */
		public static function format(format:String, date:* = null):String
		{
			var d:Date;
			
			if (date is Date)
			{
				d = date as Date;
				
				if (isNaN(d.date))
				{
					// nvalid Date
					return d.toString();
				}
			}
			else if (date is int)
			{
				var unixTimestamp:int = date as int;
				d = new Date(unixTimestamp * 1000);
			}
			else if (date == null)
			{
				d = new Date();
			}
			else
			{
				throwError(new TempleArgumentError(DateUtils, "Invalid value for date: '" + date + "'"));
			}
			
			return DateUtils.parseFormatString(d, format);
		}

		/**
		 * Split the format string into pieces and parse it.
		 * 
		 * @param String the full format String
		 * @return String
		 */
		private static function parseFormatString(date:Date, format:String ):String
		{
			var result:String = "";
			
			// Iterating over all chars
			var leni:int = format.length;
			for (var i:int = 0; i < leni; i++)
			{
				/**
				 * check if the current char was escaped. If true, don't parse it.
				 */
				if (format.charAt(i) == "\\")
				{
					// escape char, skip this
				}
				else if (i == 0 || format.charAt(i - 1) != "\\")
				{
					result += DateUtils.parseSingleChar(date, format.charAt(i));
				}
				else
				{
					result += format.charAt(i);
				}
			}
							
			return result;
		}

		/**
		 * Parses a single char.
		 * 
		 * @param char single char of a format string
		 * @return String
		 */
		private static function parseSingleChar(date:Date, char:String):String
		{
			if (!char || char.length != 1) throwError(new TempleArgumentError(DateUtils, "char must be a single char"));
			
			switch (char)
			{
				case 'a': return DateUtils.getAmPm(date);
				case 'A': return DateUtils.getAmPm(date, true);
				case 'B': return DateUtils.getSwatchInternetTime(date);
				case 'c': return DateUtils.getIso8601(date);
				case 'd': return DateUtils.getDayOfMonth(date);
				case 'D': return DateUtils.getWeekDayAsText(date, true);
				case 'F': return DateUtils.getMonthAsText(date);
				case 'g': return DateUtils.getHours(date, false, true);
				case 'G': return DateUtils.getHours(date, false);
				case 'h': return DateUtils.getHours(date, true, true);
				case 'H': return DateUtils.getHours(date);
				case 'i': return DateUtils.getMinutes(date);
				case 'I': return DateUtils.getSummertime(date);
				case 'j': return DateUtils.getDayOfMonth(date, false);
				case 'l': return DateUtils.getWeekDayAsText(date);
				case 'L': return DateUtils.getLeapYear(date);
				case 'm': return DateUtils.getMonth(date);
				case 'M': return DateUtils.getMonthAsText(date, true);
				case 'n': return DateUtils.getMonth(date, false);
				case 'N': return DateUtils.getIso8601Day(date);
				case 'O': return DateUtils.getDifferenceBetweenGmt(date);
				case 'P': return DateUtils.getDifferenceBetweenGmt(date, ":");
				case 'r': return DateUtils.getRfc2822(date);
				case 's': return DateUtils.getSeconds(date);
				case 'S': return NumberUtils.ordinalSuffix(date.getDate());
				case 't': return String(DateUtils.getDaysOfMonth(date));
				case 'T': return DateUtils.getTimezone(date);
				case 'u': return DateUtils.getMilliseconds(date);
				case 'U': return DateUtils.getUnixTimestamp(date);
				case 'w': return DateUtils.getWeekDay(date);
				case 'W': return String(DateUtils.getWeekOfYear(date));
				case 'y': return DateUtils.getYear(date, true);
				case 'Y': return DateUtils.getYear(date);
				case 'z': return String(DateUtils.getDayOfYear(date));
				case 'Z': return DateUtils.getTimezoneOffset(date);
			}
			return char;
		}

		/**
		 * returns 1 if it is summertime, else 0
		 * 
		 * @return String
		 */
		private static function getSummertime(date:Date):String
		{
			if (isSummertime(date)) return "1";
			return "0";
		}

		/**
		 * check if the current date lays in summertime.
		 * 
		 * @return Boolean
		 */
		public static function isSummertime(date:Date):Boolean
		{
			var currentOffset:Number = date.getTimezoneOffset();
			var referenceOffset:Number;

			var month:Number = 1;
						
			while (month--) 
			{
				referenceOffset = (new Date(date.getFullYear(), month, 1)).getTimezoneOffset();
				
				if (currentOffset != referenceOffset && currentOffset < referenceOffset)
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * returns the unix timestamp( seconds since the 1st January 1970 )
		 * 
		 * @return String
		 */
		public static function getUnixTimestamp(date:Date):String
		{
			return String(Math.floor(date.getTime() * 0.001));
		}

		/**
		 * returns ISO8601 formated date, like 2008-05-22T19:15:21+02:00
		 * 
		 * @return String
		 */
		public static function getIso8601(date:Date):String
		{
			return DateUtils.getYear(date) + "-" + DateUtils.getMonth(date) + "-" + DateUtils.getDayOfMonth(date) + "T" + DateUtils.getHours(date) + ":" + DateUtils.getMinutes(date) + ":" + DateUtils.getSeconds(date) + DateUtils.getDifferenceBetweenGmt(date, ":");
		}

		private static function getIso8601Day(date:Date):String
		{
			return String(_MONDAY_STARTING_WEEK[date.getDay()]);
		}

		/**
		 * returns a RFC2822 formated date string,
		 * such as Tue, 25 Jan 1983 16:55:00 +0100
		 * 
		 * @return String
		 */
		public static function getRfc2822(date:Date):String
		{
			return DateUtils.getWeekDayAsText(date, true) + ", " + DateUtils.getDayOfMonth(date) + " " + DateUtils.getMonthAsText(date, true) + " " + DateUtils.getYear(date) + " " + DateUtils.getHours(date) + ":" + DateUtils.getMinutes(date) + ":" + DateUtils.getSeconds(date) + " " + DateUtils.getDifferenceBetweenGmt(date);
		}

		/**
		* Translate RFC2822 date strings (used in RSS) to timestamp.
		*
		* @param string Date string to be parsed.
		* @return Extracted timestamp.
		**/
		public static function parseRfc2822(string:String):Date
		{
			// Thu, 25 Feb 2010 15:49:25 +0100
			
			// split RFC2822 string
			var darr:Array = string.split(' ');
			
			// set all data for date
			var date:Number = parseInt(darr[1]);
			var month:Number = _MONTHS_TO_INTEGERS[darr[2]];
			var year:Number = parseInt(darr[3]);
			
			// also split time string
			var tarr:Array = darr[4].split(':');
			var hour:Number = parseInt(tarr[0]);
			var minute:Number  = parseInt(tarr[1]);
			var second:Number  = parseInt(tarr[2]);
			
			//TODO: timezone offset
			return new Date(year,month,date,hour,minute,second);
		}
		
		/**
		 * returns the current timezone abbrevitation (such as EST, GMT, ... )
		 * 
		 * @return String
		 */
		private static function getTimezone(date:Date):String
		{
			var offset:Number = Math.round(11 + -( date.getTimezoneOffset() / 60));
			
			if (DateUtils.isSummertime(date)) offset--;
				
			return DateUtils._TIMEZONES[offset];
		}

		/**
		 * returns the difference to the greenwich time (GMT), with optional 
		 * separtor between hours and minutes (such as +0200 or +02:00 )
		 * 
		 * @param String seperator 
		 * @return String
		 */
		private static function getDifferenceBetweenGmt(date:Date, seperator:String = ''):String
		{
			var timezoneOffset:Number = -date.getTimezoneOffset();
			
			//sets the prefix
			var pre:String;
			if (timezoneOffset > 0 )
			{
				pre = "+";
			}
			else
			{
				pre = "-";
			}
			var hours:Number = Math.floor(timezoneOffset / 60);
			var min:Number = timezoneOffset - ( hours * 60 );

			// building the return string			
			var result:String = pre;
			if (hours < 9 )
			{
				result += "0";
			}
			//adding leading zero to hours
			result += hours.toString();
			result += seperator;
			if (min < 9 )
			{
				result += "0";
			}
			//adding leading zero to minutes
			result += min;	
			
			return result;
		}

		/**
		 * returns the timezone offset in seconds( between -43200 - 50400 )
		 * 
		 * @return String
		 */
		private static function getTimezoneOffset(date:Date):String
		{
			return String(date.getTimezoneOffset() * 60);
		}

		/**
		 * number of days in the current month (such as 28-31)
		 */
		public static function getDaysOfMonth(date:Date):int
		{
			return new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
		}

		/**
		 * returns the beats of the swatch internet time
		 * 
		 * @return String
		 */
		private static function getSwatchInternetTime(date:Date):String
		{
			// get passed seconds for the day
			var daySeconds:int = (date.getUTCHours() * 3600) + (date.getUTCMinutes() * 60) + (date.getUTCSeconds()) + 3600; 
			// caused of the BMT Meridian
			
			// 1day = 1000 .beat ... 1 second = 0.01157 .beat 		
			return String(Math.round(daySeconds * 0.01157));
		}

		/**
		 * returns the month as text (such as Janury - December or Jan - Dec)
		 * 
		 * @param Boolean flag to get the short version of month, optional
		 * @return String 
		 */
		public static function getMonthAsText(date:Date, short:Boolean = false):String
		{
			if (short == true )	return DateUtils.getShortMonthName(date.month);	

			return DateUtils.getMonthName(date.month);	
		}

		/**
		 * returns the milliseconds (such as 415)
		 * 
		 * @return String
		 */
		private static function getMilliseconds(date:Date):String
		{
			return String(date.getMilliseconds());
		}

		/**
		 * return seconds (such as 0-59 or 00-59)
		 * 
		 * @param Flag to add leading zero, optional default = true
		 * @return String
		 */	
		private static function getSeconds(date:Date, leadingZero:Boolean = true):String
		{
			if (leadingZero == true && date.getSeconds() <= 9)
			{
				return "0" + date.getSeconds().toString();
			}
			return String(date.getSeconds());
		}

		/**
		 * returns the minutes (such as 0-59 or 00-59)
		 * 
		 * @param flag for adding a leading zero, optional default = true
		 * @return String
		 */
		private static function getMinutes(date:Date, leadingZero:Boolean = true ):String
		{
			if (leadingZero == true && date.getMinutes() <= 9)
			{
				return "0" + date.getMinutes().toString();
			}
			return String(date.getMinutes());
		}

		/**
		 * returns the hours in diffrent formats( such as 0-12, 00-12, 0-23, 00-23 )
		 * 
		 * @param Boolean switch to add a leading zero, optional
		 * @param Boolean switch to get in in 12h instead 24h, optional
		 * @return String
		 */
		private static function getHours(date:Date, leadingZero:Boolean = true, twelfHours:Boolean = false ):String
		{
			var hours:int = date.getHours();
			if (twelfHours == true )
			{
				hours = hours % 12;
			}
			
			if (leadingZero == true && hours <= 9 )
			{
				return "0" + hours.toString();
			}
			return String(hours);
		}

		/**
		 * returns am (ante meridiem) or pm (post meridiem)
		 * 
		 * @param Boolean flag to get an upper-case string
		 * @return String am or pm
		 * 
		 * TODO: double getAMPM
		 */
		public static function getAmPm(date:Date, upperCase:Boolean = false ):String
		{
			var result:String = "am";
			if (date.hours > 12 )
			{
				result = "pm";
			}
			
			if (upperCase == true )
			{
				return result.toUpperCase();
			}
			return result;			
		}

		/**
		 * returns the numeric weekday ( 0 Sunday - 6 Saturday )
		 * 
		 * @return String
		 */
		public static function getWeekDay(date:Date):String
		{
			return String(date.getDay());
		}

		/**
		 * returns the weekday in textual presentation (such as Monday or Mon)
		 * 
		 * @param Boolean flag to switch between short and long weekdays
		 * @return String
		 */
		public static function getWeekDayAsText(date:Date, short:Boolean = false ):String
		{
			if (short == true )
			{
				return String(DateUtils.WEEKDAYS_SHORT[date.getDay() ]);
			}
			return DateUtils.WEEKDAYS[date.getDay() ];
		}

		/**
		 * returns 1 if leap year, else 0 (as String)
		 * 
		 * return String
		 */
		private static function getLeapYear(date:Date):String
		{
			if (DateUtils.isLeapYear(date.getFullYear())) return "1";
			return "0";
		}
		
		/**
		 * Returns the number of the current week for the year, a week starts with monday
		 * 
		 * @return String
		 */
		public static function getWeekOfYear(date:Date):uint
		{
			//number of passed days
			var dayOfYear:uint = DateUtils.getDayOfYear(date);
			//january 1st of the current year
			var firstDay:Date = new Date(date.getFullYear(), 0, 1);
			
			// remove Days of the first and the current week to get the realy passed weeks
			var fullWeeks:uint = (dayOfYear - (DateUtils._MONDAY_STARTING_WEEK[date.getDay()] + (7 - DateUtils._MONDAY_STARTING_WEEK[ firstDay.getDay()])) ) / 7;  
			
			// the first week of this year only matters if it has more than 3 in the current year
			if (DateUtils._MONDAY_STARTING_WEEK[firstDay.getDay() ] <= 4) fullWeeks++;
			
			//adding the current week
			fullWeeks++;
			
			return fullWeeks;		
		}

		/**
		 * returns the day of the year, starting with 0 (0-365)
		 * 
		 * return String
		 */		
		public static function getDayOfYear(date:Date):uint
		{
			var firstDayOfYear:Date = new Date(date.getFullYear(), 0, 1);
			var millisecondsOffset:Number = date.getTime() - firstDayOfYear.getTime();
			return Math.floor(millisecondsOffset / 86400000);
		}

		/**
		 * returns the year (such as 2008 or 08)
		 * 
		 * @param Boolean flag to get the year as two digits
		 * @return String
		 */
		private static function getYear(date:Date, twoDigits:Boolean = false):String
		{
			if (twoDigits == true )
			{
				//cut the year for the last two digits and return it
				return String(date.getFullYear()).substr(2, 2);
			}
			return String(date.getFullYear());
		}

		/**
		 * returns the month (1-12 or 01-12), with optional leading zero
		 * 
		 * @param Boolean optional flag to add a leading zero
		 * @return String month (1-12 or 01-12)
		 */
		private static function getMonth(date:Date, leadingZero:Boolean = true ):String
		{
			var month:Number = date.getMonth() + 1;
			if (leadingZero == true && month <= 9 )
			{
				return "0" + String(month);
			}
			return String(month);
		}

		/**
		 * returns day of the month (1-31 or 01-31), with optional leading zero
		 * 
		 * @param Boolean optional flag to add a leading zero to the day 
		 * @return day of the month (1-31 or 01-31)
		 */
		private static function getDayOfMonth(date:Date, leadingZero:Boolean = true ):String
		{
			if (leadingZero == true && date.getDate() <= 9 )
			{
				return "0" + String(date.getDate());
			}
			return String(date.getDate());
		}
		
		/**
		 * Gets the next date in the week for the given time and day. Useful for weekly countdowns
		 * @param day The day for the countdown. 0 starts at sunday, so every monday at 20:00 is: getNextInWeekDatefor (1, 20);
		 * @param hours The hours of the time
		 * @param minutes The minutes of the time
		 * @param seconds The seconds of the time
		 */
		public static function getNextInWeekDateFor(day:int, hours:int, minutes:int = 0, seconds:int = 0):Date
		{
			var d:Date = new Date();
			var targetDate:Date = new Date(d.getFullYear(), d.getMonth(), d.getDate(), hours, minutes, seconds);
			if (targetDate.getDay() != day)
			{
				targetDate.setDate(targetDate.getDate() + (((day + 7) - targetDate.getDay()) % 7));
			}
			else if (d.time > targetDate.time)
			{
				targetDate.setDate(targetDate.getDate() + 7);
			}
			return targetDate;
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(DateUtils);
		}
	}
}
