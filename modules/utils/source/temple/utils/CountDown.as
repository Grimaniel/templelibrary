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

		public function CountDown(endDate:Date = null, allowNegative:Boolean = false) 
		{
			this._startDate = new Date();
			this.endDate = endDate;
			this._allowNegative = allowNegative;
		}

		/**
		 * Date when the CountDown is ended
		 */
		public function get endDate():Date
		{
			return this._endDate;
		}

		/**
		 * @private
		 */
		public function set endDate(value:Date):void
		{
			this._endDate = value;
		}
		
		/**
		 * Date when the CountDown is started
		 */
		public function get startDate():Date
		{
			return this._startDate;
		}
		
		/**
		 * @private
		 */
		public function set startDate(value:Date):void
		{
			this._startDate = value;
		}
		
		/**
		 * Duration in milliseconds
		 */
		public function get duration():Number
		{
			return this._duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:Number):void
		{
			this._duration = value;
		}

		/**
		 * Use only when set duration, functions as restart when called twice
		 * @param duration duration in milliseconds
		 */
		public function start(duration:Number = NaN):void
		{
			if (!isNaN(duration)) this._duration = duration;
			if (isNaN(this._duration)) throwError(new TempleError(this, 'duration not set'));
			
			this._startDate = new Date();
			this._endDate = new Date();
			this._endDate.setMilliseconds(this._endDate.getMilliseconds() + this._duration);
			
			this._paused = false;
		}

		/**
		 * Stop the CountDown
		 */
		public function stop():void 
		{
			this._endDate = null;
			this._pauseTime = NaN;
			this._pauseEndTime = null;
			this._paused = false;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			this._pauseTime = getTimer();
			this._pauseEndTime = this.time;
			this._paused = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (this._paused == true)
			{
				this._endDate.setMilliseconds(this._endDate.getMilliseconds() - (getTimer() - this._pauseTime));
				this._paused = false;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean 
		{
			return this._paused;
		}
		
		/**
		 * Get the time till end as date
		 */
		public function get time():Date
		{
			if (this._paused)
			{
				return this._pauseEndTime;
			}
			else if (this._endDate)
			{
				var diff:Number = this._endDate.getTime() - new Date().getTime();
				
				if (diff < 0 && !this._allowNegative) diff = 0;
				
				return new Date(1970, 0, 1, 0, 0, 0, diff);
			}
			else
			{
				this.logWarn('endDate is not set');
				return null;
			}
		}
		
		/**
		 * Get the time till end as date
		 */
		public function get years():Number
		{
			return this.time.getFullYear() - 1970;
		}
		
		/**
		 * Get the total amount of months till end.
		 */
		public function get totalMonths():Number
		{
			return this.time.getMonth() + 1 - 1 + (this.years * 12);
		}

		/**
		 * Get the total amount of months till end minus the years.
		 */
		public function get months():Number
		{
			return this.time.getMonth() + 1 - 1;
		}
		
		/**
		 * Get the total amount of weeks till end
		 */
		public function get totalWeeks():Number
		{
			return Math.floor(this.totalTime / 1000 / 60 / 60 / 24 / 7);
		}

		/**
		 * Get the total amount of weeks till end minus the years.
		 */
		public function get weeks():Number
		{
			return Math.floor(this.days / 7);
		}
		
		/**
		 * Get the total amount of days till end.
		 */
		public function get totalDays():Number
		{
			return this.totalTime / 1000 / 60 / 60 / 24;
		}

		/**
		 * Get the total amount of days till end minus the years.
		 */
		public function get days():Number
		{
			return this.time.getDate() - 1;
		}
		
		public function get totalHours():Number
		{
			return this.totalTime / 1000 / 60 / 60;
		}

		public function get hours():Number
		{
			return this.time.getHours();
		}
		
		public function get totalMinutes():Number
		{
			return this.totalTime / 1000 / 60;
		}

		public function get minutes():Number
		{
			return this.time.getMinutes();
		}
		
		public function get totalSeconds():Number
		{
			return this.totalTime / 1000;
		}

		public function get seconds():Number
		{
			return this.time.getSeconds();
		}		
		
		public function get totalMilliseconds():Number
		{
			return this.totalTime;
		}

		public function get milliseconds():Number
		{
			return this.time.getMilliseconds();
		}
		
		private function get totalTime():Number
		{
			return this.time ? this.time.time - (this.time.getTimezoneOffset() * 60 * 1000) : NaN;
		}

		/**
		 * Get the relative time left till end, where 1 means that we are on the start and 0 means we are at the end.
		 */
		public function get ratio():Number 
		{
			if (!this._startDate || !this._endDate) return NaN;
			
			return this.totalTime / (this._endDate.time - this._startDate.time);
		}
		
		/**
		 * A Boolean which indicates if a negative value is allowed. If not all values will return 0 if endDate is in the past.
		 * @default false
		 */
		public function get allowNegative():Boolean
		{
			return this._allowNegative;
		}
		
		/**
		 * @private
		 */
		public function set allowNegative(value:Boolean):void
		{
			this._allowNegative = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._endDate = null;
			this._startDate = null;
			this._pauseEndTime = null;
			super.destruct();
		}
	}
}
