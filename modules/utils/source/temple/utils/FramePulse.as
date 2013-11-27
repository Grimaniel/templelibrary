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

package temple.utils 
{
	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * Class to generate onEnterFrame events.
	 * @example
	 * <listing version="3.0">	
	 * FramePulse.addEnterFrameListener(handleEnterFrame);
	 * 
	 * // function that handles onEnterFrame events
	 * public function handleEnterFrame (event:Event) : void {
	 * 	
	 * // code goes here...
	 * }
	 * </listing>
	 * 
	 * To stop receiving the onEnterFrame event:
	 * <listing version="3.0">	
	 * FramePulse.removeEnterFrameListener(handleEnterFrame);
	 * </listing>
	 * 
	 * @author ASAPLibrary
	 */
	public final class FramePulse 
	{
		private static var _shape:Shape;

		/**
		 * Add a listener to the FramePulse
		 * @param handler function to be called on enterframe, with parameter Event
		 */
		public static function addEnterFrameListener(handler:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			(FramePulse._shape ||= new Shape()).addEventListener(Event.ENTER_FRAME, handler, useCapture, priority, useWeakReference);
		}

		/**
		 * Remove a listener from the FramePulse
		 * @param handler function that was previously added
		 */
		public static function removeEnterFrameListener(handler:Function, useCapture:Boolean = false):void 
		{
			if (FramePulse._shape) FramePulse._shape.removeEventListener(Event.ENTER_FRAME, handler, useCapture);
		}
		
		/**
		 * Add a listener to the FramePulse
		 * @param handler function to be called on exitFrame, with parameter Event
		 */
		public static function addExitFrameListener(handler:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			(FramePulse._shape ||= new Shape()).addEventListener(Event.EXIT_FRAME, handler, useCapture, priority, useWeakReference);
		}

		/**
		 * Remove a listener from the FramePulse
		 * @param handler function that was previously added
		 */
		public static function removeExitFrameListener(handler:Function, useCapture:Boolean = false):void 
		{
			if (FramePulse._shape) FramePulse._shape.removeEventListener(Event.EXIT_FRAME, handler, useCapture);
		}
	}
}