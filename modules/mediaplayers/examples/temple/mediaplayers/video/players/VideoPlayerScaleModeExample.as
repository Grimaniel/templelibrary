/**
 * @exampleText
 * 
 * <a name="VideoPlayerScaleMode"></a>
 * <h1>VideoPlayer and ScaleMode</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/doc/temple/mediaplayers/video/players/VideoPlayer.html">VideoPlayer</a>
 * and ScaleMode.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/examples/temple/mediaplayers/video/players/VideoPlayerScaleModeExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/examples/temple/mediaplayers/video/players/VideoPlayerScaleModeExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.mediaplayers.video.players.VideoPlayer;
	import temple.ui.form.components.RadioButtonGroup;

	import flash.events.Event;

	public class VideoPlayerScaleModeExample extends DocumentClassExample 
	{
		public var mcScaleModeGroupGroup:RadioButtonGroup;
		public var mcVideoPlayer:VideoPlayer;

		public function VideoPlayerScaleModeExample()
		{
			super();
			
			mcScaleModeGroupGroup.addEventListener(Event.CHANGE, handleScaleModeChange);
		}

		private function handleScaleModeChange(event:Event):void
		{
			mcVideoPlayer.scaleMode = mcScaleModeGroupGroup.value;
		}
	}
}
