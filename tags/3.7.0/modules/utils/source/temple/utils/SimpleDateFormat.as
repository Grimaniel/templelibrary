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
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.utils.localization.IDateLabels;
	import temple.utils.types.DateUtils;
	
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
		
		public static function format(date:Date, pattern:String, labels:IDateLabels):String
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
							return DateUtils.getDayName(date, labels);
						case 'EEE':
							return DateUtils.getShortDayName(date, labels);
						case 'EEEE':
						case 'EEEEE':
							return DateUtils.getDayName(date, labels);
							
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
							return DateUtils.getShortMonthName(date, labels);
						case 'MMMM':
						case 'MMMMM':
						case 'MMMMMM':
						case 'MMMMMMM':
							return DateUtils.getMonthName(date, labels);

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
