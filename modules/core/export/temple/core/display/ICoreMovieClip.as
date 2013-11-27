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

package temple.core.display
{
	import temple.core.debug.IDebuggable;
	
	import flash.display.FrameLabel;
	
	/**
	 * @author Thijs Broerse
	 */
	public interface ICoreMovieClip extends IMovieClip, ICoreDisplayObjectContainer, IDebuggable
	{
		/**
		 * A Boolean which indicates if the MovieClip has a script on a specific frame.
		 * @param frame the frame to check for a script. Note: frame is 1 based.
		 */
		function hasFrameScript(frame:Object):Boolean;

		/**
		 * A Boolean which indicates if the MovieClip has frame scripts.
		 */
		function get hasFrameScripts():Boolean;
		
		/**
		 * Returns the script in a specific frame.
		 * @param frame the frame which has the script. Note: frame is 1 based.
		 */
		function getFrameScript(frame:Object):Function;

		/**
		 * Set the script on a specific frame.
		 * @param frame the frame of the script. Note: frame is 1 based.
		 * @param script the script to set on the frame.
		 */
		function setFrameScript(frame:Object, script:Function):void;

		/**
		 * Clears the script on a specific frame.
		 * @param frame the frame to clear. Note: frame is 1 based.
		 */
		function clearFrameScript(frame:Object):void;
		
		/**
		 * Removes all frame scripts.
		 */
		function clearFrameScripts():void;
		
		/**
		 * Returns a hash with all the FrameLabels with the name and frame as index.
		 */
		function get frameLabels():Object;
		
		/**
		 * Returns the FrameLabel for a specific frame.
		 */
		function getFrameLabel(frame:Object):FrameLabel;
		
		/**
		 * Returns the frame for a specific frame number or frame label. Returns 0 if the frame is not found
		 */
		function getFrame(frame:Object):int;
		
		/**
		 * Returns <code>true</code> if the timeline contains a specific frame label.
		 */
		function hasFrameLabel(frame:Object):Boolean;
	}
}
