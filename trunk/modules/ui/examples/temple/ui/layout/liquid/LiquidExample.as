/**
 * @exampleText
 * 
 * <a name="Liquid"></a>
 * <h1>Liquid</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/layout/liquid/LiquidBehavior.html">LiquidBehavior</a>.
 * Resize the browser or FlashPlayer to see how all objects will be scaled and positioned.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/layout/liquid/LiquidExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/layout/liquid/LiquidExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.common.enum.ScaleMode;
	import temple.ui.layout.liquid.LiquidBehavior;
	import temple.ui.layout.liquid.LiquidContainer;
	import temple.ui.layout.liquid.LiquidStage;
	import temple.utils.PerformanceStat;

	[SWF(backgroundColor="#000000", frameRate="31", width="640", height="480")]
	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class LiquidExample extends DocumentClassExample 
	{
		public function LiquidExample()
		{
			super("Temple - LiquidExample");
			
			// set a minimal size on stage
			LiquidStage.getInstance(stage).minimalHeight = 200;
			LiquidStage.getInstance(stage).minimalWidth = 200;
			
			// header
			with (this.addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
			{
				left = 4;
				top = 4;
				right = 4;
				height = 100;
				addChild(new FullSizeBackground());
			}

			// left column
			with (this.addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
			{
				left = 4;
				top = 108;
				bottom = 4;
				width = 100;
				addChild(new FullSizeBackground());
			}

			// footer
			with (this.addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
			{
				left = 108;
				right = 4;
				bottom = 4;
				height = 20;
				addChild(new FullSizeBackground());
			}
			
			// center
			with (this.addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
			{
				left = 108;
				top = 108;
				right = 4;
				bottom = 28;
				background = true;
				
				// top left
				with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
				{
					top = 0;
					left = 0;
					relativeHeight = .5;
					relativeWidth = .5;
					
					with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
					{
						top = 0;
						left = 0;
						right = 2;
						bottom = 2;
						addChild(new FullSizeBackground());
					}
				}
				// top right
				with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
				{
					top = 0;
					right = 0;
					relativeHeight = .5;
					relativeWidth = .5;
					
					with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
					{
						top = 0;
						left = 2;
						right = 0;
						bottom = 2;
						addChild(new FullSizeBackground());
					}
				}

				// bottom left
				with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
				{
					bottom = 0;
					left = 0;
					relativeHeight = .5;
					relativeWidth = 1/3;
					
					with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
					{
						top = 2;
						left = 0;
						right = 2;
						bottom = 0;
						addChild(new FullSizeBackground());
					}
				}
				
				// bottom center
				with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
				{
					bottom = 0;
					relativeX = .5;
					relativeHeight = .5;
					relativeWidth = 1/3;
					
					with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
					{
						top = 2;
						left = 2;
						right = 2;
						bottom = 0;
						addChild(new FullSizeBackground());
					}
				}
			
				// bottom right
				with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
				{
					bottom = 0;
					right = 0;
					relativeHeight = .5;
					relativeWidth = 1/3;
					
					with (addChild(new LiquidContainer(100, 100, ScaleMode.NO_SCALE, null, false)) as LiquidContainer)
					{
						top = 2;
						left = 2;
						right = 0;
						bottom = 0;
						addChild(new FullSizeBackground());
					}
				}
			}
			
			// To check how Liquid performs we add a PerformanceStat
			new LiquidBehavior(this.addChild(new PerformanceStat()), {right: 10, top: 10});
		}
	}
}
import temple.ui.layout.liquid.LiquidSprite;

class FullSizeBackground extends LiquidSprite
{
	public function FullSizeBackground() 
	{
		this.graphics.beginFill(0xffffff, .5);
		this.graphics.drawRect(0, 0, 100, 100);
		this.graphics.endFill();
		
		this.left = 0;
		this.top = 0;
		this.bottom = 0;
		this.right = 0;
		
		this.update();
	}
}
