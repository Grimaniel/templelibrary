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

package temple.mediaplayers.audio 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import temple.common.events.SoundEvent;
	import temple.common.events.StatusEvent;
	import temple.common.interfaces.IAudible;
	import temple.common.interfaces.IHasStatus;
	import temple.core.debug.IDebuggable;
	import temple.core.events.CoreEventDispatcher;
	import temple.mediaplayers.players.IProgressiveDownloadPlayer;
	import temple.mediaplayers.players.PlayerStatus;


	/**
	 * Dispatched when the status is changed
	 * @eventType temple.status.StatusEvent.STATUS_CHANGE
	 */
	[Event(name = "StatusEvent.statusChange", type = "temple.common.events.StatusEvent")]
	
	/**
	 * @author Thijs Broerse
	 */
	public class AudioPlayer extends CoreEventDispatcher implements IProgressiveDownloadPlayer, IAudible, IDebuggable, IHasStatus
	{
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var __status:String;
		private var _playWhenLoaded:Boolean;
		private var _position:Number;
		private var _volume:Number = 1;
		private var _debug:Boolean;
		private var _autoRewind:Boolean;
		private var _url:String;

		public function AudioPlayer(debug:Boolean = false)
		{
			_debug = debug;
			
			toStringProps.push("url", "volume");
		}

		/**
		 * Loads an audio file and starts playing when ready
		 */
		public function playUrl(url:String):void
		{
			if (_debug) logDebug("playAudio: " + url);
			
			_playWhenLoaded = true;
			loadUrl(url);
		}

		/**
		 * Loads an audio file
		 */
		public function loadUrl(url:String):void
		{
			if (_debug) logDebug("loadAudio: " + url);
			
			_status = PlayerStatus.PAUSED;
			
			if (_sound)
			{
				_sound.removeEventListener(Event.COMPLETE, handleSoundComplete);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, handleIOErrorEvent);
			}
			_position = 0;
			_sound = new Sound();
			_sound.addEventListener(Event.COMPLETE, handleSoundComplete);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, handleIOErrorEvent);
			_sound.load(new URLRequest(url));
			
			_url = url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			if (_debug) logDebug("play: ");
			
			clearSoundChannel();
			
			if (_sound.length)
			{
				_soundChannel = _sound.play();
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, handleSoundChannelComplete);
				updateVolume();
				_status = PlayerStatus.PLAYING;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			if (_debug) logDebug("pause: ");
			
			_position = _soundChannel ? _soundChannel.position : 0;
			if (_soundChannel) _soundChannel.stop();
			_status = PlayerStatus.PAUSED;
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (_debug) logDebug("resume: status = " + __status);
			
			if (__status != PlayerStatus.PLAYING)
			{
				clearSoundChannel();
				
				if (_sound.length)
				{
					_soundChannel = _sound.play(_position);
					_soundChannel.addEventListener(Event.SOUND_COMPLETE, handleSoundChannelComplete);
					updateVolume();
					_status = PlayerStatus.PLAYING;
				}
				_playWhenLoaded = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return __status == PlayerStatus.PAUSED;
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			if (_debug) logDebug("stop: ");
			
			clearSoundChannel();
			_status = PlayerStatus.STOPPED;
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			if (_debug) logDebug("seek: " + seconds);
			
			if (_sound)
			{
				if (__status == PlayerStatus.PLAYING)
				{
					clearSoundChannel();
					_soundChannel = _sound.play(seconds * 1000);
					_soundChannel.addEventListener(Event.SOUND_COMPLETE, handleSoundChannelComplete);
					updateVolume();
				}
				else
				{
					_position = seconds * 1000;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return __status;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			switch (__status)
			{
				case PlayerStatus.PLAYING:
					return _soundChannel ? _soundChannel.position * 0.001 : 0;
					break;
				
				case PlayerStatus.PAUSED:
					return _position * 0.001;
					break;
				default:
					return 0;
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Returns NaN if audio is not completely loaded yet
		 */
		public function get duration():Number
		{
			if (_sound == null) return NaN;
			
			if (_sound.bytesLoaded != _sound.bytesTotal) return (_sound.length * 0.001) * (_sound.bytesTotal / _sound.bytesLoaded);
			
			return _sound.length * 0.001;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			if (isNaN(duration) && _sound)
			{
				return currentPlayTime / ((_sound.length * 0.001) * (_sound.bytesTotal / _sound.bytesLoaded));
			}
			
			return currentPlayTime / duration;
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
			
			if (_debug) logDebug("autoRewind: " + _autoRewind);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint
		{
			return _sound ? _sound.bytesLoaded : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint
		{
			return _sound ? _sound.bytesTotal : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bufferLength():Number
		{
			// TODO:
			return 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferTime():Number
		{
			// TODO:
			return 0;
		}

		/**
		 * @inheritDoc
		 */
		public function set bufferTime(value:Number):void
		{
			// TODO:
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
			if (_debug) logDebug("volume: " + value);
			
			if (_volume != value)
			{
				_volume = value;
				
				updateVolume();
				dispatchEvent(new SoundEvent(SoundEvent.VOLUME_CHANGE));
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
		
		private function updateVolume():void
		{
			if (_soundChannel == null) return;
			
			var st:SoundTransform = _soundChannel.soundTransform;
			
			st.volume = _volume;
			
			_soundChannel.soundTransform = st;
		}
		
		private function set _status(value:String):void
		{
			if (__status != value)
			{
				__status = value;
				dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, __status));
			}
		}
		
		private function handleSoundComplete(event:Event):void
		{
			if (_debug) logDebug("handleSoundComplete: ");
			if (_playWhenLoaded) play();
		}
		
		private function handleSoundChannelComplete(event:Event):void
		{
			if (_debug) logDebug("handleSoundChannelComplete: ");
			if (_autoRewind)
			{
				seek(0);
				pause();
			}
			else
			{
				stop();
			}
		}
		
		private function clearSoundChannel():void
		{
			if (_soundChannel)
			{
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, handleSoundChannelComplete);
				_soundChannel = null;
			}
		}
		
		private function handleIOErrorEvent(event:IOErrorEvent):void
		{
			logError("handleIOErrorEvent: " + event.text);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_sound)
			{
				_sound.removeEventListener(Event.COMPLETE, handleSoundComplete);
				_sound = null;
			}
			clearSoundChannel();
			
			super.destruct();
		}
	}
}
