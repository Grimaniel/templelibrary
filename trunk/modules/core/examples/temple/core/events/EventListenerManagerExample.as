/**
 * @exampleText
 * 
 * <a name="EventListenerManager"></a>
 * <h1>EventListenerManager</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/events/EventListenerManager.html">EventListenerManager</a>
 * </p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/events/EventListenerManagerExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/events/EventListenerManagerExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.core.destruction.Destructor;
	import flash.events.MouseEvent;
	import temple.core.events.EventListenerManager;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class EventListenerManagerExample extends DocumentClassExample
	{
		private var _textField:TextField;
		
		public function EventListenerManagerExample()
		{
			super("Temple - EventListenerManagerExample");
			
			
			addChild(new TestSprite()).y = 100;
			addChild(new TestSprite()).y = 200;
			addChild(new TestSprite()).y = 300;
			
			
			trace(EventListenerManager.getInstance(stage).getInfo());
			
			_textField = new TextField();
			_textField.defaultTextFormat = new TextFormat("Arial", 11, 0x333333);
			_textField.text = "These square listens to the resize of the stage.\nBy clicking on a square it removes al his listeners, so it will not react on the stage anymore.\nWhen you click on this TextField, it will be destructed, and so the click listener will be removed.";
			_textField.autoSize = TextFieldAutoSize.LEFT;
			addChild(_textField);
			listenTo(_textField, MouseEvent.CLICK, handleTextFieldClick);
			
			stage.dispatchEvent(new Event(Event.RESIZE));
		}

		private function handleTextFieldClick(event:MouseEvent):void
		{
			trace(eventListenerManager.getInfo());
			
			trace("Destruct TextField");
			
			Destructor.destruct(_textField);
			
			trace(eventListenerManager.getInfo());
		}
		
	}
}
import temple.core.display.CoreSprite;
import temple.core.events.EventListenerManager;

import flash.events.Event;
import flash.events.MouseEvent;

class TestSprite extends CoreSprite
{
	public function TestSprite()
	{
		buttonMode = true;
		graphics.beginFill(0xFF0000);
		graphics.drawRect(0, 0, 50, 50);
		
		listenTo(stage, Event.RESIZE, handleResize);
		listenOnceTo(stage, Event.RESIZE, handleResizeOnce);
		
		addEventListener(MouseEvent.CLICK, handleClick);
		
		trace(eventListenerManager.getInfo());
	}
	
	private function handleResize(event:Event):void
	{
		x = stage.stageWidth - width - 10;
	}
	
	private function handleResizeOnce(event:Event):void
	{
		trace("Once");
	}
	
	private function handleClick(event:MouseEvent):void
	{
		removeAllEventListeners();
		
		trace(eventListenerManager.getInfo());
		trace(EventListenerManager.getInstance(stage).getInfo());
	}
}
