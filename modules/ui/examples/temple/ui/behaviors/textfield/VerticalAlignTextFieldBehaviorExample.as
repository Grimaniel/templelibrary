/**
 * @exampleText
 * 
 * <a name="VerticalAlignTextFieldBehavior"></a>
 * <h1>VerticalAlignTextFieldBehavior</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/behaviors/textfield/VerticalAlignTextFieldBehavior.html">VerticalAlignTextFieldBehavior</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/textfield/VerticalAlignTextFieldBehaviorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/behaviors/textfield/AutoNextTextFieldBehaviorExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.common.enum.Align;
	import temple.ui.behaviors.textfield.VerticalAlignTextFieldBehavior;

	import flash.text.TextField;

	public class VerticalAlignTextFieldBehaviorExample extends DocumentClassExample 
	{
		public var txtField1:TextField;
		public var txtField2:TextField;
		
		public function VerticalAlignTextFieldBehaviorExample()
		{
			super("Temple - VerticalAlignTextFieldBehaviorExample");
			
			new VerticalAlignTextFieldBehavior(txtField1, Align.MIDDLE);
			new VerticalAlignTextFieldBehavior(txtField2, Align.BOTTOM);
		}
	}
}
