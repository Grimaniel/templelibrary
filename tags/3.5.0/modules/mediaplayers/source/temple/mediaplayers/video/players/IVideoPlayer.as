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
	import temple.common.interfaces.IAudible;
	import temple.core.debug.IDebuggable;
	import temple.core.display.IDisplayObject;
	import temple.mediaplayers.players.IProgressiveDownloadPlayer;
	import temple.mediaplayers.video.metadata.VideoMetaData;

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
	 * @author Thijs Broerse
	 */
	public interface IVideoPlayer extends IProgressiveDownloadPlayer, IDisplayObject, IDebuggable, IAudible
	{
		/**
		 * The path of the current video
		 */
		function get videoPath():String;
		
		/**
		 * @private
		 */
		function set videoPath(value:String):void
		
		/**
		 *	Returns metadata of loaded movie
		 */
		function get metaData():VideoMetaData;
		
		/**
		 * Get or set the scale mode of the Video
		 * 
		 * Possible values:
		 * ScaleMode.EXACT_FIT		Specifies that the entire video be visible in the specified area without trying to preserve the original aspect ratio.
		 * ScaleMode.NO_BORDER		Specifies that the entire video fill the specified area, without distortion but possibly with some cropping, while maintaining the original aspect ratio of the video.
		 * ScaleMode.NO_SCALE		Specifies that the size of the video be fixed, so that it remains unchanged even as the size of the player changes.
		 * ScaleMode.SHOW_ALL		Specifies that the entire video be visible in the specified area without distortion while maintaining the original aspect ratio of the video. 
		 */
		function get scaleMode():String;

		/**
		 * @private
		 */
		function set scaleMode(value:String):void;
		
		/**
		 * Clears the image currently displayed in the Video object. This is useful when you want to display standby information without having to hide the Video object. 
		 */
		function clear():void;

		/**
		 * Specifies whether the video should be smoothed (interpolated) when it is scaled. For smoothing to work, the player must be in high-quality mode. The default value is false (no smoothing).
		 */
		function get smoothing():Boolean;

		/**
		 * @private
		 */
		function set smoothing(value:Boolean):void;
		
		/**
		 * Return the domain + the application name
		 * (Substring of begin till 2nd "/" after "rtmp://"
		 */
		function get rtmpConnection():String;
		
		/**
		 * @inheritDoc
		 */
		function set rtmpConnection(value:String):void;
	}
}
