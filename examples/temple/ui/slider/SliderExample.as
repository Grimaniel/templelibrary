/**
 * @exampleText
 * 
 * <h1>Slider</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/slider/Slider.html">Slider</a>.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/slider/SliderExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/slider/SliderExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/slider/SliderExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import flash.text.TextFieldAutoSize;
	import temple.ui.slider.SliderEvent;
	import temple.ui.slider.Slider;
	import temple.core.CoreSprite;
	import temple.utils.StageSettings;

	import flash.text.TextField;

	public class SliderExample extends CoreSprite 
	{
		private var _textField:TextField;
		private var _slider:Slider;

		public function SliderExample()
		{
			new StageSettings(this);
			
			var track:Track = new Track();
			this.addChild(track);
			track.x = 30;
			track.y = 30;
			
			var button:Button = new Button();
			this.addChild(button);
			button.x = 30;
			button.y = 30;
			
			this._slider = new Slider(button, track.getRect(this));
			this._slider.addEventListener(SliderEvent.SLIDING, this.handleSliding);
			
			this._textField = new TextField();
			this.addChildAt(this._textField, 0);
			this._textField.text = this._slider.value.toString();
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.x = 30;
			this._textField.y = 10;
		}

		private function handleSliding(event:SliderEvent):void 
		{
			this._textField.text = event.value.toString();
		}
	}
}

import temple.core.CoreSprite;
import temple.ui.buttons.MultiStateButton;
import temple.ui.states.over.OverState;

import flash.filters.BevelFilter;
import flash.filters.DropShadowFilter;

class Track extends CoreSprite
{
	public function Track() 
	{
		this.graphics.beginFill(0x888888);
		this.graphics.drawRect(0, 0, 300, 20);
		this.graphics.endFill();
		
		this.filters = [new DropShadowFilter(1, 45, 0, 1, 3, 3, 1, 1, true)];
	}
}

class Button extends MultiStateButton
{
	public function Button() 
	{
		this.graphics.beginFill(0xaaaaaa);
		this.graphics.drawRect(0, 0, 20, 20);
		this.graphics.endFill();
		
		this.filters = [new BevelFilter(1, 45, 0xffffff, 1, 0, 1, 3, 3)];
		
		this.addChild(new ButtonOverState());
		this.outOnDragOut = false;
	}
}

class ButtonOverState extends OverState
{
	public function ButtonOverState() 
	{
		this.graphics.beginFill(0xeeeeee);
		this.graphics.drawRect(0, 0, 20, 20);
		this.graphics.endFill();
	}
}
