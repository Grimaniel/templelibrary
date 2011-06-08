package temple.ui.form.components 
{
	import temple.CodeComponents;
	import temple.core.CoreSprite;
	import temple.ui.icons.CodeCheck;
	import temple.ui.states.focus.FocusFadeState;
	import temple.ui.states.select.SelectFadeState;
	import temple.ui.style.CodeStyle;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeCheckBox extends CheckBox 
	{
		CodeComponents;
		
		public function CodeCheckBox(label:String = null, value:* = null, selected:Boolean = false) 
		{
			this.addChild(new TextField());
			
			super();
			
			this.createUI();
			
			if (label) this.label = label;
			this.selectedValue = value == null ? (label ? label : true) : value;
			this.selected = selected;
		}

		private function createUI():void 
		{
			// Box
			var box:CoreSprite = new CoreSprite();
			box.graphics.beginFill(CodeStyle.backgroundColor, CodeStyle.backgroundAlpha);
			box.graphics.lineStyle(CodeStyle.outlineThickness *.5, CodeStyle.outlineColor, CodeStyle.outlineAlpha);
			box.graphics.drawRect(CodeStyle.outlineThickness *.5, CodeStyle.outlineThickness, 14, 14);
			box.graphics.endFill();
			this.addChildAt(box, 0);
			//box.filters = CodeStyle.backgroundFilters;
			box.y = 1;
			
			// select state
			var selectState:SelectFadeState = new SelectFadeState(.3, .3);
			selectState.addChild(new CodeCheck(CodeStyle.iconColor, CodeStyle.iconAlpha));
			selectState.y = 1;
			this.addChild(selectState);
			
			// focus state
			var focus:FocusFadeState = new FocusFadeState(.2, .2);
			focus.graphics.beginFill(0xff0000, 1);
			focus.graphics.drawRect(0, 0, 15, 15);
			focus.graphics.endFill();
			this.addChildAt(focus, 0);
			focus.filters = CodeStyle.focusFilters;
			focus.y = 2;
			
			// Label
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this.textField.x = 12;
			this.textField.defaultTextFormat = CodeStyle.textFormat;
			this.textField.textColor = CodeStyle.textColor;
		}
	}
}
