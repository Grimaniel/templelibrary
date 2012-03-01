/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
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