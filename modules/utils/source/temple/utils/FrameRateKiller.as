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
	import temple.core.CoreObject;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * The FrameRateKiller allows you to throttle the framerate of SWF, without changing the frameRate of the Stage.
	 * 
	 * <p>The FrameRateKiller is very useful for testing and debug purposes. For instance check how your application will perform on a slow computer.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new FrameRateKiller();
	 * </listing>
	 * 
	 * @includeExample ../ui/animation/FrameStableMovieClipExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class FrameRateKiller extends CoreObject
	{
		private static var _sprite:Sprite = new Sprite();
		
		private var _time:int;
		private var _frameDuration:Number;

		public function FrameRateKiller(fps:Number = 10)
		{
			this.fps = fps;
			FrameRateKiller._sprite.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		/**
		 * The maximum frames per seconds of the SWF. Value must be hight then 0.
		 */
		public function get fps():Number 
		{
			return 1000 / _frameDuration;
		}

		/**
		 * @inheritDoc
		 */
		public function set fps(value:Number):void
		{
			if (isNaN(value) || value <= 0)
			{
				throwError(new TempleArgumentError(this, "FPS must be higher then zero"));
			}
			else
			{
				_frameDuration = 1000 / value;
			}
			
		}

		private function handleEnterFrame(event:Event):void
		{
			if (!_time) _time = getTimer();
			while (getTimer() - _time < _frameDuration)
			{
				// do nothing
			}
			_time = getTimer();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			FrameRateKiller._sprite.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			super.destruct();
		}
	}
}
