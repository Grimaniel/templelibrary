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
		private var _startTime:uint;
		private var _previousFrame:int;
		private var _startFrame:uint;
		private var _scriptFrame:int;

		public function FrameStableMovieClip(frameRate:Number = NaN)
		{
			super.stop();

			this.frameRate = frameRate;
			
			this.play();
			
			this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
		}

		/**
		 * @inheritDoc
		 */
		override public function play():void
		{
			this._startFrame = this._previousFrame = this.currentFrame;
			this._startTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
		}

		/**
		 * @inheritDoc
		 */
		override public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			super.stop();
			this._previousFrame = this.currentFrame;
			
			if (this._scriptFrame > 0) this.gotoAndStop(this._scriptFrame);
			this._scriptFrame = -1;
		}

		/**
		 * @inheritDoc
		 */
		override public function gotoAndPlay(frame:Object, scene:String = null):void
		{
			super.gotoAndStop(frame, scene);
			this._startFrame = this._previousFrame = this.currentFrame;
			this._startTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
		}

		/**
		 * @inheritDoc
		 */
		override public function gotoAndStop(frame:Object, scene:String = null):void
		{
			this._previousFrame = this.currentFrame;
			super.gotoAndStop(frame, scene);
			this.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			this._scriptFrame = -1;
		}

		/**
		 * The frame rate for playing the timeline of the MovieClip. Is NaN the frame rate of the stage is used.
		 */
		public function get frameRate():Number
		{
			return this._frameRate;
		}

		/**
		 * @private
		 */
		public function set frameRate(value:Number):void
		{
			if (isNaN(value))
			{
				this.useStageFrameRate = true;
			}
			else
			{
				this._frameRate = value;
				this._frameTime = 1000 / this._frameRate;
				this._useStageFrameRate = false;
			}
		}

		/**
		 * A Boolean which indicates if the frame rate of the stage is used, rather then a custom frame rate.
		 */
		public function get useStageFrameRate():Boolean
		{
			return this._useStageFrameRate;
		}

		/**
		 * @private
		 */
		public function set useStageFrameRate(value:Boolean):void
		{
			this._useStageFrameRate = value;
			
			if (this._useStageFrameRate)
			{
				if (this.stage)
				{
					this._frameRate = this.stage.frameRate;
					this._frameTime = 1000 / this._frameRate;
					this.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
				}
				else
				{
					this.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
				}
			}
		}

		private function handleAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			if (this._useStageFrameRate)
			{
				this._frameRate = this.stage.frameRate;
				this._frameTime = 1000 / this._frameRate;
			}
		}

		private function handleEnterFrame(event:Event):void
		{
			super.gotoAndStop(int(((getTimer() - this._startTime) / this._frameTime + this._startFrame - 1) % this.totalFrames) + 1);
			
			if (this._previousFrame > this.currentFrame) this._previousFrame -= this.totalFrames;
			
			while (this._previousFrame < this.currentFrame - 1)
			{
				if (this._previousFrame <= 0)
				{
					this._scriptFrame = this._previousFrame + this.totalFrames;
					if (this.hasFrameScript(this._previousFrame + this.totalFrames))
					{
						if (this.debug) this.logDebug("handleEnterFrame: execute skipped framescript of frame " + (this._previousFrame + this.totalFrames + 1));
						this.getFrameScript(this._previousFrame + this.totalFrames)();
					}
				}
				else
				{
					this._scriptFrame = this._previousFrame;
					if (this.hasFrameScript(this._previousFrame))
					{
						if (this.debug) this.logDebug("handleEnterFrame: execute skipped framescript of frame " + (this._previousFrame + 1));
						this.getFrameScript(this._previousFrame)();
					}
				}
				this._previousFrame++;
				
				if (this._scriptFrame == -1) return;
			}
			this._scriptFrame = -1;
			this._previousFrame = this.currentFrame;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);

			this._frameRate = NaN;
			this._previousFrame = NaN;
			this._useStageFrameRate = false;
			this._frameTime = NaN;
			this._startFrame = NaN;
			this._startTime = NaN;
			this._scriptFrame = NaN;
		}
	}
}
