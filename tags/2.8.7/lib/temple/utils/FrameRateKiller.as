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

package temple.utils 
{
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;
	import flash.utils.getTimer;
	import temple.core.CoreObject;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * The FrameRateKiller allows you to throttle the framerate of SWF, without changing the frameRate of the Stage.
	 * 
	 * <p>The FrameRateKiller is very useful for testing and debug purposes. For instance check how your application will perform on a slow computer.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new FrameRateKiller();
	 * </listing>
	 * 
	 * @includeExample ../ui/animation/FrameStableMovieClipExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class FrameRateKiller extends CoreObject
	{
		private static var _sprite:Sprite = new Sprite();
		
		private var _time:int;
		private var _frameDuration:Number;

		public function FrameRateKiller(fps:Number = 10)
		{
			this.fps = fps;
			FrameRateKiller._sprite.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
		}

		/**
		 * The maximum frames per seconds of the SWF. Value must be hight then 0.
		 */
		public function get fps():Number 
		{
			return 1000 / this._frameDuration;
		}

		/**
		 * @inheritDoc
		 */
		public function set fps(value:Number):void
		{
			if (isNaN(value) || value <= 0)
			{
				throwError(new TempleArgumentError(this, "FPS must be higher then zero"));
			}
			else
			{
				this._frameDuration = 1000 / value;
			}
			
		}

		private function handleEnterFrame(event:Event):void
		{
			if (!this._time) this._time = getTimer();
			while (getTimer() - this._time < this._frameDuration)
			{
				// do nothing
			}
			this._time = getTimer();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			FrameRateKiller._sprite.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			super.destruct();
		}
	}
}
