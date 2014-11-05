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

package temple.yalog.common 
{ 
	import temple.data.encoding.json.json;
	
	/**
	 * @author Stephan Bezoen, Thijs Broerse
	 */
	public class MessageData 
	{
		/**
		 * Converts the data to a <code>MessageData</code>
		 */
		public static function convert(data:*):MessageData
		{
			if (data is MessageData)
			{
				 return MessageData(data);
			}
			else if (data is String)
			{
				try
				{
					return convert(json.parse(data));
				}
				catch (error:Error)
				{
					return new MessageData(data);
				}
			}
			else if ("text" in data)
			{
				return new MessageData(data.text, data.level, data.time, data.sender, data.senderId, data.stackTrace, data.frame, data.connectionId, data.connectionName);
			}
			
			return new MessageData("unknown object received: " + dump(data, 3, false), Levels.ERROR);
		}
		
		/**
		 * the message
		 */
		public var text:String; 
		
		/**
		 * the level of importance
		 */
		public var level:uint; 
		
		/**
		 * the time of dispatch in milliseconds
		 */
		public var time:uint; 
		
		/**
		 * name of sender
		 */
		public var sender:String; 
		
		/**
		 * RegistryID of the sender
		 */
		public var senderId:uint;
		
		/**
		 * The stackTrace of the message
		 */
		public var stackTrace:String;

		/**
		 * id of the connection 
		 */
		public var connectionId:uint;

		/**
		 * Name of the connection 
		 */
		public var connectionName:String;
		
		/**
		 * id of the channel
		 */
		public var channelId:uint;
		
		/**
		 * The current frame
		 */
		public var frame:uint;

		public function MessageData(text:String = null, level:uint = 0, time:uint = 0, sender:String = null, senderId:uint = 0, stackTrace:String = null, frame:uint = 0, connectionId:int = 0, connectionName:String = null) 
		{
			switch (text)
			{
				case null:
					text = "(null)";
					break;
				case "":
					text = "(empty String)";
					break;
			}
			
			this.text = text;
			this.level = level;
			this.time = time;
			this.sender = sender;
			this.senderId = senderId;
			this.stackTrace = stackTrace;
			this.frame = frame;
			this.connectionId = connectionId;
			this.connectionName = connectionName;
		}

		public function toString():String 
		{
			var s:String = "";
			if (!isNaN(time)) s += time + "\t";
			s += Levels.getName(level) + ": " + text;
			if (sender != null) s += " -- " + sender;
			
			return s;
		}
	}
}