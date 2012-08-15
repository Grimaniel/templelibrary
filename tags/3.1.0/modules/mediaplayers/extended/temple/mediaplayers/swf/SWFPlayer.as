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

package temple.mediaplayers.swf
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import temple.common.events.SoundEvent;
	import temple.common.events.StatusEvent;
	import temple.common.interfaces.IAudible;
	import temple.core.debug.IDebuggable;
	import temple.data.cache.CacheLoader;
	import temple.mediaplayers.movieclip.IMovieClipPlayer;
	import temple.mediaplayers.movieclip.MovieClipPlayer;
	import temple.mediaplayers.players.IProgressiveDownloadPlayer;
	import temple.mediaplayers.players.PlayerEvent;
	import temple.mediaplayers.players.PlayerStatus;

	/**
	 * Class for playing SWF files as if they are video files.
	 * 
	 * @author Thijs Broerse
	 */
	public class SWFPlayer extends CacheLoader implements IProgressiveDownloadPlayer, IDebuggable, IAudible, IMovieClipPlayer
	{
		private var _movieClipPlayer:MovieClipPlayer;
		private var _playWhenReady:Boolean;
		private var _bufferTime:Number = 30;
		private var _isBuffering:Boolean;
		
		public function SWFPlayer(logErrors:Boolean = true, cache:Boolean = false)
		{
			super(logErrors, cache);
			
			this._movieClipPlayer = new MovieClipPlayer();
			this._movieClipPlayer.addEventListener(StatusEvent.STATUS_CHANGE, this.handleMovieClipPlayerStatusChange);
			this._movieClipPlayer.addEventListener(PlayerEvent.PLAY_STARTED, this.dispatchEvent);
			this._movieClipPlayer.addEventListener(SoundEvent.VOLUME_CHANGE, this.dispatchEvent);
			this.addEventListener(Event.INIT, this.handleInit);
			this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
		}

		/**
		 * Returns a reference to the loaded SWF
		 */
		public function get swf():MovieClip
		{
			return this.content as MovieClip;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			this._movieClipPlayer.pause();
			this._playWhenReady = false;
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (!this._isBuffering) this._movieClipPlayer.resume();
			this._playWhenReady = true;
		}

		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return this._movieClipPlayer.paused;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return this._isBuffering ? PlayerStatus.LOADING : this._movieClipPlayer.status;
		}

		/**
		 * @inheritDoc
		 */
		public function loadUrl(url:String):void
		{
			this._playWhenReady = false;
			this.load(new URLRequest(url));
		}

		/**
		 * @inheritDoc
		 */
		public function playUrl(url:String):void
		{
			this._playWhenReady = true;
			this.load(new URLRequest(url));
		}

		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			if (!this._isBuffering) this._movieClipPlayer.play();
			this._playWhenReady = true;
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			this._movieClipPlayer.stop();
			this._playWhenReady = false;
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			this._movieClipPlayer.seek(seconds);
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			return this._movieClipPlayer.currentPlayTime;
		}

		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return this._movieClipPlayer.duration;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			return this._movieClipPlayer.currentPlayFactor;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return this._movieClipPlayer.autoRewind;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoRewind(value:Boolean):void
		{
			this._movieClipPlayer.autoRewind = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bufferLength():Number
		{
			return this.swf ? this.swf.framesLoaded - this.swf.currentFrame : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bufferTime():Number
		{
			return this._bufferTime;
		}

		/**
		 * @inheritDoc
		 */
		public function set bufferTime(value:Number):void
		{
			this._bufferTime = value;
		}
		
		/**
		 * Indicates if the SWF player is currenlty buffering
		 */
		public function get isBuffering():Boolean
		{
			return this._isBuffering;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return this._movieClipPlayer.volume;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			this._movieClipPlayer.volume = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get frameRate():Number
		{
			return this._movieClipPlayer.frameRate;
		}

		/**
		 * @inheritDoc
		 */
		public function set frameRate(value:Number):void
		{
			this._movieClipPlayer.frameRate = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get useStageFrameRate():Boolean
		{
			return this._movieClipPlayer.useStageFrameRate;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set useStageFrameRate(value:Boolean):void
		{
			this._movieClipPlayer.useStageFrameRate = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get movieClip():MovieClip
		{
			return this._movieClipPlayer.movieClip;
		}

		/**
		 * @inheritDoc
		 */
		public function set movieClip(value:MovieClip):void
		{
			this._movieClipPlayer.movieClip = value;
		}

		/**
		 * @inheritDoc
		 */
		public function goto(frame:Object, scene:String = null):void
		{
			this._movieClipPlayer.goto(frame, scene);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set debug(value:Boolean):void
		{
			this._movieClipPlayer.debug = super.debug = value;
		}
		
		private function handleInit(event:Event):void
		{
			this._movieClipPlayer.movieClip = this.content as MovieClip;
			if (this._playWhenReady) this._movieClipPlayer.play();
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (this.isLoaded && this._isBuffering)
			{
				this._isBuffering = false;
				if (this._playWhenReady) this.resume();
			}
			else if (this.isLoading)
			{
				var buffering:Boolean = this._isBuffering;
				
				this._isBuffering = this.bufferLength && this.bufferLength < this.bufferTime;
				
				if (buffering != this._isBuffering)
				{
					if (this._isBuffering)
					{
						this._movieClipPlayer.pause();
					}
					else if (this._playWhenReady)
					{
						this._movieClipPlayer.resume();
					}
					else
					{
						this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this.status));
					}
				}
			}
		}
		
		private function handleMovieClipPlayerStatusChange(event:StatusEvent):void
		{
			this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this.status));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._movieClipPlayer)
			{
				this._movieClipPlayer.destruct();
				this._movieClipPlayer = null;
			}
			
			super.destruct();
		}
	}
}
