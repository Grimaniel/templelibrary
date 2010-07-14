/**
 * @exampleText
 * 
 * <h1>VideoPlayer</h1>
 * 
 * <p>This is an example about the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/media/video/players/VideoPlayer.html">VideoPlayer</a>.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/media/video/players/VideoPlayerExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/media/video/players/VideoPlayerExample.swf</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/media/video/players/VideoPlayerExample.swf" target="_blank">Download source</a></p>
 */
package  
{
	import flash.display.StageScaleMode;
	import temple.core.CoreSprite;
	import temple.media.video.players.VideoPlayer;

	[SWF(backgroundColor="#000000", frameRate="31", width="800", height="450")]
	public class VideoPlayerExample extends CoreSprite 
	{
		public function VideoPlayerExample()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var videoPlayer:VideoPlayer = new VideoPlayer(800, 450);
			this.addChild(videoPlayer);
			videoPlayer.playUrl('http://www.mediamonks.com/video/reel_en.flv');
		}
	}
}
