/**
 * @exampleText
 * 
 * <a name="CodeAutoCompleteInputField"></a>
 * <h1>CodeAutoCompleteInputField</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeAutoCompleteInputField.html">CodeAutoCompleteInputField</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeAutoCompleteInputFieldExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeAutoCompleteInputFieldExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.codecomponents.form.components.CodeAutoCompleteInputField;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeAutoCompleteInputFieldExample extends DocumentClassExample 
	{
		public function CodeAutoCompleteInputFieldExample()
		{
			super("Temple - CodeAutoCompleteInputFieldExample");
			
			var autoCompleteInputField:CodeAutoCompleteInputField = new CodeAutoCompleteInputField();
			addChild(autoCompleteInputField);
			autoCompleteInputField.x = 20;
			autoCompleteInputField.y = 20;
			
			autoCompleteInputField.hintText = "hint text";
			
			autoCompleteInputField.addItems(["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]);

			autoCompleteInputField = new CodeAutoCompleteInputField(100);
			addChild(autoCompleteInputField);
			autoCompleteInputField.x = 220;
			autoCompleteInputField.y = 20;
			
			autoCompleteInputField.addItems(["Lorem ipsum", "dolor sit amet", "consectetur", "adipiscing", "elit", "Ut rhoncus", "malesuada", "venenatis", "Aliquam", "tincidunt", "tellus nec", "blandit porttitor", "neque"]);
		}
	}
}
