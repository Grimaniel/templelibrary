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
			super("Temple - VideoPlayerExample");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var videoPlayer:VideoPlayer = new VideoPlayer(800, 450);
			addChild(videoPlayer);
			
			// set the scale mode
			videoPlayer.scaleMode = ScaleMode.NO_SCALE;
			
			// set the sound volume 
			videoPlayer.volume = 0.7;
			
			// set debug mode to show and log debug information from the VideoPlayer
			videoPlayer.debug = true;
			
			videoPlayer.playUrl('complete_intro.f4v');
		}
	}
}
