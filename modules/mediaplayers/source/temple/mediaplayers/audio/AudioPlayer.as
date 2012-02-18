/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
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
			this._debug = debug;
			
			this.toStringProps.push("url", "volume");
		}

		/**
		 * Loads an audio file and starts playing when ready
		 */
		public function playUrl(url:String):void
		{
			if (this._debug) this.logDebug("playAudio: " + url);
			
			this._playWhenLoaded = true;
			this.loadUrl(url);
		}

		/**
		 * Loads an audio file
		 */
		public function loadUrl(url:String):void
		{
			if (this._debug) this.logDebug("loadAudio: " + url);
			
			this._status = PlayerStatus.PAUSED;
			
			if (this._sound)
			{
				this._sound.removeEventListener(Event.COMPLETE, this.handleSoundComplete);
				this._sound.removeEventListener(IOErrorEvent.IO_ERROR, this.handleIOErrorEvent);
			}
			this._position = 0;
			this._sound = new Sound();
			this._sound.addEventListener(Event.COMPLETE, this.handleSoundComplete);
			this._sound.addEventListener(IOErrorEvent.IO_ERROR, this.handleIOErrorEvent);
			this._sound.load(new URLRequest(url));
			
			this._url = url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return this._url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			if (this._debug) this.logDebug("play: ");
			
			this.clearSoundChannel();
			
			if (this._sound.length)
			{
				this._soundChannel = this._sound.play();
				this._soundChannel.addEventListener(Event.SOUND_COMPLETE, this.handleSoundChannelComplete);
				this.updateVolume();
				this._status = PlayerStatus.PLAYING;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			if (this._debug) this.logDebug("pause: ");
			
			this._position = this._soundChannel ? this._soundChannel.position : 0;
			if (this._soundChannel) this._soundChannel.stop();
			this._status = PlayerStatus.PAUSED;
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			if (this._debug) this.logDebug("resume: status = " + this.__status);
			
			if (this.__status != PlayerStatus.PLAYING)
			{
				this.clearSoundChannel();
				
				if (this._sound.length)
				{
					this._soundChannel = this._sound.play(this._position);
					this._soundChannel.addEventListener(Event.SOUND_COMPLETE, this.handleSoundChannelComplete);
					this.updateVolume();
					this._status = PlayerStatus.PLAYING;
				}
				this._playWhenLoaded = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return this.__status == PlayerStatus.PAUSED;
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			if (this._debug) this.logDebug("stop: ");
			
			this.clearSoundChannel();
			this._status = PlayerStatus.STOPPED;
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			if (this._debug) this.logDebug("seek: " + seconds);
			
			if (this._sound)
			{
				if (this.__status == PlayerStatus.PLAYING)
				{
					this.clearSoundChannel();
					this._soundChannel = this._sound.play(seconds * 1000);
					this._soundChannel.addEventListener(Event.SOUND_COMPLETE, this.handleSoundChannelComplete);
					this.updateVolume();
				}
				else
				{
					this._position = seconds * 1000;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return this.__status;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			switch (this.__status)
			{
				case PlayerStatus.PLAYING:
					return this._soundChannel ? this._soundChannel.position * 0.001 : 0;
					break;
				
				case PlayerStatus.PAUSED:
					return this._position * 0.001;
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
			if (this._sound == null) return NaN;
			
			if (this._sound.bytesLoaded != this._sound.bytesTotal) return (this._sound.length * 0.001) * (this._sound.bytesTotal / this._sound.bytesLoaded);
			
			return this._sound.length * 0.001;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			if (isNaN(this.duration) && this._sound)
			{
				return this.currentPlayTime / ((this._sound.length * 0.001) * (this._sound.bytesTotal / this._sound.bytesLoaded));
			}
			
			return this.currentPlayTime / this.duration;
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
			
			if (this._debug) this.logDebug("autoRewind: " + this._autoRewind);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint
		{
			return this._sound ? this._sound.bytesLoaded : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint
		{
			return this._sound ? this._sound.bytesTotal : 0;
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
			return this._volume;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			if (this._debug) this.logDebug("volume: " + value);
			
			if (this._volume != value)
			{
				this._volume = value;
				
				this.updateVolume();
				this.dispatchEvent(new SoundEvent(SoundEvent.VOLUME_CHANGE));
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
		
		private function updateVolume():void
		{
			if (this._soundChannel == null) return;
			
			var st:SoundTransform = this._soundChannel.soundTransform;
			
			st.volume = this._volume;
			
			this._soundChannel.soundTransform = st;
		}
		
		private function set _status(value:String):void
		{
			if (this.__status != value)
			{
				this.__status = value;
				this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this.__status));
			}
		}
		
		private function handleSoundComplete(event:Event):void
		{
			if (this._debug) this.logDebug("handleSoundComplete: ");
			if (this._playWhenLoaded) this.play();
		}
		
		private function handleSoundChannelComplete(event:Event):void
		{
			if (this._debug) this.logDebug("handleSoundChannelComplete: ");
			if (this._autoRewind)
			{
				this.seek(0);
				this.pause();
			}
			else
			{
				this.stop();
			}
		}
		
		private function clearSoundChannel():void
		{
			if (this._soundChannel)
			{
				this._soundChannel.stop();
				this._soundChannel.removeEventListener(Event.SOUND_COMPLETE, this.handleSoundChannelComplete);
				this._soundChannel = null;
			}
		}
		
		private function handleIOErrorEvent(event:IOErrorEvent):void
		{
			this.logError("handleIOErrorEvent: " + event.text);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._sound)
			{
				this._sound.removeEventListener(Event.COMPLETE, this.handleSoundComplete);
				this._sound = null;
			}
			this.clearSoundChannel();
			
			super.destruct();
		}
	}
}
