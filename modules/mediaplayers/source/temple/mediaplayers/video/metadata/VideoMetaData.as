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

package temple.mediaplayers.video.metadata 
{
	import temple.common.interfaces.IObjectParsable;
	import temple.core.CoreObject;
	import temple.mediaplayers.video.cuepoints.VideoCuePoint;

	/**
	 * @author Thijs Broerse
	 */
	public class VideoMetaData extends CoreObject implements IObjectParsable
	{
		private var _audiocodecid:Number;
		private var _audiodatarate:Number;
		private var _audiodelay:Number;
		private var _canSeekToEnd:Boolean;
		private var _duration:Number;
		private var _framerate:Number;
		private var _height:Number;
		private var _videocodecid:Number;
		private var _videodatarate:Number;
		private var _width:Number;
		private var _cuePoints:Array;

		/**
		 * Constructor.
		 * @param data Object to parse, this should be a raw NetStream.onMetaData data object.   
		 */
		public function VideoMetaData(data:Object = null) 
		{
			if (data) this.parseObject(data);
		}

		/**
		 * @inheritDoc
		 */
		public function parseObject(object:Object):Boolean
		{
			this._audiocodecid = isNaN(object.audiocodecid) ? null : object.audiocodecid;
			this._audiodatarate = isNaN(object.audiodatarate) ? null : object.audiodatarate;
			this._audiodelay = isNaN(object.audiodelay) ? null : object.audiodelay;
			this._canSeekToEnd = (object.canSeekToEnd == undefined) ? false : object.canSeekToEnd;
			this._duration = isNaN(object.duration) ? null : object.duration;
			this._framerate = isNaN(object.framerate) ? null : object.framerate;
			this._height = isNaN(object.height) ? null : object.height;
			this._videocodecid = (object.videocodecid == undefined) ? null : object.videocodecid;
			this._videodatarate = isNaN(object.videodatarate) ? null : object.videodatarate;
			this._width = isNaN(object.width) ? null : object.width;
			
			if (object.cuePoints is Array)
			{
				var cuePoint:VideoCuePoint;
				this._cuePoints = [];
				for (var i:int = 0, leni:int = object.cuePoints.length; i < leni; i++)
				{
					cuePoint = new VideoCuePoint();
					cuePoint.parseObject(object.cuePoints[i]);
					this._cuePoints.push(cuePoint);
				}
			}
			
			return true;
		}

		/**
		 * A number that indicates the audio codec (code/decode technique) that was used
		 */
		public function get audiocodecid():Number
		{
			return this._audiocodecid;
		}
		
		/**
		 * A number that indicates the rate at which audio was encoded, in kilobytes per second
		 */
		public function get audiodatarate():Number
		{
			return this._audiodatarate;
		}
		
		/**
		 * A number that indicates what time in the FLV file "time 0" of the original FLV file exists
		 */
		public function get audiodelay():Number
		{
			return this._audiodelay;
		}
		
		/**
		 * A Boolean value that is true if the FLV file is encoded with a keyframe on the last frame that allows seeking to the end of a progressive download movie clip
		 */
		public function get canSeekToEnd():Boolean
		{
			return this._canSeekToEnd;
		}
		
		/**
		 * A number that specifies the duration of the FLV file, in seconds
		 */
		public function get duration():Number
		{
			return this._duration;
		}
		
		/**
		 * A number that is the frame rate of the FLV file
		 */
		public function get framerate():Number
		{
			return this._framerate;
		}
		
		/**
		 * A number that is the height of the FLV file, in pixels
		 */
		public function get height():Number
		{
			return this._height;
		}
		
		/**
		 * A number that is the codec version that was used to encode the video
		 */
		public function get videocodecid():Number
		{
			return this._videocodecid;
		}
		
		/**
		 * A number that is the video data rate of the FLV file
		 */
		public function get videodatarate():Number
		{
			return this._videodatarate;
		}
		
		/**
		 * A number that is the width of the FLV file, in pixels
		 */
		public function get width():Number
		{
			return this._width;
		}
		
		/**
		 * An array with cuePoints
		 */
		public function get cuePoints():Array
		{
			return this._cuePoints;
		}
	}
}