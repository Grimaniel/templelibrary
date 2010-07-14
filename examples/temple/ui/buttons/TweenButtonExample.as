/**
 * @exampleText
 * 
 * <h1>TweenButton</h1>
 * 
 * <p>This is an example about how the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/buttons/TweenButton.html">TweenButton</a>.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/TweenButtonExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/TweenButtonExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/buttons/TweenButtonExample.swf" target="_blank">Download source</a></p>
 */
package  
{
	import com.greensock.easing.Elastic;
	import flash.display.LineScaleMode;
	import temple.ui.buttons.TweenButton;
	import temple.core.CoreSprite;
	
	public class TweenButtonExample extends CoreSprite 
	{
		public function TweenButtonExample()
		{
			// Create a new TweenButton
			var button:TweenButton = new TweenButton();
			
			// draw something in it, so we can see something
			button.graphics.beginFill(0x8888ff, .5);
			button.graphics.lineStyle(1, 0x0000ff, 1, false, LineScaleMode.NONE);
			button.graphics.drawRect(-100, -50, 200, 100);
			button.graphics.endFill();
			button.x = 220;
			button.y = 170;
			
			// define up state
			button.upVars = {scaleX: 1, scaleY: 1, ease:Elastic.easeOut};
			
			// set the time (in seconds) it should take to go back into the up state
			button.upDuration = .5;
			
			// define the over state
			button.overVars = {scaleX: 1.5, scaleY: 1, ease:Elastic.easeOut};
			
			// set the time (in seconds) it should take to go to the over state
			button.overDuration = 1;
			
			// define the down state
			button.downVars = {scaleX: 1.5, scaleY: 1.5, ease:Elastic.easeOut};
			
			// set the time (in seconds) it should take to go to the down state
			button.downDuration = 1;
			
			this.addChild(button);
		}
	}
}
