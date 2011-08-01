package temple.ui.form.components 
{
	import temple.ui.states.focus.FocusFadeState;
	import temple.ui.style.CodeStyle;

	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeInputField extends InputField 
	{
		public function CodeInputField(width:Number = 160, height:Number = 18, multiline:Boolean = false)
		{
			super(this.addChild(new TextField()) as TextField);
			
			this.textField.type = TextFieldType.INPUT;
			this.textField.width = width;
			this.textField.height = height;
			this.textField.defaultTextFormat = CodeStyle.textFormat;
			this.multiline = multiline;
			
			this.textColor = CodeStyle.textColor;
			this.hintTextColor = 0x888888;
			this.errorTextColor = 0xff0000;
			
			this.addChildAt(new CodeBackground(width, height), 0);
			
			// focus state
			var focus:FocusFadeState = new FocusFadeState(.2, .2);
			focus.graphics.beginFill(0xff0000, 1);
			focus.graphics.drawRoundRect(-1, -1, width+2, height+2, CodeStyle.backgroundRounding);
			focus.graphics.endFill();
			this.addChildAt(focus, 0);
			focus.filters = CodeStyle.focusFilters;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get value():*
		{
			return super.value;
		}
	}
}
