/**
 * @exampleText
 * 
 * <a name="MultiStateButtonFrameLabel"></a>
 * <h1>MultiStateButton and Frame Labels</h1>
 * 
 * <p>This is an example about the usage of frame labels in a <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/buttons/MultiStateButton.html">MultiStateButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/MultiStateButtonFrameLabelsExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/MultiStateButtonFrameLabelsExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/buttons/MultiStateButtonFrameLabelsExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.ui.buttons.behaviors.ButtonTimelinePlayMode;
	import temple.ui.buttons.MultiStateButton;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class MultiStateButtonFrameLabelsExample extends DocumentClassExample 
	{
		
		// A MultiStateButton with 'up', 'in', 'over', 'out', 'press', 'down' and 'release' framelabels.
		// 
		// When the mouse is not on the button, the timeline is at the 'up' label.
		// When the mouse enters the button, the timeline is played from 'in' till 'over' is played.
		// When the mouse leaves the button, the timeline is played from 'out' till 'up' is played.
		// When the mouse presses the button, the timeline is played from 'press' till 'down' is played.
		// When the mouse releases the button, the timeline is played from 'release' till 'over' is played.
		public var mcButton1:MultiStateButton;
		
		// A MultiStateButton with 'up', 'in', 'over', 'press' and 'down' framelabels.
		// 
		// When the mouse is not on the button, the timeline is at the 'up' label.
		// When the mouse enters the button, the timeline is played from 'in' till 'over' is played.
		// When the mouse leaves the button, the timeline jumps directly to the 'up' frame.
		// When the mouse presses the button, the timeline is played from 'press' till 'down' is played.
		// When the mouse releases the button, the timeline jumps directly to the 'over' frame.
		public var mcButton2:MultiStateButton;
		
		
		// A MultiStateButton with 'up', 'over', 'out', 'down' and 'release' framelabels.
		// 
		// When the mouse is not on the button, the timeline is at the 'up' label.
		// When the mouse enters the button, the timeline jumps directly to the 'over' frame.
		// When the mouse leaves the button, the timeline is played from 'out' till 'up' is played.
		// When the mouse presses the button, the timeline jumps directly to the 'down' frame.
		// When the mouse releases the button, the timeline is played from 'release' till 'over' is played.
		public var mcButton3:MultiStateButton;

		// A MultiStateButton with 'up', 'over' and 'down' framelabels.
		// 
		// When the mouse is not on the button, the timeline is at the 'up' label.
		// When the mouse enters the button, the timeline is played from 'up' till 'over' is played.
		// When the mouse leaves the button, the timeline is played from 'up' till 'over' is played backwards.
		// When the mouse presses the button, the timeline is played from 'over' till 'down' is played.
		// When the mouse releases the button, the timeline is played from 'over' till 'down' is played backwards.
		public var mcButton4:MultiStateButton;
		
		// A MultiStateButton without any framelabels.
		// 
		// When the mouse is not on the button, the timeline is at the first frame.
		// When the mouse enters the button, the timeline is played till the last frame.
		// When the mouse leaves the button the timeline is played backwards till the first frame.
		public var mcButton5:MultiStateButton;

		// Same MultiStateButton as mcButton1, but with playing backwards switched off.
		public var mcButton6:MultiStateButton;
		
		public function MultiStateButtonFrameLabelsExample()
		{
			super("Temple - MultiStateButtonFrameLabelsExample");
			
			// Switch off playing backwards.
			mcButton6.buttonTimelineBehavior.playMode = ButtonTimelinePlayMode.CONTINUE;
			mcButton6.buttonTimelineBehavior.pressPlayMode = ButtonTimelinePlayMode.IMMEDIATELY;
			
		}
	}
}
