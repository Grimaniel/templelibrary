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

package temple.utils 
{
	import temple.core.debug.objectToString;
	import temple.utils.types.StringUtils;

	/**
	 * This class contains some functions for URLs.
	 * 
	 * @author Thijs Broerse
	 */
	public final class URLUtils 
	{
		/**
		 * Provides the value of a specific query parameter.
		 * @param param Parameter name.
		 */
		public static function getParameter(url:String, param:String):String
		{
			var index:Number = url.indexOf('?');
			if (index != -1)
			{
				url = url.substr(index + 1);
				var params:Array = url.split('&');
				var p:Array;
				var i:Number = params.length;
				while (i--)
				{
					p = String(params[i]).split('=');
					if (p[0] == param)
					{
						return p[1];
					}
				}
			}
			return '';
		}
		
		/**
		 * Checks if the URL contains a specific parameter
		 */
		public static function hasParameter(url:String, param:String):Boolean
		{
			return url.indexOf(param + "=") != -1;
		}
		
		/**
		 * Add a parameter to the url
		 */
		public static function addParameter(url:String, param:String, value:String):String
		{
			return url + (url.indexOf("?") == -1 ? "?" : "&") + param + "=" + value;
		}
		
		/**
		 * Set a parameter in the URL
		 */
		public static function setParameter(url:String, param:String, value:String):String
		{
			if (URLUtils.hasParameter(url, param))
			{
				return url.replace(new RegExp('(?<=' + param + '=)\\w*', 'g'), value);
			}
			else
			{
				return URLUtils.addParameter(url, param, value);
			}
		}

		/**
		 * Get the file extension of an URL
		 */
		public static function getFileExtension(url:String):String
		{
			if (url == null) return null;
			if (url.indexOf('?') != -1) url = StringUtils.beforeFirst(url, '?');
			return StringUtils.afterLast(url, ".");
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(URLUtils);
		}
	}
}
