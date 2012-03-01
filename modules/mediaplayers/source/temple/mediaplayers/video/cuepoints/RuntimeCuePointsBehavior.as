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

package temple.mediaplayers.video.cuepoints 
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import temple.core.behaviors.AbstractBehavior;
	import temple.mediaplayers.players.PlayerStatus;
	import temple.mediaplayers.video.players.IVideoPlayer;

	/**
	 * Class for adding cuepoints in a VideoPlayer at runtime.
	 * 
	 * @includeExample RuntimeCuePointsBehaviorExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class RuntimeCuePointsBehavior extends AbstractBehavior 
	{
		private var _cuepoints:Array;
		private var _previousPlayTime:Number;
		private var _previousCheckTime:Number;

		public function RuntimeCuePointsBehavior(target:IVideoPlayer)
		{
			super(target);
			
			this._cuepoints = new Array();
			
			target.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
		}

		/**
		 * Returns a reference to the VideoPlayer
		 */
		public function get videoPlayer():IVideoPlayer 
		{
			return this.target as IVideoPlayer;
		}

		/**
		 * Add a runtime CuePoint.
		 */
		public function addCuePoint(cuepoint:VideoCuePoint):void 
		{
			this._cuepoints.push(cuepoint);
			this._cuepoints.sortOn('time');
		}

		private function handleEnterFrame(event:Event):void 
		{
			var playTime:Number = this.videoPlayer.currentPlayTime;
			var checkTime:Number = getTimer() * .001;
			if (this.videoPlayer.status == PlayerStatus.PLAYING)
			{
				if (this._previousPlayTime > playTime || isNaN(this._previousPlayTime)) this._previousPlayTime = 0;
				
				if (playTime != this._previousPlayTime && playTime - this._previousPlayTime <= checkTime - this._previousCheckTime + .1)
				{
					var leni:int = this._cuepoints.length;
					var cuepoint:VideoCuePoint;
					for (var i:int = 0; i < leni; i++)
					{
						cuepoint = VideoCuePoint(this._cuepoints[i]);
						if (cuepoint.time > playTime)
						{
							break;
						}
						else if (cuepoint.time > this._previousPlayTime || this._previousPlayTime == 0)
						{
							this.videoPlayer.dispatchEvent(new CuePointEvent(CuePointEvent.CUEPOINT, cuepoint));
						}
					}
				}
			}
			this._previousPlayTime = playTime;
			this._previousCheckTime = checkTime;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (this.videoPlayer)
			{
				this.videoPlayer.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			}
			this._cuepoints = null;
			
			super.destruct();
		}
	}
}
