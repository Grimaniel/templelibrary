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

package temple.facebook.data.vo
{
	import temple.core.CoreObject;
	import temple.facebook.data.vo.IFacebookDateData;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookDateData extends CoreObject implements IFacebookDateData
	{
		private var _year:Number;
		private var _month:Number;
		private var _day:Number;
		private var _date:Date;

		/**
		 * 
		 */
		public function FacebookDateData(value:*)
		{
			var a:Array;
			
			if (int(value) == value)
			{
				_date = new Date(1000 * value);
				_year = _date.getFullYear();
				_month = _date.getMonth();
				_day = _date.getDate();
			}
			else if (String(value).indexOf("/") != -1)
			{
				a = String(value).split("/");
				
				_year = a[2];
				_month = a[0] - 1;
				_day = a[1];
			}
			else if (String(value).indexOf("-") != -1)
			{
				a = String(value).split("-");
				_year = a[0];
				_month = a[1] - 1;
				_day = a[2];
			}
			
			if (!_date && !isNaN(_year) && !isNaN(_month) && !isNaN(_day))
			{
				_date = new Date(_year, _month, day);
			}
			
			toStringProps.push("year", "month", "day", "date");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get date():Date
		{
			return _date;
		}

		/**
		 * @inheritDoc
		 */
		public function get year():Number
		{
			return _year;
		}

		/**
		 * @inheritDoc
		 */
		public function get month():Number
		{
			return _month;
		}

		/**
		 * @inheritDoc
		 */
		public function get day():Number
		{
			return _day;
		}
	}
}
