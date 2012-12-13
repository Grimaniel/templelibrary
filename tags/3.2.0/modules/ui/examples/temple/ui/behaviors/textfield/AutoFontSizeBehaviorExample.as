/**
 * @exampleText
 * 
 * <a name="AutoFontSizeBehavior"></a>
 * <h1>AutoFontSizeBehavior</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/behaviors/textfield/AutoFontSizeBehavior.html">AutoFontSizeBehavior</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/textfield/AutoFontSizeBehaviorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/textfield/AutoNextTextFieldBehaviorExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.behaviors.textfield.AutoFontSizeBehavior;

	import flash.text.TextField;
	/**
	 * @author Thijs Broerse
	 */
	public class AutoFontSizeBehaviorExample extends DocumentClassExample 
	{
		public var textField:TextField;
		
		public function AutoFontSizeBehaviorExample()
		{
			super("Temple - AutoFontSizeBehaviorExample");
			
			new AutoFontSizeBehavior(this.textField);
		}
	}
}
