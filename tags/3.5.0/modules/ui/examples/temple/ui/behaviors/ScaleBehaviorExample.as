/**
 * @exampleText
 * 
 * <a name="ScaleBehavior"></a>
 * <h1>ScaleBehavior</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/behaviors/ScaleBehavior.html">ScaleBehavior</a>.</p>
 *  
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/ScaleBehaviorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/ScaleBehaviorExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.behaviors.ScaleBehavior;
	import temple.ui.behaviors.ScaleBehaviorEvent;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class ScaleBehaviorExample extends DocumentClassExample 
	{
		private var _handle:Sprite;
		private var _box:Sprite;
		
		public function ScaleBehaviorExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - ScaleBehaviorExample");
			
			// Create a new Sprite
			_box = createBox(250, 150, 0xEEEEEE, 0xCCCCCC);
			_box.x = 10;
			_box.y = 80;
			_box.buttonMode = true;
			addChild(_box);
			
			// Create the handle, place it bottom-right, put it inside the box
			_handle = createBox(15, 15, 0xD0DEEC, 0x99A6C4);
			_handle.buttonMode = true;
			positionHandle();
			addChild(_handle);
			
			// add ScaleBehavior to make the box scalable
			var scaleBehavior:ScaleBehavior = new ScaleBehavior(_box, _handle, null, true);
			scaleBehavior.addEventListener(ScaleBehaviorEvent.SCALE_START, handleScaleBehaviorChange);
			scaleBehavior.addEventListener(ScaleBehaviorEvent.SCALE_STOP, handleScaleBehaviorChange);
			scaleBehavior.addEventListener(ScaleBehaviorEvent.SCALING, handleScaleBehaviorChange);
			
			// create label
			var label:TextField = new TextField();
			label.defaultTextFormat = new TextFormat("Arial", 12, 0x333333, true);
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = label.y = 10;
			label.selectable = label.mouseEnabled = false;
			label.text = "Scale the box; drag the blue handle";
			addChild(label);
		}

		private function handleScaleBehaviorChange(event:ScaleBehaviorEvent):void
		{
			positionHandle();
		}

		private function positionHandle():void
		{
			_handle.x = _box.x + _box.width - _handle.width;
			_handle.y = _box.y + _box.height - _handle.height;
		}
		
		private function createBox(width:uint, height:uint, backgroundColor:uint, borderColor:uint):Sprite
		{
			var box:Sprite = new Sprite();
			box.graphics.beginFill(backgroundColor, 1);
			box.graphics.lineStyle(.0001, borderColor, 1, true);
			box.graphics.drawRect(0, 0, width, height);
			box.graphics.endFill();
			return box;	
		}
	}
}
