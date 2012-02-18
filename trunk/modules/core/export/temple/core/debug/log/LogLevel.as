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

package temple.core.debug.log 
{
	import temple.core.templelibrary;

	/**
	 * This class contains all possible levels of log messages.
	 * 
	 * @author Thijs Broerse
	 */
	public final class LogLevel 
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.0";
		
		/**
		 * The information is only useful when debugging the application.
		 */
		public static const DEBUG:String = "debug";
		
		/**
		 * Just some information. Everything is OK. 
		 */
		public static const INFO:String = "info";
		
		/**
		 * Something is not OK, but we can still continue.
		 */
		public static const WARN:String = "warn";
		
		/**
		 * Something went wrong, you should check it.
		 */
		public static const ERROR:String = "error";
		
		/**
		 * Something went terribly wrong, you should quit immediately.
		 */
		public static const FATAL:String = "fatal";
		
		/**
		 * Internal used level.
		 */
		public static const STATUS:String = "status";
	}
}
