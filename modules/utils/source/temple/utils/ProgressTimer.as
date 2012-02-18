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

package temple.utils 
{
	import temple.core.utils.CoreTimer;

	import flash.utils.getTimer;

	/**
	 * Same as the normal Timer, but has an extra 'progress' property
	 * 
	 * @author Thijs Broerse
	 */
	public class ProgressTimer extends CoreTimer 
	{
		private var _startTime:Number;

		public function ProgressTimer(delay:Number, repeatCount:int = 0)
		{
			super(delay, repeatCount);
		}

		override public function start():void
		{
			super.start();
			this._startTime = getTimer();
		}

		override public function stop():void
		{
			super.stop();
			this._startTime = NaN;
		}

		override public function reset():void
		{
			super.reset();
			this._startTime = NaN;
		}

		/**
		 * Returns the progress factor of the timer between 0 and 1
		 * where 0 is started and 1 is complete
		 */
		public function get progress():Number
		{
			return this.timeRunning / this.delay;
		}

		/**
		 * Returns the number of milliseconds this timer is running
		 */
		public function get timeRunning():int
		{
			return this.running ? (getTimer() - this._startTime) : 0;
		}
	}
}
