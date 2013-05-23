/**
 * @exampleText
 * 
 * <a name="LiquidContainer"></a>
 * <h1>LiquidContainer</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/layout/liquid/LiquidContainer.html">LiquidContainer</a>.
 * Resize the browser or FlashPlayer to see how all objects will be scaled and positioned.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/layout/liquid/LiquidContainerExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/layout/liquid/LiquidContainerExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.ui.layout.liquid.LiquidBehavior;
	import temple.ui.layout.liquid.LiquidContainer;

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class LiquidContainerExample extends DocumentClassExample
	{
		public function LiquidContainerExample()
		{
			super("Temple - LiquidContainerExample");
			
			var container:LiquidContainer = new LiquidContainer();
			container.clipping = true;
			container.top = container.left = container.right = container.bottom = 10;
			//container.background = true;
			
			var box:Shape = new Shape();
			
			var matrix:Matrix = new Matrix();
     		matrix.createGradientBox(500, 500, 0, 0, 0);
			box.graphics.beginGradientFill(GradientType.LINEAR, [0x00FF00, 0x0000FF], [1, 1], [0, 255], matrix);
			box.graphics.drawRect(0, 0, 500, 500);
			box.graphics.endFill();
			
			container.addChild(box);
			
			// Add box in the top left corner
			box = new Shape();
			box.graphics.beginFill(0xFF0000);
			box.graphics.drawRect(0, 0, 50, 50);
			box.graphics.endFill();
			new LiquidBehavior(box, {left: 0, top: 0});
			container.addChild(box);
			
			// Add box in the top right corner
			box = new Shape();
			box.graphics.beginFill(0xFF0000);
			box.graphics.drawRect(0, 0, 50, 50);
			box.graphics.endFill();
			new LiquidBehavior(box, {right: 0, top: 0});
			container.addChild(box);
			
			// Add box in the bottom left corner
			box = new Shape();
			box.graphics.beginFill(0xFF0000);
			box.graphics.drawRect(0, 0, 50, 50);
			box.graphics.endFill();
			new LiquidBehavior(box, {left: 0, bottom: 0});
			container.addChild(box);
			
			// Add box in the bottom right corner
			box = new Shape();
			box.graphics.beginFill(0xFF0000);
			box.graphics.drawRect(0, 0, 50, 50);
			box.graphics.endFill();
			new LiquidBehavior(box, {right: 0, bottom: 0});
			container.addChild(box);
			
			// Add box in the center
			box = new Shape();
			box.graphics.beginFill(0xFF0000);
			box.graphics.drawRect(0, 0, 50, 50);
			box.graphics.endFill();
			new LiquidBehavior(box, {horizontalCenter: 0, verticalCenter: 0});
			container.addChild(box);
			
			addChild(container);
		}
	}
}
