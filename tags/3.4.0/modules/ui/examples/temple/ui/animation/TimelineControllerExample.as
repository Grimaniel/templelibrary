/**
 * @exampleText
 * 
 * <a name="TimelineController"></a>
 * <h1>TimelineController</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/animation/TimelineController.html">TimelineController</a>.</p>
 *  
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/animation/TimelineControllerExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/DragBehaviorExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.animation.TimelineController;
	import temple.ui.animation.TimelineControllerEvent;
	
	import flash.events.Event;
	import flash.text.TextField;	

	public class TimelineControllerExample extends DocumentClassExample 
	{
		public var txtFrameNum:TextField;

		private var _timelineController:TimelineController;

		public function TimelineControllerExample()
		{
			super("Temple - TimelineControllerExample");
			
			_timelineController = new TimelineController(this);
			
//			_timelineController.debug = true;
			_timelineController.dispatchLabelEvents = true;
			
			_timelineController.addLabelEventListener('test', handleLabelEvent);
			_timelineController.addLabelEventListener('test2', handleLabelEvent);
			_timelineController.addLabelEventListener('test', handleLabelEvent, -10);
			_timelineController.addLabelEventListener('test', handleLabelEvent, -1);
			_timelineController.addLabelEventListener('test', handleLabelEvent, 1);
			_timelineController.addFrameEventListener(20, handleLabelEvent);
			
			_timelineController.addEventListener(TimelineControllerEvent.REACH_FRAME, handleTimeLineControllerEvent);
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
//			_timelineController.removeLabelEventListener('test', handleLabelEvent);
//			_timelineController.removeLabelEventListener('test2', handleLabelEvent);
//			_timelineController.removeLabelEventListener('test', handleLabelEvent, -10);
//			_timelineController.removeLabelEventListener('test', handleLabelEvent, -1);
//			_timelineController.removeLabelEventListener('test', handleLabelEvent, 1);
//			_timelineController.removeFrameEventListener(20, handleLabelEvent);
		}
		
		private function handleTimeLineControllerEvent(event:TimelineControllerEvent):void
		{
			trace("TimelineControllerExample::handleTimeLineControllerEvent, label:" + event.label + " frame:" + event.frame);
		}

		private function handleLabelEvent(event:TimelineControllerEvent):void
		{
			trace("TimelineControllerExample::handleLabelEvent, label:" + event.label + " frame:" + event.frame);
		}
		
		override public function destruct():void
		{
			if (_timelineController)
			{
				_timelineController.destruct();
				_timelineController = null;
			}
			super.destruct();
		}
		
		private function handleEnterFrame(event:Event):void
		{
			this.txtFrameNum.text = currentFrame.toString();
		}
	}
}
