/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
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
	import temple.utils.types.DateUtils;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	
	/**
	 * SimpleDateFormat is a class for formatting and parsing dates in a locale-sensitive manner.
	 * It allows for formatting (date -> text), parsing (text -> date), and normalization.
	 * 
	 * @see http://docs.oracle.com/javase/1.4.2/docs/api/java/text/SimpleDateFormat.html
	 * 
	 * @author Thijs Broerse
	 */
	public final class SimpleDateFormat
	{
		private static const _SUPPORTED_CHARACTERS:String = 
		"G" + // Era designator: AD
		"y" + // Year: 1996; 96
		"M" + // Month in year:	July; Jul; 07
		"w" + // Week in year: 27
		"W" + // Week in month:	2
		"D" + // Day in year: 189
		"d" + // Day in month: 10
		"F" + // Day of week in month: 2
		"E" + // Day in week: Tuesday; Tue
		"a" + // Am/pm marker: PM
		"H" + // Hour in day (0-23): 0
		"k" + // Hour in day (1-24): 24
		"K" + // Hour in am/pm (0-11): 0
		"h" + // Hour in am/pm (1-12): 12
		"m" + // Minute in hour: 30
		"s" + // Second in minute: 55
		"S" + // Millisecond: 978 
		// TODO: "z" + // Time zone, General time zone: Pacific Standard Time; PST; GMT-08:00 
		// TODO: "Z" + // Time zone, RFC 822 time zone: -0800
		"";
		
		private static const _TEMP_QUOTE_SIGN:String = "<<<Q>>>";

		private static var _regExp:RegExp;
		
		public static function format(date:Date, pattern:String):String
		{
			// replace quotes for a temperary sign, so we can replace it back later
			pattern = pattern.split("''").join(_TEMP_QUOTE_SIGN);
			
			// temperary store all quoted texts and replace with a place holder
			var temp:Array = [];
			pattern = pattern.replace(/'(.*?)'/gm, function ():String { return "<<<" + (temp.push(arguments[1])-1) + ">>>"; });
			
			pattern = pattern.replace(SimpleDateFormat._regExp ||= SimpleDateFormat.createRegExp(),
				function ():*
				{
					var hours:uint;
					
					switch (arguments[0])
					{
						case 'a':
						case 'aa':
						case 'aaa':
							return DateUtils.getAMPM(date);

						case 'd':
							return date.date;
						case 'dd':
							return date.date < 10 ? "0" + date.date : date.date;
						
						case 'E':
							return DateUtils.getWeekDayAsText(date);
						case 'EEE':
							return DateUtils.getWeekDayAsText(date).substr(0, 3);
						case 'EEEE':
						case 'EEEEE':
							return DateUtils.getWeekDayAsText(date);
							
						case 'G':
						case 'GG':
						case 'GGG':
							return date.fullYear < 0 ? 'BC' : 'AD';
						
						case 'H':
							return date.hours;
						case 'HH':
							return date.hours < 10 ? "0" + date.hours : date.hours;

						case 'h':
							hours = date.hours % 12;
							return hours == 0 ? 12 : hours;
						case 'hh':
							hours = date.hours % 12;
							return hours == 0 ? 12 : (hours < 10 ? "0" + hours : hours);

						case 'K':
							return date.hours % 12;
						case 'KK':
							hours = date.hours % 12;
							return hours < 10 ? "0" + hours : hours;

						case 'k':
							return date.hours == 0 ? 24 : date.hours;
						case 'kk':
							return date.hours == 0 ? 24 : (date.hours < 10 ? "0" + date.hours : date.hours);

						case 'M':
							return date.month + 1;
						case 'MM':
							return date.month < 9 ? "0" + (date.month + 1) : date.month + 1;
						case 'MMM':
							return DateUtils.getShortMonthName(date.month);
						case 'MMMM':
						case 'MMMMM':
						case 'MMMMMM':
						case 'MMMMMMM':
							return DateUtils.getMonthName(date.month);

						case 'm':
							return date.minutes;
						case 'mm':
							return date.minutes < 9 ? "0" + date.minutes : date.minutes;

						case 's':
							return date.seconds;
						case 'ss':
							return date.seconds < 9 ? "0" + date.seconds : date.seconds;

						case 'S':
							return date.milliseconds;
						case 'SS':
							return date.milliseconds < 9 ? "0" + date.milliseconds : date.milliseconds;
						
						case 'w':
							return DateUtils.getWeekOfYear(date);
						case 'ww':
							var week:uint = DateUtils.getWeekOfYear(date);
							return week < 10 ? "0" + week : week;
						
						case 'yy':
							return DateUtils.getShortYear(date);
						case 'yyyy':
							return date.fullYear;
						case 'yyyyy':
							return "0" + date.fullYear;
						
					}
					
					Log.error("Unsupported pattern '" + arguments[0] + "'", SimpleDateFormat);
					
					return arguments[0];
				}
			);
			
			pattern = pattern.replace(/<<<([0-9]+)>>>/gm, function ():String { return temp[arguments[1]]; });
			
			pattern = pattern.split(_TEMP_QUOTE_SIGN).join("'");
			
			return pattern;
		}

		private static function createRegExp():RegExp
		{
			var pattern:String = "";
			for (var i:int = 0, leni:int = _SUPPORTED_CHARACTERS.length; i < leni; i++)
			{
				pattern += (i ? "|" : "") + "(" + _SUPPORTED_CHARACTERS.charAt(i) + "+)";
			}
			return new RegExp(pattern, "gm");
		}
		
		/**
		 * @private
		 */
		public static function toString():String 
		{
			return objectToString(SimpleDateFormat);
		}
	}
}
