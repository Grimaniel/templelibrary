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

package temple.speech.googlespeech.data
{
	import temple.common.interfaces.IObjectParsable;
	import temple.data.object.ObjectParser;
	/**
	 * @author Arjan van Wijk
	 */
	public class GoogleSpeechResultData implements IObjectParsable
	{
		private var _hypotheses:Vector.<GoogleSpeechHypothese>;
		private var _status:uint;
		private var _id:String;

		public function parseObject(object:Object):Boolean
		{
			_status = object['status'];
			_id = object['id'];
			
			_hypotheses = Vector.<GoogleSpeechHypothese>(ObjectParser.parseList(object['hypotheses'] as Array, GoogleSpeechHypothese));
			
			
			return true;
		}

		public function get id():String
		{
			return _id;
		}
		
		public function set status(value:uint):void
		{
			_status = value;
		}
		
		public function get status():uint
		{
			return _status;
		}
		
		public function get hypotheses():Vector.<GoogleSpeechHypothese>
		{
			return _hypotheses;
		}
		
		public function get hypothese():GoogleSpeechHypothese
		{
			if (0 in _hypotheses) return _hypotheses[0];
			
			return null;
		}
	}
}