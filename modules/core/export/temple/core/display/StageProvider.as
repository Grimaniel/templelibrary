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
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.templelibrary;


	/**
	 * The StageProvider stores a global reference to the stage.
	 * 
	 * The stage is automatically set by the <code>CoreSprite</code> and the <code>CoreMovieClip</code>.
	 * 
	 * @author Thijs Broerse
	 */
	public final class StageProvider 
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.4.0";
		
		private static var _stage:Stage;
		
		/**
		 * Returns a reference of the stage
		 */
		public static function get stage():Stage
		{
			return StageProvider._stage;
		}
		
		/**
		 * Set the stage. The stage is automatically set by the <code>CoreSprite</code> and the <code>CoreMovieClip</code>.
		 */
		public static function set stage(value:Stage):void
		{
			if (value == null)
			{
				throwError(new TempleArgumentError(StageProvider, "Stage cannot be set to null"));
			}
			else if (StageProvider._stage == null)
			{
				StageProvider._stage = value;
				StageProvider._stage.addEventListener(FullScreenEvent.FULL_SCREEN, StageProvider.handleFullScreen, false, int.MAX_VALUE, true);
			}
		}
		
		private static function handleFullScreen(event:FullScreenEvent):void
		{
			if (event.fullScreen)
			{
				StageProvider._stage.addEventListener(KeyboardEvent.KEY_DOWN, StageProvider.handleKeyDown, false, int.MAX_VALUE, true);
				StageProvider._stage.addEventListener(Event.ENTER_FRAME, StageProvider.handleFrameDelay);
			}
		}
		
		/**
		 * Stop KeyboardEvent for SPACE, since this one is caused by a bug
		 * http://bugs.adobe.com/jira/browse/FP-814
		 */
		private static function handleKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE) event.stopImmediatePropagation();
		}
		
		private static function handleFrameDelay(event:Event):void
		{
			StageProvider._stage.removeEventListener(KeyboardEvent.KEY_DOWN, StageProvider.handleKeyDown);
			StageProvider._stage.removeEventListener(Event.ENTER_FRAME, StageProvider.handleFrameDelay);
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(StageProvider);
		}
	}
}
