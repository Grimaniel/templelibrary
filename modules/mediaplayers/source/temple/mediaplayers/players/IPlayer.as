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

package temple.mediaplayers.players 
{
	import temple.common.interfaces.IHasStatus;
	import temple.common.interfaces.IPauseable;
	import temple.core.events.ICoreEventDispatcher;

	/**
	 * @author Thijs Broerse
	 */
	public interface IPlayer extends ICoreEventDispatcher, IPauseable, IHasStatus
	{
		/**
		 * 	start from beginning
		 */
		function play():void;

		/**
		 * Stops the player.
		 */
		function stop():void;

		/**
		 * Seeks to the offset specified (seconds). Pass '0' to rewind the player.
		 * @param seconds the offset to seek to (in seconds)
		 */
		function seek(seconds:Number = 0):void;

		/**
		 *	the current progress time in seconds.
		 */
		function get currentPlayTime():Number;
		
		/**
		 * The total duration in seconds
		 */
		function get duration():Number;

		/**
		 *	returns the current progress (value between 0 and 1)
		 *	if the duration has been set, otherwise returns 0.
		 */
		function get currentPlayFactor():Number;
		
		/**
		 * Get or set the autoRewind of the VideoPlayer
		 * When autoRewind is set to true, the video rewinds when the video is done playing
		 */
		function get autoRewind():Boolean;

		/**
		 * @private
		 */
		function set autoRewind(value:Boolean):void;
	}
}
