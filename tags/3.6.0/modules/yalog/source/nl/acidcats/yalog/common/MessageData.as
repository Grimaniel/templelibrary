/*
Copyright 2009 Stephan Bezoen, http://stephan.acidcats.nl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package nl.acidcats.yalog.common 
{ 
	public class MessageData 
	{
		/**
		 * the message
		 */
		public var text:String; 
		
		/**
		 * the level of importance
		 */
		public var level:uint; 
		
		/**
		 * the time of dispatch
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

		public function MessageData(text:String = null, level:uint = 0, time:uint = 0, sender:String = null, senderId:uint = 0, stackTrace:String = null, frame:uint = 0, connectionId:int = 0) 
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