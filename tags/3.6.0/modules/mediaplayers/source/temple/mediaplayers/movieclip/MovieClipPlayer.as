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
		
		public function MovieClipPlayer(movieClip:MovieClip = null, status:String = null)
		{
			this.movieClip = movieClip;
			_status = status;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get movieClip():MovieClip
		{
			return _movieClip;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set movieClip(value:MovieClip):void
		{
			if (_movieClip) _movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			_movieClip = value;
			if (_movieClip)
			{
				_movieClip.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
				this.volume = _volume;
			}
			_status = PlayerStatus.PAUSED;
		}
		
		/**
		 * @inheritDoc
		 */
		public function goto(frame:Object, scene:String = null):void
		{
			if (_movieClip)
			{
				if (status == PlayerStatus.PLAYING && _movieClip)
				{
					_movieClip.gotoAndPlay(frame, scene);
				}
				else if (_movieClip) 
				{
					_movieClip.gotoAndStop(frame, scene);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isPlaying():Boolean
		{
			return _status == PlayerStatus.PLAYING;
		}

		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			if (debug) logDebug("play: ");
			if (_movieClip) _movieClip.gotoAndPlay(1);
			if (_status != PlayerStatus.PLAYING)
			{
				_status = PlayerStatus.PLAYING;
				dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
				dispatchEvent(new PlayerEvent(PlayerEvent.PLAY_STARTED));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			if (debug) logDebug("stop: ");
			if (_movieClip) _movieClip.stop();
			if (_status != PlayerStatus.STOPPED)
			{
				_status = PlayerStatus.STOPPED;
				dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			if (debug) logDebug("seek: " + seconds);
			
			if (status == PlayerStatus.PLAYING && _movieClip)
			{
				_movieClip.gotoAndPlay(secondsToFrame(seconds));
			}
			else if (_movieClip) 
			{
				_movieClip.gotoAndStop(secondsToFrame(seconds));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			return _movieClip ? frameToSeconds(_movieClip.currentFrame) : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return _movieClip ? frameToSeconds(_movieClip.totalFrames) : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			return _movieClip ? _movieClip.currentFrame / _movieClip.totalFrames : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return _autoRewind;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoRewind(value:Boolean):void
		{
			_autoRewind = value;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			if (debug) logDebug("pause: ");
			if (_movieClip) _movieClip.stop();
			if (_status != PlayerStatus.PAUSED)
			{
				_status = PlayerStatus.PAUSED;
				dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
			}
				
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (debug) logDebug("resume: ");
			if (_movieClip) _movieClip.play();
			if (_status != PlayerStatus.PLAYING)
			{
				_status = PlayerStatus.PLAYING;
				dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get isPaused():Boolean
		{
			return _status == PlayerStatus.PAUSED;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return _status;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return _volume;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			_volume = value;
			
			if (_movieClip)
			{
				var soundTransform:SoundTransform = _movieClip.soundTransform;
				soundTransform.volume = _volume;
				_movieClip.soundTransform = soundTransform;
				dispatchEvent(new SoundEvent(SoundEvent.VOLUME_CHANGE));
			}
		}
		
		public function get frameRate():Number
		{
			return !isNaN(_frameRate) ? _frameRate : (_movieClip && _movieClip.stage ? _movieClip.stage.frameRate : 31);
		}
		
		public function set frameRate(value:Number):void
		{
			_frameRate = value;
		}
		
		/**
		 * A Boolean which indicates if the frame rate of the stage is used, rather then a custom frame rate.
		 */
		public function get useStageFrameRate():Boolean
		{
			return isNaN(_frameRate);
		}

		/**
		 * @private
		 */
		public function set useStageFrameRate(value:Boolean):void
		{
			_frameRate = value ? NaN : 31;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (_movieClip && _movieClip.currentFrame == _movieClip.totalFrames && status == PlayerStatus.PLAYING)
			{
				stop();
				dispatchEvent(new PlayerEvent(PlayerEvent.COMPLETE));
				if (_autoRewind) _movieClip.gotoAndStop(1);
			}
		}

		private function frameToSeconds(frame:uint):Number
		{
			return (frame - 1) / frameRate;
		}

		private function secondsToFrame(seconds:Number):uint
		{
			return Math.round(1 + seconds * frameRate);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_movieClip)
			{
				_movieClip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				_movieClip = null;
			}
			_status = null;
			
			super.destruct();
		}
	}
}
