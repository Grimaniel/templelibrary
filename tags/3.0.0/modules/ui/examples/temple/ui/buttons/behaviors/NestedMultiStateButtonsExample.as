/**
 * @exampleText
 * 
 * <a name="Nested-MultiStateButtons-EventTunneling"></a>
 * <h1>Nested MultiStateButtons and EventTunneling</h1>
 * 
 * <p>This is an example about how to nest <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/buttons/MultiStateButton.html">MultiStateButtons</a> and how <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/eventtunneling/EventTunneler.html">EventTunneling</a> is used.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/behaviors/NestedMultiStateButtonsExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/behaviors/NestedMultiStateButtonsExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.utils.types.DisplayObjectContainerUtils;

	import flash.display.Sprite;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class NestedMultiStateButtonsExample extends DocumentClassExample 
	{
		public function NestedMultiStateButtonsExample()
		{
			super("Temple - NestedMultiStateButtonsExample");
			
			// create the container buttons
			var container:Button = new Button(325, 125);
			container.x = 50;
			container.y = 50;
			this.addChild(container);
			
			// create a button inside the container. This button will react on ButtonEvents of the container.
			var nestedButton1:Button = new Button(75, 75);
			nestedButton1.x = 25;
			nestedButton1.y = 25;
			container.addChild(nestedButton1);
			
			// Buttons can be nested as deep as needed, they will always react on ButtonEvents of the container.
			var nestedButton2:Button = new Button(75, 75);
			nestedButton2.x = 125;
			nestedButton2.y = 25;
			// add some more Sprites to test deeply nesting
			container.addChild(new Sprite().addChild(new Sprite().addChild(new Sprite().addChild(nestedButton2))));
			
			
			// create an other button. But this button will not react on the ButtonEvents of the container. (updateByParent is set to false)
			var nestedButton3:Button = new Button(75, 75);
			nestedButton3.x = 225;
			nestedButton3.y = 25;
			container.addChild(nestedButton3);
			nestedButton3.updateByParent = false;
			
			// reset mouseEnabled and mouseChildren on the buttons to let the nestedButton3 receive MouseEvents.
			container.mouseChildren = true;
			DisplayObjectContainerUtils.mouseChildren(container);
			nestedButton3.mouseEnabled = true;
		}
	}
}

import temple.ui.buttons.MultiStateButton;
import temple.ui.states.down.DownState;
import temple.ui.states.over.OverState;

import flash.filters.BevelFilter;

class Button extends MultiStateButton
{
	public function Button(width:Number, height:Number) 
	{
		this.graphics.beginFill(0xaaaaaa);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
		
		this.filters = [new BevelFilter(1, 45, 0xffffff, 1, 0, 1, 3, 3)];
		
		this.addChild(new ButtonOverState(width, height));
		this.addChild(new ButtonDownState(width, height));
	}
}

class ButtonOverState extends OverState
{
	public function ButtonOverState(width:Number, height:Number) 
	{
		this.graphics.beginFill(0xeeeeee);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
	}
}

class ButtonDownState extends DownState
{
	public function ButtonDownState(width:Number, height:Number) 
	{
		this.graphics.beginFill(0x888888);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
	}
}
