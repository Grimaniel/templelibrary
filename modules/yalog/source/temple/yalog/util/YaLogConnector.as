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

package temple.yalog.util 
{
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.yalog.yalogger;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogEvent;
	import temple.core.debug.log.LogLevel;
	import temple.yalog.Yalog;

	/**
	 * Connects to Temple's <code>Log</code> class and sends all Log messages to
	 * <a href="http://yalala.tyz.nl/" target="_blank">Yalala</a>.
	 * 
	 * @includeExample ../../../../temple/yalog/YaLogConnectorExample.as
	 * 
	 * @see temple.core.debug.log.Log
	 * 
	 * @author Stephan Bezoen, Thijs Broerse
	 */
	public final class YaLogConnector 
	{
		private static var _instance:YaLogConnector;

		/**
		 * @return singleton instance of YaLogConnector
		 */
		public static function getInstance():YaLogConnector 
		{
			return YaLogConnector._instance;
		}
		
		/**
		 * Connect to the Log.
		 * @param name optional name that is used to identify the connection. The name is displayed in Yalala.
		 */
		public static function connect(name:String = null, yalog:Yalog = null):YaLogConnector 
		{
			yalog ||= yalogger;
			
			if (name)
			{
				if (yalog.connection)
				{
					yalog.connection.name = name;
				}
				else
				{
					throwError(new TempleError(YaLogConnector, "Yalog " + yalog + " has no connection"));
				}
				
			}
			
			if (_instance)
			{
				if (_instance.yalog == yalog)
				{
					return _instance;
				}
				else
				{
					return new YaLogConnector(yalog);
				}
			}
			else
			{
				return _instance = new YaLogConnector(yalog);
			}
		}
		
		/**
		 * Indicates if Yalog is already connected.
		 */
		public static function get isConnected():Boolean
		{
			return !!YaLogConnector._instance;
		}
		
		private var _yalog:Yalog;

		public function YaLogConnector(yalog:Yalog) 
		{
			_yalog = yalog;
			_yalog.showTrace = false;
			
			Log.addLogListener(handleLogEvent);
		}
		
		public function get yalog():Yalog
		{
			return _yalog;
		}

		private function handleLogEvent(event:LogEvent):void 
		{
			switch (event.level) 
			{
				case LogLevel.DEBUG: 
					_yalog.debug(event.data, event.sender, event.objectId, event.stackTrace, event.frame); 
					break;
				case LogLevel.ERROR: 
					_yalog.error(event.data, event.sender, event.objectId, event.stackTrace, event.frame); 
					break;
				case LogLevel.FATAL: 
					_yalog.fatal(event.data, event.sender, event.objectId, event.stackTrace, event.frame); 
					break;
				case LogLevel.INFO: 
					_yalog.info(event.data, event.sender, event.objectId, event.stackTrace, event.frame); 
					break;
				case LogLevel.STATUS: 
					_yalog.info(event.data, event.sender, event.objectId, event.stackTrace, event.frame); 
					break;
				case LogLevel.WARN: 
					_yalog.warn(event.data, event.sender, event.objectId, event.stackTrace, event.frame); 
					break;
			}
		}
	}
}