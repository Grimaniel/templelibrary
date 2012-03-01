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

	/**
	 * @author Thijs Broerse
	 */
	public final class CuePointType 
	{
		/**
		 * This type of cue point is seekable within the user interface skin of the FLVPlayback component.
		 * Whenever the user clicks the next or previous button in the control bar, the corresponding 
		 * navigation cue point is played. You would use this type of cue point for the start times of each
		 * new scene in a video clip. (Note that you can't jump forward in a Flash Video clip unless that
		 * portion of the FLV file has already downloaded, as is the case with progressively loaded FLV files.
		 * If you are streaming Flash Video content with a Flash Communication Server or Flash Media Server,
		 * you can seek forward without waiting for all segments between the current playhead time and the
		 * seeked-to point to download.) 
		 */
		public static const NAVIGATION:String = "navigation";

		/**
		 * This type of cue point is revealed only to ActionScript handlers you build in your own code.
		 * (Note that you can detect both types, navigation and event, in ActionScript handlers.) An event
		 * cue point, however, is one that you specifically don't want to be revealed to the navigation
		 * controls for your video content. For example, if you want a scene title to be removed before the
		 * next scene title appears, you can use an event cue point to mark the time when the text should be
		 * cleared. The addition and removal of captions for speech could also be handled by event cue points,
		 * as speech captions are not necessarily chapter or scene points within the video clip.
		 */
		public static const EVENT:String = "event";
	}
}
