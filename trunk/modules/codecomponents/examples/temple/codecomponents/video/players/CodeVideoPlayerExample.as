/**
 * @exampleText
 * 
 * <a name="CodeVideoPlayer"></a>
 * <h1>CodeVideoPlayer</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/video/players/CodeVideoPlayer.html">CodeVideoPlayer</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/video/players/CodeVideoPlayerExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/video/players/CodeVideoPlayerExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.common.enum.ScaleMode;
	import temple.codecomponents.video.players.CodeVideoPlayer;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="800", height="450")]
	public class CodeVideoPlayerExample extends DocumentClassExample
	{
		public function CodeVideoPlayerExample()
		{
			super("Temple - CodeVideoPlayerExample");
			
			var videoPlayer:CodeVideoPlayer = new CodeVideoPlayer(800, 450, true, ScaleMode.SHOW_ALL);
			addChild(videoPlayer);
			videoPlayer.playUrl('http://www.mediamonks.com/video/reel_en.flv');
			videoPlayer.left = 0;
			videoPlayer.right = 0;
			videoPlayer.top = 0;
			videoPlayer.bottom = 0;
		}
	}
}
