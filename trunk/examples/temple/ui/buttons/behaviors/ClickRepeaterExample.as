/**
 * @exampleText
 * 
 * <p>This is an example about the ClickRepeater.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/behaviors/ClickRepeaterExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/behaviors/ClickRepeaterExample.swf</a></p>
 */
package  
{
	import nl.acidcats.yalog.util.YaLogConnector;

	import temple.core.CoreSprite;
	import temple.ui.buttons.BaseButton;
	import temple.ui.buttons.behaviors.ClickRepeater;
	import temple.utils.StageSettings;

	import flash.events.MouseEvent;

	public class ClickRepeaterExample extends CoreSprite 
	{
		private var _button:BaseButton;

		public function ClickRepeaterExample()
		{
			super();
			
			// Connect to Yalog, so you can see all log message at: http://yala.acidcats.nl/
			YaLogConnector.connect();
			
			// set stage properties
			new StageSettings(this);
			
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
