/**
 * @exampleText
 * 
 * <a name="ButtonBinder"></a> 
 * <h1>ButtonBinder</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/buttons/behaviors/ButtonBinder.html">ButtonBinder</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/behaviors/ButtonBinderExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/behaviors/ButtonBinderExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.core.display.CoreSprite;
	import temple.ui.buttons.MultiStateButton;
	import temple.ui.buttons.TweenButton;
	import temple.ui.buttons.behaviors.ButtonBinder;
	import temple.ui.states.over.OverFadeState;

	import flash.events.MouseEvent;

	public class ButtonBinderExample extends DocumentClassExample
	{
		private var _buttonA:TweenButton;
		private var _buttonB:MultiStateButton;
		private var _hitArea:CoreSprite;
		
		public function ButtonBinderExample()
		{
			// Super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - ButtonBinderExample");
			
			// create left button (TweenButton), make it yellow in overState
			this._buttonA = new TweenButton();
			this._buttonA.name = 'buttonA';
			this._buttonA.upVars = {tint:null};
			this._buttonA.upDuration = 0.3;
			this._buttonA.overVars = {tint:0xFFFF00};
			this._buttonA.downDuration = 0.6;
			this._buttonA.graphics.beginFill(0x444444);
			this._buttonA.graphics.drawRect(0, 0, 100, 50);
			this._buttonA.graphics.endFill();
			this._buttonA.x = 50;
			this._buttonA.y = 50;
			this._buttonA.addEventListener(MouseEvent.CLICK, handleButtonClick);
			this.addChild(this._buttonA);
			
			// create right button (MultiStateButton)
			this._buttonB = new MultiStateButton();
			this._buttonB.name = 'buttonB';
			this._buttonB.graphics.beginFill(0x444444);
			this._buttonB.graphics.drawRect(0, 0, 100, 50);
			this._buttonB.graphics.endFill();
			this._buttonB.x = 200;
			this._buttonB.y = 50;
			this._buttonB.addEventListener(MouseEvent.CLICK, handleButtonClick);
			this.addChild(this._buttonB);
			
			// create a (fading) overstate for right button, make it orange
			// constructor parameters set the duration of over- and out durations
			var overClip:OverFadeState = new OverFadeState(.4,.8);
			overClip.graphics.beginFill(0xFF7700);
			overClip.graphics.drawRect(0, 0, 100, 50);
			overClip.graphics.endFill();
			this._buttonB.addChild(overClip);

			// create a hitArea that's (also) going to control the other buttons
			this._hitArea = new CoreSprite();
			this._hitArea.name = 'hitArea';
			this._hitArea.graphics.beginFill(0x777777);
			this._hitArea.graphics.drawRect(0, 0, 250, 50);
			this._hitArea.graphics.endFill();
			this._hitArea.x = 50;
			this._hitArea.y = 150;
			this._hitArea.buttonMode = true;
			this._hitArea.addEventListener(MouseEvent.CLICK, handleButtonClick);
			this.addChild(this._hitArea);

			// bind the buttons together and add the hitArea
			new ButtonBinder(this._buttonA, this._buttonB).add(this._hitArea);
		}

		private function handleButtonClick(event:MouseEvent) : void
		{
			logInfo('Clicked, target: '+event.target);
		}
	}
}
