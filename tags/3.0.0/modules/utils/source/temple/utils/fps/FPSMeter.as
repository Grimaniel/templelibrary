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

package temple.utils.fps
{
	import temple.core.CoreObject;
	import temple.utils.FramePulse;

	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * Class for calculating the current frame rate.
	 * 
	 * @author Thijs Broerse
	 */
	public class FPSMeter extends CoreObject
	{
		private var _times:Array;
		private var _length:uint;
		
		public function FPSMeter(length:uint = 100)
		{
			this._length = length;
			this._times = [];
			
			FramePulse.addEnterFrameListener(this.handleEnterFrame);
		}

		public function getFPS(frames:uint = 1):Number
		{
			frames = Math.min(frames, this._times.length - 1);
			return 1000 / ((this._times[0] - this._times[frames]) / frames); 
		}

		public function get length():uint
		{
			return this._length;
		}

		public function set length(value:uint):void
		{
			this._length = value;
		}

		private function handleEnterFrame(event:Event):void
		{
			this._times.unshift(getTimer());
			
			if (this._times.length > this._length) this._times.length = this._length;
		}

		override public function destruct():void
		{
			FramePulse.removeEnterFrameListener(this.handleEnterFrame);
			
			super.destruct();
		}
	}
}
