/**
 * @exampleText
 * 
 * <a name="VideoPlayer"></a>
 * <h1>VideoPlayer</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/doc/temple/mediaplayers/video/players/VideoPlayer.html">VideoPlayer</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/examples/temple/mediaplayers/video/players/VideoPlayerExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/examples/temple/mediaplayers/video/players/VideoPlayerExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.common.enum.ScaleMode;
	import temple.mediaplayers.video.players.VideoPlayer;

	import flash.display.StageScaleMode;

	[SWF(backgroundColor="#000000", frameRate="31", width="800", height="450")]
	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class VideoPlayerExample extends DocumentClassExample 
	{
		public function VideoPlayerExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - VideoPlayerExample");
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var videoPlayer:VideoPlayer = new VideoPlayer(800, 450);
			this.addChild(videoPlayer);
			
			// set the scale mode
			videoPlayer.scaleMode = ScaleMode.NO_SCALE;
			
			// set the sound volume 
			videoPlayer.volume = 0.7;
			
			// set debug mode to show and log debug information from the VideoPlayer
			videoPlayer.debug = true;
			
			videoPlayer.playUrl('http://www.mediamonks.com/video/reel_en.flv');
		}
	}
}
