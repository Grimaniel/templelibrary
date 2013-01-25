/**
 * @exampleText
 * 
 * <a name="CodeStepSlider"></a>
 * <h1>CodeStepSlider</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/slider/CodeStepSlider.html">CodeStepSlider</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/slider/CodeStepSliderExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/slider/CodeStepSliderExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.label.CodeLabel;
	import temple.codecomponents.slider.CodeStepSlider;

	import flash.events.Event;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeStepSliderExample extends DocumentClassExample
	{
		private var _slider:CodeStepSlider;
		private var _label:CodeLabel;
		
		public function CodeStepSliderExample()
		{
			super("Temple - CodeStepSliderExample");
			
			_label = new CodeLabel();
			addChild(_label);
			_label.x = 20;
			
			_slider = new CodeStepSlider(200, 12, 0, 3, 1);;
			
			addChild(_slider);
			
			_slider.x = 20;
			_slider.y = 20;
			
			_slider.addEventListener(Event.CHANGE, handleChange);
			
			_label.label = _slider.value;
		}

		private function handleChange(event:Event):void
		{
			_label.label = _slider.value;
		}
	}
}
