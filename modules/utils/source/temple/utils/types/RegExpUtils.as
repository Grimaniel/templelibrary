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

package temple.utils.types 
{

	/**
	 * This class contains some functions for Regular Expressions.
	 * 
	 * @author Arjan van Wijk 
	 */
	public final class RegExpUtils 
	{
		private static const _ESCAPER:RegExp = new RegExp("[" + ("\\.+*?^$[]()|{}/'#".split('').join("\\")) + "]", "g");
		
		/**
		 * Searches text for all matches to the regular expression given in pattern and return the result.
		 * @param regExp the regular expression
		 * @param text the string to search on
		 */
		public static function pregMatchAll(regExp:RegExp, text:String):Array
		{
			var resultList:Array = new Array();
			
			var result:Object = regExp.exec(text);
			
			var index:int = -1;
			while (result != null && index != result.index)
			{
				for (var i:int = 0; i < result.length; ++i)
				{
					if (resultList[i] == null) resultList[i] = new Array();
					resultList[i].push(result[i] != undefined ? result[i] : '');
				}
				index = result.index;
				result = regExp.exec(text);
			}
			return resultList;
		}

		/**
		 * Searches for a match to the regular expression given in pattern.
		 * @param regExp the regular expression
		 * @param text the string to search on
		 */
		public static function pregMatch(regExp:RegExp, content:String):Array
		{
			var resultList:Array = new Array();
			
			var result:Object = regExp.exec(content);
			if (result != null)
			{
				for (var i:int = 0; i < result.length; ++i)
				{
					resultList.push(result[i] != undefined ? result[i] : '');
				}
			}
			return resultList;
		}

		public static function create(string:String, wholeWord:Boolean = false, escape:Boolean = true, global:Boolean = false, ignoreCase:Boolean = false, extended:Boolean = false, dotall:Boolean = false, multiline:Boolean = false):RegExp
		{
			var vlags:String = "";
			if (global) vlags += "g";
			if (ignoreCase) vlags += "i";
			if (extended) vlags += "x";
			if (dotall) vlags += "s";
			if (multiline) vlags += "m";
			
			if (escape) string = RegExpUtils.escape(string);
			if (wholeWord) string = "(^|(?<=\\W))" + string + "($|(?=\\W))";
			
			return new RegExp(string, vlags);
		}

		/**
		 * Escapes all special characters in a string so it can be used in a RegExp
		 */
		public static function escape(string:String):String
		{
			return string.replace(RegExpUtils._ESCAPER, "\\$&");
		}
	}
}
