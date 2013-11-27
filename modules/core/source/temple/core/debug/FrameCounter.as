/*
include "../includes/License.as.inc";
 */

package temple.core.debug
{
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * Counts the frames since the application has started.
	 * 
	 * @author Thijs Broerse
	 */
	public final class FrameCounter
	{
		/**
		 * DisplayObject for EnterFrame events
		 */
		private static const _shape:Shape = new Shape();
		
		private static var _frame:uint = 1;

		public static function get frame():uint
		{
			return FrameCounter._frame;
		}
		
		private static function init():void
		{
			_shape.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		private static function handleEnterFrame(event:Event):void
		{
			FrameCounter._frame++;
		}
		
		init();
	}
}
