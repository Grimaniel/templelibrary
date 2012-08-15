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
			
			this._timelineController = new TimelineController(this);
			
//			this._timelineController.debug = true;
			this._timelineController.dispatchLabelEvents = true;
			
			this._timelineController.addLabelEventListener('test', handleLabelEvent);
			this._timelineController.addLabelEventListener('test2', handleLabelEvent);
			this._timelineController.addLabelEventListener('test', handleLabelEvent, -10);
			this._timelineController.addLabelEventListener('test', handleLabelEvent, -1);
			this._timelineController.addLabelEventListener('test', handleLabelEvent, 1);
			this._timelineController.addFrameEventListener(20, handleLabelEvent);
			
			this._timelineController.addEventListener(TimelineControllerEvent.REACH_FRAME, handleTimeLineControllerEvent);
			
			this.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
//			this._timelineController.removeLabelEventListener('test', handleLabelEvent);
//			this._timelineController.removeLabelEventListener('test2', handleLabelEvent);
//			this._timelineController.removeLabelEventListener('test', handleLabelEvent, -10);
//			this._timelineController.removeLabelEventListener('test', handleLabelEvent, -1);
//			this._timelineController.removeLabelEventListener('test', handleLabelEvent, 1);
//			this._timelineController.removeFrameEventListener(20, handleLabelEvent);
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
			if (this._timelineController)
			{
				this._timelineController.destruct();
				this._timelineController = null;
			}
			super.destruct();
		}
		
		private function handleEnterFrame(event:Event):void
		{
			this.txtFrameNum.text = this.currentFrame.toString();
		}
	}
}
