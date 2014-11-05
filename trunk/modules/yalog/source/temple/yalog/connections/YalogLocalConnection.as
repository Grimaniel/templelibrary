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

package temple.yalog.connections
{
	import temple.core.debug.IDebuggable;
	import temple.core.errors.TempleError;
	import temple.core.events.CoreEventDispatcher;
	import temple.yalog.common.Functions;
	import temple.yalog.common.MessageData;

	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;

	/**
	 * @author Thijs Broerse
	 */
	public class YalogLocalConnection extends CoreEventDispatcher implements IYalogConnection, IDebuggable
	{
		private static const _MAX_PACKAGE_BYTES:uint = 40000;
		
		private var _sender:LocalConnection;
		private var _receiver:PongConnection;

		private var _id:Number;
		private var _name:String;
		private var _connected:Boolean;
		private var _sendAsByteArray:Boolean = true;
		private var _debug:Boolean;
		
		public function YalogLocalConnection(debug:Boolean = false)
		{
			_id = new Date().time;
			_debug = debug;
			
			// create send connection
			_sender = new LocalConnection();
			_sender.client = _sender;
			_sender.addEventListener(StatusEvent.STATUS, handleSenderStatus, false, 0, true);
			
			// send a "ping" on the main channel to check for availability of any viewer application		
			ping();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get id():Number
		{
			return _id;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		public function get connected():Boolean
		{
			return _connected;
		}
		
		/**
		 *	Send out message on the local connection
		 */
		public function send(data:MessageData):void 
		{
			if (debug) trace("send: " + data);
			
			if (!_connected) throw new TempleError(this, "Not connected");
			
			data.connectionId = _id;
			data.connectionName = _name;
			data.channelId = _receiver.channelId;
			
			if (!_sendAsByteArray)
			{
				_sender.send(Functions.CHANNEL, Functions.FUNC_WRITELOG, data);
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
						_sender.send(Functions.CHANNEL, Functions.FUNC_WRITELOG, dataPackages[i]);
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
		 * If set to true the data will be send as ByteArray (recommanded).
		 */
		public function get sendAsByteArray():Boolean
		{
			return _sendAsByteArray;
		}
		
		/**
		 * @private
		 */
		public function set sendAsByteArray(value:Boolean):void
		{
			_sendAsByteArray = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		/**
		 *	Send a "ping" on the main channel if a free receive channel is available
		 */
		private function ping():void 
		{
			if (_debug) trace("ping: ");
			if (createReceiver()) 
			{
				try 
				{
					_sender.send(Functions.CHANNEL, Functions.FUNC_PING, _receiver.receiverChannel + ";" + _id);
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
			_receiver = new PongConnection();
			_receiver.addEventListener(StatusEvent.STATUS, handleReceiverStatus, false, 0, true);
			_receiver.addEventListener(PongConnection.EVENT_PONG_RECEIVED, handlePong, false, 0, true);
			
			return _receiver.start();
		}
		
		/**
		 *	Handle event from receiver connection that a pong was received
		 */
		private function handlePong(event:Event):void 
		{
			// flag we're connected to viewer
			_connected = true;
			
			if (_debug) trace("Connected");
			
			dispatchEvent(new Event(Event.CONNECT));
			
			// dump any buffered messages to the viewer
			// TODO: dumpData();
		}
		
		private function handleReceiverStatus(event:StatusEvent):void 
		{
			if (_debug) trace("handleReceiverStatus: " + event);
		}

		private function handleSenderStatus(event:StatusEvent):void 
		{
			if (_debug) trace("handleSenderStatus: " + event);
		}
	}
}


import temple.yalog.common.Functions;

import flash.events.Event;
import flash.net.LocalConnection;
/**-------------------------------------------------------
 * Private class for handling "pong" call on local connection from viewer application
 */
dynamic final class PongConnection extends LocalConnection 
{
	public static var EVENT_PONG_RECEIVED:String = "onPongReceived";

	private var _channelId:int;
	private var _receiverChannel:String;

	/**
	 * Constructor
	 */
	public function PongConnection() 
	{
		// allow connection from anywhere
		allowDomain("*");
		allowInsecureDomain("*");
		client = this;
	}

	/**
	 * Start the connection by finding a free channel and connecting on in
	 * @return true if a free channel was found and connecting was successful, otherwise false
	 */
	public function start():Boolean 
	{
		var receiverConnected:Boolean = false;
		_channelId = 0;

		// loop available channels, try to connect
		do 
		{
			_channelId++;
			_receiverChannel = Functions.CHANNEL_PING + _channelId;
			
			try 
			{
				receiverConnected = true;
				connect(_receiverChannel);
			}
			catch (e:ArgumentError) 
			{
				receiverConnected = false;
			}
		}
		while (!receiverConnected && (_channelId < Functions.MAX_CHANNEL_COUNT));
		
		if (receiverConnected) 
		{
			this[Functions.FUNC_PONG] = onPong;
		}
		return receiverConnected;
	}

	/**
	 * @return the full name of the receiver channel
	 */
	public function get receiverChannel():String 
	{
		return _receiverChannel;
	}
	
	public function get channelId():int
	{
		return _channelId;
	}

	/**
	 * Handle call from a viewer application via local connection 
	 */
	private function onPong():void 
	{
		close();
		dispatchEvent(new Event(EVENT_PONG_RECEIVED));
	}
}