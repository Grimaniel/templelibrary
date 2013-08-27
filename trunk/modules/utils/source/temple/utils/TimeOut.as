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
			_callback = callback;
			_params = params;
			
			_intervalMilliseconds = milliseconds;			
			_startMilliseconds = getTimer();
			
			_timer = new CoreTimer(_intervalMilliseconds, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			_timer.start();
		}

		/**
		 * Restarts the TimeOut
		 */
		public function restart():void
		{
			if (_timer != null && _timer.running)
			{
				_timer.stop();
			}
			
			_startMilliseconds = getTimer();
			
			if (_timer == null)
			{
				_timer = new CoreTimer(_intervalMilliseconds, 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			}
			_timer.start();
		}

		/**
		 * Pauses the TimeOut
		 */
		public function pause():void
		{
			if (_timer != null && _timer.running)
			{
				_remainingMilliseconds = _timer.delay - (getTimer() - _startMilliseconds);
				_timer.stop();
			}
		}

		/**
		 * Resumes the TimeOut when paused
		 */
		public function resume():void
		{
			if (_remainingMilliseconds > 0)
			{
				if (_timer != null)
				{
					_timer.delay = _remainingMilliseconds;
					_timer.start();
				}
				else
				{
					_timer = new CoreTimer(_remainingMilliseconds, 1);
					_timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);	
				}
				
				_startMilliseconds = getTimer();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isPaused():Boolean
		{
			return _timer ? !_timer.running : false;
		}

		/**
		 * Stops the TimeOut
		 */
		public function stop():void
		{
			if (_timer != null && _timer.running)
			{
				_timer.stop();
			}
			_remainingMilliseconds = 0;
		}

		/**
		 * Returns the passed time (in milliseconds)
		 */
		public function get timeElapsed():Number
		{
			return _intervalMilliseconds - timeLeft;
		}

		/**
		 * Returns the time (in milliseconds) it will take at this moment till the TimeOut is complete.
		 */
		public function get timeLeft():Number
		{
			return _timer ? (_timer.running ? _timer.delay - (getTimer() - _startMilliseconds) : _remainingMilliseconds) : 0;
		}
		
		/**
		 * Call this method to force a complete before the time has passed.
		 */
		public function complete():void
		{
			if (!isDestructed)
			{
				if (_params != null)
				{
					if (_callback != null) _callback.apply(null, _params);
				}
				else
				{
					if (_callback != null) _callback();
				}
				destruct();
			}
			else
			{
				throwError(new TempleError(this, "TimeOut already completed"));
			}
		}
		
		private function handleTimerComplete(event:TimerEvent):void
		{
			complete();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_timer != null)
			{
				_timer.destruct();
				_timer = null;
			}
			_callback = null;
			_params = null;	
			
			_remainingMilliseconds = 0;
			
			super.destruct();	
		}
	}
}
