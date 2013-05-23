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
			_speechApi = new GoogleSpeechAPI('http://stuff.mediamonks.net/arjan/google_speech_api/google_speech_proxy.php');
			
			_micRecorder = new MicrophoneRecorder();
			// dispatched when the microphone is inited (after calling setup();)
			_micRecorder.addEventListener(Event.INIT, handleRecorderInit);
			// dispatched when the recording is complete (after calling record(); and stop();)
			_micRecorder.addEventListener(Event.COMPLETE, handleMicrophoneRecordingComplete);
			// dispatched when you deny microphone access from the popup
//			_micRecorder.addEventListener(Event.CANCEL, handleMicrophoneCancel);
			
			initUI();
		}

		private function initUI():void
		{
			_startButton = new StartButton();
			_startButton.addEventListener(MouseEvent.CLICK, handleStartClick);
			
			_recordButton = new RecordButton();
			_recordButton.addEventListener(MouseEvent.MOUSE_DOWN, handleRecordButtonDown);
			_recordButton.addEventListener(MouseEvent.MOUSE_UP, handleRecordButtonUp);
			
			_resultField = new ResultField();
			
			_localeField = new LocaleField();
			_localeField.value = 'en-US';
			_localeField.hintText = 'locale';
			_localeField.hintTextColor = 0x666666;
			
			addChild(_startButton);
			_startButton.x = Math.round((stage.stageWidth - 72) / 2);
			_startButton.y = Math.round(stage.stageHeight + 10);
			TweenLite.to(_startButton, 0.7, new TweenLiteVars({y: Math.round((stage.stageHeight - 30) / 2)}).ease(Quad.easeOut).delay(0.5));

			fillBackground();
			
			stage.addEventListener(Event.RESIZE, handleStageResize);
		}

		private function fillBackground():void
		{
			graphics.clear();
			graphics.beginBitmapFill(new Background(1, 1));
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		}

		private function handleStageResize(event:Event):void
		{
			fillBackground();
			
			_localeField.x = 20;
			_localeField.y = Math.round(stage.stageHeight - 32 - 20);
		}
		
		private function handleStartClick(event:MouseEvent):void
		{
			_micRecorder.setup();
		}

		private function handleRecorderInit(event:Event):void
		{
			TweenLite.to(_startButton, 1, new TweenLiteVars({y: -100}).ease(Quad.easeIn).delay(0.05));
			
			addChild(_recordButton);
			_recordButton.x = Math.round((stage.stageWidth - 177) / 2);
			_recordButton.y = Math.round((stage.stageHeight - 30) / 2);
			TweenLite.to(_recordButton, 1, new TweenLiteVars({y: Math.round(stage.stageHeight + 10)}).ease(Quad.easeOut).runBackwards(true));
			
			addChild(_localeField);
			_localeField.x = 20;
			_localeField.y = Math.round(stage.stageHeight + 10);
			TweenLite.to(_localeField, 0.5, new TweenLiteVars({y: Math.round(stage.stageHeight - 32 - 20)}).ease(Quad.easeOut).delay(0.6));
		}

		private function handleRecordButtonDown(event:MouseEvent):void
		{
			_micRecorder.record();
		}

		private function handleRecordButtonUp(event:MouseEvent):void
		{
			_micRecorder.stop();
		}

		private function handleMicrophoneRecordingComplete(event:Event):void
		{
			_recordButton.disable();
			
			var audio:ByteArray = _micRecorder.output;
			
			audio = FlacEncoder.encode(audio, _micRecorder.sampleRate);
			
			if (audio)
			{
				_speechApi.request(onSpeechResult, audio, _micRecorder.sampleRate, 'en-US', 5, 0);
			}
		}

		private function onSpeechResult(result:GoogleSpeechResult):void
		{
			_recordButton.enable();
			
			if (result.success)
			{
				_hypothese = GoogleSpeechResultData(result.data).hypothese;
				
				trace("_hypothese: " + (_hypothese));
				
				if (!_resultField.parent)
				{
					TweenLite.to(_recordButton, 1, new TweenLiteVars({y: Math.round((stage.stageHeight - 30) / 2) - 60}).ease(Quad.easeInOut).delay(0.1));
					
					addChild(_resultField);
					_resultField.x = Math.round((stage.stageWidth - 502) / 2);
					_resultField.y = Math.round((stage.stageHeight - 32) / 2);
					TweenLite.to(_resultField, 1, new TweenLiteVars({y: Math.round(stage.stageHeight + 10)}).ease(Quad.easeOut).runBackwards(true));
					
					_resultField.label = _hypothese.utterance + '  (' + NumberUtils.format(_hypothese.confidence, ',', '.', 3) + ')';
				}
				else
				{
					TweenLite.to(_resultField, 0.3, new TweenLiteVars({alpha: 0}).onComplete(onHideResultField));
				}
			}
			else
			{
				trace('failed: ' + GoogleSpeechResultData(result.data).status, result.message);
				
				if (!_resultField.parent)
				{
					TweenLite.to(_recordButton, 1, new TweenLiteVars({y: Math.round((stage.stageHeight - 30) / 2) - 60}).ease(Quad.easeInOut).delay(0.1));
					
					addChild(_resultField);
					_resultField.x = Math.round((stage.stageWidth - 502) / 2);
					_resultField.y = Math.round((stage.stageHeight - 32) / 2);
					TweenLite.to(_resultField, 1, new TweenLiteVars({y: Math.round(stage.stageHeight + 10)}).ease(Quad.easeOut).runBackwards(true));
					
					_resultField.label = 'Failed: ' + result.code + ' | ' + result.message;
				}
				else
				{
					_resultField.label = 'Failed: ' + result.code + ' | ' + result.message;
				}
			}
		}
		
		private function onHideResultField():void
		{
			_resultField.label = _hypothese.utterance + '  (' + NumberUtils.format(_hypothese.confidence, ',', '.', 3) + ')';
			
			TweenLite.to(_resultField, 0.4, new TweenLiteVars({alpha: 1}));
			
			_recordButton.enable();
		}
	}
}
