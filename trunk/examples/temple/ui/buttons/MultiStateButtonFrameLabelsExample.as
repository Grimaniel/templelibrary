/**
 * @exampleText
 * 
 * <p>This is an example about how to use frame labels in a MultiStateButton.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/MultiStateButtonFrameLabelsExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/MultiStateButtonFrameLabelsExample.swf</a></p>
 * 
 * <p>This example uses an .fla file which can be fond at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/MultiStateButtonFrameLabelsExample.fla" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/MultiStateButtonFrameLabelsExample.fla</a></p>
 */
package  
{
	import temple.ui.buttons.MultiStateButton;
	import temple.core.CoreSprite;
	
	public class MultiStateButtonFrameLabelsExample extends CoreSprite 
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
		
		// A MultiStateButton no framelabels.
		// 
		// When the mouse is not on the button, the timeline at at the first frame.
		// When the mouse enters the button, the timeline is played till the last frame.
		// When the mouse leaves the button the timeline is played backwards till the first frame.
		public var mcButton5:MultiStateButton;

		// Same MultiStateButton as mcButton1, but no with playing backwards switched off.
		public var mcButton6:MultiStateButton;
		
		public function MultiStateButtonFrameLabelsExample()
		{
			super();
			
			// Switch off playing backwards.
			this.mcButton6.buttonTimelineBehavior.playBackwardsBeforeOver = false;
			this.mcButton6.buttonTimelineBehavior.playBackwardsBeforeDown = false;
		}
	}
}
