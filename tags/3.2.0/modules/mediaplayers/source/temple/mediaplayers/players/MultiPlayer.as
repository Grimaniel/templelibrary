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

package temple.mediaplayers.players
{
	import temple.common.events.SoundEvent;
	import temple.common.events.StatusEvent;
	import temple.common.interfaces.IAudible;
	import temple.core.debug.IDebuggable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.utils.types.ArrayUtils;

	/**
	 * @author Thijs Broerse
	 */
	public class MultiPlayer extends CoreEventDispatcher implements IProgressiveDownloadPlayer, IAudible, IDebuggable
	{
		private var _primaryPlayer:IPlayer;
		private var _players:Array;
		private var _debug:Boolean;
		
		public function MultiPlayer(primaryPlayer:IPlayer)
		{
			this._primaryPlayer = primaryPlayer;
			this._players = [this._primaryPlayer];
			
			this._primaryPlayer.addEventListener(StatusEvent.STATUS_CHANGE, this.handlePrimaryPlayerStatusChange);
			this._primaryPlayer.addEventListener(PlayerEvent.PLAY_STARTED, this.dispatchEvent);
			this._primaryPlayer.addEventListener(PlayerEvent.SEEK_NOTIFY, this.handleSeek);
			this._primaryPlayer.addEventListener(SoundEvent.VOLUME_CHANGE, this.handleVolumeChange);
		}

		/**
		 * Add an IPlayer to the MultiPlayer
		 */
		public function add(player:IPlayer):void
		{
			this._players.push(player);
		}

		/**
		 * Remove an IPlayer to the MultiPlayer
		 */
		public function remove(player:IPlayer):void
		{
			ArrayUtils.removeValueFromArray(this._players, player);
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			for each (var player : IPlayer in this._players)
			{
				player.pause();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			for each (var player : IPlayer in this._players)
			{
				player.resume();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return this._primaryPlayer.paused;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return this._primaryPlayer.status;
		}

		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			for each (var player : IPlayer in this._players)
			{
				player.play();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			for each (var player : IPlayer in this._players)
			{
				player.stop();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			for each (var player : IPlayer in this._players)
			{
				player.seek(seconds);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			return this._primaryPlayer.currentPlayTime;
		}

		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return this._primaryPlayer.duration;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			return this._primaryPlayer.currentPlayFactor;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return this._primaryPlayer.autoRewind;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoRewind(value:Boolean):void
		{
			for each (var player : IPlayer in this._players)
			{
				player.autoRewind = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint
		{
			var bytesLoaded:uint;
			for each (var player : IPlayer in this._players)
			{
				if (player is IProgressiveDownloadPlayer) bytesLoaded += (player as IProgressiveDownloadPlayer).bytesLoaded;
			}
			return bytesLoaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint
		{
			var bytesTotal:uint;
			for each (var player : IPlayer in this._players)
			{
				if (player is IProgressiveDownloadPlayer) bytesTotal += (player as IProgressiveDownloadPlayer).bytesTotal;
			}
			return bytesTotal;
		}

		/**
		 * @private
		 */
		public function loadUrl(url:String):void
		{
			throwError(new TempleError(this, "loadURL not used for a MultiPlayer"));
		}

		/**
		 * @private
		 */
		public function playUrl(url:String):void
		{
			throwError(new TempleError(this, "playURL not used for a MultiPlayer"));
		}

		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			throwError(new TempleError(this, "url not used for a MultiPlayer"));
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bufferLength():Number
		{
			return this._primaryPlayer is IProgressiveDownloadPlayer ? IProgressiveDownloadPlayer(this._primaryPlayer).bufferLength : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferTime():Number
		{
			return this._primaryPlayer is IProgressiveDownloadPlayer ? IProgressiveDownloadPlayer(this._primaryPlayer).bufferTime : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set bufferTime(value:Number):void
		{
			throwError(new TempleError(this, "bufferTime can not be set on a MultiPlayer"));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return this._primaryPlayer is IAudible ? IAudible(this._primaryPlayer).volume : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			for each (var player : IPlayer in this._players)
			{
				if (player is IAudible) (player as IAudible).volume = value;
			}
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
		
		private function handlePrimaryPlayerStatusChange(event:StatusEvent):void
		{
			if (this.debug) this.logDebug("handlePrimaryPlayerStatusChange: " + event.status);
			
			var player : IPlayer;
			switch (event.status)
			{
				case PlayerStatus.LOADING:
				{
					for each (player in this._players) if (player != this._primaryPlayer) player.pause();
					break;
				}
				case PlayerStatus.PAUSED:
				{
					for each (player in this._players) if (player != this._primaryPlayer) player.pause();
					break;
				}
				case PlayerStatus.PLAYING:
				{
					for each (player in this._players) if (player != this._primaryPlayer) player.resume();
					break;
				}
				case PlayerStatus.STOPPED:
				{
					for each (player in this._players) if (player != this._primaryPlayer) player.stop();
					break;
				}
				default:
				{
					throwError(new TempleError(this, "Unknown status: '" + event.status + "'"));
					break;
				}
			}
			this.dispatchEvent(event.clone());
		}
		
		private function handleVolumeChange(event:SoundEvent):void
		{
			if (this.debug) this.logDebug("handleVolumeChange: ");
			
			if (this._primaryPlayer is IAudible)
			{
				for each (var player : IPlayer in this._players) if (player != this._primaryPlayer && player is IAudible) IAudible(player).volume = IAudible(this._primaryPlayer).volume;
			}
			
			this.dispatchEvent(event.clone());
		}
		
		private function handleSeek(event:PlayerEvent):void
		{
			if (this.debug) this.logDebug("handleSeek: " + this._primaryPlayer.currentPlayTime);
			
			for each (var player : IPlayer in this._players) if (player != this._primaryPlayer) player.seek(this._primaryPlayer.currentPlayTime);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._primaryPlayer)
			{
				this._primaryPlayer.removeEventListener(StatusEvent.STATUS_CHANGE, this.dispatchEvent);
				this._primaryPlayer.removeEventListener(PlayerEvent.PLAY_STARTED, this.dispatchEvent);
				this._primaryPlayer.removeEventListener(SoundEvent.VOLUME_CHANGE, this.dispatchEvent);
				this._primaryPlayer = null;
			}
			if (this._players)
			{
				this._players.length = 0;
				this._players = null;
			}
			
			super.destruct();
		}
	}
}
