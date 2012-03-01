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
	import flash.events.Event;
	import temple.mediaplayers.players.PlayerEvent;


	/**
	 * @author Thijs Broerse
	 */
	public class VideoPlayerEvent extends PlayerEvent 
	{
		public static const BUFFER_EMPTY:String = "VideoPlayerEvent.bufferEmpty";
		public static const BUFFER_FLUSH:String = "VideoPlayerEvent.bufferFlush";
		public static const MOVIE_NOTFOUND:String = "VideoPlayerEvent.movieNotFound";
		public static const SECURITY_ERROR:String = "VideoPlayerEvent.securityError";
		public static const SEEK_INVALID:String = "VideoPlayerEvent.seekInvalid";
		public static const MOVIE_LOADED:String = "VideoPlayerEvent.movieLoaded";
		public static const SEEK_NOTIFY:String = "VideoPlayerEvent.seekNotify";

		/** 
		 * Dispatched when do a loadMovie and movie is visible and paused on first frame
		 */
		public static const LOAD_READY:String = "VideoPlayerEvent.loadReady";

		public function VideoPlayerEvent(type:String, bubbles:Boolean = false) 
		{
			super(type, bubbles);
		}

		/**
		 * Creates a copy
		 */
		override public function clone():Event 
		{
			return new VideoPlayerEvent(this.type, this.bubbles);
		}
	}
}