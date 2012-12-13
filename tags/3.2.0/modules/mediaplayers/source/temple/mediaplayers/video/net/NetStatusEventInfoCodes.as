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
		public static const NETSTREAM_SEEK_COMPLETE:String = "NetStream.Seek.Complete";

		public static const NETSTREAM_PAUSE_NOTIFY:String = "NetStream.Pause.Notify";
		public static const NETSTREAM_UNPAUSE_NOTIFY:String = "NetStream.Unpause.Notify";
		
		public static const NETCONNECTION_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
		public static const NETCONNECTION_CONNECT_CLOSED:String = "NetConnection.Connect.Closed";
		public static const NETCONNECTION_CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";
		public static const NETCONNECTION_CONNECT_FAILED:String = "NetConnection.Connect.Failed";
		
	}
}