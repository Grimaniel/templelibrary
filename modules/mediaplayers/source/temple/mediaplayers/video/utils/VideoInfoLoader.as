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

package temple.mediaplayers.video.utils 
{
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import temple.core.events.CoreEventDispatcher;
	import temple.mediaplayers.video.cuepoints.CuePointEvent;
	import temple.mediaplayers.video.metadata.VideoMetaDataEvent;
	import temple.mediaplayers.video.net.NetStatusEventInfoCodes;
	import temple.mediaplayers.video.net.VideoNetStream;
	import temple.utils.TimeOut;


	[Event(name="VideoMetaDataEvent.metadata", type="temple.mediaplayers.video.metadata.VideoMetaDataEvent")]
	[Event(name="VideoMetaDataEvent.notFound", type="temple.mediaplayers.video.metadata.VideoMetaDataEvent")]
	[Event(name="CuePointEvent.cuepoint", type="temple.mediaplayers.video.cuepoints.CuePointEvent")]

	/**
	 * @example
	 * <listing version="3.0">
	 * new VideoInfoLoader().getMetaData(url).addEventListener(MetaDataEvent.METADATA, this.handleMetaData);
	 * </listing>
	 * 
	 * @author Arjan van Wijk (arjan at mediamonks dot com)
	 */
	public class VideoInfoLoader extends CoreEventDispatcher
	{
		private var _netstreamMetaData:VideoNetStream;
		private var _netstreamCuePoint:VideoNetStream;

		private var _ncMetaData:NetConnection;
		private var _ncCuePoint:NetConnection;

		private var _metaDataTimeout:TimeOut;

		private var _urlMetaData:String;

		private var _maxRetryCount:Number;
		private var _metadata:Object;
		private var _cuepoints:Object;

		public function VideoInfoLoader(metadata:Object = null, cuepoints:Object = null)
		{
			this._metadata = metadata;
			this._cuepoints = cuepoints;
			
			this._maxRetryCount = 3;
		}

		public function getMetaData(url:String):VideoInfoLoader
		{
			this._metaDataTimeout = new TimeOut(this.retryMetaData, 1000);
			
			this._urlMetaData = url;
			
			this._ncMetaData = new NetConnection();
			this._ncMetaData.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
			this._ncMetaData.connect(null);
			
			this._netstreamMetaData = new VideoNetStream(this._ncMetaData);
			this._netstreamMetaData.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
			this._netstreamMetaData.play(url);
			this._netstreamMetaData.addEventListener(VideoMetaDataEvent.METADATA, this.onMetaData);
			
			return this;
		}

		private function handleNetStatusEvent(event:NetStatusEvent):void
		{
			if (event.info.code == NetStatusEventInfoCodes.NETSTREAM_PLAY_STREAM_NOT_FOUND)
			{
				this.dispatchEvent(new VideoMetaDataEvent(VideoMetaDataEvent.NOT_FOUND));
				
				this._metaDataTimeout.stop();
			}
		}

		private function onMetaData(event:VideoMetaDataEvent):void
		{
			event.metadata.parseObject(this._metadata);
			this.dispatchEvent(new VideoMetaDataEvent(VideoMetaDataEvent.METADATA, event.metadata));
			this._ncMetaData.close();
			this._netstreamMetaData.close();
			
			this._metaDataTimeout.stop();
		}

		public function retryMetaData():void
		{
			this._netstreamMetaData.close();
			this._ncMetaData.close();
			
			if (--this._maxRetryCount >= 0)
			{
				this.getMetaData(this._urlMetaData);
			}
			else
			{
				this.dispatchEvent(new VideoMetaDataEvent(VideoMetaDataEvent.NOT_FOUND));
			}
		}

		public function getCuePoints(url:String):VideoInfoLoader
		{
			this._ncCuePoint = new NetConnection();
			this._ncCuePoint.connect(null);
			
			this._netstreamCuePoint = new VideoNetStream(this._ncCuePoint);
			this._netstreamCuePoint.play(url);
			this._netstreamCuePoint.addEventListener(CuePointEvent.CUEPOINT, this.onCuePoints);
			
			return this;
		}

		private function onCuePoints(event:CuePointEvent):void
		{
			event.cuepoint.parseObject(this._cuepoints);
			this.dispatchEvent(new CuePointEvent(CuePointEvent.CUEPOINT, event.cuepoint));
			this._netstreamCuePoint.close();
		}

		override public function destruct():void
		{
			if (this._netstreamMetaData)
			{
				this._netstreamMetaData.destruct();
				this._netstreamMetaData = null;
			}
			
			if (this._netstreamCuePoint)
			{
				this._netstreamCuePoint.destruct();
				this._netstreamCuePoint = null;
			}
			
			if (this._ncMetaData)
			{
				this._ncMetaData.removeEventListener(NetStatusEvent.NET_STATUS, this.handleNetStatusEvent);
				this._ncMetaData = null;
			}
			
			if (this._metaDataTimeout)
			{
				this._metaDataTimeout.destruct();
				this._metaDataTimeout = null;
			}
			
			this._ncCuePoint = null;
			this._urlMetaData = null;
			
			super.destruct();
		}
	}
}
