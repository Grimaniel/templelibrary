package  
{
	import temple.ui.buttons.SwitchButton;
	import temple.ui.form.components.RadioGroup;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class SwitchButtonExample extends DocumentClassExample 
	{
		public var mcSwitchButton1:SwitchButton;
		public var mcSwitchButton2:SwitchButton;
		public var mcSwitchButton3:SwitchButton;
		public var mcSwitchButton4:SwitchButton;

		public function SwitchButtonExample() 
		{
			super("Temple - SwitchButtonExample");
			
			var radioGroup:RadioGroup = new RadioGroup();
			radioGroup.add(this.mcSwitchButton1);
			radioGroup.add(this.mcSwitchButton2);
			radioGroup.add(this.mcSwitchButton3);
			radioGroup.add(this.mcSwitchButton4);
		}
	}
}
