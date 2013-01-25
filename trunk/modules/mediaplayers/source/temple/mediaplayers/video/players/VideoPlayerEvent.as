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
			return new VideoPlayerEvent(type, bubbles);
		}
	}
}