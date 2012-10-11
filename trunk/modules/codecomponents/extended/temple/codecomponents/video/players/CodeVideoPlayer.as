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
	import temple.core.debug.IDebuggable;
	import temple.codecomponents.players.controls.CodePlayerControls;
	import temple.common.enum.ScaleMode;
	import temple.mediaplayers.video.metadata.VideoMetaData;
	import temple.mediaplayers.video.players.IVideoPlayer;
	import temple.mediaplayers.video.players.VideoPlayer;
	import temple.ui.layout.liquid.LiquidContainer;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeVideoPlayer extends LiquidContainer implements IVideoPlayer, IDebuggable
	{
		private var _controls:CodePlayerControls;
		private var _videoPlayer:VideoPlayer;
		
		public function CodeVideoPlayer(width:Number = 400, height:Number = 300, smoothing:Boolean = false, scaleMode:String = ScaleMode.EXACT_FIT, debug:Boolean = false)
		{
			super(width, height);
			
			this.background = true;
			
			this._videoPlayer = new VideoPlayer(width, height, smoothing, scaleMode, debug);
			
			this.addChild(this._videoPlayer);
			
			this._controls = new CodePlayerControls(this._videoPlayer);
			this._controls.left = 0;
			this._controls.right = 0;
			this._controls.bottom = 0;
			
			this.addChild(this._controls);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			super.width = this._videoPlayer.width = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			super.height = this._videoPlayer.height = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get videoPath():String
		{
			return this._videoPlayer.videoPath;
		}

		/**
		 * @inheritDoc
		 */
		public function set videoPath(value:String):void
		{
			this._videoPlayer.videoPath = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get metaData():VideoMetaData
		{
			return this._videoPlayer.metaData;
		}

		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			this._videoPlayer.clear();
		}

		/**
		 * @inheritDoc
		 */
		public function get smoothing():Boolean
		{
			return this._videoPlayer.smoothing;
		}

		/**
		 * @inheritDoc
		 */
		public function set smoothing(value:Boolean):void
		{
			this._videoPlayer.smoothing = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get rtmpConnection():String
		{
			return this._videoPlayer.rtmpConnection;
		}

		/**
		 * @inheritDoc
		 */
		public function set rtmpConnection(value:String):void
		{
			this._videoPlayer.rtmpConnection = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint
		{
			return this._videoPlayer.bytesLoaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint
		{
			return this._videoPlayer.bytesTotal;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferLength():Number
		{
			return this._videoPlayer.bufferLength;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferTime():Number
		{
			return this._videoPlayer.bufferTime;
		}

		/**
		 * @inheritDoc
		 */
		public function set bufferTime(value:Number):void
		{
			this._videoPlayer.bufferTime = value;
		}

		/**
		 * @inheritDoc
		 */
		public function loadUrl(url:String):void
		{
			this._videoPlayer.loadUrl(url);
		}

		/**
		 * @inheritDoc
		 */
		public function playUrl(url:String):void
		{
			this._videoPlayer.playUrl(url);
		}

		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return this._videoPlayer.url;
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number = 0):void
		{
			this._videoPlayer.seek();
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayTime():Number
		{
			return this._videoPlayer.currentPlayTime;
		}

		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return this._videoPlayer.duration;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number
		{
			return this._videoPlayer.currentPlayFactor;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoRewind():Boolean
		{
			return this._videoPlayer.autoRewind;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoRewind(value:Boolean):void
		{
			this._videoPlayer.autoRewind = value;
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			this._videoPlayer.pause();
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void
		{
			this._videoPlayer.resume();
		}

		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return this._videoPlayer.paused;
		}

		/**
		 * @inheritDoc
		 */
		public function get status():String
		{
			return this._videoPlayer.status;
		}

		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return this._videoPlayer.volume;
		}

		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void
		{
			this._videoPlayer.volume = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set debug(value:Boolean):void
		{
			this._videoPlayer.debug = super.debug = value;
		}
	}
}
