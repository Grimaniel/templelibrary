/**
 * @exampleText
 * 
 * <a name="CodeSnapSlider"></a>
 * <h1>CodeSnapSlider</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/slider/CodeSnapSlider.html">CodeSnapSlider</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/slider/CodeSnapSliderExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/slider/CodeSnapSliderExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.label.CodeLabel;
	import temple.codecomponents.slider.CodeSnapSlider;

	import com.greensock.easing.Back;

	import flash.events.Event;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeSnapSliderExample extends DocumentClassExample
	{
		private var _slider:CodeSnapSlider;
		private var _label:CodeLabel;
		
		public function CodeSnapSliderExample()
		{
			super("Temple - CodeSnapSliderExample");
			
			_label = new CodeLabel();
			addChild(_label);
			_label.x = 20;
			
			_slider = new CodeSnapSlider(200, 12, 0, 3, 1);;
			_slider.ease = Back.easeOut;
			_slider.duration = .5;
			
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
