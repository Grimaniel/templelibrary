/**
 * @exampleText
 * 
 * <a name="GoogleSpeech"></a>
 * <h1>Google Speech</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/speech/doc/temple/speech/googlespeech/GoogleSpeechAPI.html">GoogleSpeechAPI</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/speech/examples/temple/speech/googlespeech/GoogleSpeechExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/speech/examples/temple/speech/googlespeech/GoogleSpeechExample.as" target="_blank">View source</a></p>
 */
package
{
	import assets.Background;
	import assets.LocaleField;
	import assets.RecordButton;
	import assets.ResultField;
	import assets.StartButton;

	import temple.microphone.recorder.MicrophoneRecorder;
	import temple.speech.googlespeech.GoogleSpeechAPI;
	import temple.speech.googlespeech.data.GoogleSpeechHypothese;
	import temple.speech.googlespeech.data.GoogleSpeechResult;
	import temple.speech.googlespeech.data.GoogleSpeechResultData;
	import temple.speech.utils.FlacEncoder;
	import temple.ui.buttons.MultiStateButton;
	import temple.ui.form.components.InputField;
	import temple.ui.label.Label;
	import temple.utils.types.NumberUtils;

	import com.greensock.TweenLite;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Quad;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;

	public class GoogleSpeechExample extends DocumentClassExample
	{
		private var _micRecorder:MicrophoneRecorder;
		
		private var _startButton:MultiStateButton;
		private var _recordButton:MultiStateButton;
		private var _resultField:Label;
		private var _hypothese:GoogleSpeechHypothese;
		private var _localeField:InputField;
		private var _speechApi:GoogleSpeechAPI;
		
		public function GoogleSpeechExample()
		{
			this._speechApi = new GoogleSpeechAPI('http://stuff.mediamonks.net/arjan/google_speech_api/google_speech_proxy.php');
			
			this._micRecorder = new MicrophoneRecorder();
			// dispatched when the microphone is inited (after calling setup();)
			this._micRecorder.addEventListener(Event.INIT, this.handleRecorderInit);
			// dispatched when the recording is complete (after calling record(); and stop();)
			this._micRecorder.addEventListener(Event.COMPLETE, this.handleMicrophoneRecordingComplete);
			// dispatched when you deny microphone access from the popup
//			this._micRecorder.addEventListener(Event.CANCEL, this.handleMicrophoneCancel);
			
			this.initUI();
		}

		private function initUI():void
		{
			this._startButton = new StartButton();
			this._startButton.addEventListener(MouseEvent.CLICK, this.handleStartClick);
			
			this._recordButton = new RecordButton();
			this._recordButton.addEventListener(MouseEvent.MOUSE_DOWN, this.handleRecordButtonDown);
			this._recordButton.addEventListener(MouseEvent.MOUSE_UP, this.handleRecordButtonUp);
			
			this._resultField = new ResultField();
			
			this._localeField = new LocaleField();
			this._localeField.value = 'en-US';
			this._localeField.hintText = 'locale';
			this._localeField.hintTextColor = 0x666666;
			
			this.addChild(this._startButton);
			this._startButton.x = Math.round((this.stage.stageWidth - 72) / 2);
			this._startButton.y = Math.round(this.stage.stageHeight + 10);
			TweenLite.to(this._startButton, 0.7, new TweenLiteVars({y: Math.round((this.stage.stageHeight - 30) / 2)}).ease(Quad.easeOut).delay(0.5));

			this.fillBackground();
			
			this.stage.addEventListener(Event.RESIZE, this.handleStageResize);
		}

		private function fillBackground():void
		{
			this.graphics.clear();
			this.graphics.beginBitmapFill(new Background(1, 1));
			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		}

		private function handleStageResize(event:Event):void
		{
			this.fillBackground();
			
			this._localeField.x = 20;
			this._localeField.y = Math.round(this.stage.stageHeight - 32 - 20);
		}
		
		private function handleStartClick(event:MouseEvent):void
		{
			this._micRecorder.setup();
		}

		private function handleRecorderInit(event:Event):void
		{
			TweenLite.to(this._startButton, 1, new TweenLiteVars({y: -100}).ease(Quad.easeIn).delay(0.05));
			
			this.addChild(this._recordButton);
			this._recordButton.x = Math.round((this.stage.stageWidth - 177) / 2);
			this._recordButton.y = Math.round((this.stage.stageHeight - 30) / 2);
			TweenLite.to(this._recordButton, 1, new TweenLiteVars({y: Math.round(this.stage.stageHeight + 10)}).ease(Quad.easeOut).runBackwards(true));
			
			this.addChild(this._localeField);
			this._localeField.x = 20;
			this._localeField.y = Math.round(this.stage.stageHeight + 10);
			TweenLite.to(this._localeField, 0.5, new TweenLiteVars({y: Math.round(this.stage.stageHeight - 32 - 20)}).ease(Quad.easeOut).delay(0.6));
		}

		private function handleRecordButtonDown(event:MouseEvent):void
		{
			this._micRecorder.record();
		}

		private function handleRecordButtonUp(event:MouseEvent):void
		{
			this._micRecorder.stop();
		}

		private function handleMicrophoneRecordingComplete(event:Event):void
		{
			this._recordButton.disable();
			
			var audio:ByteArray = this._micRecorder.output;
			
			audio = FlacEncoder.encode(audio, this._micRecorder.sampleRate);
			
			if (audio)
			{
				this._speechApi.request(this.onSpeechResult, audio, this._micRecorder.sampleRate, 'en-US', 5, 0);
			}
		}

		private function onSpeechResult(result:GoogleSpeechResult):void
		{
			this._recordButton.enable();
			
			if (result.success)
			{
				this._hypothese = GoogleSpeechResultData(result.data).hypothese;
				
				trace("this._hypothese: " + (this._hypothese));
				
				if (!this._resultField.parent)
				{
					TweenLite.to(this._recordButton, 1, new TweenLiteVars({y: Math.round((this.stage.stageHeight - 30) / 2) - 60}).ease(Quad.easeInOut).delay(0.1));
					
					this.addChild(this._resultField);
					this._resultField.x = Math.round((this.stage.stageWidth - 502) / 2);
					this._resultField.y = Math.round((this.stage.stageHeight - 32) / 2);
					TweenLite.to(this._resultField, 1, new TweenLiteVars({y: Math.round(this.stage.stageHeight + 10)}).ease(Quad.easeOut).runBackwards(true));
					
					this._resultField.label = this._hypothese.utterance + '  (' + NumberUtils.format(this._hypothese.confidence, ',', '.', 3) + ')';
				}
				else
				{
					TweenLite.to(this._resultField, 0.3, new TweenLiteVars({alpha: 0}).onComplete(this.onHideResultField));
				}
			}
			else
			{
				trace('failed: ' + GoogleSpeechResultData(result.data).status, result.message);
				
				if (!this._resultField.parent)
				{
					TweenLite.to(this._recordButton, 1, new TweenLiteVars({y: Math.round((this.stage.stageHeight - 30) / 2) - 60}).ease(Quad.easeInOut).delay(0.1));
					
					this.addChild(this._resultField);
					this._resultField.x = Math.round((this.stage.stageWidth - 502) / 2);
					this._resultField.y = Math.round((this.stage.stageHeight - 32) / 2);
					TweenLite.to(this._resultField, 1, new TweenLiteVars({y: Math.round(this.stage.stageHeight + 10)}).ease(Quad.easeOut).runBackwards(true));
					
					this._resultField.label = 'Failed: ' + result.code + ' | ' + result.message;
				}
				else
				{
					this._resultField.label = 'Failed: ' + result.code + ' | ' + result.message;
				}
			}
		}
		
		private function onHideResultField():void
		{
			this._resultField.label = this._hypothese.utterance + '  (' + NumberUtils.format(this._hypothese.confidence, ',', '.', 3) + ')';
			
			TweenLite.to(this._resultField, 0.4, new TweenLiteVars({alpha: 1}));
			
			this._recordButton.enable();
		}
	}
}
