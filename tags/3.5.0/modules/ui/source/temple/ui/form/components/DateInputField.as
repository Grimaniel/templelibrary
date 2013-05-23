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
	import temple.ui.form.validation.rules.NullValidationRule;
	import temple.ui.form.validation.rules.Restrictions;
	import temple.utils.keys.KeyManager;
	import temple.utils.types.DateUtils;

	import flash.events.Event;

	/**
	 * Input for a date. The date is filled in with text.
	 * 
	 * @author Thijs Broerse
	 */
	public class DateInputField extends MultiElementComponent implements IHasValue, ISetValue
	{
		public static var DAY_FIELD_NAME:String = "mcDay";
		public static var MONTH_FIELD_NAME:String = "mcMonth";
		public static var YEAR_FIELD_NAME:String = "mcYear";
		
		private var _day:InputField;
		private var _month:InputField;
		private var _year:InputField;
		
		private var _format:String;
		private var _begin:Date;
		private var _end:Date;
		private var _submitOnChange:Boolean;
		
		public function DateInputField(begin:Date = null, end:Date = null, day:InputField = null, month:InputField = null, year:InputField = null)
		{
			_begin = begin;
			_end = end;
			
			this.day ||= day || getChildByName(DateInputField.DAY_FIELD_NAME) as InputField;
			this.month ||= month || getChildByName(DateInputField.MONTH_FIELD_NAME) as InputField;
			this.year ||= year || getChildByName(DateInputField.YEAR_FIELD_NAME) as InputField;
			
			if (!_day) logWarn("DateSelector: no field found with name 'day' or '" + DateInputField.DAY_FIELD_NAME + "'.");
			if (!_month) logWarn("DateSelector: no field found with name 'month' or '" + DateInputField.MONTH_FIELD_NAME + "'.");
			if (!_year) logWarn("DateSelector: no field found with name 'year' or '" + DateInputField.YEAR_FIELD_NAME + "'.");
			
			KeyManager.init(stage);
		}
		
		/**
		 * Set an InputField for day selection
		 */
		public function get day():InputField
		{
			return _day;
		}
		
		/**
		 * @private
		 */
		public function set day(value:InputField):void
		{
			if (_day)
			{
				_day.removeEventListener(Event.CHANGE, handleChange);
				removeElement(_day);
			}
			_day = value;
			if (_day)
			{
				_day.addEventListener(Event.CHANGE, handleChange);
				addElement(_day);
				_day.maxChars = 2;
				_day.restrict = Restrictions.INTEGERS;
			}
		}
		
		/**
		 * Set an InputField for month selection
		 */
		public function get month():InputField
		{
			return _month;
		}
		
		/**
		 * @private
		 */
		public function set month(value:InputField):void
		{
			if (_month)
			{
				_month.removeEventListener(Event.CHANGE, handleChange);
				_month.removeEventListener(FormElementEvent.SUBMIT, dispatchEvent);
				removeElement(_month);
			}
			_month = value;
			if (_month)
			{
				_month.addEventListener(Event.CHANGE, handleChange);
				_month.addEventListener(FormElementEvent.SUBMIT, dispatchEvent);
				addElement(_month);
				_month.maxChars = 2;
				_month.restrict = Restrictions.INTEGERS;
			}
		}

		/**
		 * Set an InputField for year selection
		 */
		public function get year():InputField
		{
			return _year;
		}
		
		/**
		 * @private
		 */
		public function set year(value:InputField):void
		{
			if (_year)
			{
				_year.removeEventListener(Event.CHANGE, handleChange);
				removeElement(_year);
			}
			_year = value;
			if (_year)
			{
				_year.addEventListener(Event.CHANGE, handleChange);
				addElement(_year);
				_year.maxChars = 4;
				_year.restrict = Restrictions.INTEGERS;
			}
		}

		/**
		 * @inheritDoc
		 * 
		 * Get or set the value. When format is set, return value is a String else return value is a Date
		 * Value can only be set as date, not a String
		 */
		override public function get value():*
		{
			var date:Date = date;
			
			if (_format && date != null)
			{
				return DateUtils.format(_format, date);
			}
			return date;
		}

		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			if (value == null) return;
			
			if (value is String)
			{
				value = DateUtils.parseFromSqlDateTime(value);
			}
			
			if (value is Date)
			{
				if (_day) _day.value = (value as Date).getDate();
				if (_month) _month.value = (value as Date).getMonth() + 1;
				if (_year) _year.value = (value as Date).getFullYear();
			}
			else
			{
				logWarn("setValue: value '" + value + "' is not a Date");
			}	
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Day hint text", type="String")]
		public function set dayHintText(value:String):void
		{
			_day.hintText = value;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Month hint text", type="String")]
		public function set monthHintText(value:String):void
		{
			_month.hintText = value;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Year hint text", type="String")]
		public function set yearHintText(value:String):void
		{
			_year.hintText = value;
		}

		/**
		 * Set the colour of the hint text
		 */
		[Inspectable(name="Hint text color", type="Color", defaultValue="#888888")]
		public function set hintTextColor(value:uint):void 
		{
			if (_day) _day.hintTextColor = value;
			if (_month) _month.hintTextColor = value;
			if (_year) _year.hintTextColor = value;
		}

		/**
		 * Set the colour of the error text
		 */
		[Inspectable(name="Error text color", type="Color", defaultValue="#FF0000")]
		public function set errorTextColor(value:uint):void 
		{
			if (_day) _day.errorTextColor = value;
			if (_month) _month.errorTextColor = value;
			if (_year) _year.errorTextColor = value;
		}

		/**
		 * Formatting of the date when call getValue() method. When format is null, a Date object is returned
		 * The format uses the PHP formatting rules. For more informatation go to: http://www.php.net/manual/en/function.date.php
		 */
		public function get format():String
		{
			return _format;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Format", type="String")]
		public function set format(value:String):void
		{
			_format = value;
		}

		/**
		 * Get or set the date of the DateSelector
		 */
		public function get date():Date
		{
			var year:int = _year ? _year.value : new Date().getFullYear();;
			var month:int = _month ? _month.value : 1;
			var day:int =  _day ? _day.value : 1;
			
			if (!year || !month || !day)
			{
				return null;
			}
			var date:Date = new Date(year, month - 1, day);
			
			// Check if date is between range
			if (_begin && _end)
			{
				if (date.time < Math.min(_begin.time, _end.time) || date.time > Math.max(_begin.time, _end.time)) return null;
			}
			else if (_begin)
			{
				if (date.time < _begin.time) return null;
			}
			else if (_end)
			{
				if (date.time > _end.time) return null;
			}
			
			// Check if days and months still match
			if (date.getDate() != day || date.getMonth() != month - 1) return null;
			
			return date;
		}

		/**
		 * @private
		 */
		public function set date(value:Date):void
		{
			this.value = value;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Validation rule", type="String", defaultValue="none", enumeration="none,mandatory")]
		public function set validationRuleName(value:String):void
		{
			switch (value)
			{
				case "none":
				{
					_validator = null;
					break;
				}
				case "mandatory":
				{
					_validator = NullValidationRule;
					break;
				}
				default:
				{
					_validator = null;
					logError("validationRule: unknown validation rule '" + value + "'");
					break;
				}
			}
		}
		
		/**
		 * Set the range (lowest and highest) value of the date
		 */
		public function setDateRange(begin:Date, end:Date):void
		{
			_begin = begin;
			_end = end;
		}
		
		/**
		 * The oldest valid date
		 */
		public function get begin():Date
		{
			return _begin;
		}
		
		/**
		 * @private
		 */
		public function set begin(value:Date):void
		{
			_begin = value;
		}
		
		/**
		 * The newest valid year
		 */
		public function get end():Date
		{
			return _end;
		}
		
		/**
		 * @private
		 */
		public function set end(value:Date):void
		{
			_end = value;
		}
		
		/**
		 * Setter function to make the resetScale option available in the Component Inspector, when the DateInputField is used as component. 
		 * 
		 * @private
		 */
		[Inspectable(name="Reset scaling", type="Boolean")]
		public function set inspectableResetScale(value:Boolean):void
		{
			if (value)
			{
				resetScale();
			}
		}

		/**
		 * When set to true, scaleX and scaleY will be reset to 0 and all children will be resized.
		 * By using this the textfield and all 9-slice children will look normal.
		 */
		public function resetScale():void
		{
			var len:int = numChildren;
			for (var i:int = 0; i < len ; i++)
			{
				getChildAt(i).width *= scaleX;
				getChildAt(i).height *= scaleY;
			}
			scaleX = scaleY = 1;
			
			if (day) day.resetScale();
			if (month) month.resetScale();
			if (year) year.resetScale();
		}
		
		/**
		 * If set to true the InputField will dispatch an FormElementEvent.SUBMIT when the user pressed any key and the form (if enabled) can be submitted.
		 */
		public function get submitOnChange():Boolean
		{
			return _submitOnChange;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Submit on Change", type="Boolean", defaultValue="false")]
		public function set submitOnChange(value:Boolean):void
		{
			_submitOnChange = value;
		}

		private function handleChange(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
			if (_submitOnChange) dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			day = null;
			month = null;
			year = null;
			_format = null;
			
			super.destruct();
		}
	}
}
