/**
 * @exampleText
 * 
 * <a name="MultiStateButtonPlayMode"></a>
 * <h1>MultiStateButton and PlayMode</h1>
 * 
 * <p>This is an example about the usage of <code>playMode</code> of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/buttons/MultiStateButton.html">MultiStateButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/MultiStateButtonPlayModeExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/MultiStateButtonPlayModeExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/MultiStateButtonPlayModeExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.ui.buttons.behaviors.ButtonTimelinePlayMode;
	import temple.ui.buttons.MultiStateButton;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class MultiStateButtonPlayModeExample extends DocumentClassExample 
	{
		public var mcButton1:MultiStateButton;
		public var mcButton2:MultiStateButton;
		public var mcButton3:MultiStateButton;

		public function MultiStateButtonPlayModeExample()
		{
			super("Temple - MultiStateButtonFrameLabelsExample");
			
			mcButton1.playMode = ButtonTimelinePlayMode.REVERSED;
			mcButton2.playMode = ButtonTimelinePlayMode.CONTINUE;
			mcButton3.playMode = ButtonTimelinePlayMode.IMMEDIATELY;
		}
	}
}
