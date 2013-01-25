/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.microphone.recorder
{
	import temple.core.events.CoreEventDispatcher;

	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * Dispatched during the recording of the audio stream coming from the microphone.
	 *
	 * @eventType org.bytearray.micrecorder.RecordingEvent.RECORDING
	 */
	[Event(name='RecordingEvent.recording', type='temple.microphone.recorder.events.RecordingEvent')]
	/**
	 * Dispatched when the creation of the output file is done.
	 *
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name='complete', type='flash.events.Event')]
	
	[Event(name='init', type='flash.events.Event')]
	
	[Event(name='cancel', type='flash.events.Event')]
	
	/**
	 * This tiny helper class allows you to quickly record the audio stream coming from the Microphone and save this as a physical file.
	 * A WavEncoder is bundled to save the audio stream as a WAV file
	 * @author Thibault Imbert - bytearray.org
	 */
	public final class MicrophoneRecorder extends CoreEventDispatcher
	{
		private var _gain:uint;
		private var _rate:uint;
		private var _inited:Boolean;
		private var _silenceLevel:uint;
		private var _silenceTimeOut:uint;
		
		private var _microphone:Microphone;
		private var _resetted:Boolean;
		private var _difference:uint;
		private var _buffer:ByteArray;
		private var _output:ByteArray;

		/**
		 * 
		 * @param gain The gain
		 * @param rate Audio rate
		 * @param silenceLevel The silence level
		 * @param timeOut The timeout
		 */
		public function MicrophoneRecorder(gain:uint = 100, rate:uint = 44, silenceLevel:uint = 0, silenceTimeOut:uint = 4000)
		{
			_gain = gain;
			_rate = rate;
			_silenceLevel = silenceLevel;
			_silenceTimeOut = silenceTimeOut;
			_buffer = new ByteArray();
			
			toStringProps.push("gain", "rate", "silenceLevel", "silenceTimeOut");
		}

		public function setup():void
		{
			if (_microphone == null)
			{
				// force mic access settings dialog
				if (_resetted)
				{
					Security.showSettings(SecurityPanel.PRIVACY);
				}
				else
				{
					createMicrophone();
					
					var nc:NetConnection = new NetConnection();
					nc.connect(null);
					var ns:NetStream = new NetStream(nc);
					ns.attachAudio(_microphone);
				}
			}
			
			if (_microphone)
			{
				_buffer.length = 0;
			}
		}

		public function record():void
		{
			_difference = getTimer();
			_microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData);
		}

		/**
		 * Stop recording the audio stream and automatically starts the packaging of the output file.
		 */
		public function stop(useSample:Boolean = true):void
		{
			var recordedBuffer:ByteArray = new ByteArray();
			
			_buffer.position = 0;
			_buffer.readBytes(recordedBuffer);
			
			if (useSample)
			{
				_buffer.clear();
				
				recordedBuffer.position = 0;
				_output = recordedBuffer;
	
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			_microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData);
		}

		public function get sampleRate():uint
		{
			var rate:uint = 22050;
			if (_rate == 44) rate = 44100;
			if (_rate == 22) rate = 22050;
			if (_rate == 11) rate = 11025;
			if (_rate == 8) rate = 8000;
			if (_rate == 5) rate = 5512;

			return rate;
		}

		public function get rate():uint
		{
			return _rate;
		}

		public function set rate(value:uint):void
		{
			_rate = value;
		}

		public function get gain():uint
		{
			return _gain;
		}

		public function set gain(value:uint):void
		{
			_gain = value;
		}

		public function get silenceLevel():uint
		{
			return _silenceLevel;
		}

		public function set silenceLevel(value:uint):void
		{
			_silenceLevel = value;
		}

		public function get output():ByteArray
		{
			return _output;
		}

		public function get recordingTime():uint
		{
			return getTimer() - _difference;
		}

		public function get silenceTimeOut():uint
		{
			return _silenceTimeOut;
		}

		public function set silenceTimeOut(value:uint):void
		{
			_silenceTimeOut = value;
		}
		
		private function createMicrophone():void
		{
			_microphone = Microphone.getMicrophone();
			
			if (_microphone)
			{
				_microphone.addEventListener(StatusEvent.STATUS, handleStatusEvent);
				
				_microphone.setSilenceLevel(_silenceLevel, _silenceTimeOut);
				_microphone.rate = _rate;
				_microphone.gain = _gain;
				
				setup();
			}
			else
			{
				dispatchEvent(new Event(Event.CANCEL));
			}
		}

		private function handleStatusEvent(event:StatusEvent):void
		{
			if (_inited) return;
			
			if (event.code == 'Microphone.Muted')
			{
				_resetted = true;
				_microphone = null;
				dispatchEvent(new Event(Event.CANCEL));
			}
			else if (event.code == 'Microphone.Unmuted')
			{
				createMicrophone();
				
				dispatchEvent(new Event(Event.INIT));
				_inited = true;
			}
			else
			{
				_difference = getTimer();
			}
		}
		
		/**
		 * Dispatched during the recording.
		 */
		private function handleSampleData(event:SampleDataEvent):void
		{
			while (event.data.bytesAvailable > 0)
			{
				_buffer.writeFloat(event.data.readFloat());
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_microphone)
			{
				_microphone.removeEventListener(StatusEvent.STATUS, handleStatusEvent);
				_microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData);
				_microphone = null;
			}
			_buffer = null;
			_output = null;
			
			super.destruct();
		}

	}
}