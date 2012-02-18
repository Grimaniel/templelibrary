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
	import temple.core.utils.CoreTimer;

	import flash.events.TimerEvent;
	import flash.utils.getTimer;


	/**
	 * The TimeOut calls a callback function after a delay.
	 * 
	 * <p><strong>What does it do</strong></p>
	 * <p>The TimeOut wait for a specific delay and calls a callback function</p>
	 * 
	 * <p><strong>Why should you use it</strong></p>
	 * <p>If a function needs to be called after a delay</p>
	 * 
	 * <p><strong>How should you use it</strong></p>
	 * <p>Create a new TimeOut instance with the callback function and delay.</p>
	 * 
	 * <listing version="3.0">
	 * // call delayedFunction after 1 second (1000 milliseconds) 
	 * new TimeOut(delayedFunction, 1000);
	 * 
	 * function delayedFunction()
	 * {
	 * 		trace("delayedFunction called");
	 * }
	 * </listing>
	 * 
	 * It is also possible to pass arguments with the callback:
	 * 
	 * <listing version="3.0">
	 * // call delayedFunction after 1 second (1000 milliseconds) 
	 * new TimeOut(delayedFunction, 1000, ["Some string", 2]);
	 * 
	 * function delayedFunction(arg1:String, arg2:Number)
	 * {
	 * 		trace("delayedFunction called with arguments: '" + arg1 + "' and " + arg2);
	 * }
	 * </listing>
	 * 
	 * @author Thijs Broerse
	 */
	public class TimeOut extends CoreObject implements IPauseable
	{
		/**
		 * Lazy creates a TimeOut
		 */
		public static function create(callback:Function, milliseconds:Number, params:Array = null):TimeOut
		{
			return new TimeOut(callback, milliseconds, params);
		}
		
		private var _timer:CoreTimer;
		private var _callback:Function;
		private var _params:Array;

		//for pausing/restarting
		private var _intervalMilliseconds:Number;
		private var _startMilliseconds:Number;
		private var _remainingMilliseconds:Number;

		/**
		 * Creates a new TimeOut
		 * @param callback the callback function to be called when done waiting
		 * @param milliseconds the number of milliseconds to wait
		 * @param params list of parameters to pass to the callback function
		 */
		public function TimeOut(callback:Function, milliseconds:Number, params:Array = null)
		{
			this._callback = callback;
			this._params = params;
			
			this._intervalMilliseconds = milliseconds;			
			this._startMilliseconds = getTimer();
			
			this._timer = new CoreTimer(this._intervalMilliseconds, 1);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.handleTimerComplete);
			this._timer.start();
		}

		/**
		 * Restarts the TimeOut
		 */
		public function restart():void
		{
			if (this._timer != null && this._timer.running == true)
			{
				this._timer.stop();
			}
			
			this._startMilliseconds = getTimer();
			
			if (this._timer == null)
			{
				this._timer = new CoreTimer(this._intervalMilliseconds, 1);
				this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.handleTimerComplete);
			}
			this._timer.start();
		}

		/**
		 * Pauses the TimeOut
		 */
		public function pause():void
		{
			if (this._timer != null && this._timer.running == true)
			{
				this._remainingMilliseconds = this._timer.delay - (getTimer() - this._startMilliseconds);
				this._timer.stop();
			}
		}

		/**
		 * Resumes the TimeOut when paused
		 */
		public function resume():void
		{
			if (this._remainingMilliseconds > 0)
			{
				if (this._timer != null)
				{
					this._timer.delay = this._remainingMilliseconds;
					this._timer.start();
				}
				else
				{
					this._timer = new CoreTimer(this._remainingMilliseconds, 1);
					this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.handleTimerComplete);	
				}
				
				this._startMilliseconds = getTimer();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return !this._timer.running;
		}

		/**
		 * Stops the TimeOut
		 */
		public function stop():void
		{
			if (this._timer != null && this._timer.running == true)
			{
				this._timer.stop();
			}
			this._remainingMilliseconds = 0;
		}

		/**
		 * Returns the passed time (in milliseconds)
		 */
		public function get timeElapsed():Number
		{
			return this._intervalMilliseconds - this.timeLeft;
		}

		/**
		 * Returns the time (in milliseconds) it will take at this moment till the TimeOut is complete.
		 */
		public function get timeLeft():Number
		{
			return this._timer ? (this._timer.running ? this._timer.delay - (getTimer() - this._startMilliseconds) : this._remainingMilliseconds) : 0;
		}
		
		/**
		 * Call this method to force a complete before the time has passed.
		 */
		public function complete():void
		{
			if (!this.isDestructed)
			{
				if (this._params != null)
				{
					if (this._callback != null) this._callback.apply(null, this._params);
				}
				else
				{
					if (this._callback != null) this._callback();
				}
				this.destruct();
			}
			else
			{
				throwError(new TempleError(this, "TimeOut already completed"));
			}
		}
		
		private function handleTimerComplete(event:TimerEvent):void
		{
			this.complete();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._timer != null)
			{
				this._timer.destruct();
				this._timer = null;
			}
			this._callback = null;
			this._params = null;	
			
			this._remainingMilliseconds = 0;
			
			super.destruct();	
		}
	}
}
