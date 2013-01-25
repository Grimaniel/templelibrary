/**
 * @exampleText
 * 
 * <a name="CodeAutoCompleteInputField"></a>
 * <h1>CodeAutoCompleteInputField</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/form/components/CodeAutoCompleteInputField.html">CodeAutoCompleteInputField</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeInputFieldExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/form/components/CodeAutoCompleteInputFieldExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.codecomponents.form.components.CodeInputField;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeInputFieldExample extends DocumentClassExample 
	{
		public function CodeInputFieldExample()
		{
			super("Temple - CodeInputFieldExample");
			
			var inputField:CodeInputField = new CodeInputField(); 
			
			inputField.x = 20;
			inputField.y = 20;
			
			inputField.hintText = "hintText";
			
			addChild(inputField);
			
			inputField = new CodeInputField(); 
			
			inputField.x = 20;
			inputField.y = 60;
			inputField.width = 100;
			
			inputField.hintText = "hintText";
			inputField.updateHintOnChange = true;
			
			addChild(inputField);
		}
	}
}
