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

package temple.utils.localization
{
	/**
	 * @author Thijs Broerse
	 */
	public interface IDateLabels
	{
		/**
		 * Labels for every day of the week, like 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
		 * A week starts on Sunday
		 */
		function get fullDays():Vector.<String>;
		
		/**
		 * Short version for every day of the week, like 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
		 */
		function get shortDays():Vector.<String>;
		
		/**
		 * Label for a day of the week, like 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday' or 'Saturday'.
		 * A week starts on Sunday
		 */
		function getDay(index:int, format:DateLabelFormat = null):String;
		
		/**
		 * Label for a day of the week, like 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday' or 'Saturday'.
		 * A week starts on Sunday
		 */
		function getFullDay(index:int):String;
		
		/**
		 * Short version for a day of the week, like 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri' or 'Sat'
		 * A week starts on Sunday
		 */
		function getShortDay(index:int):String;
		
		/**
		 * Labels for every month, like 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'.
		 */
		function get fullMonths():Vector.<String>;
		
		/**
		 * Short version for every month, like 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'.
		 */
		function get shortMonths():Vector.<String>;
		
		/**
		 * Label for a month, like 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November' or 'December'.
		 * Zero based!
		 */
		function getMonth(index:int, format:DateLabelFormat = null):String;
		
		/**
		 * Label for a month, like 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November' or 'December'.
		 * Zero based!
		 */
		function getFullMonth(index:int):String;
		
		/**
		 * Short version for a month, like 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov' or 'Dec'.
		 * Zero based!
		 */
		function getShortMonth(index:int):String;
		
		/**
		 * Default DateLabelFormat
		 */
		function get format():DateLabelFormat;
		
		/**
		 * @private
		 */
		function set format(value:DateLabelFormat):void;
	}
}
