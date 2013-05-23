/**
 * @exampleText
 * 
 * <a name="CoreDisplayObjects"></a>
 * <h1>CoreDisplayObjects</h1>
 * 
 * <p>This is an example of the CoreDisplayObjects of the Temple:
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/display/CoreMovieClip.html">CoreMovieClip</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/display/CoreSprite.html">CoreSprite</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/display/CoreBitmap.html">CoreBitmap</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/display/CoreShape.html">CoreShape</a> and
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/display/CoreLoader.html">CoreLoader</a>.
 * </p>
 * 
 * <p>This example also uses the 
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/debug/log/Log.html">Log</a> for getting debug info, the 
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/debug/Memory.html">Memory</a> and  
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/debug/MemoryDebugger.html">MemoryDebugger</a>
 * for testing destruction.</p>
 * 
 * <p>Every <code>TimerEvent</code> of a <a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/doc/temple/core/utils/CoreTimer.html">CoreTimer</a>
 * a new CodeDisplayObject (<code>CoreMovieClip</code>, <code>CoreSprite</code>, <code>CoreLoader</code>, <code>CoreBitmap</code> or <code>CoreShape</code>) is created.
 * Clicking on the object destructs the object (only on <code>InteractiveObjects</code>) or double clicking the TextField distructs all the objects.
 * The <code>MemoryDebugger</code> checks the content of the <code>Memory</code> and sends the info to the <code>Log</code>.
 * The output of the Log is displayed in the TextField.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/display/CoreDisplayObjectsExample.swf" target="_blank">View this example</a></p>
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/core/examples/temple/core/display/CoreDisplayObjectsExample.as" target="_blank">View source</a></p>
 */
package
{
	import flash.system.System;
	import temple.core.debug.MemoryDebugger;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogEvent;
	import temple.core.destruction.Destructor;
	import temple.core.destruction.IDestructible;
	import temple.core.display.CoreBitmap;
	import temple.core.display.CoreLoader;
	import temple.core.display.CoreMovieClip;
	import temple.core.display.CoreShape;
	import temple.core.display.CoreSprite;
	import temple.core.display.ICoreDisplayObject;
	import temple.core.utils.CoreTimer;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	[SWF(backgroundColor="#000000", frameRate="31", width="640", height="480")]
	public class CoreDisplayObjectsExample extends CoreSprite
	{
		private var _output:TextField;
		private var _timer:CoreTimer;
		
		public function CoreDisplayObjectsExample()
		{
			// create a TextField for displaying the output of the Log
			_output = new TextField();
			_output.defaultTextFormat = new TextFormat("Arial", 11, 0xffffff);
			_output.autoSize = TextFieldAutoSize.LEFT;
			addChild(_output);
			_output.doubleClickEnabled = true;
			// double clicking the TextField destructs all objects
			_output.addEventListener(MouseEvent.DOUBLE_CLICK, handleOutputDoubleClick);
			
			// add a listener on the Log to get the log messages
			Log.addLogListener(handleLogEvent);
			
			// create an instance of the MemoryDebugger, which checks the Memory for possible leaks
			new MemoryDebugger();
			
			// create a timer for creating objects 
			_timer = new CoreTimer(500, 10);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			_timer.start();
		}

		private function handleTimer(event:TimerEvent):void
		{
			// random create a CoreDisplayObject
			switch (int(Math.random() * 5))
			{
				case 0:
				{
					var sprite:CoreSprite = new CoreSprite();
					sprite.graphics.beginFill(0x0000ff, .5);
					sprite.graphics.lineStyle(1, 0x0000ff);
					sprite.graphics.drawRect(0, 0, 50, 50);
					sprite.addEventListener(MouseEvent.CLICK, handleClick);
					sprite.buttonMode = true;
					addOnStage(sprite);
					break;
				}
				case 1:
				{
					var movieClip:CoreMovieClip = new CoreMovieClip();
					movieClip.graphics.beginFill(0x00ff00, .5);
					movieClip.graphics.lineStyle(1, 0x00ff00);
					movieClip.graphics.drawRect(0, 0, 50, 50);
					movieClip.addEventListener(MouseEvent.CLICK, handleClick);
					movieClip.buttonMode = true;
					addOnStage(movieClip);
					break;
				}
				case 2:
				{
					var shape:CoreShape = new CoreShape();
					shape.graphics.beginFill(0xff0000, .5);
					shape.graphics.lineStyle(1, 0xff0000);
					shape.graphics.drawRect(0, 0, 50, 50);
					addOnStage(shape);
					break;
				}
				case 3:
				{
					var loader:CoreLoader = new CoreLoader();
					loader.load(new URLRequest('http://code.google.com/p/templelibrary/logo'));
					// don't add the COMPLETE listener on the contentLoaderInfo, but on the loader
					loader.addEventListenerOnce(Event.COMPLETE, handleLoaderComplete);
					loader.addEventListener(MouseEvent.CLICK, handleClick);
					break;
				}
				case 4:
				{
					var bitmapData:BitmapData = new BitmapData(50, 50, false, 0xffff00);
					var bitmap:CoreBitmap = new CoreBitmap(bitmapData);
					bitmap.alpha = .7;
					addOnStage(bitmap);
				}
			}
			
			// don't allow more than 50 objects
			if (numChildren > 50)
			{
				IDestructible(getChildAt(1)).destruct();
			}
		}

		private function addOnStage(object:ICoreDisplayObject):void
		{
			// add to stage on a random positon
			addChild(object as DisplayObject);
			object.position = new Point(int(Math.random() * (stage.stageWidth - object.width)), int(Math.random() * (stage.stageHeight - object.height)));
		}


		private function handleTimerComplete(event:TimerEvent):void
		{
			// destruct the timer (just for testing) and create a new one
			_timer.destruct();
			_timer = null;
			
			_timer = new CoreTimer(500, 10);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			_timer.start();
		}

		private function handleLogEvent(event:LogEvent):void
		{
			// put the log output in the TextField
			_output.text = "Memory info: (double click to delete all objects)\n" + event.data;
		}
		
		private function handleClick(event:MouseEvent):void
		{
			// destruct the object
			IDestructible(event.target).destruct();
		}
		
		private function handleLoaderComplete(event:Event):void
		{
			// image is loaded, add on stage
			addOnStage(CoreLoader(event.target));
		}
		
		private function handleOutputDoubleClick(event:MouseEvent):void
		{
			// destruct all
			Destructor.destructChildren(this);
			
			// the TextField is also destructed, so put it back on stage
			addChild(_output);
			
			System.gc();
		}
	}
}
