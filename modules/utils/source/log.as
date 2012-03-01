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

package 
{
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.templelibrary;
	import temple.utils.types.ObjectUtils;
	
	/**
	 * Creates a log message
	 * 
	 * @author Thijs Broerse
	 */
	public function log(message:*, object:* = "__UNLOGGABLE_STRING__", maxDepth:uint = 0, traceDuplicates:Boolean = false, level:String = "info"):void 
	{
		if (object == "__UNLOGGABLE_STRING__")
		{
			// do nothing
		}
		else if (object == null || object == undefined)
		{
			message += ": " + object;
		}
		else if (object is String || object is Number || object is Boolean || object is uint || object is int)
		{
			message += ": " + ObjectUtils.convertToString(object);
		}
		else
		{
			message += ": " + ObjectUtils.traceObject(object, maxDepth, false, traceDuplicates);
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