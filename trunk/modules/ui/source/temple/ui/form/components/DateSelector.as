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

package temple.ui.form.components 
{
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.IResettable;
	import temple.ui.form.validation.IHasError;
	import temple.utils.localization.DateLabelFormat;
	import temple.utils.localization.EnglishDateLabels;
	import temple.utils.localization.IDateLabels;

	/**
	 * Input for Date. The date can be selected from <code>Comboxes</code>.
	 * 
	 * @author Thijs Broerse
	 */
	public class DateSelector extends DateInputField implements IHasValue, IHasError, IResettable 
	{
		private var _dayFormat:DateLabelFormat;
		private var _monthFormat:DateLabelFormat = DateLabelFormat.NUMERIC;
		private var _monthLabels:IDateLabels = EnglishDateLabels;
		private var _yearFormat:DateLabelFormat;
		
		public function DateSelector(begin:Date = null, end:Date = null, day:InputField = null, month:InputField = null, year:InputField = null)
		{
			begin ||= new Date(1900, 0, 1);
			end ||= new Date();
			
			super(begin, end, day, month, year);
		}

		/**
		 * @private
		 */
		override public function set day(value:InputField):void
		{
			super.day = value;
			
			if (day is ComboBox)
			{
				ComboBox(day).removeAll();
				for (var i:int = 1;i <= 31; i++) ComboBox(day).addItem(i);
			}
		}
		
		/**
		 * @private
		 */
		override public function set month(value:InputField):void
		{
			super.month = value;
			
			if (month is ComboBox)
			{
				ComboBox(month).removeAll();
				for (var i:int = 1;i <= 12; i++) ComboBox(month).addItem(i);
				monthFormat = _monthFormat;
			}
		}

		/**
		 * @private
		 */
		override public function set year(value:InputField):void
		{
			super.year = value;
			
			if (year is ComboBox)
			{
				setDateRange(begin, end);
			}
		}
		
		/**
		 * The format of the day in de day selector. If this value is set to DateLabelFormat.FULL or
		 * DateLabelFormat.NUMERIC_LEADING_ZERO a leading zero will be added for labels lower than 10. 
		 */
		public function get dayFormat():DateLabelFormat
		{
			return _dayFormat;
		}

		/**
		 * @private
		 */
		public function set dayFormat(value:DateLabelFormat):void
		{
			_dayFormat = value;
			
			if (day is ComboBox)
			{
				var leadingZero:Boolean = _dayFormat == DateLabelFormat.FULL || DateLabelFormat.NUMERIC_LEADING_ZERO;
				
				for (var i:int = 30; i >= 0 ; --i)
				{
					ComboBox(day).setLabelAt(i, (leadingZero && i < 9 ? "0" : "") + (i + 1).toString());
				}
			}
		}

		/**
		 * The format of the month in de month selector
		 */
		public function get monthFormat():DateLabelFormat
		{
			return _monthFormat;
		}

		/**
		 * @private
		 */
		public function set monthFormat(value:DateLabelFormat):void
		{
			_monthFormat = value;
			
			if (month is ComboBox)
			{
				for (var i:int = 11; i >= 0 ; --i)
				{
					ComboBox(month).setLabelAt(i, _monthLabels ? _monthLabels.getMonth(i, _monthFormat) : (i + 1).toString());
				}
			}
		}
		
		/**
		 * IDateLabels object for localization of the month labels
		 */
		public function get monthLabels():IDateLabels
		{
			return _monthLabels;
		}

		/**
		 * @private
		 */
		public function set monthLabels(value:IDateLabels):void
		{
			_monthLabels = value;
			if (_monthLabels && (_monthFormat == DateLabelFormat.FULL || _monthFormat == DateLabelFormat.SHORT)) monthFormat = _monthFormat;
		}
		
		/**
		 * The format of the year in de year selector. If this value is set to DateLabelFormat.FULL or
		 * DateLabelFormat.NUMERIC_LEADING_ZERO a leading zero will be added for labels lower than 10. 
		 */
		public function get yearFormat():DateLabelFormat
		{
			return _yearFormat;
		}

		/**
		 * @private
		 */
		public function set yearFormat(value:DateLabelFormat):void
		{
			_yearFormat = value;
			
			if (year is ComboBox)
			{
				for (var i:int = ComboBox(year).length - 1; i >= 0 ; --i)
				{
					ComboBox(year).setLabelAt(i, getYearLabel(ComboBox(year).getItemAt(i)));
				}
			}
		}
		
		
		/**
		 * @private
		 */
		override public function set begin(value:Date):void
		{
			setDateRange(value, end);
		}
		
		/**
		 * @private
		 */
		override public function set end(value:Date):void
		{
			setDateRange(begin, value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setDateRange(begin:Date, end:Date):void
		{
			var date:Date = date;
			super.setDateRange(begin, end);
			
			if (begin && end && year is ComboBox)
			{
				ComboBox(year).removeAll();
				
				var i:int;
				
				if (begin < end)
				{
					for (i = begin.fullYear; i <= end.fullYear; i++) ComboBox(year).addItem(i, getYearLabel(i));
				}
				else
				{
					for (i = begin.fullYear; i >= end.fullYear; i--) ComboBox(year).addItem(i, getYearLabel(i));
				}
				if (date) year.value = date.getFullYear();
			}
		}
		
		private function getYearLabel(year:int):String
		{
			switch (_yearFormat)
			{
				case DateLabelFormat.SHORT:
				{
					return year.toString().substr(2);
				}
				default:
				{
					return year.toString();
				}
			}
		}


		/**
		 * The number of rows that are at least partially visible in the list.
		 */
		public function get rowCount():uint
		{
			return ComboBox(day).rowCount;
		}

		/**
		 * The number of rows that are at least partially visible in the list.
		 */
		public function set rowCount(value:uint):void
		{
			ComboBox(day).rowCount = value;
			ComboBox(month).rowCount = value;
			ComboBox(year).rowCount = value;
		}


		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_monthFormat = null;
			
			super.destruct();
		}
	}
}
