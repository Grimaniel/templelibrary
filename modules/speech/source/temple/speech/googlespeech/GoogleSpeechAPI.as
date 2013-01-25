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
	import temple.common.events.PendingCallEvent;
	import temple.common.interfaces.IPendingCall;
	import temple.core.events.CoreEventDispatcher;
	import temple.data.encoding.json.JSONCoder;
	import temple.net.multipart.MultipartURLLoader;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @includeExample GoogleSpeechExample.as
	 * 
	 * @author Arjan van Wijk
	 */
	public class GoogleSpeechAPI extends CoreEventDispatcher
	{
		private var _proxyUrl:String;
		private var _calls:Dictionary;

		public function GoogleSpeechAPI(proxyUrl:String)
		{
			_proxyUrl = proxyUrl;
			_calls = new Dictionary();
		}
		
		public function request(callback:Function, audio:ByteArray, bitrate:uint = 44000, language:String = 'en-US', maxResults:uint = 1, profanityFilter:uint = 0):IPendingCall
		{
			var call:GoogleSpeechCall = new GoogleSpeechCall(callback, audio, bitrate, language, maxResults, profanityFilter);
			call.addEventListener(Event.COMPLETE, handleCallComplete);
			call.addEventListener(ErrorEvent.ERROR, handleCallError);
			call.addEventListener(Event.CANCEL, handleCallCancel);
			
			var loader:MultipartURLLoader = new MultipartURLLoader();
			loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, call.onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, call.onSecurityError);
			loader.addFile(audio, 'recording.wav', 'recording');
			loader.load(_proxyUrl + '?xjerr=1&fileKey=recording&rate=' + bitrate + '&locale=' + language + '&maxresults=' + maxResults + '&pfilter=' + profanityFilter);
			
			_calls[loader] = call;
			// TODO: wordt de loader of the call ooit destructed?
			call.loader = loader;
			
			dispatchEvent(new PendingCallEvent(PendingCallEvent.CALL, IPendingCall(call)));
			
			return call;
		}

		private function handleCallComplete(event:Event):void
		{
			dispatchEvent(new PendingCallEvent(PendingCallEvent.RESULT, IPendingCall(event.target)));
		}

		private function handleCallError(event:ErrorEvent):void
		{
		}

		private function handleCallCancel(event:Event):void
		{
		}

		private function handleLoadComplete(event:Event):void
		{
			var target:MultipartURLLoader = MultipartURLLoader(event.target);
			var call:GoogleSpeechCall = _calls[target];
			var data:String = target.loader.data;
			
			var result:Object;
			var xml:XML;
			
			try
			{
				result = JSONCoder.decode(data);
			}
			catch (error:Error)
			{
				if (data.indexOf('<H2>Error 400</H2>') > -1)
				{
					xml = new XML(data);
					
					result = {
						id: null,
						status: 400,
						message: xml..H1
					}; 
				}
				if (data.indexOf('<H2>Error 413</H2>') > -1)
				{
					xml = new XML(data);
					
					result = {
						id: null,
						status: 413,
						message: xml..H1
					}; 
				}
				else if (data.indexOf('(Bad Request)') > -1)
				{
					result = {
						id: null,
						status: 400,
						message: 'Your client has issued a malformed or illegal request.'
					}; 
				}
			}
			
			call.onResult(result);
		}
	}
}
