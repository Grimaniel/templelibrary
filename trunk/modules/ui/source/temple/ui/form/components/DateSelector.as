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
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.ui.form.validation.IHasError;
	import temple.utils.types.DateUtils;

	/**
	 * Input for Date. The date can be selected from <code>Comboxes</code>.
	 * 
	 * @author Thijs Broerse
	 */
	public class DateSelector extends DateInputField implements IHasValue, IHasError, IResettable, ISetValue 
	{
		// statics for month formatting
		public static const MONTH_FORMAT_NUMBER:String = 'number';
		public static const MONTH_FORMAT_SHORT_EN:String = 'short EN';
		public static const MONTH_FORMAT_NAME_EN:String = 'name EN';
		public static const MONTH_FORMAT_SHORT_NL:String = 'short NL';
		public static const MONTH_FORMAT_NAME_NL:String = 'name NL';
		
		private var _monthFormat:String = MONTH_FORMAT_NUMBER;
		
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
			
			if (this.day is ComboBox)
			{
				ComboBox(this.day).removeAll();
				for (var i:int = 1;i <= 31; i++) ComboBox(this.day).addItem(i);
			}
		}
		
		/**
		 * @private
		 */
		override public function set month(value:InputField):void
		{
			super.month = value;
			
			if (this.month is ComboBox)
			{
				ComboBox(this.month).removeAll();
				for (var i:int = 1;i <= 12; i++) ComboBox(this.month).addItem(i);
				this.monthFormat = this._monthFormat;
			}
		}

		/**
		 * @private
		 */
		override public function set year(value:InputField):void
		{
			super.year = value;
			
			if (this.year is ComboBox)
			{
				this.setDateRange(this.begin, this.end);
			}
		}

		/**
		 * The format of the month in de month selector, possible values: number,short EN,name EN,short NL,name NL
		 */
		public function get monthFormat():String
		{
			return this._monthFormat;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Month format", type="String", defaultValue="number", enumeration="number,short EN,name EN,short NL,name NL")]
		public function set monthFormat(value:String):void
		{
			var labels:Array;
			var i:int;
			switch (value)
			{
				case MONTH_FORMAT_NUMBER:
				{
					labels = [1,2,3,4,5,6,7,8,9,10,11,12];
					break;
				}
				case MONTH_FORMAT_SHORT_EN:
				{
					labels = DateUtils.MONTHS_EN;
					for (i = labels.length-1; i >= 0 ; --i)
					{
						labels[i] = String(labels[i]).substr(0,3);
					}
					break;
				}
				case MONTH_FORMAT_NAME_EN:
				{
					labels = DateUtils.MONTHS_EN;
					break;
				}
				case MONTH_FORMAT_SHORT_NL:
				{
					labels = DateUtils.MONTHS_NL;
					for (i = labels.length-1; i >= 0 ; --i)
					{
						labels[i] = String(labels[i]).substr(0,3);
					}
					break;
				}
				case MONTH_FORMAT_NAME_NL:
				{
					labels = DateUtils.MONTHS_NL;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "invalid value for monthFormat '" + value + "'"));
					break;
				}
			}
			this._monthFormat = value;
			
			if (this.month is ComboBox)
			{
				for (i = labels.length-1; i >= 0 ; --i)
				{
					ComboBox(this.month).setLabelAt(i, labels[i]);
				}
			}
		}
		
		/**
		 * @private
		 */
		override public function set begin(value:Date):void
		{
			this.setDateRange(value, this.end);
		}
		
		/**
		 * @private
		 */
		override public function set end(value:Date):void
		{
			this.setDateRange(this.begin, value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setDateRange(begin:Date, end:Date):void
		{
			var date:Date = this.date;
			super.setDateRange(begin, end);
			
			if (begin && end && this.year is ComboBox)
			{
				ComboBox(this.year).removeAll();
				
				var i:int;
				
				if (begin < end)
				{
					for (i = begin.fullYear; i <= end.fullYear; i++) ComboBox(this.year).addItem(i);
				}
				else
				{
					for (i = begin.fullYear; i >= end.fullYear; i--) ComboBox(this.year).addItem(i);
				}
				if (date) this.year.value = date.getFullYear();
			}
		}

		/**
		 * The number of rows that are at least partially visible in the list.
		 */
		public function get rowCount():uint
		{
			return ComboBox(this.day).rowCount;
		}

		/**
		 * The number of rows that are at least partially visible in the list.
		 */
		public function set rowCount(value:uint):void
		{
			ComboBox(this.day).rowCount = value;
			ComboBox(this.month).rowCount = value;
			ComboBox(this.year).rowCount = value;
		}


		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._monthFormat = null;
			
			super.destruct();
		}
	}
}
