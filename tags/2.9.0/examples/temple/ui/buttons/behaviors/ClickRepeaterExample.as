/**
 * @exampleText
 * 
 * <a name="ClickRepeater"></a>
 * <h1>ClickRepeater</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/buttons/behaviors/ClickRepeater.html">ClickRepeater</a>.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/behaviors/ClickRepeaterExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/behaviors/ClickRepeaterExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/behaviors/ClickRepeaterExample.swf" target="_blank">Download source</a></p>
 */
package  
{
	import temple.ui.buttons.BaseButton;
	import temple.ui.buttons.behaviors.ClickRepeater;

	import flash.events.MouseEvent;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class ClickRepeaterExample extends DocumentClassExample 
	{
		private var _button:BaseButton;

		public function ClickRepeaterExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - ClickRepeaterExample");
			
			// Create a new BaseButton, give it rectangle a so we can see something
			this._button = new BaseButton();
			this._button.graphics.beginFill(0x8888FF);
			this._button.graphics.drawRect(-50, -25, 100, 50);
			this._button.graphics.endFill();
			
			this._button.x = 150;
			this._button.y = 75;
			
			this.addChild(this._button);
			
			// add click listener
			this._button.addEventListener(MouseEvent.CLICK, this.handleClick);
			
			// create a ClickRepeater for the button
			new ClickRepeater(this._button);
		}

		private function handleClick(event:MouseEvent):void 
		{
			this.logInfo("Click");
		}
	}
}
