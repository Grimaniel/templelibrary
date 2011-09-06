package
{
	import temple.ui.scroll.CodeScrollBar;
	import temple.ui.form.components.CodeCheckBox;
	import temple.ui.buttons.CodeButton;
	import temple.ui.style.RoundedBlueCodeStyle;
	import temple.ui.form.components.CodeInputField;

	[SWF(backgroundColor="#888888", frameRate="31", width="640", height="480")]
	public class CodeComponentsExample extends DocumentClassExample
	{
		public function CodeComponentsExample()
		{
			super("Temple - CodeComponentsExample");
			
			this.createComponents(10);
			
			RoundedBlueCodeStyle.init();

			this.createComponents(200);
		}

		private function createComponents(left:Number):void
		{
			with(this.addChild(new CodeButton(80, 30)))
			{
				x = left;
				y = 10;
			}
			with(this.addChild(new CodeButton(50, 50)))
			{
				x = left + 100;
				y = 10;
			}
			
			with(this.addChild(new CodeInputField()))
			{
				x = left;
				y = 70;
			}

			with(this.addChild(new CodeInputField(160, 40, true)))
			{
				x = left;
				y = 100;
			}
			
			with(this.addChild(new CodeCheckBox("CheckBox")))
			{
				x = left;
				y = 150;
			}

			with(this.addChild(new CodeCheckBox()))
			{
				x = left;
				y = 180;
			}

			with(this.addChild(new CodeScrollBar()))
			{
				x = left;
				y = 180;
			}
			
		}
	}
}
