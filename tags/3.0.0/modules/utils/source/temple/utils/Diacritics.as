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
			entities['ā'] = 'a';
			entities['ą'] = 'a';
			entities['ç'] = 'c';
			entities['ć'] = 'c';
			entities['ĉ'] = 'c';
			entities['ċ'] = 'c';
			entities['č'] = 'c';
			entities['ď'] = 'd';
			entities['đ'] = 'd';
			entities['è'] = 'e';
			entities['é'] = 'e';
			entities['ê'] = 'e';
			entities['ë'] = 'e';
			entities['ē'] = 'e';
			entities['ĕ'] = 'e';
			entities['ė'] = 'e';
			entities['ę'] = 'e';
			entities['ĝ'] = 'g';
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
			entities['ō'] = 'o';
			entities['ŏ'] = 'o';
			entities['ő'] = 'o';
			entities['ŕ'] = 'r';
			entities['ŗ'] = 'r';
			entities['ř'] = 'r';
			entities['ś'] = 's';
			entities['ŝ'] = 's';
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
			entities['Á'] = 'A';
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
			entities['Đ'] = 'D';
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
			entities['Í'] = 'I';
			entities['Î'] = 'I';
			entities['Ï'] = 'I';
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
			entities['Ł'] = 'L';
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
			entities['Ő'] = 'O';
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
			entities['Ý'] = 'Y';
			entities['Ÿ'] = 'Y';
			entities['Ŷ'] = 'Y';
			entities['Ź'] = 'Z';
			entities['Ż'] = 'Z';
			entities['Ž'] = 'Z';
			
			return entities;
		}
	}
}
