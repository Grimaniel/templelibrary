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

package temple.mediaplayers.audio 
{
	import temple.core.events.CoreEventDispatcher;

	import flash.events.Event;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.net.URLRequest;

	[Event(name="AudioMetaDataEvent.metadata", type="temple.mediaplayers.audio.AudioMetaDataEvent")]
	[Event(name="AudioMetaDataEvent.notFound", type="temple.mediaplayers.audio.AudioMetaDataEvent")]

	/**
	 * @author Arjan van Wijk
	 */
	public class AudioInfoLoader extends CoreEventDispatcher 
	{
		private var _sound:Sound;
		private var _metadata:Object;

		public function AudioInfoLoader(metadata:Object = null)
		{
			this._metadata = metadata;
		}

		public function getMetaData(url:String):void
		{
			this._sound = new Sound();
			this._sound.addEventListener(Event.ID3, this.handleID3Loaded);
			this._sound.addEventListener(Event.COMPLETE, this.handleComplete);
			this._sound.load(new URLRequest(url));
		}
		
		private function handleID3Loaded(event:Event):void
		{
		}
		
		private function handleComplete(event:Event):void
		{
			var id3:ID3Info = this._sound.id3;
			
			if (id3['TLEN'] == undefined) id3['TLEN'] = this._sound.length;
			
			var audioMetaData:AudioMetaData = new AudioMetaData(id3);
			audioMetaData.parseObject(this._metadata);
			this.dispatchEvent(new AudioMetaDataEvent(AudioMetaDataEvent.METADATA, audioMetaData));
		}
		
		override public function destruct():void
		{
			if (this._sound)
			{
				this._sound.removeEventListener(Event.ID3, this.handleID3Loaded);
				this._sound = null;
			}
			
			super.destruct();
		}
	}
}
