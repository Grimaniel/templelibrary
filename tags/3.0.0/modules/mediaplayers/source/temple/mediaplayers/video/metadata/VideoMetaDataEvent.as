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
	import flash.events.Event;

	/**
	 * @author Arjan van Wijk
	 */
	public class VideoMetaDataEvent extends Event 
	{
		public static const METADATA:String = "VideoMetaDataEvent.metadata";
		public static const NOT_FOUND:String = "VideoMetaDataEvent.notFound";

		private var _metadata:VideoMetaData;

		public function VideoMetaDataEvent(type:String, metadata:VideoMetaData = null, bubbles:Boolean = false):void
		{
			super(type, bubbles);
			
			this._metadata = metadata;
		}
		
		public function get metadata():VideoMetaData
		{
			return this._metadata;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event 
		{
			return new VideoMetaDataEvent(this.type, this.metadata, this.bubbles);
		}
	}
}
