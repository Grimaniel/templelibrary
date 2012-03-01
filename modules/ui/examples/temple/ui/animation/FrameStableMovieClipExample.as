/**
 * @exampleText
 * 
 * <a name="FrameStableMovieClip"></a>
 * <h1>FrameStableMovieClip</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/doc/temple/ui/animation/FrameStableMovieClip.html">FrameStableMovieClip</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/animation/FrameStableMovieClipExample.swf" target="_blank">View this example</a></p>
 * 
 * <p>This example consists of 3 animations: a normal timeline animation, a FrameStableMovieClip timeline animation and a scripted animation using TweenLite. 
 * The TweenLite animation is time based and will always animate in the same duration. The FrameStableMovieClip will also play in the same duration, no matter what the frame rate is.
 * The frame rate is throttled using the FrameRateKiller. You can change the fps in the TextField to test it.
 * </p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/animation/FrameStableMovieClipExample.fla" target="_blank">Download .fla file</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/examples/temple/ui/animation/FrameStableMovieClipExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.ui.animation.FrameStableMovieClip;
	import temple.ui.buttons.MultiStateButton;
	import temple.ui.form.validation.rules.Restrictions;
	import temple.utils.FrameRateKiller;
	import temple.utils.PerformanceStat;

	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class FrameStableMovieClipExample extends DocumentClassExample 
	{
		// MovieClip with an ordinary timeline animation over 62 frames (would normally take 2 seconds at 31 fps)
		public var mcNormalTimelineAnimation:MovieClip;
		
		// FrameStableMovieClip with an ordinary timeline animation over 62 frames (would normally take 2 seconds at 31 fps)
		public var mcFrameStableTimelineAnimation:FrameStableMovieClip;
		
		// A MovieClip with is animated by code (using TweenLite)
		public var mcTweenClip:MovieClip;
		
		public var mcPlayButton:MultiStateButton;
		
		public var txtFPS:TextField;
		
		private var _frameRateKiller:FrameRateKiller;

		public function FrameStableMovieClipExample()
		{
			super("Temple - FrameStableMovieClipExample");
			
			this.mcNormalTimelineAnimation.stop();
			this.mcFrameStableTimelineAnimation.stop();
			
			this.mcPlayButton.addEventListener(MouseEvent.CLICK, this.handlePlayButtonClick);
			
			// Add fps counter so we can see the frame rate
			this.addChild(new PerformanceStat()).x = 420;
			
			// Create a FrameRateKiller for framerate throttling
			this._frameRateKiller = new FrameRateKiller(25);
			
			this.txtFPS.restrict = Restrictions.INTEGERS;
			this.txtFPS.text = this._frameRateKiller.fps.toString();
			this.txtFPS.addEventListener(Event.CHANGE, this.handleFPSChange);
			this.txtFPS.borderColor = 0xDDDDDD;
		}

		private function handlePlayButtonClick(event:MouseEvent):void 
		{
			this.mcNormalTimelineAnimation.gotoAndPlay(1);
			
			this.mcFrameStableTimelineAnimation.gotoAndPlay(1);
			
			TweenLite.killTweensOf(this.mcTweenClip);
			this.mcTweenClip.x = 10;
			// Tween the clip over 2 seconds, since the other timelines have 62 frames (which would normally take 2 seconds at 31 fps)
			TweenLite.to(this.mcTweenClip, 2, {x: this.mcTweenClip.x + 400, ease: Linear.easeNone});
		}
		
		private function handleFPSChange(event:Event):void 
		{
			if (int(this.txtFPS.text))
			{
				this._frameRateKiller.fps = int(this.txtFPS.text);
			}
		}
	}
}
