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
			this._callback = callback;
			this._audio = audio;
			this._bitrate = bitrate;
			this._language = language;
			this._maxResults = maxResults;
			this._profanityFilter = profanityFilter;
		}

		public function get audio():ByteArray
		{
			return this._audio;
		}

		public function get bitrate():uint
		{
			return this._bitrate;
		}

		public function get language():String
		{
			return this._language;
		}

		public function get maxResults():uint
		{
			return this._maxResults;
		}

		public function get profanityFilter():uint
		{
			return this._profanityFilter;
		}
		
		public function onResult(result:Object):void
		{
			var data:GoogleSpeechResultData = new GoogleSpeechResultData();
			data.parseObject(result);
			
			var message:String = '';
			if ('message' in result) message = result['message'];
			if (data.status == 5) message = 'Audio not recognized';
			
			this._result = new GoogleSpeechResult(data, data.hypothese != null, message, data.status.toString());
			
			if (this._callback != null)
			{
				var callback:Function = this._callback;
				this._callback = null;
				callback(this._result);
			}
			
			if (this.result.success)
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
			
			this.destruct();
		}

		public function onIOError(event:IOErrorEvent):void
		{
			this.onResult({status: 6, id: null});
		}

		public function onSecurityError(event:SecurityErrorEvent):void 
		{
			this.onResult({status: 7, id: null});
		}
		
		public function cancel():Boolean
		{
			if (this._isLoaded) return false;
			
			this._isLoading = false;
			this._isLoaded = true;
			
			this._result = new GoogleSpeechResult(null, false);
			this._callback = null;
			
			this.dispatchEvent(new Event(Event.CANCEL));
			
			return true;
		}

		public function get result():IDataResult
		{
			return this._result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return this._isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			this._callback = null;
			this._audio = null;
			this._language = null;
			this._result = null;
			
			super.destruct();
		}
	}
}
