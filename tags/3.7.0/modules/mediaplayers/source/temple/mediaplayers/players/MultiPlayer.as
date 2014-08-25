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
	import temple.utils.types.VectorUtils;
	import temple.common.events.SoundEvent;
	import temple.common.events.StatusEvent;
	import temple.common.interfaces.IAudible;
	import temple.core.debug.IDebuggable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;

	/**
	 * @author Thijs Broerse
	 */
	public class MultiPlayer extends CoreEventDispatcher implements IProgressiveDownloadPlayer, IAudible, IDebuggable
	{
		private var _primaryPlayer:IPlayer;
		private var _players:Vector.<IPlayer>;
		private var _debug:Boolean;
		
		public function MultiPlayer(primaryPlayer:IPlayer)
		{
			_primaryPlayer = primaryPlayer;
			_players = Vector.<IPlayer>([_primaryPlayer]);
			
			_primaryPlayer.addEventListener(StatusEvent.STATUS_CHANGE, handlePrimaryPlayerStatusChange);
			_primaryPlayer.addEventListener(PlayerEvent.PLAY_STARTED, dispatchEvent);
			_primaryPlayer.addEventListener(PlayerEvent.SEEK_NOTIFY, handleSeek);
			_primaryPlayer.addEventListener(SoundEvent.VOLUME_CHANGE, handleVolumeChange);
		}

		/**
		 * Add an IPlayer to the MultiPlayer
		 */
		public function add(player:IPlayer):void
		{
			_players.push(player);
		}

		/**
		 * Remove an IPlayer to the MultiPlayer
		 */
		public function remove(player:IPlayer):void
		{
			VectorUtils.removeValueFromVector(_players, player);
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			for each (var player : IPlayer in _players)
			{
				player.pause();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			for each (var player : IPlayer in _players)
			{
				player.resume();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get isPaused():Boolean
		{
			return _primaryPlayer.isPaused;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return _primaryPlayer.status;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isPlaying():Boolean
		{
			return _primaryPlayer && _primaryPlayer.isPlaying;
		}

		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			for each (var player : IPlayer in _players)
			{
				player.play();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			for each (var player : IPlayer in _players)
			{
				player.stop();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			for each (var player : IPlayer in _players)
			{
				player.seek(seconds);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			return _primaryPlayer.currentPlayTime;
		}

		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return _primaryPlayer.duration;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			return _primaryPlayer.currentPlayFactor;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return _primaryPlayer.autoRewind;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoRewind(value:Boolean):void
		{
			for each (var player : IPlayer in _players)
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
			for each (var player : IPlayer in _players)
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
			for each (var player : IPlayer in _players)
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
			return _primaryPlayer is IProgressiveDownloadPlayer ? IProgressiveDownloadPlayer(_primaryPlayer).bufferLength : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferTime():Number
		{
			return _primaryPlayer is IProgressiveDownloadPlayer ? IProgressiveDownloadPlayer(_primaryPlayer).bufferTime : NaN;
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
			return _primaryPlayer is IAudible ? IAudible(_primaryPlayer).volume : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			for each (var player : IPlayer in _players)
			{
				if (player is IAudible) (player as IAudible).volume = value;
			}
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
		
		private function handlePrimaryPlayerStatusChange(event:StatusEvent):void
		{
			if (debug) logDebug("handlePrimaryPlayerStatusChange: " + event.status);
			
			var player : IPlayer;
			switch (event.status)
			{
				case PlayerStatus.LOADING:
				{
					for each (player in _players) if (player != _primaryPlayer) player.pause();
					break;
				}
				case PlayerStatus.PAUSED:
				{
					for each (player in _players) if (player != _primaryPlayer) player.pause();
					break;
				}
				case PlayerStatus.PLAYING:
				{
					for each (player in _players) if (player != _primaryPlayer) player.resume();
					break;
				}
				case PlayerStatus.STOPPED:
				{
					for each (player in _players) if (player != _primaryPlayer) player.stop();
					break;
				}
				default:
				{
					throwError(new TempleError(this, "Unknown status: '" + event.status + "'"));
					break;
				}
			}
			dispatchEvent(event.clone());
		}
		
		private function handleVolumeChange(event:SoundEvent):void
		{
			if (debug) logDebug("handleVolumeChange: ");
			
			if (_primaryPlayer is IAudible)
			{
				for each (var player : IPlayer in _players) if (player != _primaryPlayer && player is IAudible) IAudible(player).volume = IAudible(_primaryPlayer).volume;
			}
			
			dispatchEvent(event.clone());
		}
		
		private function handleSeek(event:PlayerEvent):void
		{
			if (debug) logDebug("handleSeek: " + _primaryPlayer.currentPlayTime);
			
			for each (var player : IPlayer in _players) if (player != _primaryPlayer) player.seek(_primaryPlayer.currentPlayTime);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_primaryPlayer)
			{
				_primaryPlayer.removeEventListener(StatusEvent.STATUS_CHANGE, dispatchEvent);
				_primaryPlayer.removeEventListener(PlayerEvent.PLAY_STARTED, dispatchEvent);
				_primaryPlayer.removeEventListener(SoundEvent.VOLUME_CHANGE, dispatchEvent);
				_primaryPlayer = null;
			}
			if (_players)
			{
				_players.length = 0;
				_players = null;
			}
			
			super.destruct();
		}
	}
}
