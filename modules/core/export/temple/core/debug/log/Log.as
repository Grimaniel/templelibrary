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

package temple.core.debug.log 
{
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.templelibrary;


	/**
	 * Dispatched when a new Log message is received
	 * @eventType temple.debug.log.LogEvent.EVENT
	 */
	[Event(name="LogEvent.Event", type="temple.core.debug.log.LogEvent")]
	
	/**
	 * This class implements a simple logging functionality that dispatches an event whenever a log message is received.
	 * The object sent with the event is of type LogEvent. The LogEvent class contains public properties for the text of
	 * the message, 
	 * a String denoting the sender of the message, and the level of importance of the message.
	 * By default, log messages are also output as traces to the Flash IDE output window. This behavior can be changed.
	 * @example
	 * <listing version="3.0">
	 * Log.addEventListener(handleLogEvent);	// handle events locally
	 * Log.showTrace(false);	// don't output log messages as traces
	 * 
	 * Log.debug("This is a debug message", this);
	 * Log.error("This is an error message", this);
	 * Log.info("This is an info message", this);
	 * 
	 * private function handleLogEvent (event:LogEvent)
	 * {
	 * 	// handle the event by showing the message as a trace
	 * 	trace(event.text);
	 * }
	 * 
	 * public function toString () : String {
	 * return getQualifiedClassName(this);
	 * }
	 * </listing>
	 * This will show the following output in the Flash IDE output window:
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	This is a debug message
	 * 	This is an error message
	 * 	This is an info message
	 * </listing>
	 * 
	 * The standard trace output of the Log class looks as follows:
	 * 
	 * @example
	 * <listing version="3.0">
	 *	13	debug: This is a debug message -- TestClass
	 *	13	error: This is an error message -- TestClass
	 *	13	info: This is an info message -- TestClass
	 * </listing>
	 * 
	 * The number "13" is the time at which the log message was generated. This time is not kept in the LogEvent class.
	 * 
	 * @includeExample LogExample.as
	 * 
	 * @includeExample ../../display/CoreDisplayObjectsExample.as
	 * 
	 * @author Stephan Bezoen, Thijs Broerse
	 */
	public final class Log extends EventDispatcher 
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.2.0";
		
		private static var _instance:Log;
		private static var _showTrace:Boolean = true;
		private static var _stackTrace:Boolean = false;
		
		/**
		 * Log a message with debug level.
		 * @param text the message
		 * @param sender a reference denoting the source of the message;  <code>toString()</code> is called on this
		 *  object internally.
		 *			
		 * @example
		 * <listing version="3.0">
		 * Log.debug("This is a debug message", this);
		 * </listing>
		 *	
		 * @see temple.core.debug.log.LogLevel#DEBUG
		 */
		public static function debug(data:*, sender:*):void 
		{
			Log.templelibrary::send(data, sender, LogLevel.DEBUG);
		}

		/**
		 * Log a message with info level.
		 * @param text the message
		 * @param sender a reference denoting the source of the message; <code>toString()</code> is called on this
		 *  object internally.
		 * 
		 * @example
		 * <listing version="3.0">
		 * Log.info("This is an info message", this);
		 * </listing>
		 * 
		 * @see temple.core.debug.log.LogLevel#INFO
		 */
		public static function info(data:*, sender:*):void 
		{
			Log.templelibrary::send(data, sender, LogLevel.INFO);
		}

		/**
		 * Log a message with error level.
		 * @param text the message
		 * @param sender a reference denoting the source of the message; <code>toString()</code> is called on this
		 *  object internally.
		 *  
		 * @example
		 * <listing version="3.0">
		 *	Log.error("This is an error message", this);
		 *	</listing>
		 *	
		 *	@see temple.core.debug.log.LogLevel#ERROR
		 */
		public static function error(data:*, sender:*):void 
		{
			Log.templelibrary::send(data, sender, LogLevel.ERROR);
		}

		/**
		 * Log a message with warning level
		 * @param text the message
		 * @param sender a reference denoting the source of the message; <code>toString()</code> is called on this
		 *  object internally.
		 *
		 * @example
		 * <listing version="3.0">
		 * Log.warn("This is a warning message", this);
		 * </listing>
		 *	
		 *	@see temple.core.debug.log.LogLevel#WARN
		 */
		public static function warn(data:*, sender:*):void 
		{
			Log.templelibrary::send(data, sender, LogLevel.WARN);
		}

		/**
		 * Log a message with fatal level
		 * @param text the message
		 * @param sender a reference denoting the source of the message; <code>toString()</code> is called on this
		 *  object internally.
		 * 
		 * @example
		 * <listing version="3.0">
		 * Log.fatal("This is a fatal message", this);
		 * </listing>
		 *	
		 *	@see temple.core.debug.log.LogLevel#FATAL
		 */
		public static function fatal(data:*, sender:*):void 
		{
			Log.templelibrary::send(data, sender, LogLevel.FATAL);
		}

		/**
		 * Log a message with status level
		 * @param text the message
		 * @param sender a reference denoting the source of the message; <code>toString()</code> is called on this
		 *  object internally.
		 *
		 * @example
		 * <listing version="3.0">
		 * Log.status("This is a status message", this);
		 * </listing>
		 *	
		 *	@see temple.core.debug.log.LogLevel#STATUS
		 */
		public static function status(data:*, sender:*):void 
		{
			Log.templelibrary::send(data, sender, LogLevel.STATUS);
		}

		/**
		 * Dispatch a <code>LogEvent</code> with the input parameters; trace if flag is set to do so
		 * @param text the message
		 * @param sender a reference denoting the source of the message
		 * @param level the level of the message
		 * @param objectId the Registry objectId that is stored in Core Objects;
		 * @param stackLine the line of the stackTrace that must be used as stack. Only works if stackTrace is enabled.
		 * 
		 * @see temple.core.debug.log.LogEvent
		 */
		templelibrary static function send(data:*, sender:String, level:String, objectId:uint = 0, stackLine:uint = 3):void 
		{
			var stack:String;
			
			if (Log._stackTrace)
			{
				stack = new Error().getStackTrace();
				
				if (stack)
				{
					var lines:Array = stack.split("\n");
					stack = String(lines[stackLine]).substr(4);
					var i:int = stack.indexOf('::');
					if (i != -1) stack = stack.substr(i+2);
					stack = stack.replace("/", ".");
					i = stack.lastIndexOf(':');
					if (i != -1)
					{
						stack = stack.substr(0, stack.indexOf('()') + 2) + stack.substring(i, stack.length - 1);
					}
				}
			}
			
			if (Log._showTrace) 
			{
				trace(Log.formatTime(getTimer()) + " \t" + level + ": \t" + String(data) + " \t-- " + (sender ? sender.toString() : 'null') + (objectId == 0 ? '' : " #" + objectId + "#") + (stack ? " " + stack : ""));
			}
			Log.getInstance().dispatchEvent(new LogEvent(level, data, sender ? sender.toString() : 'null', objectId, stack));
		}

		private static function formatTime(milliseconds:int):String
		{
			return Log.padLeft(Math.floor(milliseconds / 60000).toString(), 2) + ":" + Log.padLeft((Math.floor(milliseconds * .001) % 60).toString(), 2) + '.' + Log.padLeft((Math.round(Math.floor(milliseconds % 1000))).toString(), 3);
		}
		
		private static function padLeft(string:String, length:int):String
		{
			if (string.length < length)
			{
				var iLim:int = length - string.length;
				for (var i:int = 0; i < iLim;i++)
				{
					string = "0" + string;
				}
			}
			return string;
		}
		
		/**
		 *	Add a function as listener to LogEvent events
		 *	@param handler the function to handle LogEvents
		 *	@example
		 *	<listing version="3.0">
		 *	Log.addLogListener(handleLog);
		 *	
		 *	private function handleLog (event:LogEvent)
		 *	{
		 *		// log message available in event.data
		 *	}
		 *	</listing>
		 *	
		 *	@see temple.core.debug.log.LogEvent
		 */
		public static function addLogListener(handler:Function):void 
		{
			Log.getInstance().addListener(handler);
		}

		/**
		 *	Remove a function as listener to LogEvent events
		 *	@param handler the function that handles LogEvents
		 */
		public static function removeLogListener(handler:Function):void 
		{
			Log.getInstance().removeListener(handler);
		}

		/**
		 *	Set whether log messages should be output as a trace
		 *	@param show if true, log messages are output as a trace
		 *	Set this to false if a log listener also outputs as a trace.
		 *	@example
		 *	<listing version="3.0">
		 *	Log.showTrace = false;
		 *	</listing>
		 */
		public static function get showTrace():Boolean 
		{
			return Log._showTrace;
		}
		
		/**
		 * @private
		 */
		public static function set showTrace(value:Boolean):void 
		{
			Log._showTrace = value;
		}

		public static function get stackTrace():Boolean 
		{
			return Log._stackTrace;
		}
		
		/**
		 * @private
		 */
		public static function set stackTrace(value:Boolean):void 
		{
			Log._stackTrace = value;
		}

		/**
		 * @return singleton instance of Logger
		 */
		private static function getInstance():Log 
		{
			return Log._instance ||= new Log();
		}
		
		/**
		 * @private
		 */
		public function Log()
		{
			if (Log._instance) throwError(new TempleError(this, "Singleton, please use static methods"));
		}

		/**
		 *	Add a function to the event listeners
		 */
		private function addListener(handler:Function):void 
		{
			this.addEventListener(LogEvent.EVENT, handler);
		}

		/**
		 *	Remove a function from the event listeners
		 */
		private function removeListener(handler:Function):void 
		{
			this.removeEventListener(LogEvent.EVENT, handler);
		}

		/**
		 * @inheritDoc
		 */
		public static function destruct():void
		{
			Log._instance = null;
		}
	}
}
