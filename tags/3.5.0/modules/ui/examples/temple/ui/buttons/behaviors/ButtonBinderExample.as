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
			_buttonA = new TweenButton();
			_buttonA.name = 'buttonA';
			_buttonA.upVars = {tint:null};
			_buttonA.upDuration = 0.3;
			_buttonA.overVars = {tint:0xFFFF00};
			_buttonA.downDuration = 0.6;
			_buttonA.graphics.beginFill(0x444444);
			_buttonA.graphics.drawRect(0, 0, 100, 50);
			_buttonA.graphics.endFill();
			_buttonA.x = 50;
			_buttonA.y = 50;
			_buttonA.addEventListener(MouseEvent.CLICK, handleButtonClick);
			addChild(_buttonA);
			
			// create right button (MultiStateButton)
			_buttonB = new MultiStateButton();
			_buttonB.name = 'buttonB';
			_buttonB.graphics.beginFill(0x444444);
			_buttonB.graphics.drawRect(0, 0, 100, 50);
			_buttonB.graphics.endFill();
			_buttonB.x = 200;
			_buttonB.y = 50;
			_buttonB.addEventListener(MouseEvent.CLICK, handleButtonClick);
			addChild(_buttonB);
			
			// create a (fading) overstate for right button, make it orange
			// constructor parameters set the duration of over- and out durations
			var overClip:OverFadeState = new OverFadeState(.4,.8);
			overClip.graphics.beginFill(0xFF7700);
			overClip.graphics.drawRect(0, 0, 100, 50);
			overClip.graphics.endFill();
			_buttonB.addChild(overClip);

			// create a hitArea that's (also) going to control the other buttons
			_hitArea = new CoreSprite();
			_hitArea.name = 'hitArea';
			_hitArea.graphics.beginFill(0x777777);
			_hitArea.graphics.drawRect(0, 0, 250, 50);
			_hitArea.graphics.endFill();
			_hitArea.x = 50;
			_hitArea.y = 150;
			_hitArea.buttonMode = true;
			_hitArea.addEventListener(MouseEvent.CLICK, handleButtonClick);
			addChild(_hitArea);

			// bind the buttons together and add the hitArea
			new ButtonBinder(_buttonA, _buttonB).add(_hitArea);
		}

		private function handleButtonClick(event:MouseEvent) : void
		{
			logInfo('Clicked, target: '+event.target);
		}
	}
}
