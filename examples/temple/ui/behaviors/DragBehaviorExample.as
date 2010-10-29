/**
 * @exampleText
 * 
 * <a name="DragBehavior"></a>
 * <h1>DragBehavior</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/behaviors/DragBehavior.html">DragBehavior</a>.</p>
 *  
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/DragBehaviorExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/DragBehaviorExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/DragBehaviorExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import temple.ui.behaviors.DragBehavior;
	import temple.utils.propertyproxy.TweenLitePropertyProxy;

	import com.greensock.OverwriteManager;
	import com.greensock.easing.Elastic;

	import flash.display.Sprite;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class DragBehaviorExample extends DocumentClassExample 
	{
		public function DragBehaviorExample()
		{
			super("Temple - DragBehaviorExample");
			
			// Create a new Sprite
			var sprite:Sprite = new Sprite();
			
			// Draw a rectangle so we can see something
			sprite.graphics.beginFill(0x000000);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();
			
			// add to stage
			this.addChild(sprite);
			
			// add DragBehavior to make te sprite draggable
			new DragBehavior(sprite);
			
						// Create an other Sprite
			var sprite2:Sprite = new Sprite();
			sprite2.x = 200;
			sprite2.y = 100;
			
			// Draw a rectangle so we can see something
			sprite2.graphics.beginFill(0x000000);
			sprite2.graphics.drawRect(0, 0, 50, 50);
			sprite2.graphics.endFill();
			
			// add to stage
			this.addChild(sprite2);
			
			// add DragBehavior to make te sprite draggable
			new DragBehavior(sprite2).positionProxy = new TweenLitePropertyProxy(2, {ease:Elastic.easeOut});
			
			OverwriteManager.init();
			
		}
	}
}
