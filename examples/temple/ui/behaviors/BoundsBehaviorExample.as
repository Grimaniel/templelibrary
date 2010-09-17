/**
 * @exampleText
 * 
 * <a name="BoundsBehavior"></a>
 * <h1>BoundsBehavior</h1>
 * 
 * <p>This is an example about how the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/behaviors/BoundsBehavior.html">BoundsBehavior</a> works.</p>
 *  
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/BoundsBehaviorExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/BoundsBehaviorExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/BoundsBehaviorExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import flash.geom.Rectangle;
	import temple.ui.behaviors.DragBehavior;
	import temple.core.CoreSprite;

	import flash.display.Sprite;

	public class BoundsBehaviorExample extends CoreSprite 
	{
		public function BoundsBehaviorExample()
		{
			// Create a new Sprite
			var sprite:Sprite = new Sprite();
			
			// Draw a rectangle so we can see something
			sprite.graphics.beginFill(0x000000);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();
			
			// add to stage
			this.addChild(sprite);
			
			// add DragBehavior with bounds to make te sprite draggable within the bounds
			new DragBehavior(sprite, new Rectangle(100, 100, 200, 200));
		}
	}
}