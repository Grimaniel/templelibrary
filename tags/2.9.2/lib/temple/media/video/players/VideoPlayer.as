/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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

package temple.media.video.players 
{
	import temple.core.CoreSprite;
	import temple.data.loader.preload.IPreloader;
	import temple.debug.DebugManager;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.media.player.PlayerEvent;
	import temple.media.player.PlayerStatus;
	import temple.media.sound.SoundEvent;
	import temple.media.video.cuepoints.CuePointEvent;
	import temple.media.video.cuepoints.VideoCuePoint;
	import temple.media.video.metadata.VideoMetaData;
	import temple.media.video.metadata.VideoMetaDataEvent;
	import temple.media.video.net.NetStatusEventInfoCodes;
	import temple.media.video.net.VideoNetConnection;
	import temple.media.video.net.VideoNetStream;
	import temple.status.StatusEvent;
	import temple.ui.IHasBackground;
	import temple.ui.layout.ScaleMode;
	import temple.utils.FrameDelay;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.ObjectEncoding;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * Dispatched when the status is changed
	 * @eventType temple.status.StatusEvent.STATUS_CHANGE
	 */
	[Event(name = "StatusEvent.statusChange", type = "temple.status.StatusEvent")]
	
	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.BUFFER_EMPTY
	 */
	[Event(name = "VideoPlayerEvent.bufferEmpty", type = "temple.media.video.players.VideoPlayerEvent")]
	
	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.BUFFER_FLUSH
	 */
	[Event(name = "VideoPlayerEvent.bufferFlush", type = "temple.media.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.MOVIE_NOTFOUND
	 */
	[Event(name = "VideoPlayerEvent.movieNotFound", type = "temple.media.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.SECURITY_ERROR
	 */
	[Event(name = "VideoPlayerEvent.securityError", type = "temple.media.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.SEEK_INVALID
	 */
	[Event(name = "VideoPlayerEvent.seekInvalid", type = "temple.media.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.MOVIE_LOADED
	 */
	[Event(name = "VideoPlayerEvent.movieLoaded", type = "temple.media.video.players.VideoPlayerEvent")]
	
	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.SEEK_NOTIFY
	 */
	[Event(name = "VideoPlayerEvent.seekNotify", type = "temple.media.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.LOAD_READY
	 */
	[Event(name = "VideoPlayerEvent.loadReady", type = "temple.media.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.sound.SoundEvent.VOLUME_CHANGE
	 */
	[Event(name = "SoundEvent.volumeChange", type = "temple.media.sound.SoundEvent")]

	/**
	 * @eventType flash.events.NetStatusEvent.NET_STATUS
	 */
	[Event(name = "netStatus", type = "flash.events.NetStatusEvent")]

	/**
	 * @eventType temple.media.video.metadata.VideoMetaDataEvent.METADATA
	 */
	[Event(name = "VideoMetaDataEvent.metadata", type = "temple.media.video.metadata.VideoMetaDataEvent")]
	
	/**
	 * @eventType temple.media.video.cuepoints.CuePointEvent.CUEPOINT
	 */
	[Event(name = "CuePointEvent.cuepoint", type = "temple.media.video.cuepoints.CuePointEvent")]
	
	/**
	 * Class for playing video. The VideoPlayer can handle progressive download video files, like flv or f4v
	 * and streaming video, like RTMP or RTMPT.
	 * 
	 * @example
	 * <listing version="3.0">
	 * // create videoplayer
	 * var video:VideoPlayer = new VideoPlayer(324, 182);
	 * // add videoplayer to stage or displaylist
	 * addChild(video);
	 * // position videoplayer
	 * video.x = 20;
	 * video.y = 20;
	 * // start video
	 * video.playMovie(url);
	 * </listing>
	 * 
	 * @includeExample VideoPlayerExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class VideoPlayer extends CoreSprite implements IVideoPlayer, IHasBackground
	{
		/** @private */
		protected var _netStream:VideoNetStream;
		/** @private */
		protected var _metaData:VideoMetaData;
		
		// if pausing when status is between connected<>playing, the video is paused but the NetStream.Play.Start is still broadcasted (so the UI is updated)
		protected var _delayedPause:Boolean;

		private var _netConnection:VideoNetConnection;
		private var _cuePoint:VideoCuePoint;
		private var _video:Video;
		private var _videoPath:String;
		private var _status:String;
		private var _netConnectionCommand:String;
		private var _volume:Number = 1;
		private var _debug:Boolean;
		private var _isLoaded:Boolean;
		private var _txtDebug:TextField;
		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;
		private var _isClosed:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _scaleMode:String = ScaleMode.EXACT_FIT;
		private var _upscaleEnabled:Boolean = true;
		private var _playAfterLoaded:Boolean;
		private var _autoRewind:Boolean;
		private var _bufferTime:Number;
		private var _screenShot:BitmapData;
		private var _preloader:IPreloader;
		private var _rtmpConnection:String;
		
		private var _background:Boolean;
		private var _backgroundColor:uint = 0;
		private var _backgroundAlpha:Number = 1;
		
		/**
		 * Create a new video player
		 * @param width The width of the video
		 * @param height The height of the video
		 * @param smoothing (optional) set video to smooting when scaled, default 
		 * @param scaleMode (optional) indicates how the player should scale the video, default: 'exactFit'
		 * @param debug (optional) indicates if debug info should be logged
		 */
		public function VideoPlayer(width:Number = NaN, height:Number = NaN, smoothing:Boolean = false, scaleMode:String = ScaleMode.EXACT_FIT, debug:Boolean = false) 
		{
			this.toStringProps.push('videoPath');
			if (isNaN(width) && super.width > 0)
			{
				this._width = super.width;
			}
			else
			{
				this._width = width;
			}
			if (isNaN(height) && super.height > 0)
			{
				this._height = super.height;
			}
			else
			{
				this._height = height;
			}
			
			if (isNaN(this._width) || isNaN(this._height)) throwError(new TempleError(this, "Video dimensions are not set, please fill in width and height"));
			
			this._isLoaded = false;
			this._isClosed = true;
			
			this._netConnection = new VideoNetConnection();
			this._netConnection.addEventListener(NetStatusEvent.NET_STATUS, this.handleNetStatusEvent);
			this._netConnection.objectEncoding = ObjectEncoding.AMF0;
			
			this._netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError);
			this._netConnection.addEventListener(IOErrorEvent.IO_ERROR, this.handleIOError);
			this._netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.handleNetConnectionAsyncError);
			
			// create a bitmap for screenshot
			// in this way you can always make a screenshot of the video, even when the NetStream is closed. More about this bug on: http://bugs.adobe.com/jira/browse/FP-1048
			this._screenShot = new BitmapData(this._width, this._height, true, 0x00000000);
			this.addChild(new Bitmap(this._screenShot));
			
			// create actual video
			this._video = new Video(this._width, this._height);
			this._video.smoothing = smoothing;
			this.addChild(this._video);
			
			this.scrollRect = new Rectangle(0, 0, this._width, this._height);
			this.debug = debug;
			
			DebugManager.add(this);
			
			this.scaleMode = scaleMode;
			
			this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			
			// We create the netStream later, depending on the NetConnection.connect (Streaming or not)
		}

		/**
		 * Plays the video on a URL
		 * This video player can handle local files, web files (http) and RTMP Streaming
		 * 
		 * When using RTMP streaming pass url as:
		 * rtmp:[//host][:port]/[appname]/[video filename]
		 */
		 public function playUrl(url:String):void 
		{
			if (url == null)
			{
				this.logError("playUrl: url can not be null");
				return;
			}
			
			if (this._debug) this.logDebug("playUrl: " + url);
			
			if (this._scaleMode != ScaleMode.EXACT_FIT)
			{
				if (this._status != PlayerStatus.LOADING)
				{
					this._status = PlayerStatus.LOADING;
					this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
				
					// first hide player, so we can't see him playing, show it after playing and seek to 0 and start play again
					this._video.visible = false;
					this._playAfterLoaded = true;
				}
			}
			else
			{
				this.setVideoSize();
			}
			
			this._isLoaded = false;
			this._delayedPause = false;
			
			this._videoPath = url;
			
			// Check if this is RTMP streaming
			if (this.isRTMPStream(this._videoPath))
			{
				// If netStream is allready created and the net connection command is the same, we can directly play the video. Otherwise connect first
				if (this._netStream && this._netConnectionCommand == this.rtmpConnection)
				{
					if (this._netConnection.connected)
					{
						this.addChild(this._video);
						
						if (this.debug) this.addChild(this._txtDebug);
						
						if (this._status == PlayerStatus.PAUSED)
						{
							this._isClosed = false;
							this._netStream.resume();
						}
						else
						{
							this._isClosed = false;
							if (this._debug) this.logDebug("playUrl: play '" + this._videoPath + "'");
							this._netStream.play(this.rtmpVideoFile);
						}
					}
				}
				else
				{
					this._netConnectionCommand = this.rtmpConnection;
					if (this._debug) this.logDebug("playUrl: Connect to '" + this._netConnectionCommand + "'");
					this._netConnection.connect(this._netConnectionCommand);
				}
			}
			else
			{
				// Check if we have a netstream with no netconnection command
				if (this._netStream == null || this._netConnectionCommand != null)
				{
					this._netConnectionCommand = null;
					if (this._debug) this.logDebug("playUrl: Connect to '" + this._netConnectionCommand + "'");
					this._netConnection.connect(this._netConnectionCommand);
					this.createNetStream();
				}
				this.addChild(this._video);
				if (this._debug) 
				{
					this.logDebug("playUrl: play '" + this._videoPath + "'");
					this.addChild(this._txtDebug);
				}
				this._netStream.play(this._videoPath);
				this._isClosed = false;
			}
		}

		/**
		 * @inheritDoc
		 * 
		 * Loads a movie, but does not play it. Stops movie on first frame
		 */
		public function loadUrl(url:String):void
		{
			if (this._debug) this.logDebug("loadUrl: " + url);
			
			if (this._videoPath) this.clear();
			
			this._status = PlayerStatus.LOADING;
			this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
			this._playAfterLoaded = false;
			
			// first hide player, so we can't see him playing, show it after playing and seek to 0.
			this._video.visible = false;
			if (this._netStream)
			{
				try
				{
					this._netStream.soundTransform = new SoundTransform(0);
				}
				catch (error:Error)
				{
					this.logError(error.message);
				}
			}
			this.playUrl(url);
		}

		/**
		 * @inheritDoc
		 */
		public function play():void 
		{
			if (this._debug) this.logDebug("play: ");
			
			this._delayedPause = false;
			
			if (!this._netStream)
			{
				this.logError("play: NetStream is not set yet");
			}
			else
			{
				this.addChild(this._video);
				if (this.debug) this.addChild(this._txtDebug);
				
				if (this.isRTMPStream(this._videoPath))
				{
					if (this._debug) this.logDebug("play: '" + this.rtmpVideoFile + "'");
					this._netStream.play(this.rtmpVideoFile);
				}
				else
				{
					if (this._debug) this.logDebug("play: '" + this._videoPath + "'");
					this._netStream.play(this._videoPath);
				}
				
				this._isClosed = false;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void 
		{
			if (this._debug) this.logDebug("pause: ");
			
			this._delayedPause = true;
			
			if (!this._netStream)
			{
				this.logError("pause: NetStream is not set yet");
			}
			else
			{
				this._netStream.pause();
				this._status = PlayerStatus.PAUSED;
				this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void 
		{
			if (this._debug) this.logDebug("resume: current status is " + this._status);
			
			this._delayedPause = false;
			
			if (!this._netStream)
			{
				this.logError("resume: NetStream is not set yet");
			}
			else if (this._status == PlayerStatus.LOADING)
			{
				this._playAfterLoaded = true;
			}
			else
			{
				this._netStream.resume();
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
		public function stop():void 
		{
			if (this._debug) this.logDebug("stop: ");
			
			this._bytesLoaded = this.bytesLoaded;
			this._bytesTotal = this.bytesTotal;
			
			this._isClosed = true;
			
			if (this._netStream)
			{
				// try catch draw to prevent Security Error
				try
				{
					this._screenShot.draw(this);
				}
				catch (error:Error)
				{
					if (this.debug) this.logError(error.message);
				}
				
				this._netStream.close();
			}
			
			if (this._video.parent == this)
			{
				this.removeChild(this._video);
			}
			
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
			if (this._debug) this.logDebug("seek: " + seconds);
			
			if (this._netStream && (this._metaData || seconds == 0))
			{
				if (seconds == 0 || seconds >= 0 && seconds < this._metaData.duration)
				{
					this._netStream.seek(seconds);
				}
				else
				{
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SEEK_INVALID)); 
				}
			}
			else
			{
				this.logError("seek: MetaData is not available");
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return this._width;
		}

		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void 
		{
			if (this._width != value)
			{
				this._width = value;
				this.setVideoSize();
				
				var rect:Rectangle = this.scrollRect;
				rect.width = this._width;
				this.scrollRect = rect;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return this._height;
		}

		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void 
		{
			if (this._height != value)
			{
				this._height = value;
				this.setVideoSize();
				
				var rect:Rectangle = this.scrollRect;
				rect.height = this._height;
				this.scrollRect = rect;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint 
		{
			if (this._isClosed == true) return this._bytesLoaded;
			return this._netStream.bytesLoaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint 
		{
			if (this._isClosed == true) return this._bytesTotal;
			return this._netStream.bytesTotal;
		}

		/**
		 * @inheritDoc
		 */
		public function get metaData():VideoMetaData 
		{
			return this._metaData;
		}

		/**
		 *	Returns most recent cuepoint
		 */
		public function get currentCuePoint():VideoCuePoint 
		{
			return this._cuePoint;
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
		[Inspectable(name="Volume", type="Number", defaultValue="1")]
		public function set volume(value:Number):void 
		{
			if (this._debug) this.logDebug("volume: " + value);
			
			if (this._volume != value)
			{
				this._volume = value;
				if (this._netStream)
				{
					try
					{
						this._netStream.soundTransform = new SoundTransform(this._volume);
					}
					catch (error:Error)
					{
						this.logError(error.message);
					}
				}
				this.dispatchEvent(new SoundEvent(SoundEvent.VOLUME_CHANGE));
			}
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
		public function get currentPlayTime():Number 
		{
			if (this._netStream == null || this._status == PlayerStatus.LOADING) return 0;
			return this._netStream.time;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return this._metaData ? this.metaData.duration : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number 
		{
			if (!this.metaData || isNaN(this.metaData.duration)) return 0;
			
			return this.currentPlayTime / this.metaData.duration;
		}

		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return this.videoPath;
		}

		/**
		 * @inheritDoc
		 */
		public function get videoPath():String
		{
			return this._videoPath;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="VideoPath", type="String")]
		public function set videoPath(value:String):void
		{
			if (value != null && value != '') this.playUrl(value);
		}

		/**
		 * Checks if the video buffer is full or the buffer equals the length of the video
		 */
		public function isBufferFull():Boolean
		{
			if (this._metaData)
			{
				return Math.round(this._netStream.bufferLength) == Math.round(this._metaData.duration) || Math.round(this._netStream.bufferLength) == Math.round(this._netStream.bufferTime);
			}
			else
			{
				return Math.round(this._netStream.bufferLength) == Math.round(this._netStream.bufferTime);
			}
		}

		/**
		 * Return true is the video is loaded
		 */
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}

		/**
		 * Returns true if the video is closed
		 */
		public function get isClosed():Boolean
		{
			return this._isClosed;
		}
		
		/**
		 * Get or set the scale mode of the Video
		 * 
		 * Possible values:
		 * ScaleMode.EXACT_FIT		Specifies that the entire video be visible in the specified area without trying to preserve the original aspect ratio.
		 * ScaleMode.NO_BORDER		Specifies that the entire video fill the specified area, without distortion but possibly with some cropping, while maintaining the original aspect ratio of the video.
		 * ScaleMode.NO_SCALE		Specifies that the size of the video be fixed, so that it remains unchanged even as the size of the player changes.
		 * ScaleMode.SHOW_ALL		Specifies that the entire video be visible in the specified area without distortion while maintaining the original aspect ratio of the video. 
		 */
		public function get scaleMode():String
		{
			return this._scaleMode;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="scaleMode", type="List", defaultValue="exactFit", enumeration="exactFit,noBorder,noScale,showAll")]
		public function set scaleMode(value:String):void
		{
			if (this._debug) this.logDebug("scaleMode: " + value);
			
			switch (value)
			{
				case ScaleMode.EXACT_FIT:
				case ScaleMode.NO_BORDER:
				case ScaleMode.NO_SCALE:
				case ScaleMode.SHOW_ALL:
					this._scaleMode = value;
					this.setVideoSize();
					break;
				default:
					throwError(new TempleError(this, "Invalid value for scaleMode: '" + value + "'"));
					break;
			}
		}

		/**
		 * When you set the scaleMode to a property other than NO_SCALE, and clipping mode is enabled, every image is scaled.
		 * When you set upscaleEnabled to false, images that are smaller than the clippingRect are not scaled.
		 * @default true
		 */
		public function get upscaleEnabled():Boolean
		{
			return this._upscaleEnabled;
		}

		/**
		 * @private
		 */
		public function set upscaleEnabled(value:Boolean):void
		{
			this._upscaleEnabled = value;
			this.setVideoSize();
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			if (this._debug) this.logDebug("clear: ");
			
			if (this._video)
			{
				// due to a known bug, clear doens't work. So we just make a copy of the video
				var video:Video = new Video();
				video.x = this._video.x;
				video.y = this._video.y;
				video.width = this._video.width;
				video.height = this._video.height;
				video.visible = this._video.visible;
				video.smoothing = this._video.smoothing;
				this._video.attachNetStream(null);
				
				video.attachNetStream(this._netStream);
				
				this._video.clear();
				if (this._video.parent == this)
				{
					this.removeChild(this._video);
				}
				this._video = video;
				this.addChild(this._video);
				if (this.debug) this.addChild(this._txtDebug);
			}
			if (this._screenShot) this._screenShot.dispose();
		}

		/**
		 * @inheritDoc
		 */
		public function get smoothing():Boolean
		{
			return this._video.smoothing;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Smoothing", type="Boolean", defaultValue="false")]
		public function set smoothing(value:Boolean):void
		{
			this._video.smoothing = value;
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
		public function get preloader():IPreloader
		{
			return this._netStream ? this._netStream.preloader : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set preloader(value:IPreloader):void
		{
			if (this._netStream) this._netStream.preloader = this._preloader;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferLength():Number
		{
			return this._netStream ? this._netStream.bufferLength : 0;
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
			if (this._netStream) this._netStream.bufferTime = value;
		}
		
		/**
		 * Return the domain + the application name
		 * (Substring of begin till 2nd "/" after "rtmp://"
		 */
		public function get rtmpConnection():String
		{
			if (this._rtmpConnection)
			{
				return this._rtmpConnection;
			}
			if (this._videoPath)
			{
				return this._videoPath.substring(0, this._videoPath.lastIndexOf("/"));
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set rtmpConnection(value:String):void
		{
			this._rtmpConnection = value;
		}

		/**
		 * Return the url of the file of an RMTP url
		 * (Substring after 2nd "/" after "rtmp://"
		 */
		public function get rtmpVideoFile():String
		{
			if (this._rtmpConnection)
			{
				return this._videoPath.indexOf(this._rtmpConnection) == 0 ? this._videoPath.substr(this._rtmpConnection.length) : this._videoPath;
			}
			if (this._videoPath)
			{
				this._videoPath = this._videoPath.substring(this._videoPath.lastIndexOf("/") + 1);
				if (this._videoPath.substr(-4) == '.mp3')
				{
					this._videoPath = 'mp3:' + this._videoPath.substr(0,this._videoPath.length-4);
				}
				else if (this._videoPath.substr(-4) == '.mp4' || this._videoPath.substr(-4) == '.mov' || this._videoPath.substr(-4) == '.aac' || this._videoPath.substr(-4) == '.m4a')
				{
					this._videoPath = 'mp4:' + this._videoPath.substr(0, this._videoPath.length-4);
				}
				else if (this._videoPath.substr(-4) == '.flv')
				{
					this._videoPath = this._videoPath.substr(0, this._videoPath.length-4);
				}
				return this._videoPath;
			}
			return null;
		}
		
		/**
		 * Returns a reference to the Video object of the VideoPlayer.
		 */
		public function get video():Video
		{
			return this._video;
		}
		
		/**
		 * A Boolean which indicates if background filling is enabled.
		 * If set to true the background of the VideoPlayer will be filled which the color and alpha set by backgroundColor and backgroundAlpha
		 */
		public function get background():Boolean
		{
			return this._background;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Background", type="Boolean", defaultValue="false")]
		public function set background(value:Boolean):void
		{
			this._background = value;
			this.setBackground();
		}
		
		/**
		 * The color of the background of the VideoPlayer, if background is enabled.
		 */
		public function get backgroundColor():uint
		{
			return this._backgroundColor;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Background Color", type="Color", defaultValue="#000000")]
		public function set backgroundColor(value:uint):void
		{
			this._backgroundColor = value;
			this.setBackground();
		}
		
		/**
		 * The Number (between 0 and 1) which indicted the alpha of the background of the VideoPlayer, if background is enabled.
		 */
		public function get backgroundAlpha():Number
		{
			return this._backgroundAlpha;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Background Alpha", type="Number", defaultValue="1")]
		public function set backgroundAlpha(value:Number):void
		{
			this._backgroundAlpha = Math.min(Math.max(value, 0), 1);
			this.setBackground();
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
		[Inspectable(name="Debug", type="Boolean", defaultValue="false")]
		public function set debug(value:Boolean):void
		{
			this._debug = value;
			
			if (this._debug)
			{
				this.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				
				this.createDebugInfo();
			}
		}

		/**
		 * @private
		 * 
		 * Flash Player dispatches NetStatusEvent objects when NetStream reports its status.
		 */
		protected function handleNetStatusEvent(event:NetStatusEvent):void 
		{
			if (this._debug)
			{
				if (event.info.level == "error")
				{
					this.logError("handleNetStatusEvent: '" + event.info.code + "' " + event.info.description + ", status=" + this._status);
				}
				else
				{
					this.logDebug("handleNetStatusEvent: '" + event.info.code + "' " + event.info.description + ", status=" + this._status);
				}
			}
			
			switch (event.info.code) 
			{
				//NetStream events
				case NetStatusEventInfoCodes.NETSTREAM_BUFFER_EMPTY:
				{
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BUFFER_EMPTY)); 
					break;
				}
				case NetStatusEventInfoCodes.NETSTREAM_BUFFER_FULL:
				{
					if (this._status == PlayerStatus.LOADING)
					{
						this.onLoadReady();
					}
					else
					{
						this.dispatchEvent(new VideoPlayerEvent(PlayerEvent.PLAY_STARTED));
					}
					break;
				}
				case NetStatusEventInfoCodes.NETSTREAM_PLAY_START:
				{
					if (this._status != PlayerStatus.LOADING)
					{
						if (!this._delayedPause)
						{
							this._status = PlayerStatus.PLAYING;
							this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
						}
					}					
					else
					{
						new FrameDelay(this.onLoadReady, 30);
					}
					break;
				}
				case NetStatusEventInfoCodes.NETSTREAM_PLAY_STOP:
				{
					if (this._status == PlayerStatus.PLAYING)
					{
						this._status = PlayerStatus.STOPPED;
						this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
						
						if (this.currentPlayFactor > 0.99)
						{
							if (this._autoRewind)
							{
								this.seek(0);
								this.pause();
							}
							this.dispatchEvent(new PlayerEvent(PlayerEvent.COMPLETE));
						}
					}
					break;
				}
				case NetStatusEventInfoCodes.NETSTREAM_PLAY_STREAM_NOT_FOUND:
				{
					this.logError("handleNetStatusEvent: '" + event.info.code + "' - '" + this._videoPath + "'");
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.MOVIE_NOTFOUND)); 
					break;
				}
				
				case NetStatusEventInfoCodes.NETSTREAM_SEEK_INVALID_TIME:
				{
					this.logError("handleNetStatusEvent: try to seek to invalid time '" + event.info.code + "'");
					break;
				}

				case NetStatusEventInfoCodes.NETSTREAM_BUFFER_FLUSH:
				{
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BUFFER_FLUSH)); 
					break;
				}
				
				case NetStatusEventInfoCodes.NETSTREAM_SEEK_NOTIFY:
				{
					this.dispatchEvent(new PlayerEvent(PlayerEvent.SEEK_NOTIFY)); 
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SEEK_NOTIFY)); 
					break;
				}
				
				case NetStatusEventInfoCodes.NETSTREAM_PLAY_RESET:
				case NetStatusEventInfoCodes.NETSTREAM_UNPAUSE_NOTIFY:
				case NetStatusEventInfoCodes.NETSTREAM_PAUSE_NOTIFY:
				{
					// do nothing
					break;
				}
				
				//NetConnection events
				case NetStatusEventInfoCodes.NETCONNECTION_CONNECT_SUCCESS:
				{
					if (this._netConnectionCommand != null)
					{
						this.createNetStream();
						if (this.debug) this.logDebug("handleNetStatusEvent: play \"" + this.rtmpVideoFile + "\"");
						this._netStream.play(this.rtmpVideoFile);
					}
					break;
				}

				case NetStatusEventInfoCodes.NETCONNECTION_CONNECT_CLOSED:
				{
					// do nothing
					break;
				}
				
				case NetStatusEventInfoCodes.NETCONNECTION_CONNECT_REJECTED:
				{
					this.logError("handleNetStatusEvent: Error can't connect '" + event.info.code + "'");
					break;
				}
				
				default:
				{
					this.logError("handleNetStatusEvent: unhandled NetStatusEvent '" + event.info.code + "'");
					break;
				}
			}
			this.dispatchEvent(event.clone());
		}

		/**
		 *	Flash Player dispatches an AsyncErrorEvent when an exception is thrown from native asynchronous code 
		 */
		private function handleAsyncError(event:AsyncErrorEvent):void 
		{
			this.logError("handleAsyncError: " + event.text);
		}

		/**
		 *	Flash Player dispatches SecurityErrorEvent objects to report the occurrence of a security error
		 */
		private function handleSecurityError(event:SecurityErrorEvent):void 
		{
			this.logError("handleSecurityError: " + event.text);
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SECURITY_ERROR));
		}

		/**
		 *	Handler for metadata & cuepoints events from the NetStream object.
		 */
		private function handleMetaDataEvent(event:VideoMetaDataEvent):void 
		{
			if (this._debug) this.logDebug("handleMetaDataEvent: " + event.metadata);
			
			this._metaData = event.metadata;
			new FrameDelay(this.setVideoSize);
			
			// max buffertime to duration
			if (this._netStream.bufferTime > this._metaData.duration) this._netStream.bufferTime = this._metaData.duration;
			
			this.dispatchEvent(event.clone());
		}
		/**
		 *	Handler for metadata & cuepoints events from the NetStream object.
		 */
		private function handleCuePointEvent(event:CuePointEvent):void 
		{
			if (this._debug) this.logDebug("handleCuePointEvent: " + event.cuepoint);
			
			// store cuepoint
			this._cuePoint = event.cuepoint;
			
			this.dispatchEvent(event.clone());
		}

		private function handleNetConnectionAsyncError(event:AsyncErrorEvent):void
		{
			this.logError("handleNetConnectionAsyncError: '" + event.text + "'");
		}

		private function handleIOError(event:IOErrorEvent):void
		{
			this.logError("handleIOError: '" + event.text + "'");
		}

		private function onLoadReady():void
		{
			if (this._status == PlayerStatus.LOADING)
			{
				if (this._debug) this.logDebug("onLoadReady: Load Ready!");
				
				this.setVideoSize();
				this._video.visible = true;
				var volume:Number = this._volume;
				this._volume = 0;
				this.volume = volume;

				if (this._playAfterLoaded)
				{
					this._status = PlayerStatus.PLAYING;
					this.dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, this._status));
				}
				else
				{
					this.pause();
					this.seek(0);
				}
				
				this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.LOAD_READY));
			}
		}

		private function isRTMPStream(url:String):Boolean
		{
			if (url.substr(0, 7) == "rtmp://" || url.substr(0, 8) == "rtmpt://")
			{
				return true;
			}
			return false;
		}

		private function createNetStream():void
		{
			if (this._netStream != null)
			{
				this._netStream.destruct();
			}
			this._netStream = new VideoNetStream(this._netConnection);
			this._netStream.checkPolicyFile = true;
			this._netStream.soundTransform = new SoundTransform(this._status == PlayerStatus.LOADING ? 0 : this._volume);
			this._netStream.addEventListener(VideoMetaDataEvent.METADATA, this.handleMetaDataEvent);
			this._netStream.addEventListener(CuePointEvent.CUEPOINT, this.handleCuePointEvent);
			this._netStream.addEventListener(NetStatusEvent.NET_STATUS, this.handleNetStatusEvent);
			this._netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.handleAsyncError);
			this._netStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError);
			this._netStream.bufferTime = this._bufferTime;
			this._netStream.preloader = this._preloader;
			
			this._video.attachNetStream(this._netStream);
			
			if (this.debug) this.logDebug("createNetStream: ");
			
			this.addChild(this._video);
			if (this.debug) this.addChild(this._txtDebug);
		}
		
		private function createDebugInfo():void
		{
			this._txtDebug = this.addChild(this._txtDebug || new TextField()) as TextField;
			this._txtDebug.background = true;
			this._txtDebug.border = true;
			this._txtDebug.multiline = true;
			this._txtDebug.width = this._video.width;
			this._txtDebug.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function handleEnterFrame(event:Event):void
		{
			// if loaded, dispatch event
			if (this.bytesLoaded > 10 && this.bytesLoaded == this.bytesTotal && this._isLoaded == false)
			{
				this._isLoaded = true;
				
				this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.MOVIE_LOADED));
				
				if (!this._debug) this.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			}
			
			if (this._debug)
			{
				try
				{
					this._txtDebug.text = this.videoPath;
					this._txtDebug.appendText("\n" + this.isLoaded + ' : ' + this.bytesLoaded + ' / ' + this.bytesTotal);
					this._txtDebug.appendText("\n" + this.currentPlayTime);
					this._txtDebug.appendText("\n" + this.metaData.duration);
				}
				catch (e:Error)
				{
				}
			}
		}
		
		private function setVideoSize():void
		{
			var vWidth:Number = this._metaData ? this._metaData.width : this._video.videoWidth;
			var vHeight:Number = this._metaData ? this._metaData.height : this._video.videoHeight;
			
			switch (this._scaleMode)
			{
				case ScaleMode.EXACT_FIT:
				{
					// do nothing
					this._video.width = this._width;
					this._video.height = this._height;
					this._video.x = 0;
					this._video.y = 0;
					break;
				}	
				case ScaleMode.NO_BORDER:
				{
					if (this._width / vWidth > this._height / vHeight)
					{
						this._video.height = (this._width / vWidth) * vHeight;
						this._video.width = this._width;
						
						this._video.x = 0;
						this._video.y = - 0.5 * (this._video.height - this._height);
					}
					else
					{
						this._video.width = (this._height / vHeight) * vWidth;
						this._video.height = this._height;
						
						this._video.x = - 0.5 * (this._video.width - this._width);
						this._video.y = 0;
					}
					break;
				}
				case ScaleMode.NO_SCALE:
				{
					this._video.width = vWidth;
					this._video.height = vHeight;
					
					this._video.x = - 0.5 * (this._video.width - this._width);
					this._video.y = - 0.5 * (this._video.height - this._height);
					
					break;
				}	
				case ScaleMode.SHOW_ALL:
				{
					if (this._width / vWidth < this._height / vHeight)
					{
						this._video.height = (this._width / vWidth) * vHeight;
						this._video.width = this._width;
						
						this._video.x = 0;
						this._video.y = 0.5 * (this._height - this._video.height);
					}
					else
					{
						this._video.width = (this._height / vHeight) * vWidth;
						this._video.height = this._height;

						this._video.x = 0.5 * (this._width - this._video.width);
						this._video.y = 0;
					}
					break;
				}
			}
			if (!this._upscaleEnabled)
			{
				if (this._video.width > vWidth)
				{
					this._video.width = vWidth;
					this._video.x = 0.5 * (this._width - this._video.width);
				}
				if (this._video.height > vHeight)
				{
					this._video.height = vHeight;
					this._video.y = 0.5 * (this._height - this._video.height);
				}
			}
			
			this.setBackground();
		}

		private function setBackground():void 
		{
			this.graphics.clear();
			if (this._background)
			{
				this.graphics.beginFill(this._backgroundColor, this._backgroundAlpha);
				this.graphics.drawRect(0, 0, this._width, this._height);
				this.graphics.endFill();
			}
		}

		/**
		 * Removes all listeners of the video player
		 */
		override public function destruct():void
		{
			this.stop();
			this.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);

			if (this._netStream)
			{
				this._netStream.destruct();
				this._netStream = null;
			}
			if (this._netConnection)
			{
				this._netConnection.destruct();
				this._netConnection = null;
			}
			this._metaData = null;
			
			if (this._video.parent && this._video.parent == this)
			{
				this.removeChild(this._video);
				this._video = null;
			}
			
			if (this._screenShot)
			{
				this._screenShot.dispose();
				this._screenShot = null;
			}
			
			this._txtDebug = null;
			this._cuePoint = null;
			
			super.destruct();
		}
	}
}
