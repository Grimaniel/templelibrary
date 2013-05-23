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

package temple.mediaplayers.video.players 
{
	import temple.common.enum.Align;
	import temple.common.enum.ScaleMode;
	import temple.common.events.SoundEvent;
	import temple.common.events.StatusEvent;
	import temple.common.interfaces.IHasBackground;
	import temple.core.debug.addToDebugManager;
	import temple.core.display.CoreSprite;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.media.CoreVideo;
	import temple.mediaplayers.players.PlayerEvent;
	import temple.mediaplayers.players.PlayerStatus;
	import temple.mediaplayers.video.cuepoints.CuePointEvent;
	import temple.mediaplayers.video.cuepoints.VideoCuePoint;
	import temple.mediaplayers.video.metadata.VideoMetaData;
	import temple.mediaplayers.video.metadata.VideoMetaDataEvent;
	import temple.mediaplayers.video.net.NetStatusEventInfoCodes;
	import temple.mediaplayers.video.net.VideoNetConnection;
	import temple.mediaplayers.video.net.VideoNetStream;
	import temple.utils.FrameDelay;
	import temple.utils.TimeUtils;

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
	[Event(name = "StatusEvent.statusChange", type = "temple.common.events.StatusEvent")]
	
	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.BUFFER_EMPTY
	 */
	[Event(name = "VideoPlayerEvent.bufferEmpty", type = "temple.mediaplayers.video.players.VideoPlayerEvent")]
	
	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.BUFFER_FLUSH
	 */
	[Event(name = "VideoPlayerEvent.bufferFlush", type = "temple.mediaplayers.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.MOVIE_NOTFOUND
	 */
	[Event(name = "VideoPlayerEvent.movieNotFound", type = "temple.mediaplayers.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.SECURITY_ERROR
	 */
	[Event(name = "VideoPlayerEvent.securityError", type = "temple.mediaplayers.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.SEEK_INVALID
	 */
	[Event(name = "VideoPlayerEvent.seekInvalid", type = "temple.mediaplayers.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.MOVIE_LOADED
	 */
	[Event(name = "VideoPlayerEvent.movieLoaded", type = "temple.mediaplayers.video.players.VideoPlayerEvent")]
	
	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.SEEK_NOTIFY
	 */
	[Event(name = "VideoPlayerEvent.seekNotify", type = "temple.mediaplayers.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.video.players.VideoPlayerEvent.LOAD_READY
	 */
	[Event(name = "VideoPlayerEvent.loadReady", type = "temple.mediaplayers.video.players.VideoPlayerEvent")]

	/**
	 * @eventType temple.media.sound.SoundEvent.VOLUME_CHANGE
	 */
	[Event(name = "SoundEvent.volumeChange", type = "temple.common.events.SoundEvent")]

	/**
	 * @eventType flash.events.NetStatusEvent.NET_STATUS
	 */
	[Event(name = "netStatus", type = "flash.events.NetStatusEvent")]

	/**
	 * @eventType temple.media.video.metadata.VideoMetaDataEvent.METADATA
	 */
	[Event(name = "VideoMetaDataEvent.metadata", type = "temple.mediaplayers.video.metadata.VideoMetaDataEvent")]
	
	/**
	 * @eventType temple.media.video.cuepoints.CuePointEvent.CUEPOINT
	 */
	[Event(name = "CuePointEvent.cuepoint", type = "temple.mediaplayers.video.cuepoints.CuePointEvent")]
	
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
		private var _metaData:VideoMetaData;
		
		// if pausing when status is between connected<>playing, the video is paused but the NetStream.Play.Start is still broadcasted (so the UI is updated)
		protected var _delayedPause:Boolean;

		private var _netConnection:VideoNetConnection;
		private var _cuePoint:VideoCuePoint;
		private var _video:CoreVideo;
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
		private var _align:String;
		private var _playAfterLoaded:Boolean;
		private var _autoRewind:Boolean;
		private var _bufferTime:Number;
		private var _screenShot:BitmapData;
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
			toStringProps.push('videoPath', 'status');
			if (isNaN(width) && super.width > 0)
			{
				_width = super.width;
			}
			else
			{
				_width = width;
			}
			if (isNaN(height) && super.height > 0)
			{
				_height = super.height;
			}
			else
			{
				_height = height;
			}
			
			if (isNaN(_width) || isNaN(_height)) throwError(new TempleError(this, "Video dimensions are not set, please fill in width and height"));
			
			_isLoaded = false;
			_isClosed = true;
			
			_netConnection = new VideoNetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
			_netConnection.objectEncoding = ObjectEncoding.AMF0;
			
			_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			_netConnection.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleNetConnectionAsyncError);
			
			// create a bitmap for screenshot
			// in this way you can always make a screenshot of the video, even when the NetStream is closed. More about this bug on: http://bugs.adobe.com/jira/browse/FP-1048
			_screenShot = new BitmapData(_width, _height, true, 0x00000000);
			addChild(new Bitmap(_screenShot));
			
			// create actual video
			_video = new CoreVideo(_width, _height);
			_video.smoothing = smoothing;
			addChild(_video);
			
			scrollRect = new Rectangle(0, 0, _width, _height);
			this.debug = debug;
			
			addToDebugManager(this);
			
			this.scaleMode = scaleMode;
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
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
				logError("playUrl: url can not be null");
				return;
			}
			
			if (_debug) logDebug("playUrl: " + url);
			
			_video.visible = true;
			
			if (_scaleMode != ScaleMode.EXACT_FIT)
			{
				if (_status != PlayerStatus.LOADING)
				{
					_status = PlayerStatus.LOADING;
					dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
				
					// first hide player, so we can't see him playing, show it after playing and seek to 0 and start play again
					_video.visible = false;
					_playAfterLoaded = true;
				}
			}
			else
			{
				setVideoSize();
			}
			
			_isLoaded = false;
			_delayedPause = false;
			
			_videoPath = url;
			
			// Check if this is RTMP streaming
			if (isRTMPStream(_videoPath))
			{
				// If netStream is allready created and the net connection command is the same, we can directly play the video. Otherwise connect first
				if (_netStream && _netConnectionCommand == rtmpConnection)
				{
					if (_netConnection.connected)
					{
						addChild(_video);
						
						if (debug) addChild(_txtDebug);
						
						if (_status == PlayerStatus.PAUSED)
						{
							_isClosed = false;
							_netStream.resume();
						}
						else
						{
							_isClosed = false;
							if (_debug) logDebug("playUrl: play '" + _videoPath + "'");
							_netStream.play(rtmpVideoFile);
						}
					}
				}
				else
				{
					_netConnectionCommand = rtmpConnection;
					if (_debug) logDebug("playUrl: Connect to '" + _netConnectionCommand + "'");
					_netConnection.connect(_netConnectionCommand);
				}
			}
			else
			{
				// Check if we have a netstream with no netconnection command
				if (_netStream == null || _netConnectionCommand != null)
				{
					_netConnectionCommand = null;
					if (_debug) logDebug("playUrl: Connect to '" + _netConnectionCommand + "'");
					_netConnection.connect(_netConnectionCommand);
					createNetStream();
				}
				addChild(_video);
				if (_debug) 
				{
					logDebug("playUrl: play '" + _videoPath + "'");
					addChild(_txtDebug);
				}
				_netStream.play(_videoPath);
				_isClosed = false;
			}
		}

		/**
		 * @inheritDoc
		 * 
		 * Loads a movie, but does not play it. Stops movie on first frame
		 */
		public function loadUrl(url:String):void
		{
			if (_debug) logDebug("loadUrl: " + url);
			
			if (_videoPath) clear();
			
			_status = PlayerStatus.LOADING;
			dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
			_playAfterLoaded = false;
			
			// first hide player, so we can't see him playing, show it after playing and seek to 0.
			_video.visible = false;
			if (_netStream)
			{
				try
				{
					_netStream.soundTransform = new SoundTransform(0);
				}
				catch (error:Error)
				{
					logError(error.message);
				}
			}
			playUrl(url);
			_video.visible = false;
		}

		/**
		 * @inheritDoc
		 */
		public function play():void 
		{
			if (_debug) logDebug("play: ");
			
			_delayedPause = false;
			
			if (!_netStream)
			{
				logError("play: NetStream is not set yet");
			}
			else
			{
				addChild(_video);
				if (debug) addChild(_txtDebug);
				
				if (isRTMPStream(_videoPath))
				{
					if (_debug) logDebug("play: '" + rtmpVideoFile + "'");
					_netStream.play(rtmpVideoFile);
				}
				else
				{
					if (_debug) logDebug("play: '" + _videoPath + "'");
					_netStream.play(_videoPath);
				}
				
				_isClosed = false;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void 
		{
			if (_debug) logDebug("pause: ");
			
			_delayedPause = true;
			
			if (!_netStream)
			{
				logError("pause: NetStream is not set yet");
			}
			else
			{
				_netStream.pause();
				_status = PlayerStatus.PAUSED;
				dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function resume():void 
		{
			if (_debug) logDebug("resume: current status is " + _status);
			
			_delayedPause = false;
			
			if (!_netStream)
			{
				logError("resume: NetStream is not set yet");
			}
			else if (_status == PlayerStatus.LOADING)
			{
				_playAfterLoaded = true;
			}
			else
			{
				_netStream.resume();
				_status = PlayerStatus.PLAYING;
				dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get paused():Boolean
		{
			return _status == PlayerStatus.PAUSED;
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void 
		{
			if (_debug) logDebug("stop: ");
			
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
			
			_isClosed = true;
			
			if (_netStream)
			{
				// try catch draw to prevent Security Error
				try
				{
					_screenShot.draw(this);
				}
				catch (error:Error)
				{
					if (debug) logError(error.message);
				}
				
				_netStream.close();
			}
			
			if (_video.parent == this)
			{
				removeChild(_video);
			}
			
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
			if (_debug) logDebug("seek: " + seconds);
			
			if (_netStream && (_metaData || seconds == 0))
			{
				if (seconds == 0 || seconds >= 0 && seconds < duration)
				{
					_netStream.seek(seconds);
				}
				else
				{
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SEEK_INVALID)); 
				}
			}
			else
			{
				logError("seek: MetaData is not available");
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return _width;
		}

		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void 
		{
			if (_width != value)
			{
				_width = value;
				setVideoSize();
				
				var rect:Rectangle = scrollRect;
				rect.width = _width;
				scrollRect = rect;
			}
		}

		/**
		 * Returns the width of the current video
		 */
		public function get videoWidth():Number
		{
			return _metaData ? _metaData.width : _video.videoWidth;
		}

		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return _height;
		}

		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void 
		{
			if (_height != value)
			{
				_height = value;
				setVideoSize();
				
				var rect:Rectangle = scrollRect;
				rect.height = _height;
				scrollRect = rect;
			}
		}
		
		/**
		 * Returns the height of the current video
		 */
		public function get videoHeight():Number
		{
			return _metaData ? _metaData.height : _video.videoHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint 
		{
			if (_isClosed == true) return _bytesLoaded;
			return _netStream.bytesLoaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint 
		{
			if (_isClosed == true) return _bytesTotal;
			return _netStream.bytesTotal;
		}

		/**
		 * @inheritDoc
		 */
		public function get metaData():VideoMetaData 
		{
			return _metaData;
		}

		/**
		 *	Returns most recent cuepoint
		 */
		public function get currentCuePoint():VideoCuePoint 
		{
			return _cuePoint;
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
		[Inspectable(name="Volume", type="Number", defaultValue="1")]
		public function set volume(value:Number):void 
		{
			if (_debug) logDebug("volume: " + value);
			
			if (_volume != value)
			{
				_volume = value;
				if (_netStream)
				{
					try
					{
						_netStream.soundTransform = new SoundTransform(_volume);
					}
					catch (error:Error)
					{
						logError(error.message);
					}
				}
				dispatchEvent(new SoundEvent(SoundEvent.VOLUME_CHANGE));
			}
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
		public function get currentPlayTime():Number 
		{
			if (_netStream == null || _status == PlayerStatus.LOADING) return 0;
			return _netStream.time;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get duration():Number
		{
			return _metaData ? metaData.duration : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPlayFactor():Number 
		{
			if (!metaData || isNaN(duration)) return 0;
			
			return currentPlayTime / duration;
		}

		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return videoPath;
		}

		/**
		 * @inheritDoc
		 */
		public function get videoPath():String
		{
			return _videoPath;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="VideoPath", type="String")]
		public function set videoPath(value:String):void
		{
			if (value != null && value != '') playUrl(value);
		}

		/**
		 * Checks if the video buffer is full or the buffer equals the length of the video
		 */
		public function isBufferFull():Boolean
		{
			if (_metaData)
			{
				return Math.round(_netStream.bufferLength) == Math.round(duration) || Math.round(_netStream.bufferLength) == Math.round(_netStream.bufferTime);
			}
			else
			{
				return Math.round(_netStream.bufferLength) == Math.round(_netStream.bufferTime);
			}
		}

		/**
		 * Return true is the video is loaded
		 */
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}

		/**
		 * Returns true if the video is closed
		 */
		public function get isClosed():Boolean
		{
			return _isClosed;
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
			return _scaleMode;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="scaleMode", type="List", defaultValue="exactFit", enumeration="exactFit,noBorder,noScale,showAll")]
		public function set scaleMode(value:String):void
		{
			if (_debug) logDebug("scaleMode: " + value);
			
			switch (value)
			{
				case ScaleMode.EXACT_FIT:
				case ScaleMode.NO_BORDER:
				case ScaleMode.NO_SCALE:
				case ScaleMode.SHOW_ALL:
					_scaleMode = value;
					setVideoSize();
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
			return _upscaleEnabled;
		}

		/**
		 * @private
		 */
		public function set upscaleEnabled(value:Boolean):void
		{
			_upscaleEnabled = value;
			setVideoSize();
		}
		
		/**
		 * 
		 */
		public function get align():String
		{
			return _align;
		}

		/**
		 * @private
		 */
		public function set align(value:String):void
		{
			switch (value)
			{
				case Align.LEFT:
				case Align.CENTER:
				case Align.RIGHT:
				case Align.TOP:
				case Align.MIDDLE:
				case Align.BOTTOM:
				case Align.TOP_LEFT:
				case Align.TOP_RIGHT:
				case Align.BOTTOM_LEFT:
				case Align.BOTTOM_RIGHT:
				case Align.NONE:
				case null:
					_align = value;
					setVideoSize();
					break;
				
				default:
					throwError(new ArgumentError("Invalid value for align: '" + value + "'"));
					break;
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			if (_debug) logDebug("clear: ");
			
			if (_video)
			{
				// due to a known bug, clear doens't work. So we just make a copy of the video
				_video.destruct();
				var video:CoreVideo = new CoreVideo();
				video.x = _video.x;
				video.y = _video.y;
				video.width = _video.width;
				video.height = _video.height;
				video.visible = _video.visible;
				video.smoothing = _video.smoothing;
				_video.attachNetStream(null);
				
				video.attachNetStream(_netStream);
				
				_video.clear();
				if (_video.parent == this)
				{
					removeChild(_video);
				}
				_video = video;
				addChild(_video);
				if (debug) addChild(_txtDebug);
			}
			if (_screenShot) _screenShot.dispose();
		}

		/**
		 * @inheritDoc
		 */
		public function get smoothing():Boolean
		{
			return _video.smoothing;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Smoothing", type="Boolean", defaultValue="false")]
		public function set smoothing(value:Boolean):void
		{
			_video.smoothing = value;
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
		public function get bufferLength():Number
		{
			return _netStream ? _netStream.bufferLength : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get bufferTime():Number
		{
			return _bufferTime;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set bufferTime(value:Number):void
		{
			_bufferTime = value;
			if (_netStream) _netStream.bufferTime = value;
		}
		
		/**
		 * Return the domain + the application name
		 * (Substring of begin till 2nd "/" after "rtmp://"
		 */
		public function get rtmpConnection():String
		{
			if (_rtmpConnection)
			{
				return _rtmpConnection;
			}
			if (_videoPath)
			{
				return _videoPath.substring(0, _videoPath.lastIndexOf("/"));
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set rtmpConnection(value:String):void
		{
			_rtmpConnection = value;
		}

		/**
		 * Return the url of the file of an RMTP url
		 * (Substring after 2nd "/" after "rtmp://"
		 */
		public function get rtmpVideoFile():String
		{
			if (_rtmpConnection)
			{
				return _videoPath.indexOf(_rtmpConnection) == 0 ? _videoPath.substr(_rtmpConnection.length) : _videoPath;
			}
			if (_videoPath)
			{
				_videoPath = _videoPath.substring(_videoPath.lastIndexOf("/") + 1);
				if (_videoPath.substr(-4) == '.mp3')
				{
					_videoPath = 'mp3:' + _videoPath.substr(0,_videoPath.length-4);
				}
				else if (_videoPath.substr(-4) == '.mp4' || _videoPath.substr(-4) == '.mov' || _videoPath.substr(-4) == '.aac' || _videoPath.substr(-4) == '.m4a')
				{
					_videoPath = 'mp4:' + _videoPath.substr(0, _videoPath.length-4);
				}
				else if (_videoPath.substr(-4) == '.flv')
				{
					_videoPath = _videoPath.substr(0, _videoPath.length-4);
				}
				return _videoPath;
			}
			return null;
		}
		
		/**
		 * Returns a reference to the Video object of the VideoPlayer.
		 */
		public function get video():Video
		{
			return _video;
		}
		
		/**
		 * A Boolean which indicates if background filling is enabled.
		 * If set to true the background of the VideoPlayer will be filled which the color and alpha set by backgroundColor and backgroundAlpha
		 */
		public function get background():Boolean
		{
			return _background;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Background", type="Boolean", defaultValue="false")]
		public function set background(value:Boolean):void
		{
			_background = value;
			setBackground();
		}
		
		/**
		 * The color of the background of the VideoPlayer, if background is enabled.
		 */
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Background Color", type="Color", defaultValue="#000000")]
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			setBackground();
		}
		
		/**
		 * The Number (between 0 and 1) which indicted the alpha of the background of the VideoPlayer, if background is enabled.
		 */
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Background Alpha", type="Number", defaultValue="1")]
		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = Math.min(Math.max(value, 0), 1);
			setBackground();
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
		[Inspectable(name="Debug", type="Boolean", defaultValue="false")]
		public function set debug(value:Boolean):void
		{
			_debug = value;
			
			if (_debug)
			{
				removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				addEventListener(Event.ENTER_FRAME, handleEnterFrame);
				
				createDebugInfo();
			}
		}

		/**
		 * @private
		 * 
		 * Flash Player dispatches NetStatusEvent objects when NetStream reports its status.
		 */
		protected function handleNetStatusEvent(event:NetStatusEvent):void 
		{
			if (_debug)
			{
				if (event.info.level == "error")
				{
					logError("handleNetStatusEvent: '" + event.info.code + "' " + event.info.description + ", status=" + _status);
				}
				else
				{
					logDebug("handleNetStatusEvent: '" + event.info.code + "' " + event.info.description + ", status=" + _status);
				}
			}
			
			switch (event.info.code) 
			{
				//NetStream events
				case NetStatusEventInfoCodes.NETSTREAM_BUFFER_EMPTY:
				{
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BUFFER_EMPTY)); 
					break;
				}
				case NetStatusEventInfoCodes.NETSTREAM_BUFFER_FULL:
				{
					if (_status == PlayerStatus.LOADING)
					{
						onLoadReady();
					}
					else
					{
						dispatchEvent(new VideoPlayerEvent(PlayerEvent.PLAY_STARTED));
					}
					break;
				}
				case NetStatusEventInfoCodes.NETSTREAM_PLAY_START:
				{
					if (_status != PlayerStatus.LOADING)
					{
						if (!_delayedPause)
						{
							_status = PlayerStatus.PLAYING;
							dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
						}
					}					
					else
					{
						new FrameDelay(onLoadReady, 30);
					}
					break;
				}
				case NetStatusEventInfoCodes.NETSTREAM_PLAY_STOP:
				{
					if (_status == PlayerStatus.PLAYING)
					{
						_status = PlayerStatus.STOPPED;
						dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
						
						if (currentPlayFactor > 0.99)
						{
							if (_autoRewind)
							{
								seek(0);
								pause();
							}
							dispatchEvent(new PlayerEvent(PlayerEvent.COMPLETE));
						}
					}
					break;
				}
				case NetStatusEventInfoCodes.NETSTREAM_PLAY_STREAM_NOT_FOUND:
				{
					logError("handleNetStatusEvent: '" + event.info.code + "' - '" + _videoPath + "'");
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.MOVIE_NOTFOUND)); 
					break;
				}
				
				case NetStatusEventInfoCodes.NETSTREAM_SEEK_INVALID_TIME:
				{
					logError("handleNetStatusEvent: try to seek to invalid time '" + event.info.code + "'");
					break;
				}

				case NetStatusEventInfoCodes.NETSTREAM_BUFFER_FLUSH:
				{
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BUFFER_FLUSH)); 
					break;
				}
				
				case NetStatusEventInfoCodes.NETSTREAM_SEEK_NOTIFY:
				{
					dispatchEvent(new PlayerEvent(PlayerEvent.SEEK_NOTIFY)); 
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SEEK_NOTIFY)); 
					break;
				}
				
				case NetStatusEventInfoCodes.NETSTREAM_SEEK_COMPLETE:
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
					if (_netConnectionCommand != null)
					{
						createNetStream();
						if (debug) logDebug("handleNetStatusEvent: play \"" + rtmpVideoFile + "\"");
						_netStream.play(rtmpVideoFile);
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
					logError("handleNetStatusEvent: Error can't connect '" + event.info.code + "'");
					break;
				}
				
				default:
				{
					logError("handleNetStatusEvent: unhandled NetStatusEvent '" + event.info.code + "'");
					break;
				}
			}
			dispatchEvent(event.clone());
		}

		/**
		 *	Flash Player dispatches an AsyncErrorEvent when an exception is thrown from native asynchronous code 
		 */
		private function handleAsyncError(event:AsyncErrorEvent):void 
		{
			logError("handleAsyncError: " + event.text);
		}

		/**
		 *	Flash Player dispatches SecurityErrorEvent objects to report the occurrence of a security error
		 */
		private function handleSecurityError(event:SecurityErrorEvent):void 
		{
			logError("handleSecurityError: " + event.text);
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SECURITY_ERROR));
		}

		/**
		 *	Handler for metadata & cuepoints events from the NetStream object.
		 */
		private function handleMetaDataEvent(event:VideoMetaDataEvent):void 
		{
			if (_debug) logDebug("handleMetaDataEvent: " + event.metadata);
			
			_metaData = event.metadata;
			new FrameDelay(setVideoSize);
			
			// max buffertime to duration
			if (_netStream.bufferTime > duration) _netStream.bufferTime = duration;
			
			dispatchEvent(event.clone());
		}
		/**
		 *	Handler for metadata & cuepoints events from the NetStream object.
		 */
		private function handleCuePointEvent(event:CuePointEvent):void 
		{
			if (_debug) logDebug("handleCuePointEvent: " + event.cuepoint);
			
			// store cuepoint
			_cuePoint = event.cuepoint;
			
			dispatchEvent(event.clone());
		}

		private function handleNetConnectionAsyncError(event:AsyncErrorEvent):void
		{
			logError("handleNetConnectionAsyncError: '" + event.text + "'");
		}

		private function handleIOError(event:IOErrorEvent):void
		{
			logError("handleIOError: '" + event.text + "'");
		}

		private function onLoadReady():void
		{
			if (_status == PlayerStatus.LOADING)
			{
				if (_debug) logDebug("onLoadReady: Load Ready!");
				
				setVideoSize();
				_video.visible = true;
				var volume:Number = _volume;
				_volume = 0;
				this.volume = volume;

				if (_playAfterLoaded)
				{
					_status = PlayerStatus.PLAYING;
					dispatchEvent(new StatusEvent(StatusEvent.STATUS_CHANGE, _status));
				}
				else
				{
					pause();
					seek(0);
				}
				
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.LOAD_READY));
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
			if (_netStream != null)
			{
				_netStream.destruct();
			}
			_netStream = new VideoNetStream(_netConnection);
			_netStream.checkPolicyFile = true;
			_netStream.soundTransform = new SoundTransform(_status == PlayerStatus.LOADING ? 0 : _volume);
			_netStream.addEventListener(VideoMetaDataEvent.METADATA, handleMetaDataEvent);
			_netStream.addEventListener(CuePointEvent.CUEPOINT, handleCuePointEvent);
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncError);
			_netStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			_netStream.bufferTime = _bufferTime;
			
			_video.attachNetStream(_netStream);
			
			if (debug) logDebug("createNetStream: ");
			
			addChild(_video);
			if (debug) addChild(_txtDebug);
		}
		
		private function createDebugInfo():void
		{
			_txtDebug = addChild(_txtDebug || new TextField()) as TextField;
			_txtDebug.background = true;
			_txtDebug.alpha = .75;
			_txtDebug.border = true;
			_txtDebug.multiline = true;
			_txtDebug.width = _video.width;
			_txtDebug.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function handleEnterFrame(event:Event):void
		{
			// if loaded, dispatch event
			if (bytesLoaded > 10 && bytesLoaded == bytesTotal && _isLoaded == false)
			{
				_isLoaded = true;
				
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.MOVIE_LOADED));
				
				if (!_debug) removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
			
			if (_debug)
			{
				_txtDebug.text = "";
				_txtDebug.appendText("url: " + videoPath + "\n");
				if (videoPath && !isRTMPStream(videoPath)) _txtDebug.appendText((isLoaded ? "loaded" : "loading") + ': ' + int(bytesLoaded / 1024) + ' / ' + int(bytesTotal / 1024) + " KB - " + uint(100 * bytesLoaded / bytesTotal) + "%\n");
				_txtDebug.appendText(status + ": " + TimeUtils.secondsToString(currentPlayTime) + " / " + TimeUtils.formatTime(duration * 1000) + "\n");
				_txtDebug.appendText(scaleMode + ": " + videoWidth + "x" + videoHeight);
				if (!_video.visible) _txtDebug.appendText(" (hidden)");
			}
		}
		
		private function setVideoSize():void
		{
			var videoWidth:Number = videoWidth;
			var videoHeight:Number = videoHeight;
			
			if (debug) logDebug("setVideoSize: " + _scaleMode + " " + videoWidth + "*" + videoHeight);
			
			switch (_scaleMode)
			{
				case ScaleMode.EXACT_FIT:
				{
					// do nothing
					_video.width = _width;
					_video.height = _height;
					break;
				}	
				case ScaleMode.NO_BORDER:
				{
					if (_width / videoWidth > _height / videoHeight)
					{
						_video.height = (_width / videoWidth) * videoHeight;
						_video.width = _width;
					}
					else
					{
						_video.width = (_height / videoHeight) * videoWidth;
						_video.height = _height;
					}
					break;
				}
				case ScaleMode.NO_SCALE:
				{
					_video.width = videoWidth;
					_video.height = videoHeight;
					break;
				}	
				case ScaleMode.SHOW_ALL:
				{
					if (_width / videoWidth < _height / videoHeight)
					{
						_video.height = (_width / videoWidth) * videoHeight;
						_video.width = _width;
					}
					else
					{
						_video.width = (_height / videoHeight) * videoWidth;
						_video.height = _height;
					}
					break;
				}
			}
			if (!_upscaleEnabled)
			{
				if (_video.width > videoWidth)
				{
					_video.width = videoWidth;
				}
				if (_video.height > videoHeight)
				{
					_video.height = videoHeight;
				}
			}
			setAlign();
			
			setBackground();
		}
		
		private function setAlign():void
		{
			// Horizontal
			switch (_align)
			{
				case Align.LEFT:
				case Align.TOP_LEFT:
				case Align.BOTTOM_LEFT:
					_video.x = 0;
					break;

				case Align.RIGHT:
				case Align.TOP_RIGHT:
				case Align.BOTTOM_RIGHT:
					_video.x = -1 * (_video.width - _width);
					break;
				
				default:
					_video.x = - 0.5 * (_video.width - _width);
					break;
			}
			
			// Vertical
			switch (_align)
			{
				case Align.TOP:
				case Align.TOP_LEFT:
				case Align.TOP_RIGHT:
					_video.y = 0;
					break;

				case Align.BOTTOM:
				case Align.BOTTOM_LEFT:
				case Align.BOTTOM_RIGHT:
					_video.y = -1 * (_video.height - _height);
					break;
				
				default:
					_video.y = - 0.5 * (_video.height - _height);
					break;
			}
		}

		private function setBackground():void 
		{
			graphics.clear();
			if (_background)
			{
				graphics.beginFill(_backgroundColor, _backgroundAlpha);
				graphics.drawRect(0, 0, _width, _height);
				graphics.endFill();
			}
		}

		/**
		 * Removes all listeners of the video player
		 */
		override public function destruct():void
		{
			removeAllStrongEventListenersForType(StatusEvent.STATUS_CHANGE);
			stop();
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);

			if (_netStream)
			{
				_netStream.destruct();
				_netStream = null;
			}
			if (_netConnection)
			{
				_netConnection.destruct();
				_netConnection = null;
			}
			_metaData = null;
			
			if (_video)
			{
				_video.destruct();
				_video = null;
			}
			
			if (_screenShot)
			{
				_screenShot.dispose();
				_screenShot = null;
			}
			
			_txtDebug = null;
			_cuePoint = null;
			
			super.destruct();
		}
	}
}
