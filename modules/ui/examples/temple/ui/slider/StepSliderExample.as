/**
 * @exampleText
 * 
 * <a name="StepSlider"></a>
 * <h1>StepSlider</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/slider/StepSlider.html">StepSlider</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/slider/StepSliderExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/slider/StepSliderExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.slider.SliderEvent;
	import temple.ui.slider.StepSlider;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class StepSliderExample extends DocumentClassExample 
	{
		private var _textField:TextField;
		private var _slider:StepSlider;

		public function StepSliderExample()
		{
			super("Temple - StepSliderExample");
			
			var track:Track = new Track();
			addChild(track);
			track.x = 30;
			track.y = 30;
			
			var button:Button = new Button();
			addChild(button);
			button.x = 30;
			button.y = 30;
			
			_slider = new StepSlider(button, track.getRect(this), -2, 2, .5);
			_slider.addEventListener(SliderEvent.SLIDING, handleSliding);
			
			_textField = new TextField();
			addChildAt(_textField, 0);
			_textField.text = _slider.value.toString();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.x = 30;
			_textField.y = 10;
		}

		private function handleSliding(event:SliderEvent):void 
		{
			_textField.text = event.value.toString();
		}
	}
}
import temple.core.display.CoreSprite;
import temple.ui.buttons.MultiStateButton;
import temple.ui.states.over.OverState;

import flash.filters.BevelFilter;
import flash.filters.DropShadowFilter;

class Track extends CoreSprite
{
	public function Track() 
	{
		graphics.beginFill(0x888888);
		graphics.drawRect(0, 0, 300, 20);
		graphics.endFill();
		
		filters = [new DropShadowFilter(1, 45, 0, 1, 3, 3, 1, 1, true)];
	}
}

class Button extends MultiStateButton
{
	public function Button() 
	{
		graphics.beginFill(0xaaaaaa);
		graphics.drawRect(0, 0, 20, 20);
		graphics.endFill();
		
		filters = [new BevelFilter(1, 45, 0xffffff, 1, 0, 1, 3, 3)];
		
		addChild(new ButtonOverState());
		this.outOnDragOut = false;
	}
}

class ButtonOverState extends OverState
{
	public function ButtonOverState() 
	{
		graphics.beginFill(0xeeeeee);
		graphics.drawRect(0, 0, 20, 20);
		graphics.endFill();
	}
}
