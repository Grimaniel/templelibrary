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
