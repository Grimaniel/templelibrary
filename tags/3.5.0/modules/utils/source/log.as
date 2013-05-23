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

package 
{
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.templelibrary;
	import temple.utils.types.ObjectUtils;
	
	/**
	 * Quick way to send a message to the <code>Log</code> class.
	 * 
	 * @param message the message which is sent to the Log.
	 * @param object an object wich is added to the message. The object will be added with all his properties, using the
	 * 	<code>dump()</code> method.
	 * @param depth indicates the depth of recursion of the properties of the object. If set to 0 only the properties of
	 * 	the object will be added, if set to 1 also the properties of each property will be added etcetera.
	 * @param duplicates a Boolean which indicates if duplicate objects in the properties of the object should be added
	 * every time the object occurs (<code>true</code>) or only should be added once and ignored for the other occasions.
	 * @param level the level of the log message. Possible values are "error", "warn", "debug", "info", "fatal" and
	 * 	"status".
	 * 
	 *  @example
	 * <listing version="3.0">
	 * 
	 *  log("myObject", myObject);
	 * 
	 * </listing>
	 * 
	 * @see dump
	 * @see temple.core.debug.log.Log
	 * @see temple.core.debug.log.LogLevel
	 * 
	 * @author Thijs Broerse
	 */
	public function log(message:*, object:* = "__UNLOGGABLE_STRING__", depth:uint = 0, duplicates:Boolean = false, level:String = "info"):void 
	{
		if (object == "__UNLOGGABLE_STRING__")
		{
			// do nothing
		}
		else if (object == null || object == undefined)
		{
			message += ": " + object;
		}
		else if (object is String || object is Number || object is Boolean || object is uint || object is int || object is Function)
		{
			message += ": " + ObjectUtils.convertToString(object);
		}
		else
		{
			message += ": " + dump(object, depth, duplicates);
		}
		
		switch (level)
		{
			case LogLevel.DEBUG:
			case LogLevel.ERROR:
			case LogLevel.FATAL:
			case LogLevel.INFO:
			case LogLevel.STATUS:
			case LogLevel.WARN:
			{
				Log.templelibrary::send(message, "log", level);
				break;
			}
			default:
			{
				Log.templelibrary::send(message, "log", LogLevel.INFO);
				Log.error("Invalid value for level: '" + level + "'", "log");
			}
		}
		
		
	}
}