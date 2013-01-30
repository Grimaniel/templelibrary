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
	import flash.events.TimerEvent;
	import temple.core.utils.CoreTimer;

	/**
	 * Timer with a random delay within min/max range
	 * 
	 * @author Thijs Broerse
	 */
	public class RandomTimer extends CoreTimer 
	{
		private var _minDelay:Number;
		private var _maxDelay:Number;
		
		public function RandomTimer(minDelay:Number, maxDelay:Number, repeatCount:int = 0)
		{
			super(getDelay(minDelay, maxDelay), repeatCount);
			
			construct::randomTimer(minDelay, maxDelay, repeatCount);
			
			addEventListener(TimerEvent.TIMER, handleTimerEvent);
		}

		/**
		 * @private
		 */
		construct function randomTimer(minDelay:Number, maxDelay:Number, repeatCount:int):void
		{
			_minDelay = minDelay;
			_maxDelay = maxDelay;
			toStringProps.push('minDelay', 'maxDelay');
			repeatCount;
		}

		/**
		 * Minimum delay in milliseconds
		 */
		public function get minDelay():Number
		{
			return _minDelay;
		}

		/**
		 * @private
		 */
		public function set minDelay(value:Number):void
		{
			_minDelay = value;
		}

		/**
		 * Maximum delay in milliseconds
		 */
		public function get maxDelay():Number
		{
			return _maxDelay;
		}

		/**
		 * @private
		 */
		public function set maxDelay(value:Number):void
		{
			_maxDelay = value;
		}

		private function getDelay(min:Number, max:Number):Number
		{
			return min + (max - min) * Math.random();
		}
		
		private function handleTimerEvent(event:TimerEvent):void
		{
			delay = getDelay(_minDelay, _maxDelay);
		}
	}
}
