/**
 * @exampleText
 * 
 * <a name="ClickRepeater"></a>
 * <h1>ClickRepeater</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/buttons/behaviors/ClickRepeater.html">ClickRepeater</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/behaviors/ClickRepeaterExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/behaviors/ClickRepeaterExample.as" target="_blank">View source</a></p>
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
			_button = new BaseButton();
			_button.graphics.beginFill(0x8888FF);
			_button.graphics.drawRect(-50, -25, 100, 50);
			_button.graphics.endFill();
			
			_button.x = 150;
			_button.y = 75;
			
			addChild(_button);
			
			// add click listener
			_button.addEventListener(MouseEvent.CLICK, handleClick);
			
			// create a ClickRepeater for the button
			new ClickRepeater(_button);
		}

		private function handleClick(event:MouseEvent):void 
		{
			logInfo("Click");
		}
	}
}
