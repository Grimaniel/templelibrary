/**
 * @exampleText
 * 
 * <a name="F4VPlayer"></a>
 * <h1>F4VPlayer</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/doc/temple/mediaplayers/video/players/F4VPlayer.html">VideoPlayer</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/examples/temple/mediaplayers/video/players/F4VPlayerExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/examples/temple/mediaplayers/video/players/F4VPlayerExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.mediaplayers.video.cuepoints.CuePointEvent;
	import temple.mediaplayers.video.players.F4VPlayer;

	import flash.display.StageScaleMode;
	
	[SWF(backgroundColor="#000000", frameRate="31", width="800", height="450")]
	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class F4VPlayerExample extends DocumentClassExample
	{
		
		public function F4VPlayerExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super('Temple - F4VPlayerExample');
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var videoPlayer:F4VPlayer = new F4VPlayer(800, 450);
			addChild(videoPlayer);
			
			videoPlayer.playUrl('complete_intro.f4v');
			
			// listen for cue points
			videoPlayer.addEventListener(CuePointEvent.CUEPOINT, handleCuePoint);
			
			// set debug mode to show and log debug information from the F4VPlayer
			videoPlayer.debug = true;
		}

		private function handleCuePoint(event:CuePointEvent):void 
		{
			logInfo("Cuepoint: " + event.cuepoint);
		}
	}
}
