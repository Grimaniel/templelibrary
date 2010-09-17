/**
 * @exampleText
 * 
 * <a name="FrameStableMovieClip-FrameRateKiller"></a>
 * <h1>FrameStableMovieClip &amp; FrameRateKiller</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/ui/animation/FrameStableMovieClip.html">FrameStableMovieClip</a> and <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/utils/FrameRateKiller.html">FrameRateKiller</a>.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/animation/FrameStableMovieClipExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/animation/FrameStableMovieClipExample.swf</a></p>
 * 
 * <p>This example uses an .fla file which can be found at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/animation/FrameStableMovieClipExample.fla" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/animation/FrameStableMovieClipExample.fla</a></p>
 * 
 * <p>This example consists of 3 animations: a normal timeline animation, a FrameStableMovieClip timeline animation and a scripted animation using TweenLite. 
 * The TweenLite animation is time based and will always animate in the same duration. The FrameStableMovieClip will also play in the same duration, no matter what the frame rate is.
 * The frame rate is throttled using the FrameRateKiller. You can change the fps in the TextField to test it.
 * </p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/animation/FrameStableMovieClipExample.as" target="_blank">Download source</a></p>
 */
package  
{
	import temple.utils.StageSettings;
	import flash.events.Event;
	import temple.ui.form.validation.rules.Restrictions;
	import temple.utils.FrameRateKiller;
	import flash.text.TextField;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import temple.debug.PerformanceStat;
	import temple.core.CoreSprite;
	import temple.ui.animation.FrameStableMovieClip;
	import temple.ui.buttons.MultiStateButton;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class FrameStableMovieClipExample extends CoreSprite 
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
			new StageSettings(this);
			
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
		}

		private function handlePlayButtonClick(event:MouseEvent):void 
		{
			this.play();
		}

		private function play():void 
		{
			trace("play");
			
			this.mcNormalTimelineAnimation.gotoAndPlay(1);
			this.mcFrameStableTimelineAnimation.gotoAndPlay(1);
			
			this.mcTweenClip.x = 40;
			
			// Tween the clip over 2 seconds, since the other timelines have 62 frames (which would normally take 2 seconds at 31 fps)
			TweenLite.to(this.mcTweenClip, 2, {x: 440, ease: Linear.easeNone});
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
