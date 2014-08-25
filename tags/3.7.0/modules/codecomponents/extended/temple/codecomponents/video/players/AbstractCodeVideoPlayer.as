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

package temple.codecomponents.video.players
{
	import temple.codecomponents.players.controls.CodePlayerControls;
	import temple.common.events.SoundEvent;
	import temple.common.events.StatusEvent;
	import temple.core.debug.IDebuggable;
	import temple.mediaplayers.players.PlayerEvent;
	import temple.mediaplayers.video.metadata.VideoMetaData;
	import temple.mediaplayers.video.metadata.VideoMetaDataEvent;
	import temple.mediaplayers.video.players.IVideoPlayer;
	import temple.mediaplayers.video.players.VideoPlayerEvent;
	import temple.ui.layout.liquid.LiquidContainer;

	import flash.display.DisplayObject;
	import flash.events.NetStatusEvent;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractCodeVideoPlayer extends LiquidContainer implements IVideoPlayer, IDebuggable
	{
		private var _controls:CodePlayerControls;
		private var _videoPlayer:IVideoPlayer;

		public function AbstractCodeVideoPlayer(videoPlayer:IVideoPlayer, width:Number = 400, height:Number = 300)
		{
			super(width, height);
			
			_videoPlayer = videoPlayer;
			_videoPlayer.addEventListener(VideoPlayerEvent.BUFFER_EMPTY, dispatchEvent);
			_videoPlayer.addEventListener(VideoPlayerEvent.BUFFER_FLUSH, dispatchEvent);
			_videoPlayer.addEventListener(VideoPlayerEvent.MOVIE_NOTFOUND, dispatchEvent);
			_videoPlayer.addEventListener(VideoPlayerEvent.SECURITY_ERROR, dispatchEvent);
			_videoPlayer.addEventListener(VideoPlayerEvent.SEEK_INVALID, dispatchEvent);
			_videoPlayer.addEventListener(VideoPlayerEvent.MOVIE_LOADED, dispatchEvent);
			_videoPlayer.addEventListener(VideoPlayerEvent.SEEK_NOTIFY, dispatchEvent);
			_videoPlayer.addEventListener(VideoPlayerEvent.LOAD_READY, dispatchEvent);
			_videoPlayer.addEventListener(StatusEvent.STATUS_CHANGE, dispatchEvent);
			_videoPlayer.addEventListener(SoundEvent.VOLUME_CHANGE, dispatchEvent);
			_videoPlayer.addEventListener(PlayerEvent.COMPLETE, dispatchEvent);
			_videoPlayer.addEventListener(PlayerEvent.SEEK_NOTIFY, dispatchEvent);
			_videoPlayer.addEventListener(NetStatusEvent.NET_STATUS, dispatchEvent);
			_videoPlayer.addEventListener(VideoMetaDataEvent.METADATA, dispatchEvent);
			
			addChild(DisplayObject(_videoPlayer));
			
			_controls = new CodePlayerControls(_videoPlayer);
			_controls.left = 0;
			_controls.right = 0;
			_controls.bottom = 0;
			
			addChild(_controls);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get isPlaying():Boolean
		{
			return _videoPlayer.isPlaying;
		}

		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			_videoPlayer.play();
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			_videoPlayer.stop();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			super.width = _videoPlayer.width = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			super.height = _videoPlayer.height = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get videoPath():String
		{
			return _videoPlayer.videoPath;
		}

		/**
		 * @inheritDoc
		 */
		public function set videoPath(value:String):void
		{
			_videoPlayer.videoPath = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get videoMetaData():VideoMetaData
		{
			return _videoPlayer.videoMetaData;
		}

		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_videoPlayer.clear();
		}

		/**
		 * @inheritDoc
		 */
		public function get smoothing():Boolean
		{
			return _videoPlayer.smoothing;
		}

		/**
		 * @inheritDoc
		 */
		public function set smoothing(value:Boolean):void
		{
			_videoPlayer.smoothing = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get rtmpConnection():String
		{
			return _videoPlayer.rtmpConnection;
		}

		/**
		 * @inheritDoc
		 */
		public function set rtmpConnection(value:String):void
		{
			_videoPlayer.rtmpConnection = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint
		{
			return _videoPlayer.bytesLoaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint
		{
			return _videoPlayer.bytesTotal;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferLength():Number
		{
			return _videoPlayer.bufferLength;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferTime():Number
		{
			return _videoPlayer.bufferTime;
		}

		/**
		 * @inheritDoc
		 */
		public function set bufferTime(value:Number):void
		{
			_videoPlayer.bufferTime = value;
		}

		/**
		 * @inheritDoc
		 */
		public function loadUrl(url:String):void
		{
			_videoPlayer.loadUrl(url);
		}

		/**
		 * @inheritDoc
		 */
		public function playUrl(url:String):void
		{
			_videoPlayer.playUrl(url);
		}

		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return _videoPlayer.url;
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			_videoPlayer.seek(seconds);
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			return _videoPlayer.currentPlayTime;
		}

		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return _videoPlayer.duration;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			return _videoPlayer.currentPlayFactor;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return _videoPlayer.autoRewind;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoRewind(value:Boolean):void
		{
			_videoPlayer.autoRewind = value;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			_videoPlayer.pause();
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			_videoPlayer.resume();
		}

		/**
		 * @inheritDoc
		 */
		public function get isPaused():Boolean
		{
			return _videoPlayer.isPaused;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return _videoPlayer.status;
		}

		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return _videoPlayer.volume;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			_videoPlayer.volume = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get videoWidth():Number
		{
			return _videoPlayer.videoWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function get videoHeight():Number
		{
			return _videoPlayer.videoHeight;
		}
		
		/**
		 * returns a reference to the actual player
		 */
		public function get videoPlayer():IVideoPlayer
		{
			return _videoPlayer;
		}
		
		/***
		 * @inheritDoc
		 */
		override public function get scaleMode():String
		{
			return _videoPlayer.scaleMode;
		}
		
		/***
		 * @inheritDoc
		 */
		override public function set scaleMode(value:String):void
		{
			_videoPlayer.scaleMode = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_videoPlayer.debug = value;
		}
	}
}
