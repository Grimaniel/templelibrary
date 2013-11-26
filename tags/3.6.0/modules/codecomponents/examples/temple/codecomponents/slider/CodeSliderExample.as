/**
 * @exampleText
 * 
 * <a name="CodeSlider"></a>
 * <h1>CodeSlider</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/slider/CodeSlider.html">CodeSlider</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/slider/CodeSliderExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/slider/CodeSliderExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.label.CodeLabel;
	import temple.codecomponents.slider.CodeSlider;

	import flash.events.Event;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeSliderExample extends DocumentClassExample
	{
		private var _slider:CodeSlider;
		private var _label:CodeLabel;
		
		public function CodeSliderExample()
		{
			super("Temple - CodeSliderExample");
			
			_label = new CodeLabel();
			addChild(_label);
			_label.x = 20;
			
			_slider = new CodeSlider();
			
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
