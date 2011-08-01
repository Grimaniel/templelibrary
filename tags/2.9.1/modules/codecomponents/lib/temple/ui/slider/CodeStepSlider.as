package temple.ui.slider
{
	import temple.CodeComponents;
	import temple.core.CoreSprite;
	import temple.ui.buttons.CodeButton;
	import temple.ui.form.components.CodeBackground;
	import temple.ui.form.components.ISetValue;
	import temple.ui.form.validation.IHasValue;
	import temple.ui.layout.Direction;
	import temple.ui.layout.Orientation;

	import flash.display.InteractiveObject;
	import flash.events.Event;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeStepSlider extends CoreSprite implements IHasValue, ISetValue
	{
		CodeComponents;
		
		private var _track:InteractiveObject;
		private var _button:InteractiveObject;
		private var _slider:StepSlider;
		
		public function CodeStepSlider(width:Number = 200, height:Number = 10, min:Number = 0, max:Number = 1, stepSize:Number = .1, direction:String = Direction.ASCENDING)
		{
			this._track = this.addChild(new CodeBackground(width, height)) as InteractiveObject;
			this._button = this.addChild(new CodeButton(Math.min(width, height), Math.min(width, height))) as InteractiveObject;
			this._slider = new StepSlider(this._button, this._track.getRect(this), min, max, stepSize, height > width ? Orientation.VERTICAL : Orientation.HORIZONTAL, direction);
			CodeButton(this._button).outOnDragOut = false;
			
			this._slider.addEventListener(SliderEvent.SLIDE_START, this.dispatchEvent);
			this._slider.addEventListener(SliderEvent.SLIDING, this.handleSliding);
			this._slider.addEventListener(SliderEvent.SLIDE_STOP, this.dispatchEvent);
			this._slider.addEventListener(Event.CHANGE, this.dispatchEvent);
		}

		public function get track():InteractiveObject
		{
			return this._track;
		}

		public function get button():InteractiveObject
		{
			return this._button;
		}

		public function get slider():StepSlider
		{
			return this._slider;
		}

		public function get value():*
		{
			return this._slider.value;
		}

		public function set value(value:*):void
		{
			this._slider.value = value;
		}
		
		private function handleSliding(event:SliderEvent):void
		{
			this.dispatchEvent(event);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
