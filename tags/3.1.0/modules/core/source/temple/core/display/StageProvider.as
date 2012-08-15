/*
include "../includes/License.as.inc";
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
		include "../includes/Version.as.inc";
		
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
