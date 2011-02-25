/**
 * @exampleText
 * 
 * <a name="BoundsBehavior"></a>
 * <h1>BoundsBehavior</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/behaviors/BoundsBehavior.html">BoundsBehavior</a>.</p>
 *  
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/BoundsBehaviorExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/BoundsBehaviorExample.swf</a></p>
 * 
 * <p>The Sprite (blue square) can only be dragged within the bounds (red rectangle).</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/BoundsBehaviorExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import temple.ui.behaviors.DragBehavior;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class BoundsBehaviorExample extends DocumentClassExample 
	{
		public function BoundsBehaviorExample()
		{
			super("Temple - BoundsBehaviorExample");
			
			// Create a new Sprite
			var sprite:Sprite = new Sprite();
			
			// Draw a rectangle so we can see something
			sprite.graphics.beginFill(0x0000ff, .2);
			sprite.graphics.lineStyle(1, 0x0000ff);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();
			
			// add to stage
			this.addChild(sprite);
			
			// create the bounds
			var bounds:Rectangle = new Rectangle(100, 100, 200, 200);
			
			// add DragBehavior with bounds to make te sprite draggable within the bounds
			new DragBehavior(sprite, bounds);
			
			// draw the bounds so we can see something
			this.graphics.lineStyle(1, 0xff0000);
			this.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			this.graphics.endFill();
		}
	}
}
