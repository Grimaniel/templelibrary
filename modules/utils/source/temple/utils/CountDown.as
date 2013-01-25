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
	import temple.common.interfaces.IPauseable;
	import temple.core.CoreObject;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import flash.utils.getTimer;


	/**
	 * Class for calculating the remaining time till a specific Date and time.
	 * 
	 * @author Arjan van Wijk
	 */
	public class CountDown extends CoreObject implements IPauseable
	{
		private var _paused:Boolean;
		private var _duration:Number;
		private var _pauseTime:Number;
		private var _endDate:Date;
		private var _startDate:Date;
		private var _allowNegative:Boolean;
		private var _pauseEndTime:Date;
		private var _timeDiff:Number;

		public function CountDown(endDate:Date = null, allowNegative:Boolean = false) 
		{
			_startDate = new Date();
			this.endDate = endDate;
			_allowNegative = allowNegative;
		}

		/**
		 * Date when the CountDown is ended
		 */
		public function get endDate():Date
		{
			return _endDate;
		}

		/**
		 * @private
		 */
		public function set endDate(value:Date):void
		{
			_endDate = value;
		}
		
		/**
		 * @private
		 * Set the time difference in miliseconds to work with (instead of an end-date)
		 * Use 2 constant times (endtime - now) and substract the getTimer
		 */
		public function set timeDiff(value:Number):void
		{
			_timeDiff = value;
		}
		
		/**
		 * Date when the CountDown is started
		 */
		public function get startDate():Date
		{
			return _startDate;
		}
		
		/**
		 * @private
		 */
		public function set startDate(value:Date):void
		{
			_startDate = value;
		}
		
		/**
		 * Duration in milliseconds
		 */
		public function get duration():Number
		{
			return _duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:Number):void
		{
			_duration = value;
		}

		/**
		 * Use only when set duration, functions as restart when called twice
		 * @param duration duration in milliseconds
		 */
		public function start(duration:Number = NaN):void
		{
			if (!isNaN(duration)) _duration = duration;
			if (isNaN(_duration)) throwError(new TempleError(this, 'duration not set'));
			
			_startDate = new Date();
			_endDate = new Date();
			_endDate.setMilliseconds(_endDate.getMilliseconds() + _duration);
			
			_paused = false;
		}

		/**
		 * Stop the CountDown
		 */
		public function stop():void 
		{
			_endDate = null;
			_pauseTime = NaN;
			_pauseEndTime = null;
			_paused = false;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			_pauseTime = getTimer();
			_pauseEndTime = time;
			_paused = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (_paused == true)
			{
				_endDate.setMilliseconds(_endDate.getMilliseconds() - (getTimer() - _pauseTime));
				_paused = false;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		/**
		 * Get the time till end as date
		 */
		public function get time():Date
		{
			if (_paused)
			{
				return _pauseEndTime;
			}
			else if (_endDate)
			{
				var diff:Number = _endDate.getTime() - new Date().getTime();
				
				if (diff < 0 && !_allowNegative) diff = 0;
				
				return new Date(1970, 0, 1, 0, 0, 0, diff);
			}
			else
			{
				logWarn('endDate is not set');
				return null;
			}
		}
		
		/**
		 * Get the time till end as date
		 */
		public function get years():Number
		{
			return time.getFullYear() - 1970;
		}
		
		/**
		 * Get the total amount of months till end.
		 */
		public function get totalMonths():Number
		{
			return time.getMonth() + 1 - 1 + (years * 12);
		}

		/**
		 * Get the total amount of months till end minus the years.
		 */
		public function get months():Number
		{
			return time.getMonth() + 1 - 1;
		}
		
		/**
		 * Get the total amount of weeks till end
		 */
		public function get totalWeeks():Number
		{
			return Math.floor(totalTime / 1000 / 60 / 60 / 24 / 7);
		}

		/**
		 * Get the total amount of weeks till end minus the years.
		 */
		public function get weeks():Number
		{
			if (_endDate)
			{
				return Math.floor(days / 7);
			}
			else
			{
				return int(totalWeeks);
			}
		}
		
		/**
		 * Get the total amount of days till end.
		 */
		public function get totalDays():Number
		{
			return totalTime / 1000 / 60 / 60 / 24;
		}

		/**
		 * Get the total amount of days till end minus the years.
		 */
		public function get days():Number
		{
			if (_endDate)
			{
				return time.getDate() - 1;
			}
			else
			{
				return int(totalDays);
			}
		}
		
		public function get totalHours():Number
		{
			return totalTime / 1000 / 60 / 60;
		}

		public function get hours():Number
		{
			if (_endDate)
			{
				return time.getHours();
			}
			else
			{
				return int(totalHours % 24);
			}
		}
		
		public function get totalMinutes():Number
		{
			return totalTime / 1000 / 60;
		}

		public function get minutes():Number
		{
			if (_endDate)
			{
				return time.getMinutes();
			}
			else
			{
				return int(totalMinutes % 60);
			}
		}
		
		public function get totalSeconds():Number
		{
			return totalTime / 1000;
		}

		public function get seconds():Number
		{
			if (_endDate)
			{
				return time.getSeconds();
			}
			else
			{
				return int(totalSeconds % 60);
			}
		}		
		
		public function get totalMilliseconds():Number
		{
			return totalTime;
		}

		public function get milliseconds():Number
		{
			if (_endDate)
			{
				return time.getMilliseconds();
			}
			else
			{
				return int(milliseconds);
			}
		}
		
		private function get totalTime():Number
		{
			return time ? time.time - (time.getTimezoneOffset() * 60 * 1000) : (_allowNegative ? _timeDiff : Math.max(_timeDiff, 0));
		}

		/**
		 * Get the relative time left till end, where 1 means that we are on the start and 0 means we are at the end.
		 */
		public function get ratio():Number 
		{
			if (!_startDate || !_endDate) return NaN;
			
			return totalTime / (_endDate.time - _startDate.time);
		}
		
		/**
		 * A Boolean which indicates if a negative value is allowed. If not all values will return 0 if endDate is in the past.
		 * @default false
		 */
		public function get allowNegative():Boolean
		{
			return _allowNegative;
		}
		
		/**
		 * @private
		 */
		public function set allowNegative(value:Boolean):void
		{
			_allowNegative = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_endDate = null;
			_startDate = null;
			_pauseEndTime = null;
			super.destruct();
		}
	}
}
