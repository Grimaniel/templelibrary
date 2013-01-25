/**
 * @exampleText
 * 
 * <a name="DragBehavior"></a>
 * <h1>DragBehavior</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/behaviors/DragBehavior.html">DragBehavior</a>.</p>
 *  
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/DragBehaviorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/DragBehaviorExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.behaviors.DragBehavior;
	import temple.utils.propertyproxy.TweenLitePropertyProxy;

	import com.greensock.OverwriteManager;
	import com.greensock.easing.Elastic;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class DragBehaviorExample extends DocumentClassExample 
	{
		public function DragBehaviorExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - DragBehaviorExample");
			
			// Create a new Sprite
			var box1:Sprite = createBox(0xD0DEEC, 0x99A6C4);
			box1.x = 10;
			box1.y = 80;
			box1.buttonMode = true;
			addChild(box1);
			
			// add DragBehavior to make the box draggable
			new DragBehavior(box1);
			
			// Create an other Sprite
			var box2:Sprite = createBox(0xE1ECD0, 0xB1C499);
			box2.x = 80;
			box2.y = 80;
			box2.buttonMode = true;
			addChild(box2);
			
			// add DragBehavior to make the box draggable, using 
			new DragBehavior(box2).positionProxy = new TweenLitePropertyProxy(2, {ease:Elastic.easeOut});
			
			OverwriteManager.init();
			
			
			// create label
			var label:TextField = new TextField();
			label.defaultTextFormat = new TextFormat("Arial", 12, 0x333333, true);
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = label.y = 10;
			label.selectable = label.mouseEnabled = false;
			label.text = "Drag a box";
			addChild(label);
		}
		
		private function createBox(backgroundColor:uint, borderColor:uint):Sprite
		{
			var box:Sprite = new Sprite();
			box.graphics.beginFill(backgroundColor, 1);
			box.graphics.lineStyle(1, borderColor, 1, true);
			box.graphics.drawRect(0, 0, 50, 50);
			box.graphics.endFill();
			return box;	
		}
	}
}
