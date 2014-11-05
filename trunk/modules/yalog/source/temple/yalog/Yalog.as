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

package temple.yalog 
{
	import temple.core.templelibrary;
	import temple.core.CoreObject;
	import temple.yalog.common.Levels;
	import temple.yalog.common.MessageData;
	import temple.yalog.connections.IYalogConnection;

	import flash.events.Event;
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
	 * @author Stephan Bezoen, Thijs Broerse
	 */
	public final class Yalog extends CoreObject
	{
		private var _buffer:Vector.<MessageData>;
		private var _connection:IYalogConnection;
		private var _showTrace:Boolean = true;
		private var _debug:Boolean;
		private var _bufferSize:uint;
		
		/**
		 * 
		 */
		public function Yalog(connection:IYalogConnection = null, bufferSize:uint = 250, debug:Boolean = false) 
		{
			this.connection = connection;
			
			// create buffer for buffering messages while not connected
			_bufferSize = bufferSize;
			_debug = debug;
			
			toStringProps.push("connection");
		}
		
		/**
		 *	Send a debug message to Yalala
		 *	
		 *	@param text the message
		 *	@param sender a String denoting the sender (p.e. the classname)
		 */
		public function debug(text:String, sender:String = null, objectId:uint = 0, stackTrace:String = null, frame:uint = 0):void 
		{
			send(text, Levels.DEBUG, sender, objectId, stackTrace, frame);
		}

		/**
		 *	Send an informational message to Yalala
		 *	@param text the message
		 *	@param sender a String denoting the sender (p.e. the classname)
		 */
		public function info(text:String, sender:String = null, objectId:uint = 0, stackTrace:String = null, frame:uint = 0):void 
		{
			send(text, Levels.INFO, sender, objectId, stackTrace, frame);
		}

		/**
		 *	Send an error message to Yalala
		 *	@param text the message
		 *	@param sender a String denoting the sender (p.e. the classname)
		 */
		public function error(text:String, sender:String = null, objectId:uint = 0, stackTrace:String = null, frame:uint = 0):void 
		{
			send(text, Levels.ERROR, sender, objectId, stackTrace, frame);
		}

		/**
		 *	Send a warning message to Yalala
		 *	@param text the message
		 *	@param sender a String denoting the sender (p.e. the classname)
		 */
		public function warn(text:String, sender:String = null, objectId:uint = 0, stackTrace:String = null, frame:uint = 0):void 
		{
			send(text, Levels.WARN, sender, objectId, stackTrace, frame);
		}

		/**
		 *	Send a fatal message to Yalala
		 *	@param text the message
		 *	@param sender a String denoting the sender (p.e. the classname)
		 */
		public function fatal(text:String, sender:String = null, objectId:uint = 0, stackTrace:String = null, frame:uint = 0):void 
		{
			send(text, Levels.FATAL, sender, objectId, stackTrace, frame);
		}
		
		/**
		 *	Send a text to Yalala with a certain level of importance
		 *	@param text the message
		 *	@param level the level of importance
		 *	@param sender a String denoting the sender (p.e. the classname)
		 */
		private function send(text:String, level:uint, sender:String, objectId:uint, stackTrace:String, frame:uint):void 
		{
			if (_debug) trace("send: \"" + text + "\", levels: " + level + ", sender: " + sender);
			handleData(new MessageData(text, level, getTimer(), sender, objectId, stackTrace, frame));
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
		public function get showTrace():Boolean 
		{
			return _showTrace;
		}

		/**
		 * @private
		 */
		public function set showTrace(value:Boolean):void 
		{
			_showTrace = value;
		}
		
		/**
		 * The connection Yalog uses to send the messages to the console
		 */
		public function get connection():IYalogConnection
		{
			return _connection;
		}

		/**
		 * @private
		 */
		public function set connection(value:IYalogConnection):void
		{
			if (_connection) _connection.removeEventListener(Event.CONNECT, handleConnect);
			
			_connection = value;
			if (_connection && !_connection.connected) _connection.addEventListener(Event.CONNECT, handleConnect);
		}

		/**
		 * Number of messages to be kept as history when connection is not connected.
		 */
		public function get bufferSize():uint 
		{
			return _bufferSize;
		}
		
		/**
		 * @private
		 */
		public function set bufferSize(size:uint):void 
		{
			_bufferSize = size;
			if (_buffer && _buffer.length > bufferSize) _buffer.length = bufferSize;
		}

		/**
		 * Enables debugging of Yalog. If set to <code>true</code> Yalog will trace debug messages.
		 */
		templelibrary function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @private
		 */
		templelibrary function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		/**
		 *	Process message data
		 */
		private function handleData(data:MessageData):void 
		{
			if (_showTrace) trace(data);
			
			if (_connection && _connection.connected) 
			{
				if (_debug) trace("send: " + data);
				_connection.send(data);
			} 
			else 
			{
				if (_debug)
				{
					if (_connection)
					{
						trace(_connection + " is not connected");
					}
					else
					{
						trace("No connection");
					}
				}
				// Store data
				(_buffer ||= new Vector.<MessageData>()).unshift(data);
				if (_buffer.length > _bufferSize) _buffer.length = _bufferSize;
			}
		}

		/**
		 *	Send out all stored messages
		 */
		private function dump():void 
		{
			if (_debug) trace("dump");
			if (!_buffer || !_buffer.length) return;
			handleData(new MessageData("-- START DUMP --", Levels.STATUS, getTimer(), toString()));
			while (_buffer.length) handleData(_buffer.pop());
			handleData(new MessageData("-- END DUMP --", Levels.STATUS, getTimer(), toString()));
		}
		
		private function handleConnect(event:Event):void
		{
			_connection.removeEventListener(Event.CONNECT, handleConnect);
			dump();
		}
	}
}