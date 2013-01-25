/**
 * @exampleText
 * 
 * <a name="AutoNextTextFieldBehavior"></a>
 * <h1>AutoNextTextFieldBehavior</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/behaviors/textfield/AutoNextTextFieldBehavior.html">AutoNextTextFieldBehavior</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/textfield/AutoNextTextFieldBehaviorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/textfield/AutoNextTextFieldBehaviorExample.as" target="_blank">View source</a></p>
 */
package 
{
	import temple.ui.behaviors.textfield.AutoNextTextFieldBehavior;

	import flash.text.TextField;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class AutoNextTextFieldBehaviorExample extends DocumentClassExample
	{
		public var textfield1:TextField;
		public var textfield2:TextField;
		public var textfield3:TextField;
		public var textfield4:TextField;
		public var textfield5:TextField;
		public var textfield6:TextField;
		public var textfield7:TextField;
		public var textfield8:TextField;
		
		public function AutoNextTextFieldBehaviorExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - AutoNextTextFieldBehaviorExample");
			
			// define textfield maxchars
			this.textfield1.maxChars = 2;
			this.textfield2.maxChars = 1;
			this.textfield3.maxChars = 2;
			this.textfield4.maxChars = 1;
			this.textfield5.maxChars = 2;
			this.textfield6.maxChars = 1;
			this.textfield7.maxChars = 2;
			this.textfield8.maxChars = 1;
			
			// create behavior, add textfields in sorted order
			var autoNextTextFieldBehavior:AutoNextTextFieldBehavior = new AutoNextTextFieldBehavior();
			autoNextTextFieldBehavior.add(textfield1);
			autoNextTextFieldBehavior.add(textfield2);
			autoNextTextFieldBehavior.add(textfield3);
			autoNextTextFieldBehavior.add(textfield4);
			autoNextTextFieldBehavior.add(textfield5);
			autoNextTextFieldBehavior.add(textfield6);
			autoNextTextFieldBehavior.add(textfield7);
			autoNextTextFieldBehavior.add(textfield8);
		}
	}
}
