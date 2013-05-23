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
	import temple.core.utils.CoreTimer;

	import flash.utils.getTimer;

	/**
	 * Same as the normal Timer, but has an extra 'progress' property
	 * 
	 * @author Thijs Broerse
	 */
	public class ProgressTimer extends CoreTimer 
	{
		private var _startTime:Number;

		public function ProgressTimer(delay:Number, repeatCount:int = 0)
		{
			super(delay, repeatCount);
		}

		override public function start():void
		{
			super.start();
			_startTime = getTimer();
		}

		override public function stop():void
		{
			super.stop();
			_startTime = NaN;
		}

		override public function reset():void
		{
			super.reset();
			_startTime = NaN;
		}

		/**
		 * Returns the progress factor of the timer between 0 and 1
		 * where 0 is started and 1 is complete
		 */
		public function get progress():Number
		{
			return timeRunning / delay;
		}

		/**
		 * Returns the number of milliseconds this timer is running
		 */
		public function get timeRunning():int
		{
			return running ? (getTimer() - _startTime) : 0;
		}
	}
}
