/**
 * @exampleText
 * 
 * <a name="BoundsBehavior"></a>
 * <h1>BoundsBehavior</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/behaviors/BoundsBehavior.html">BoundsBehavior</a>.</p>
 *  
 * <p>The Sprite (blue square) can only be dragged within the bounds (red rectangle).</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/BoundsBehaviorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/BoundsBehaviorExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.behaviors.DragBehavior;

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class BoundsBehaviorExample extends DocumentClassExample 
	{
		public function BoundsBehaviorExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - BoundsBehaviorExample");
			
			// Create a new Sprite, draw a rectangle so we can see something
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xD0DEEC, 1);
			sprite.graphics.lineStyle(1, 0x99A6C4, 1, true);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();
			sprite.buttonMode = true;
			
			this.addChild(sprite);
			
			// create the bounds
			var bounds:Rectangle = new Rectangle(10, 45, 200, 200);
			
			// add DragBehavior with bounds to make te sprite draggable within the bounds
			new DragBehavior(sprite, bounds);
			
			
			// draw the bounds so we can see where they are
			this.graphics.lineStyle(1, 0xDEDEDA);
			this.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			this.graphics.endFill();
			
			// create label
			var label:TextField = new TextField();
			label.defaultTextFormat = new TextFormat("Arial", 12, 0x333333, true);
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = label.y = 10;
			label.selectable = label.mouseEnabled = false;
			label.text = "Drag the box";
			this.addChild(label);
		}
	}
}
