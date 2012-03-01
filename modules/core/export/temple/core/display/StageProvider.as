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
		templelibrary static const VERSION:String = "3.0.0";
		
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
