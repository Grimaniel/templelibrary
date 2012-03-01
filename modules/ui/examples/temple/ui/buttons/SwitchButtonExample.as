/**
 * @exampleText
 * 
 * <a name="SwitchButton"></a>
 * <h1>SwitchButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/buttons/SwitchButton.html">SwitchButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/SwitchButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/D:/Projects/Temple/GoogleCode/templelibrary/modules/ui/examples/temple/ui/buttons/SwitchButtonExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/SwitchButtonExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.buttons.SwitchButton;
	import temple.ui.form.components.RadioGroup;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class SwitchButtonExample extends DocumentClassExample 
	{
		// A SwitchButton without framelabels. Shows a clip (SelectState) when selected.
		public var mcSwitchButton1:SwitchButton;
		
		// A SwitchButton with labels 'up', 'over' and 'selected'.
		public var mcSwitchButton2:SwitchButton;
		
		// A SwitchButton with frame labels 'up' and 'over'. There is a frame label 'selected' on the same frame as 'over'.
		public var mcSwitchButton3:SwitchButton;
		
		// A SwitchButton with 'up', 'in', 'over', 'out', 'select', 'selected', and 'deselect' framelabels.
		public var mcSwitchButton4:SwitchButton;

		public function SwitchButtonExample() 
		{
			super("Temple - SwitchButtonExample");
			
			// Add buttons in a RadioGroup, so other buttons will be deselected when you select a button.
			var radioGroup:RadioGroup = new RadioGroup();
			radioGroup.add(this.mcSwitchButton1);
			radioGroup.add(this.mcSwitchButton2);
			radioGroup.add(this.mcSwitchButton3);
			radioGroup.add(this.mcSwitchButton4);
		}
	}
}
