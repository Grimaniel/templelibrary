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
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	/**
	 * @author Thijs Broerse
	 */
	internal final class DateLabels implements IDateLabels
	{
		private var _fullDays:Vector.<String>;
		private var _shortDays:Vector.<String>;
		private var _fullMonths:Vector.<String>;
		private var _shortMonths:Vector.<String>;
		private var _format:DateLabelFormat;

		public function DateLabels(fullDays:Vector.<String>, fullMonths:Vector.<String>, shortDays:Vector.<String> = null, shortMonths:Vector.<String> = null)
		{
			if (!fullDays || fullDays.length != 7) throwError(new TempleArgumentError(this, "Invalid length for fullDays"));
			if (!fullMonths || fullMonths.length != 12) throwError(new TempleArgumentError(this, "Invalid length for fullMonths"));
			if (shortDays && shortDays.length != 7) throwError(new TempleArgumentError(this, "Invalid length for daysShort"));
			if (shortMonths && shortMonths.length != 12) throwError(new TempleArgumentError(this, "Invalid length for monthsShort"));
			
			_fullDays = fullDays;
			_fullMonths = fullMonths;
			_shortDays = shortDays;
			_shortMonths = shortMonths;
			
			_fullDays.fixed = true;
			_fullMonths.fixed = true;
			
			if (_shortDays) _shortDays.fixed = true;
			if (_shortMonths) _shortMonths.fixed = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get fullDays():Vector.<String>
		{
			return _fullDays;
		}

		/**
		 * @inheritDoc
		 */
		public function get shortDays():Vector.<String>
		{
			if (!_shortDays)
			{
				var v:Vector.<String> = new Vector.<String>(7, true);
				for (var i:int = 0, leni:int = v.length; i < leni; i++)
				{
					v[i] = getShortDay(i);
				}
				_shortDays = v;
			}
			return _shortDays;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDay(index:int, format:DateLabelFormat = null):String
		{
			format ||= _format;
			
			switch (format)
			{
				case DateLabelFormat.NUMERIC:
				{
					return index.toString();
				}
				case DateLabelFormat.NUMERIC_LEADING_ZERO:
				{
					return (index < 10 ? "0" : "") + index.toString();
				}
				case DateLabelFormat.FULL:
				case null:
				{
					return getFullDay(index);
				}
				case DateLabelFormat.SHORT:
				{
					return getShortDay(index);
				}
				default:
				{
					throwError(new TempleArgumentError(this, "Invalid value for format '" + format + "'"));
					break;
				}
			}
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function getFullDay(index:int):String
		{
			return index in _fullDays ? _fullDays[index] : null;
		}

		/**
		 * @inheritDoc
		 */
		public function getShortDay(index:int):String
		{
			return _shortDays && index in _shortDays ? _shortDays[index] : (index in _fullDays ? _fullDays[index].substr(0, 3) : null);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get fullMonths():Vector.<String>
		{
			return _fullMonths;
		}

		/**
		 * @inheritDoc
		 */
		public function get shortMonths():Vector.<String>
		{
			if (!_shortMonths)
			{
				var v:Vector.<String> = new Vector.<String>(12, true);
				for (var i:int = 0, leni:int = v.length; i < leni; i++)
				{
					v[i] = getShortMonth(i);
				}
				_shortMonths = v;
			}
			return _shortMonths;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getMonth(index:int, format:DateLabelFormat = null):String
		{
			format ||= _format;
			
			switch (format)
			{
				case DateLabelFormat.NUMERIC:
				{
					return (index + 1).toString();
				}
				case DateLabelFormat.NUMERIC_LEADING_ZERO:
				{
					return (index < 9 ? "0" : "") + (index + 1).toString();
				}
				case DateLabelFormat.FULL:
				case null:
				{
					return getFullMonth(index);
				}
				case DateLabelFormat.SHORT:
				{
					return getShortMonth(index);
				}
				default:
				{
					throwError(new TempleArgumentError(this, "Invalid value for format '" + format + "'"));
					break;
				}
			}
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function getFullMonth(index:int):String
		{
			return index in _fullMonths ? _fullMonths[index] : null;
		}

		/**
		 * @inheritDoc
		 */
		public function getShortMonth(index:int):String
		{
			return (_shortMonths && index in _shortMonths) ? (_shortMonths[index]) : (index in _fullMonths ? _fullMonths[index].substr(0, 3) : null);
		}

		/**
		 * @inheritDoc
		 */
		public function get format():DateLabelFormat
		{
			return _format;
		}

		/**
		 * @inheritDoc
		 */
		public function set format(value:DateLabelFormat):void
		{
			_format = value;
		}
	}
}
