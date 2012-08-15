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

package temple.mediaplayers.video.cuepoints 
{
	import temple.common.interfaces.IObjectParsable;
	import temple.core.CoreObject;

	/**
	 * @author Thijs Broerse
	 */
	public class VideoCuePoint extends CoreObject implements IObjectParsable
	{
		private var _name:String;
		private var _parameters:Object;
		private var _time:Number;
		private var _type:String;

		/**
		 * Constructor.
		 * @param data Object to parse, this should be a raw NetStream.onCuePoint data object.   
		 */
		public function VideoCuePoint(name:String = null, time:Number = NaN, type:String = "event", parameters:Object = null)
		{
			this._name = name;
			this._time = time;
			this._type = type;
			this._parameters = parameters;
			this.toStringProps.push('type', 'name', 'time');
		}

		/**
		 * @inheritDoc
		 */
		public function parseObject(data:Object):Boolean
		{
			this._name = (data.name == undefined) ? null : data.name;
			this._parameters = data.parameters;
			this._time = isNaN(data.time) ? null : data.time;
			this._type = (data.type == undefined) ? 'event' : data.type;
			
			return true;
		}

		/**
		 * The name given to the cue point when it was embedded in the FLV file
		 */
		public function get name():String
		{
			return this._name;
		}
		
		/**
		 * A associative array of name/value pair strings specified for this cue point. Any valid string can be used for the parameter name or value.
		 */
		public function get parameters():Object
		{
			return this._parameters;
		}
		
		/**
		 * The time in seconds at which the cue point occurred in the video file during playback
		 */
		public function get time():Number
		{
			return this._time;
		}
		
		/**
		 * The type of cue point that was reached, either navigation or event
		 */
		public function get type():String
		{
			return this._type;
		}
	}
}