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
