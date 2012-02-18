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

package temple.utils.types 
{
	import temple.core.Temple;

	import flash.utils.Dictionary;

	/**
	 * This class contains some utilities for Functions.
	 * 
	 * @author Thijs Broerse
	 */
	public final class FunctionUtils 
	{
		/**
		 * Converts a function to a readable string.
		 * Note: only works in the debug player.
		 * 
		 * @includeExample FunctionUtilsExample.as
		 */
		public static function functionToString(func:Function):String 
		{
			try
			{
				Dictionary(func);
			}
			catch (error:Error)
			{
				var regExp:RegExp = /MC{(?:.*) (.*)}/g;
				var result:Array = regExp.exec(String(error.message));
				if (!result || !result[1]) return "function()";
				var s:String = String(result[1]);
				var i:int = s.indexOf("/");
				var className:String = s.substr(0, i);
				var functionName:String = s.substr(i);
				functionName = functionName.substr(functionName.indexOf("::") + 2);
				
				if (Temple.displayFullPackageInToString || className.indexOf('::') == -1)
				{
					return className + "." + functionName;
				}
				else
				{
					return className.split('::')[1] + "." + functionName;
				}
			}
			return null;
		}
	}
}
