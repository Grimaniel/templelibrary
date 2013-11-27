/**
 * @exampleText
 * 
 * <a name="LiveInspector"></a>
 * <h1>LiveInspector</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/liveinspector/doc/temple/liveinspector/LiveInspector.html" name="doc">LiveInspector</a>.
 * The LiveInspector visualizes the change of property values over time and makes it possible to update the values at run-time using a simple GUI. There is no need to instantiate the LiveInspector manually, it should work when the <code>add</code> function is called.
 * This example demonstrates how the Live Inspector module looks show the possibilities of changing values at runtime for debugging purposes.
 * </p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/liveinspector/examples/temple/liveinspector/LiveInspectorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/liveinspector/examples/temple/liveinspector/LiveInspectorExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeLabelButton;
	import temple.codecomponents.graphics.CodeBackground;
	import temple.codecomponents.labels.CodeLabel;
	import temple.liveinspector.liveInspectorInstance;

	import com.greensock.TweenMax;
	import com.greensock.data.TweenMaxVars;
	import com.greensock.easing.Sine;

	import flash.events.MouseEvent;
	
	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class LiveInspectorExample extends DocumentClassExample 
	{
		private var _button:CodeLabelButton;
		private var _panel:CodeBackground;
		private var _label:CodeLabel;

		public function LiveInspectorExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - LiveInspectorExample");
			
			// creates a button, a moving panel and a label at the bottom of the screen
			createUI();

			// inspects the label of the button.
			liveInspectorInstance.add(_button, ["text", "enabled"]);

			// inspect the position of the panel. Try to scroll on the live inspector editor or use the up/down keys on your keyboard.
			liveInspectorInstance.add(_panel, ["x", "y"]);
			
			// just inspects a object. This results in a non-editable toString representation of the panel
			liveInspectorInstance.add(_panel);
			
			// you can even scroll on special properties like blendmodes or booleans.
			liveInspectorInstance.add(_panel, ["visible","blendMode"]);
		}

		private function createUI():void
		{
			_button = new CodeLabelButton("Edit this label!");
			_button.name = "button";
			_button.x = (stage.stageWidth - _button.width) / 2;
			_button.y = (stage.stageHeight - _button.height) / 2;
			_button.addEventListener(MouseEvent.CLICK, handleButtonClick);
			_button.enabled = false;
			addChild(_button);
			
			_panel = new CodeBackground(300, 300);
			_panel.name = "panel";
			_panel.x = 200;
			_panel.y = (stage.stageHeight - _panel.height) / 2;
			TweenMax.to(_panel, 3, new TweenMaxVars().x(50).yoyo(true).repeat(-1).ease(Sine.easeInOut));
			addChild(_panel);
			
			_label = new CodeLabel("Your goal: hide or move the panel using the Live Inspector\nChange the label of the button to 'done' and click the button!");
			_label.x = (stage.stageWidth - _label.width) / 2;
			_label.y = stage.stageHeight - _label.height - 10;
			_label.autoSize = true;
			addChild(_label);
		}

		private function handleButtonClick(event:MouseEvent):void
		{
			if (_button.text.toLowerCase() === "done")
			{
				_label.text = "Congrats! Enjoy live debugging using the Temple Library!";
			}
		}
	}
}
