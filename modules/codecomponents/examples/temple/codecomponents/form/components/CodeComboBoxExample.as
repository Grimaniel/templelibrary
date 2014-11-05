/**
 * @exampleText
 * 
 * <a name="CodeComboBox"></a>
 * <h1>CodeComboBox</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeComboBox.html">CodeComboBox</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeComboBoxExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeComboBoxExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.codecomponents.form.components.CodeComboBox;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeComboBoxExample extends DocumentClassExample 
	{
		public function CodeComboBoxExample()
		{
			super("Temple - CodeComboBoxExample");
			
			var comboBox:CodeComboBox = new CodeComboBox();
			addChild(comboBox);
			comboBox.x = 20;
			comboBox.y = 20;
			
			comboBox.hintText = "hint text";
			
			comboBox.addItems(["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]);
			
			comboBox = new CodeComboBox(100);
			addChild(comboBox);
			comboBox.x = 220;
			comboBox.y = 20;
			
			comboBox.addItems(["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]);
		}
	}
}
