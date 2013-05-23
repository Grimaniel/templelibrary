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
