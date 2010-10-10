/**
 * @exampleText
 * 
 * <a name="States"></a>
 * <h1>States</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/states/package-detail.html">states</a>.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/states/StatesExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/states/StatesExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/states/StatesExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import temple.ui.states.select.SelectState;
	import temple.core.CoreSprite;
	import temple.ui.buttons.SwitchButton;
	import temple.ui.states.down.DownState;
	import temple.ui.states.focus.FocusFadeState;
	import temple.ui.states.over.OverFadeState;

	import flash.filters.BevelFilter;
	import flash.filters.GlowFilter;

	public class StatesExample extends CoreSprite 
	{
		public function StatesExample()
		{
			// create a button
			var button:SwitchButton = new SwitchButton();
			this.addChild(button);
			button.x = 50;
			button.y = 50;
			
			// Create a background in the button
			button.graphics.beginFill(0x888888);
			button.graphics.drawRect(0, 0, 100, 50);
			button.graphics.endFill();
			
			button.filters = [new BevelFilter(2, 45, 0xffffff, 1, 0x000000, 1, 2, 2)];
			
			// Create an IOverState in the button to highlight the button when the mouse hovers the button.
			// We use a 'FadeState' for this one, the the highlighting is animated.
			var overState:OverFadeState = new OverFadeState();
			overState.graphics.beginFill(0xaaaaaa);
			overState.graphics.drawRect(0, 0, 100, 50);
			overState.graphics.endFill();
			button.addChild(overState);

			// Create an IDownState in the button to highlight the button over more when the user presses the button
			// This is just an ordinary DownState without animation.
			var downState:DownState = new DownState();
			downState.graphics.beginFill(0xeeeeee);
			downState.graphics.drawRect(0, 0, 100, 50);
			downState.graphics.endFill();
			button.addChild(downState);
			
			// Create an IFocusState for when the button has focus.
			var focusState:FocusFadeState = new FocusFadeState();
			focusState.graphics.beginFill(0xeeeeee);
			focusState.graphics.drawRect(-2, -2, 104, 54);
			focusState.graphics.endFill();
			focusState.filters = [new GlowFilter(0xffff00, 1, 4, 4, 500, 1, false, true)];
			button.addChild(focusState);
			
			// Create an ISelectState for displaying the selected state of the button.
			var selectState:SelectState = new SelectState();
			selectState.graphics.beginFill(0x00ff00, .5);
			selectState.graphics.drawRect(0, 0, 100, 50);
			selectState.graphics.endFill();
			button.addChild(selectState);
		}
	}
}
