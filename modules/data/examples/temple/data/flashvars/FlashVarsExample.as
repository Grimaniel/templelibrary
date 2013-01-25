/**
 * @exampleText
 * 
 * <a name="FlashVars"></a>
 * <h1>FlashVars</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/doc/temple/data/flashvars/FlashVars.html">FlashVars</a> class.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/flashvars/FlashVarsExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/flashvars/FlashVarsExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.data.flashvars.FlashVars;

	import flash.text.TextField;

	public class FlashVarsExample extends DocumentClassExample 
	{
		private static const _LANGUAGE:String = 'language';
		private static const _VERSION:String = 'version';
		private static const _IS_DEMO:String = 'is_demo';
		
		public function FlashVarsExample()
		{
			FlashVars.initialize(loaderInfo.parameters);
			
			FlashVars.configureVar(_LANGUAGE, 'nl', String);
			FlashVars.configureVar(_VERSION, 1, int);
			FlashVars.configureVar(_IS_DEMO, true, Boolean);
			
			var txt:TextField = new TextField();
			txt.border = true;
			txt.width = 550;
			txt.height = 400;
			addChild(txt);
			
			txt.appendText('defaults : ' + "\n");
			txt.appendText('LANGUAGE : nl' + "\n");
			txt.appendText('VERSION : 1' + "\n");
			txt.appendText('IS_DEMO : true' + "\n");
			txt.appendText("\n");
			
			txt.appendText('FlashVars.isExternal(_LANGUAGE) : ' + FlashVars.isExternal(_LANGUAGE) + "\n");
			txt.appendText('FlashVars.isExternal(_VERSION) : ' + FlashVars.isExternal(_VERSION) + "\n");
			txt.appendText('FlashVars.isExternal(_IS_DEMO) : ' + FlashVars.isExternal(_IS_DEMO) + "\n");
			txt.appendText('FlashVars.isExternal(NOT_DEFINED) : ' + FlashVars.isExternal('NOT_DEFINED') + "\n");
			txt.appendText("\n");
			txt.appendText('FlashVars.getValue(_LANGUAGE) : ' + FlashVars.getValue(_LANGUAGE) + "\n");
			txt.appendText('FlashVars.getValue(_VERSION) : ' + FlashVars.getValue(_VERSION) + "\n");
			txt.appendText('FlashVars.getValue(_IS_DEMO) : ' + FlashVars.getValue(_IS_DEMO) + "\n");
			txt.appendText("\n");
			txt.appendText(FlashVars.dump());
		}
	}
}
