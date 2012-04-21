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
	/**
	 * Util class for Diacritics.
	 * @see http://en.wikipedia.org/wiki/Diacritic
	 * 
	 * @author Thijs Broerse
	 */
	public final class Diacritics
	{
		private static var _entities:Object;
		
		/**
		 * Replaces all Diacritics to their "normal" equivalent.
		 * @see http://en.wikipedia.org/wiki/Diacritic
		 */
		public static function normalize(string:String):String
		{
			Diacritics._entities ||= Diacritics.getEntities();
        	
			for (var entity:String in Diacritics._entities)
			{
				string = string.replace(new RegExp(entity, 'g'), Diacritics._entities[entity]);
			}
			return string;
		}
		
		private static function getEntities():Object
		{
			var entities: Object = new Object();
			
			entities['Æ'] = 'A';
			entities['ß'] = 'S';
			entities['æ'] = 'a';
			entities['ð'] = 'o';
			entities['þ'] = 'b';
			entities['ƒ'] = 'f';
			
			entities['à'] = 'a';
			entities['á'] = 'a';
			entities['â'] = 'a';
			entities['ã'] = 'a';
			entities['ä'] = 'a';
			entities['å'] = 'a';
			entities['�?'] = 'a';
			entities['ą'] = 'a';
			entities['ç'] = 'c';
			entities['ć'] = 'c';
			entities['ĉ'] = 'c';
			entities['ċ'] = 'c';
			entities['�?'] = 'c';
			entities['�?'] = 'd';
			entities['đ'] = 'd';
			entities['è'] = 'e';
			entities['é'] = 'e';
			entities['ê'] = 'e';
			entities['ë'] = 'e';
			entities['ē'] = 'e';
			entities['ĕ'] = 'e';
			entities['ė'] = 'e';
			entities['ę'] = 'e';
			entities['�?'] = 'g';
			entities['ğ'] = 'g';
			entities['ġ'] = 'g';
			entities['ģ'] = 'g';
			entities['ĥ'] = 'h';
			entities['ħ'] = 'h';
			entities['ì'] = 'i';
			entities['í'] = 'i';
			entities['î'] = 'i';
			entities['ï'] = 'i';
			entities['ĩ'] = 'i';
			entities['ī'] = 'i';
			entities['ĭ'] = 'i';
			entities['ı'] = 'i';
			entities['į'] = 'i';
			entities['ĵ'] = 'j';
			entities['ķ'] = 'k';
			entities['ĸ'] = 'k';
			entities['ĺ'] = 'l';
			entities['ļ'] = 'l';
			entities['ŀ'] = 'l';
			entities['ł'] = 'l';
			entities['ñ'] = 'n';
			entities['ń'] = 'n';
			entities['ņ'] = 'n';
			entities['ň'] = 'n';
			entities['ŋ'] = 'n';
			entities['ò'] = 'o';
			entities['ó'] = 'o';
			entities['ô'] = 'o';
			entities['ö'] = 'o';
			entities['õ'] = 'o';
			entities['ø'] = 'o';
			entities['�?'] = 'o';
			entities['�?'] = 'o';
			entities['ő'] = 'o';
			entities['ŕ'] = 'r';
			entities['ŗ'] = 'r';
			entities['ř'] = 'r';
			entities['ś'] = 's';
			entities['�?'] = 's';
			entities['ş'] = 's';
			entities['š'] = 's';
			entities['ţ'] = 't';
			entities['ť'] = 't';
			entities['ŧ'] = 't';
			entities['ù'] = 'u';
			entities['ú'] = 'u';
			entities['û'] = 'u';
			entities['ü'] = 'u';
			entities['ũ'] = 'u';
			entities['ů'] = 'u';
			entities['ū'] = 'u';
			entities['ŭ'] = 'u';
			entities['ű'] = 'u';
			entities['ų'] = 'u';
			entities['ŵ'] = 'w';
			entities['ý'] = 'y';
			entities['ÿ'] = 'y';
			entities['ŷ'] = 'y';
			entities['ź'] = 'z';
			entities['ż'] = 'z';
			entities['ž'] = 'z';
			
			entities['À'] = 'A';
			entities['�?'] = 'A';
			entities['Â'] = 'A';
			entities['Ã'] = 'A';
			entities['Ä'] = 'A';
			entities['Å'] = 'A';
			entities['Ā'] = 'A';
			entities['Ă'] = 'A';
			entities['Ą'] = 'A';
			entities['Ç'] = 'C';
			entities['Ć'] = 'C';
			entities['Ĉ'] = 'C';
			entities['Ċ'] = 'C';
			entities['Č'] = 'C';
			entities['Ď'] = 'D';
			entities['�?'] = 'D';
			entities['È'] = 'E';
			entities['É'] = 'E';
			entities['Ê'] = 'E';
			entities['Ë'] = 'E';
			entities['Ē'] = 'E';
			entities['Ĕ'] = 'E';
			entities['Ė'] = 'E';
			entities['Ę'] = 'E';
			entities['Ě'] = 'E';
			entities['Ĝ'] = 'G';
			entities['Ğ'] = 'G';
			entities['Ġ'] = 'G';
			entities['Ģ'] = 'G';
			entities['Ĥ'] = 'H';
			entities['Ħ'] = 'H';
			entities['Ì'] = 'I';
			entities['�?'] = 'I';
			entities['Î'] = 'I';
			entities['�?'] = 'I';
			entities['Ĩ'] = 'I';
			entities['Ī'] = 'I';
			entities['Ĭ'] = 'I';
			entities['İ'] = 'I';
			entities['Į'] = 'I';
			entities['Ĵ'] = 'J';
			entities['Ķ'] = 'K';
			entities['ĸ'] = 'K';
			entities['Ĺ'] = 'L';
			entities['Ļ'] = 'L';
			entities['Ľ'] = 'L';
			entities['Ŀ'] = 'L';
			entities['�?'] = 'L';
			entities['Ñ'] = 'N';
			entities['Ń'] = 'N';
			entities['Ņ'] = 'N';
			entities['Ň'] = 'N';
			entities['Ŋ'] = 'N';
			entities['Ò'] = 'O';
			entities['Ó'] = 'O';
			entities['Ô'] = 'O';
			entities['Ö'] = 'O';
			entities['Õ'] = 'O';
			entities['Ø'] = 'O';
			entities['Ō'] = 'O';
			entities['Ŏ'] = 'O';
			entities['�?'] = 'O';
			entities['Ŕ'] = 'R';
			entities['Ŗ'] = 'R';
			entities['Ř'] = 'R';
			entities['Ś'] = 'S';
			entities['Ŝ'] = 'S';
			entities['Ş'] = 'S';
			entities['Š'] = 'S';
			entities['Ţ'] = 'T';
			entities['Ť'] = 'T';
			entities['Ŧ'] = 'T';
			entities['Ù'] = 'U';
			entities['Ú'] = 'U';
			entities['Û'] = 'U';
			entities['Ü'] = 'U';
			entities['Ũ'] = 'U';
			entities['Ů'] = 'U';
			entities['Ū'] = 'U';
			entities['Ŭ'] = 'U';
			entities['Ű'] = 'U';
			entities['Ų'] = 'U';
			entities['Ŵ'] = 'W';
			entities['�?'] = 'Y';
			entities['Ÿ'] = 'Y';
			entities['Ŷ'] = 'Y';
			entities['Ź'] = 'Z';
			entities['Ż'] = 'Z';
			entities['Ž'] = 'Z';
			
			return entities;
		}
	}
}
