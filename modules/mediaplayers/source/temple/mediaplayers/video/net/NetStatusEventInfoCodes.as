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

package temple.mediaplayers.video.net 
{

	/**
	 * @author Thijs Broerse
	 */
	public class NetStatusEventInfoCodes 
	{
		public static const NETSTREAM_BUFFER_EMPTY:String = "NetStream.Buffer.Empty";
		public static const NETSTREAM_BUFFER_FULL:String = "NetStream.Buffer.Full";
		public static const NETSTREAM_BUFFER_FLUSH:String = "NetStream.Buffer.Flush";

		public static const NETSTREAM_PLAY_START:String = "NetStream.Play.Start";
		public static const NETSTREAM_PLAY_STOP:String = "NetStream.Play.Stop";
		public static const NETSTREAM_PLAY_STREAM_NOT_FOUND:String = "NetStream.Play.StreamNotFound";
		public static const NETSTREAM_PLAY_RESET:String = "NetStream.Play.Reset";

		public static const NETSTREAM_SEEK_INVALID_TIME:String = "NetStream.Seek.InvalidTime";
		public static const NETSTREAM_SEEK_NOTIFY:String = "NetStream.Seek.Notify";

		public static const NETSTREAM_PAUSE_NOTIFY:String = "NetStream.Pause.Notify";
		public static const NETSTREAM_UNPAUSE_NOTIFY:String = "NetStream.Unpause.Notify";
		
		public static const NETCONNECTION_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
		public static const NETCONNECTION_CONNECT_CLOSED:String = "NetConnection.Connect.Closed";
		public static const NETCONNECTION_CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";
		public static const NETCONNECTION_CONNECT_FAILED:String = "NetConnection.Connect.Failed";
		
	}
}