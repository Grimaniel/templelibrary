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

package temple.common.events
{
	import flash.events.Event;

	/**
	 * Event for Sounds.
	 * 
	 * @author Thijs Broerse
	 */
	public class SoundEvent extends Event 
	{
		public static const VOLUME_CHANGE:String = "SoundEvent.volumeChange";
		public static const SOUND_COMPLETE:String = "SoundEvent.soundComplete";
		public static const GLOBAL_VOLUME_CHANGE:String = "SoundEvent.globalVolumeChange";
		
		private var _name:String;

		public function SoundEvent(type:String, name:String = null) 
		{
			super(type);
			
			this._name = name;
		}
		
		/**
		 * The name of the Sound
		 */
		public function get name():String
		{
			return this._name;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event 
		{
			return new SoundEvent(this.type, this._name);
		}
	}
}
