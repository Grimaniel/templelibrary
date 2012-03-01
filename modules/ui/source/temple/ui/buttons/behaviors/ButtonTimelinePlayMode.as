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

package temple.ui.buttons.behaviors
{
	import temple.common.enum.Enumerator;

	/**
	 * This contains possible values of what should happen when the <code>ButtonTimelineBehavior</code> must go to an
	 * other label.
	 * 
	 * @see temple.ui.buttons.behaviors.ButtonTimelineBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class ButtonTimelinePlayMode extends Enumerator
	{
		/**
		 * Play the timeline in reverse (if possible) till the new state is reached.
		 */
		public static const REVERSED:ButtonTimelinePlayMode = new ButtonTimelinePlayMode("reversed");
		
		/**
		 * Continue playing the timeline until the end of the animation is reached then go to the new state.
		 */
		public static const CONTINUE:ButtonTimelinePlayMode = new ButtonTimelinePlayMode("continue");
		
		/**
		 * Stop current animation and jump immediately to the new state.
		 */
		public static const IMMEDIATELY:ButtonTimelinePlayMode = new ButtonTimelinePlayMode("immediately");
		
		/**
		 * Get the value of ButtonTimelinePlayMode based on a String
		 */
		public static function get(value:String):ButtonTimelinePlayMode
		{
			return Enumerator.get(ButtonTimelinePlayMode, value) as ButtonTimelinePlayMode;
		}
		
		/**
		 * @private
		 */
		public function ButtonTimelinePlayMode(value:String)
		{
			super(value);
		}
	}
}
