/**
 * @exampleText
 * 
 * <a name="CodeComponents"></a>
 * <h1>CodeComponents</h1>
 * 
 * <p>This is an example of the CodeComponents. This classes uses the following CodeComponents:
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeButton.html">CodeButton</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeCloseButton.html">CodeCloseButton</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeCollapseButton.html">CodeCollapseButton</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeExpandButton.html">CodeExpandButton</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeLabelButton.html">CodeLabelButton</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeAutoCompleteInputField.html">CodeAutoCompleteInputField</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeCheckBox.html">CodeCheckBox</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeComboBox.html">CodeComboBox</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeDateSelector.html">CodeDateSelector</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeInputField.html">CodeInputField</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeList.html">CodeList</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeRadioButton.html">CodeRadioButton</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/labels/CodeLabel.html">CodeLabel</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/scroll/CodeScrollBar.html">CodeScrollBar</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/slider/CodeSlider.html">CodeSlider</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/slider/CodeStepSlider.html">CodeStepSlider</a>,
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/tooltip/CodeToolTip.html">CodeToolTip</a> and
 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/windows/CodeWindow.html">CodeWindow</a>
 * </p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/CodeComponentsExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/CodeComponentsExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodePauseButton;
	import temple.codecomponents.buttons.CodeNextButton;
	import temple.codecomponents.buttons.CodeFastForwardButton;
	import temple.codecomponents.buttons.CodePlayBackwardButton;
	import temple.codecomponents.buttons.CodeFastBackwardButton;
	import temple.codecomponents.buttons.CodePreviousButton;
	import temple.ui.layout.HBox;
	import temple.codecomponents.buttons.CodePlayButton;
	import temple.common.enum.Orientation;
	import temple.codecomponents.buttons.CodeButton;
	import temple.codecomponents.buttons.CodeCloseButton;
	import temple.codecomponents.buttons.CodeCollapseButton;
	import temple.codecomponents.buttons.CodeExpandButton;
	import temple.codecomponents.buttons.CodeLabelButton;
	import temple.codecomponents.form.components.CodeAutoCompleteInputField;
	import temple.codecomponents.form.components.CodeCheckBox;
	import temple.codecomponents.form.components.CodeComboBox;
	import temple.codecomponents.form.components.CodeDateSelector;
	import temple.codecomponents.form.components.CodeInputField;
	import temple.codecomponents.form.components.CodeList;
	import temple.codecomponents.form.components.CodeRadioButton;
	import temple.codecomponents.labels.CodeLabel;
	import temple.codecomponents.scroll.CodeScrollBar;
	import temple.codecomponents.slider.CodeSlider;
	import temple.codecomponents.slider.CodeStepSlider;
	import temple.codecomponents.tooltip.CodeToolTip;
	import temple.codecomponents.windows.CodeWindow;
	import temple.ui.form.components.RadioGroup;
	import temple.ui.tooltip.ToolTip;

	import flash.display.DisplayObject;
	
	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeComponentsExample extends DocumentClassExample
	{
		private static const _COLUMN1:Number = 10;
		private static const _COLUMN2:Number = 160;
		private static const _COLUMN3:Number = 360;
		private static const _COLUMN4:Number = 500;

		private static const _LINE_HEIGHT:Number = 30;
		
		public function CodeComponentsExample()
		{
			super("Temple - CodeComponentsExample");
			
			var line:Number = 10;
			
			add(new CodeLabel("CodeButton"), _COLUMN1, line + 2);
			add(new CodeButton(24, 16), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeCloseButton"), _COLUMN1, line + 2);
			add(new CodeCloseButton(24, 16), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeCollapseButton"), _COLUMN1, line + 2);
			add(new CodeCollapseButton(24, 16), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeExpandButton"), _COLUMN1, line + 2);
			add(new CodeExpandButton(24, 16), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeLabelButton"), _COLUMN1, line + 2);
			add(new CodeLabelButton("TEST"), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeAutoCompleteInputField"), _COLUMN1, line + 2);
			add(new CodeAutoCompleteInputField(160, 18, ["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"], true), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeCheckBox"), _COLUMN1, line + 2);
			add(new CodeCheckBox("Lorem ipsum"), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeComboBox"), _COLUMN1, line + 2);
			add(new CodeComboBox(160, 18, ["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeDateSelector"), _COLUMN1, line + 2);
			add(new CodeDateSelector(null, null, 6), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeInputField"), _COLUMN1, line + 2);
			add(new CodeInputField(), _COLUMN2, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeList"), _COLUMN1, line + 2);
			add(new CodeList(160, 6, ["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]), _COLUMN2, line);
			line += 120;
			
			line = 10;
			
			add(new CodeLabel("CodeRadioButton"), _COLUMN3, line + 2);
			var group:RadioGroup = new RadioGroup();
			group.add(add(new CodeRadioButton("Option 1"), _COLUMN4, line) as CodeRadioButton);
			group.add(add(new CodeRadioButton("Option 2"), _COLUMN4 + 70, line) as CodeRadioButton);
			group.add(add(new CodeRadioButton("Option 3"), _COLUMN4 + 140, line) as CodeRadioButton);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeLabel"), _COLUMN3, line + 2);
			add(new CodeLabel("Lorem ipsum"), _COLUMN4, line);
			line += _LINE_HEIGHT;
			
			
			add(new CodeLabel("CodeScrollBar"), _COLUMN3, line + 2);
			add(new CodeScrollBar(Orientation.VERTICAL, 60), _COLUMN4, line);
			add(new CodeScrollBar(Orientation.HORIZONTAL), _COLUMN4 + 40, line);
			line += 80;
			
			add(new CodeLabel("CodeSider"), _COLUMN3, line + 2);
			add(new CodeSlider(100), _COLUMN4, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeStepSider"), _COLUMN3, line + 2);
			add(new CodeStepSlider(100, 10, 0, 1, .2), _COLUMN4, line);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeToolTip"), _COLUMN3, line + 2);
			ToolTip.add(add(new CodeLabel("hover here"), _COLUMN4, line + 2), "Lorem ipsum");
			stage.addChild((ToolTip.clip = add(new CodeToolTip(), _COLUMN4, line) as CodeToolTip) as DisplayObject);
			line += _LINE_HEIGHT;
			
			add(new CodeLabel("CodeWindow"), _COLUMN3, line + 2);
			add(new CodeWindow(200, 100, "Lorem ipsum"), _COLUMN4, line);
			line += 120;
			
			add(new CodeLabel("Other"), _COLUMN3, line + 2);
			
			var hbox:HBox = new HBox(5);
			
			ToolTip.add(hbox.addChild(new CodePreviousButton()), "CodePreviousButton");
			ToolTip.add(hbox.addChild(new CodeFastBackwardButton()), "CodeFastBackwardButton");
			ToolTip.add(hbox.addChild(new CodePlayBackwardButton()), "CodePlayBackwardButton");
			ToolTip.add(hbox.addChild(new CodePauseButton()), "CodePauseButton");
			ToolTip.add(hbox.addChild(new CodePlayButton()), "CodePlayButton");
			ToolTip.add(hbox.addChild(new CodeFastForwardButton()), "CodeFastForwardButton");
			ToolTip.add(hbox.addChild(new CodeNextButton()), "CodeNextButton");
			
			add(hbox, _COLUMN4, line);
			line += _LINE_HEIGHT;
		}

		private function add(child:DisplayObject, x:Number, y:Number):DisplayObject
		{
			addChild(child);
			child.x = x;
			child.y = y;
			
			return child;
		}
	}
}
