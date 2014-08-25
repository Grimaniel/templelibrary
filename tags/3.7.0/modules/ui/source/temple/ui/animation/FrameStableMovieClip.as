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

package temple.ui.animation 
{
	import temple.core.debug.IDebuggable;
	import temple.core.display.CoreMovieClip;

	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * The FrameStableMovieClip will always play the timeline on the correct frame rate, even if the frame rate of the SWF drops due to performance issues.
	 * 
	 * <p>Use this class as a base class in the library of your .fla file.
	 * If the real frame rate of the SWF drops, the FrameStableMovieClip will skip frames to maintain the original frame rate.
	 * Although frames are skipped, FrameScripts on the skipped frames will always be executed.</p>
	 * 
	 * @includeExample FrameStableMovieClipExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class FrameStableMovieClip extends CoreMovieClip implements IDebuggable
	{
		private var _frameRate:Number;
		private var _frameTime:Number = 1000 / _frameRate;
		private var _useStageFrameRate:Boolean;
		private var _startTime:int;
		private var _previousFrame:int;
		private var _startFrame:int;
		private var _scriptFrame:int;
		private var _labels:Object;

		public function FrameStableMovieClip(frameRate:Number = NaN)
		{
			super.stop();
			this.frameRate = frameRate;
			play();
		}

		/**
		 * @inheritDoc
		 */
		override public function play():void
		{
			_startFrame = _previousFrame = currentFrame;
			_startTime = getTimer();
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		/**
		 * @inheritDoc
		 */
		override public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			super.stop();
			_previousFrame = currentFrame;
			
			if (_scriptFrame > 0) gotoAndStop(_scriptFrame);
			_scriptFrame = -1;
		}

		/**
		 * @inheritDoc
		 */
		override public function gotoAndPlay(frame:Object, scene:String = null):void
		{
			if (debug) logDebug("gotoAndPlay: " + frame + (scene ? ", scene: " + scene : ""));
			super.gotoAndStop(frame, scene);
			_startFrame = _previousFrame = int(frame) || getFrame(String(frame)) || 1;
			_startTime = getTimer();
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		/**
		 * @inheritDoc
		 */
		override public function gotoAndStop(frame:Object, scene:String = null):void
		{
			if (debug) logDebug("gotoAndStop: " + frame + (scene ? ", scene: " + scene : ""));
			_previousFrame = currentFrame;
			super.gotoAndStop(frame, scene);
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			_scriptFrame = -1;
		}

		/**
		 * The frame rate for playing the timeline of the MovieClip. If NaN the frame rate of the stage is used.
		 */
		public function get frameRate():Number
		{
			return _frameRate;
		}

		/**
		 * @private
		 */
		public function set frameRate(value:Number):void
		{
			if (isNaN(value))
			{
				useStageFrameRate = true;
			}
			else
			{
				_frameRate = value;
				_frameTime = 1000 / _frameRate;
				_useStageFrameRate = false;
			}
		}

		/**
		 * A Boolean which indicates if the frame rate of the stage is used, rather then a custom frame rate.
		 */
		public function get useStageFrameRate():Boolean
		{
			return _useStageFrameRate;
		}

		/**
		 * @private
		 */
		public function set useStageFrameRate(value:Boolean):void
		{
			_useStageFrameRate = value;
			
			if (_useStageFrameRate)
			{
				if (stage)
				{
					_frameRate = stage.frameRate;
					_frameTime = 1000 / _frameRate;
					removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
				}
				else
				{
					addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
				}
			}
		}

		private function handleAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			if (_useStageFrameRate)
			{
				_frameRate = stage.frameRate;
				_frameTime = 1000 / _frameRate;
			}
		}

		private function handleEnterFrame(event:Event):void
		{
			super.gotoAndStop(int(((getTimer() - _startTime) / _frameTime + _startFrame - 1) % totalFrames) + 1);
			
			if (_previousFrame > currentFrame) _previousFrame -= totalFrames;
			
			while (++_previousFrame < currentFrame)
			{
				if (_previousFrame <= 0)
				{
					_scriptFrame = _previousFrame + totalFrames;
					if (hasFrameScript(_previousFrame + totalFrames))
					{
						if (debug) logDebug("handleEnterFrame: execute skipped framescript of frame " + (_previousFrame + totalFrames) + ", currentFrame=" + currentFrame);
						getFrameScript(_previousFrame + totalFrames)();
					}
				}
				else
				{
					_scriptFrame = _previousFrame;
					if (hasFrameScript(_previousFrame))
					{
						if (debug) logDebug("handleEnterFrame: execute skipped framescript of frame " + _previousFrame + ", currentFrame=" + currentFrame);
						getFrameScript(_previousFrame)();
					}
				}
				if (_scriptFrame == -1) return;
			}
			_scriptFrame = -1;
			_previousFrame = currentFrame;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

			_frameRate = NaN;
			_previousFrame = NaN;
			_useStageFrameRate = false;
			_frameTime = NaN;
			_startFrame = NaN;
			_startTime = NaN;
			_scriptFrame = NaN;
			_labels = null;
		}
	}
}
