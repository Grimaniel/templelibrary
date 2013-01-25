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

package nl.acidcats.yalog 
{
	import nl.acidcats.yalog.common.Functions;
	import nl.acidcats.yalog.common.Levels;
	import nl.acidcats.yalog.common.MessageData;

	import temple.core.debug.objectToString;
	import temple.core.errors.throwError;

	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * Yalog is a logging tool that comprises a set of classes for inclusion in an Actionscript application, and a
	 * viewing application for viewing the generated log messages.
	 * 
	 * View your debug messages at: http://yalala.tyz.nl/
	 * 
	 * @includeExample ../../../temple/yalog/YalogExample.as
	 * 
	 * @see http://yalala.tyz.nl/
	 * @see http://code.google.com/p/yalog/
	 * @see http://stephan.acidcats.nl/blog/2009/02/04/yalog-actionscript-3-log-utility-with-viewer-open-source/
	 * 
	 * @author Stephan Bezoen (modified by Thijs Broerse)
	 */
	public final class Yalog 
	{
		private static const _BUFFER_SIZE:uint = 250;
		private static const _MAX_PACKAGE_BYTES:uint = 40000;

		private static var _instance:Yalog;
		private static var _bufferSize:uint = Yalog._BUFFER_SIZE;
		private static var _showTrace:Boolean = true;
		private static var _sendAsByteArray:Boolean = true;
		
		// Identifiers for this connection
		private static const _connectionId:Number = new Date().time;
		private static var _connectionName:String;
		
		/**
		 *	Set the number of messages to be kept as history.
		 *	Note: this will clear the current buffer, so make sure this is the first thing you do!
		 */
		public static function setBufferSize(size:Number):void 
		{
			Yalog.getInstance().setBufSize(size);
		}

		/**
		 *	Send a debug message to Yala
		 *	@param text: the message
		 *	@param sender: a String denoting the sender (p.e. the classname)
		 */
		public static function debug(text:String, sender:String, objectId:uint = 0, stackTrace:String = null):void 
		{
			Yalog.sendToConsole(text, Levels.DEBUG, sender, objectId, stackTrace);
		}

		/**
		 *	Send an informational message to Yala
		 *	@param text: the message
		 *	@param sender: a String denoting the sender (p.e. the classname)
		 */
		public static function info(text:String, sender:String, objectId:uint = 0, stackTrace:String = null):void 
		{
			Yalog.sendToConsole(text, Levels.INFO, sender, objectId, stackTrace);
		}

		/**
		 *	Send an error message to Yala
		 *	@param text: the message
		 *	@param sender: a String denoting the sender (p.e. the classname)
		 */
		public static function error(text:String, sender:String, objectId:uint = 0, stackTrace:String = null):void 
		{
			Yalog.sendToConsole(text, Levels.ERROR, sender, objectId, stackTrace);
		}

		/**
		 *	Send a warning message to Yala
		 *	@param text: the message
		 *	@param sender: a String denoting the sender (p.e. the classname)
		 */
		public static function warn(text:String, sender:String, objectId:uint = 0, stackTrace:String = null):void 
		{
			Yalog.sendToConsole(text, Levels.WARN, sender, objectId, stackTrace);
		}

		/**
		 *	Send a fatal message to Yala
		 *	@param text: the message
		 *	@param sender: a String denoting the sender (p.e. the classname)
		 */
		public static function fatal(text:String, sender:String, objectId:uint = 0, stackTrace:String = null):void 
		{
			Yalog.sendToConsole(text, Levels.FATAL, sender, objectId, stackTrace);
		}

		/**
		 *	Send a text to Yala with a certain level of importance
		 *	@param text: the message
		 *	@param level: the level of importance
		 *	@param sender: a String denoting the sender (p.e. the classname)
		 */
		private static function sendToConsole(text:String, level:uint, sender:String, objectId:uint, stackTrace:String):void 
		{
			var md:MessageData = new MessageData(text, level, getTimer(), sender, objectId, stackTrace);
			
			if (Yalog._showTrace) trace(md.toString());

			Yalog.getInstance().handleData(md);
		}

		/**
		 *	Set whether log messages should be output as a trace
		 *	@param show if true, log messages are output as a trace
		 *	Set this to false if a log listener also outputs as a trace.
		 *	@use
		 *	<code>
		 *	Yalog.showTrace = false;
		 *	</code>
		 */
		public static function get showTrace():Boolean 
		{
			return Yalog._showTrace;
		}

		/**
		 * @private
		 */
		public static function set showTrace(value:Boolean):void 
		{
			Yalog._showTrace = value;
		}
		
		/**
		 * If set to true the data will be send as ByteArray (recommanded).
		 */
		public static function get sendAsByteArray():Boolean
		{
			return Yalog._sendAsByteArray;
		}
		
		/**
		 * @private
		 */
		public static function set sendAsByteArray(value:Boolean):void
		{
			Yalog._sendAsByteArray = value;
		}
		
		/**
		 * The id for the connection. Used to easely identify the connection.
		 */
		public static function get connectionId():Number
		{
			return Yalog._connectionId;
		}

		/**
		 * The name for the connection. Used to easely identify the connection.
		 */
		public static function get connectionName():String
		{
			return Yalog._connectionName;
		}
		
		/**
		 * @private
		 */
		public static function set connectionName(value:String):void
		{
			Yalog._connectionName = value;
		}

		private static function getInstance():Yalog
		{
			return Yalog._instance ||= new Yalog();
		}

		private var _sender:LocalConnection;
		private var _senderConnected:Boolean;

		private var _receiver:PongConnection;

		private var _buffer:Vector.<MessageData>;
		private var _writePointer:uint;
		private var _fullCircle:Boolean;
		
		/*
		 * Constructor; private not allowed in AS3
		 */
		public function Yalog() 
		{
			if (_instance) throwError(new Error(this, "Singleton, use Yalog.getInstance()"));
			
			// create send connection
			this._sender = new LocalConnection();
			this._sender.client = this._sender;
			this._sender.addEventListener(StatusEvent.STATUS, this.handleSenderStatus, false, 0, true);

			// create buffer for buffering messages while not connected
			this._buffer = new Vector.<MessageData>(_bufferSize);

			// send a "ping" on the main channel to check for availability of any viewer application		
			this.ping();
		}

		/**
		 *	Send a "ping" on the main channel if a free receive channel is available
		 */
		private function ping():void 
		{
			if (this.createReceiver()) 
			{
				try 
				{
					this._sender.send(Functions.CHANNEL, Functions.FUNC_PING, this._receiver.receiverChannel + ";" + Yalog._connectionId);
				}
				catch (error:ArgumentError) 
				{
					trace(error);
				}
			}
		}

		/**
		 *	Create receiver local connection to handle pong from viewer application
		 */
		private function createReceiver():Boolean 
		{
			this._receiver = new PongConnection();
			this._receiver.addEventListener(StatusEvent.STATUS, this.handleReceiverStatus, false, 0, true);
			this._receiver.addEventListener(PongConnection.EVENT_PONG_RECEIVED, this.handlePong, false, 0, true);
			
			return this._receiver.start();
		}

		/**
		 *	Handle event from receiver connection that a pong was received
		 */
		private function handlePong(event:Event):void 
		{
			// flag we're connected to viewer
			this._senderConnected = true;
			
			// dump any buffered messages to the viewer
			this.dumpData();
		}

		
		
		/**
		 *	Process message data
		 */
		private function handleData(data:MessageData):void 
		{
			if (!this._senderConnected) 
			{
				this.storeData(data);
			} 
			else 
			{
				this.sendData(data);
			}
		}

		/**
		 *	Send out message on the local connection
		 */
		private function sendData(data:MessageData):void 
		{
			data.channelID = this._receiver.channelID;
			data.connectionId = Yalog.connectionId;
			data.connectionName = Yalog.connectionName;
			
			if (!Yalog._sendAsByteArray)
			{
				this._sender.send(Functions.CHANNEL, Functions.FUNC_WRITELOG, data);
			}
			else
			{
				/**
				 * Following code is copied from the MonserDebugger
				 * 
				 * author: Ferdi Koomen, Joost Harts
 				 * company: De Monsters
 				 * link: http://www.deMonsterDebugger.com
				 */
				
				// Compress the data
				var item:ByteArray = new ByteArray();
				item.writeObject(data);
				item.compress();
				
				// Array to hold the data packages
				var dataPackages:Array = new Array();
				
				// Counter for the loops
				var i:int = 0;
				
				// Check if the data should be splitted
				// The max size for localconnection = 40kb = 40960b
				// We use 960b for the package definition
				if (item.length > _MAX_PACKAGE_BYTES)
				{
					// Save the length
					var bytesAvailable:int = item.length;
					var offset:int = 0;
					
					// Calculate the total package count
					var total:int = Math.ceil(item.length / _MAX_PACKAGE_BYTES);
					
					// Loop through the bytes / chunks
					for (i = 0; i < total; i++)
					{
						// Set the length to read
						var length:int = bytesAvailable;
						if (length > _MAX_PACKAGE_BYTES)
						{
							length = _MAX_PACKAGE_BYTES;
						}
						
						// Read a chunk of data
						var tmp:ByteArray = new ByteArray();
						tmp.writeBytes(item, offset, length);
						
						// Create a data package
						dataPackages.push({total:total, nr:(i + 1), bytes:tmp});
						
						// Update the bytes available and offset
						bytesAvailable -= length;
						offset += length;
					}		
				} 
				else
				{
					// The data size is under 40kb, so just send one package
					dataPackages.push({total:1, nr:1, bytes:item});
				}
				
				// send the data packages through the line out
				for (i = 0; i < dataPackages.length; i++)
				{
					try
					{
						this._sender.send(Functions.CHANNEL, Functions.FUNC_WRITELOG, dataPackages[i]);
					}
					catch(error:Error)
					{
						trace(error.message);
						break;
					}
				}
			}
		}
		
		/**
		 *	Store message
		 */
		private function storeData(data:MessageData):void 
		{
			this._buffer[this._writePointer++] = data;
			
			if (this._writePointer >= _BUFFER_SIZE) 
			{
				this._fullCircle = true;
				this._writePointer = 0;
			}
		}

		/**
		 *	Send out all stored messages
		 */
		private function dumpData():void 
		{
			if (!_fullCircle && (_writePointer == 0)) return;
			
			this.sendData(new MessageData("-- START DUMP --", Levels.STATUS, getTimer(), toString()));
			
			if (_fullCircle) 
			{
				this.dumpRange(_writePointer, _BUFFER_SIZE - 1);
			}
			this.dumpRange(0, _writePointer - 1);

			this.sendData(new MessageData("-- END DUMP --", Levels.STATUS, getTimer(), toString()));
			
			this._writePointer = 0;
			this._fullCircle = false;
		}

		/**
		 *	Send out messages in a consecutive range
		 */
		private function dumpRange(start:Number, end:Number):void 
		{
			for (var i:Number = start;i <= end;i++) 
			{
				this.sendData(MessageData(_buffer[i]));
			}
		}

		/**
		 *	Set the buffer size for storing messages
		 */
		private function setBufSize(size:uint):void 
		{
			Yalog._bufferSize = size;
			
			this._buffer.length = Yalog._bufferSize;
			this._writePointer = 0;
			this._fullCircle = false;
		}

		private function handleReceiverStatus(event:StatusEvent):void 
		{
		}

		private function handleSenderStatus(event:StatusEvent):void 
		{
		}

		public function toString():String 
		{
			return objectToString(this);
		}
	}
}
import nl.acidcats.yalog.common.Functions;

import flash.events.Event;
import flash.net.LocalConnection;

/**-------------------------------------------------------
 * Private class for handling "pong" call on local connection from viewer application
 */
dynamic final class PongConnection extends LocalConnection 
{
	public static var EVENT_PONG_RECEIVED:String = "onPongReceived";

	private var _channelID:int;
	private var _receiverChannel:String;

	/**
	 * Constructor
	 */
	public function PongConnection() 
	{
		// allow connection from anywhere
		this.allowDomain("*");
		this.allowInsecureDomain("*");
		this.client = this;
	}

	/**
	 * Start the connection by finding a free channel and connecting on in
	 * @return true if a free channel was found and connecting was successful, otherwise false
	 */
	public function start():Boolean 
	{
		var receiverConnected:Boolean = false;
		this._channelID = 0;

		// loop available channels, try to connect
		do 
		{
			this._channelID++;
			this._receiverChannel = Functions.CHANNEL_PING + _channelID;
			
			try 
			{
				receiverConnected = true;
				this.connect(this._receiverChannel);
			}
			catch (e:ArgumentError) 
			{
				receiverConnected = false;
			}
		}
		while (!receiverConnected && (_channelID < Functions.MAX_CHANNEL_COUNT));
		
		if (receiverConnected) 
		{
			this[Functions.FUNC_PONG] = this.onPong;
		}
		return receiverConnected;
	}

	/**
	 * @return the full name of the receiver channel
	 */
	public function get receiverChannel():String 
	{
		return this._receiverChannel;
	}
	
	public function get channelID():int
	{
		return this._channelID;
	}

	/**
	 * Handle call from a viewer application via local connection 
	 */
	private function onPong():void 
	{
		this.close();
		this.dispatchEvent(new Event(EVENT_PONG_RECEIVED));
	}
}
