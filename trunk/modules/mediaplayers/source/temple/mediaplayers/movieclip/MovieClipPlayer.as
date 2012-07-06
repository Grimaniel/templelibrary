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

package temple.mediaplayers.movieclip
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import temple.common.events.SoundEvent;
	import temple.common.events.StatusEvent;
	import temple.core.debug.IDebuggable;
	import temple.core.events.CoreEventDispatcher;
	import temple.mediaplayers.players.PlayerStatus;
	import temple.mediaplayers.players.PlayerEvent;


	/**
	 * @author Thijs Broerse
	 */
	public class MovieClipPlayer extends CoreEventDispatcher implements IMovieClipPlayer, IDebuggable
	{
		private var _movieClip:MovieClip;
		private var _status:String;
		private var _autoRewind:Boolean;
		private var _debug:Boolean;
		private var _volume:Number = 1;
		private var _frameRate:Number;
		
		public function MovieClipPlayer(movieClip:MovieClip = null)
		{
			this.movieClip = movieClip;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get movieClip():MovieClip
		{
			return this._movieClip;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set movieClip(value:MovieClip):void
		{
			if (this._movieClip) this._movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			
			this._movieClip = value;
			if (this._movieClip)
			{
				this._movieClip.stop();
				this._movieClip.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this.volume = this._volume;
			}
			this._status = PlayerStatus.PAUSED;
		}
		
		/**
		 * @inheritDoc
		 */
		public function goto(frame:Object, scene:String = null):void
		{
			if (this._movieClip)
			{
				if (this.status == PlayerStatus.PLAYING && this._movieClip)
				{
					this._movieClip.gotoAndPlay(frame, scene);
				}
				else if (this._movieClip) 
				{
					this._movieClip.gotoAndStop(frame, scene);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			if (this.debug) this.logDebug("play: ");
			if (this._movieClip) this._movieClip.gotoAndPlay(1);
			if (this._status != PlayerStatus.PLAYING)
			{
				this._status = PlayerStatus.PLAYING;
				this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			if (this.debug) this.logDebug("stop: ");
			if (this._movieClip) this._movieClip.stop();
			if (this._status != PlayerStatus.STOPPED)
			{
				this._status = PlayerStatus.STOPPED;
				this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			if (this.debug) this.logDebug("seek: " + seconds);
			
			if (this.status == PlayerStatus.PLAYING && this._movieClip)
			{
				this._movieClip.gotoAndPlay(this.secondsToFrame(seconds));
			}
			else if (this._movieClip) 
			{
				this._movieClip.gotoAndStop(this.secondsToFrame(seconds));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			return this._movieClip ? this.frameToSeconds(this._movieClip.currentFrame) : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return this._movieClip ? this.frameToSeconds(this._movieClip.totalFrames) : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			return this._movieClip ? this._movieClip.currentFrame / this._movieClip.totalFrames : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return this._autoRewind;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoRewind(value:Boolean):void
		{
			this._autoRewind = value;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			if (this.debug) this.logDebug("pause: ");
			if (this._movieClip) this._movieClip.stop();
			if (this._status != PlayerStatus.PAUSED)
			{
				this._status = PlayerStatus.PAUSED;
				this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
			}
				
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (this.debug) this.logDebug("resume: ");
			if (this._movieClip) this._movieClip.play();
			if (this._status != PlayerStatus.PLAYING)
			{
				this._status = PlayerStatus.PLAYING;
				this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return this._status == PlayerStatus.PAUSED;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return this._status;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return this._volume;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			this._volume = value;
			
			if (this._movieClip)
			{
				var soundTransform:SoundTransform = this._movieClip.soundTransform;
				soundTransform.volume = this._volume;
				this._movieClip.soundTransform = soundTransform;
				this.dispatchEvent(new SoundEvent(SoundEvent.VOLUME_CHANGE));
			}
		}
		
		public function get frameRate():Number
		{
			return !isNaN(this._frameRate) ? this._frameRate : (this._movieClip && this._movieClip.stage ? this._movieClip.stage.frameRate : 31);
		}
		
		public function set frameRate(value:Number):void
		{
			this._frameRate = value;
		}
		
		/**
		 * A Boolean which indicates if the frame rate of the stage is used, rather then a custom frame rate.
		 */
		public function get useStageFrameRate():Boolean
		{
			return isNaN(this._frameRate);
		}

		/**
		 * @private
		 */
		public function set useStageFrameRate(value:Boolean):void
		{
			this._frameRate = value ? NaN : 31;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (this._movieClip && this._movieClip.currentFrame == this._movieClip.totalFrames && this.status == PlayerStatus.PLAYING)
			{
				this.stop();
				this.dispatchEvent(new PlayerEvent(PlayerEvent.COMPLETE));
				if (this._autoRewind) this._movieClip.gotoAndStop(1);
			}
		}

		private function frameToSeconds(frame:uint):Number
		{
			return (frame - 1) / this.frameRate;
		}

		private function secondsToFrame(seconds:Number):uint
		{
			return Math.round(1 + seconds * this.frameRate);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._movieClip)
			{
				this._movieClip.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this._movieClip = null;
			}
			this._status = null;
			
			super.destruct();
		}
	}
}
