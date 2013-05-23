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

package temple.speech.googlespeech
{
	import temple.speech.googlespeech.data.GoogleSpeechResultData;
	import flash.events.ErrorEvent;
	import temple.net.multipart.MultipartURLLoader;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import temple.common.interfaces.IDataResult;
	import temple.common.interfaces.IPendingCall;
	import temple.core.events.CoreEventDispatcher;
	import temple.speech.googlespeech.data.GoogleSpeechResult;

	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * @author Arjan van Wijk
	 */
	public class GoogleSpeechCall extends CoreEventDispatcher implements IPendingCall
	{
		private var _callback:Function;
		private var _result:GoogleSpeechResult;
		
		internal var loader:MultipartURLLoader;
		internal var _isLoading:Boolean;
		private var _isLoaded:Boolean;
		
		private var _audio:ByteArray;
		private var _bitrate:uint;
		private var _language:String;
		private var _maxResults:uint;
		private var _profanityFilter:uint;

		public function GoogleSpeechCall(callback:Function, audio:ByteArray, bitrate:uint = 44000, language:String = 'en-US', maxResults:uint = 1, profanityFilter:uint = 0) 
		{
			_callback = callback;
			_audio = audio;
			_bitrate = bitrate;
			_language = language;
			_maxResults = maxResults;
			_profanityFilter = profanityFilter;
		}

		public function get audio():ByteArray
		{
			return _audio;
		}

		public function get bitrate():uint
		{
			return _bitrate;
		}

		public function get language():String
		{
			return _language;
		}

		public function get maxResults():uint
		{
			return _maxResults;
		}

		public function get profanityFilter():uint
		{
			return _profanityFilter;
		}
		
		public function onResult(result:Object):void
		{
			var data:GoogleSpeechResultData = new GoogleSpeechResultData();
			data.parseObject(result);
			
			var message:String = '';
			if ('message' in result) message = result['message'];
			if (data.status == 5) message = 'Audio not recognized';
			
			_result = new GoogleSpeechResult(data, data.hypothese != null, message, data.status.toString());
			
			if (_callback != null)
			{
				var callback:Function = _callback;
				_callback = null;
				callback(_result);
			}
			
			if (result.success)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
			
			destruct();
		}

		public function onIOError(event:IOErrorEvent):void
		{
			onResult({status: 6, id: null});
		}

		public function onSecurityError(event:SecurityErrorEvent):void 
		{
			onResult({status: 7, id: null});
		}
		
		public function cancel():Boolean
		{
			if (_isLoaded) return false;
			
			_isLoading = false;
			_isLoaded = true;
			
			_result = new GoogleSpeechResult(null, false);
			_callback = null;
			
			dispatchEvent(new Event(Event.CANCEL));
			
			return true;
		}

		public function get result():IDataResult
		{
			return _result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			_callback = null;
			_audio = null;
			_language = null;
			_result = null;
			
			super.destruct();
		}
	}
}
