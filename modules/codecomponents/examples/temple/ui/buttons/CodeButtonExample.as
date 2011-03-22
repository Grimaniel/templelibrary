package
{
	import temple.ui.buttons.CodeButton;

	public class CodeButtonExample extends DocumentClassExample
	{
		public function CodeButtonExample()
		{
			super("Temple - CodeButtonExample");
			
			var defaultButton:CodeButton = new CodeButton();
			this.addChild(defaultButton);
			
			defaultButton.x = 20;
			defaultButton.y = 20;
		}
	}
}
