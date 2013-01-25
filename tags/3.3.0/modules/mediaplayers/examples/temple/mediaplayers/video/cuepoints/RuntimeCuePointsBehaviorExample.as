/**
 * @exampleText
 * 
 * <a name="RuntimeCuePointsBehavior"></a>
 * <h1>RuntimeCuePointsBehavior</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/doc/temple/mediaplayers/video/cuepoints/RuntimeCuePointsBehavior.html">RuntimeCuePointsBehavior</a>. </p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/examples/temple/mediaplayers/video/cuepoints/RuntimeCuePointsBehaviorExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/mediaplayers/examples/temple/mediaplayers/video/cuepoints/RuntimeCuePointsBehaviorExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.mediaplayers.video.cuepoints.CuePointEvent;
	import temple.mediaplayers.video.cuepoints.RuntimeCuePointsBehavior;
	import temple.mediaplayers.video.cuepoints.VideoCuePoint;
	import temple.mediaplayers.video.players.VideoPlayer;

	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFormat;

	[SWF(backgroundColor="#000000", frameRate="31", width="800", height="450")]
	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class RuntimeCuePointsBehaviorExample extends DocumentClassExample 
	{
		private var _videoPlayer:VideoPlayer;
		private var _message:Sprite;

		public function RuntimeCuePointsBehaviorExample()
		{
			// The super class connects to Yalog, so you can see all log message at: http://yalala.tyz.nl/
			super("Temple - RuntimeCuePointsBehaviorExample");
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this._videoPlayer = new VideoPlayer(800, 450);
			this.addChild(this._videoPlayer);
			
			// add listener to receive cue point messages
			this._videoPlayer.addEventListener(CuePointEvent.CUEPOINT, this.handleCuePoint);
			this._videoPlayer.playUrl('http://www.mediamonks.com/video/reel_en.flv');
			
			// create RuntimeCuePointsBehavior, assign the _videoPlayer as target
			var runtimeCuepoints:RuntimeCuePointsBehavior = new RuntimeCuePointsBehavior(this._videoPlayer);
			runtimeCuepoints.addCuePoint(new VideoCuePoint("Hello world!", 0));
			runtimeCuepoints.addCuePoint(new VideoCuePoint("This is the RuntimeCuePointBehavior Example", 3));
			runtimeCuepoints.addCuePoint(new VideoCuePoint("Happy coding", 5));
		}

		private function handleCuePoint(event:CuePointEvent):void 
		{
			this.logInfo("Cuepoint: " + event.cuepoint);
			
			// display the cuepoint name as message on screen
			
			if (this._message)
			{
				this.removeChild(this._message);
				this._message = null;
			}
			
			this._message = this.createMessage(event.cuepoint.name, 0xE5ECF9, 0x6B90DA);
			this._message.x = (this._videoPlayer.width - this._message.width) / 2;
			this._message.y = this._videoPlayer.height - 40;
			this.addChild(this._message);
		}
		
		
		private function createMessage(label:String, backgroundColor:uint, borderColor:uint):Sprite
		{
			var messageLabel:TextField = new TextField();
			messageLabel.defaultTextFormat = new TextFormat("Arial", 12, 0x333333, true, null, null, null, null, "center");
			messageLabel.height = 20;
			messageLabel.selectable = messageLabel.mouseEnabled = false;
			messageLabel.text = label;
			messageLabel.width = messageLabel.textWidth + 5;
			
			var message:Sprite = new Sprite();
			message.graphics.beginFill(backgroundColor);
			message.graphics.lineStyle(1, borderColor, 1, true);
			message.graphics.drawRoundRect(-4, -4, messageLabel.width+8, 28, 8);
			message.graphics.endFill();
			message.mouseChildren = false;
			
			message.addChild(messageLabel);
			return message;
		}
	}
}
