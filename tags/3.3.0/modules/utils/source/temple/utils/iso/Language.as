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

package temple.utils.iso
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	
	/**
	 * ISO 639-1 Codes for the representation of names of languages
	 * 
	 * @see http://en.wikipedia.org/wiki/ISO_639-1
	 * 
	 * @author Thijs Broerse
	 */
	public final class Language
	{
		public static const ARMENIAN:String = "hy";
		public static const CHINESE_SIMPLIFIED:String = "zh-CN";
		public static const CHINESE_TRADITIONAL:String = "zh-TW";
		public static const CZECH:String = "cs";
		public static const DANISH:String = "da";
		public static const DUTCH:String = "nl";
		public static const ENGLISH:String = "en";
		public static const ESPERANTO:String = "eo";
		public static const FINNISH:String = "fi";
		public static const FRENCH:String = "fr";
		public static const GERMAN:String = "de";
		public static const HUNGARIAN:String = "hu";
		public static const IDO:String = "io";
		public static const ITALIAN:String = "it";
		public static const JAPANESE:String = "ja";
		public static const KOREAN:String = "ko";
		public static const NORWEGIAN:String = "no";
		public static const POLISH:String = "pl";
		public static const PORTUGUESE:String = "pt";
		public static const RUSSIAN:String = "ru";
		public static const SPANISH:String = "es";
		public static const SWEDISH:String = "sv";
		public static const TURKISH:String = "tr";
		public static const UNKNOWN:String = "xu";

		/**
		 * Name used in a specific language for a geographical feature situated outside the area where that language is
		 * spoken, and differing in its form from the name used in an official or well-established language of that area
		 * where the geographical feature is located.
		 */
		public static function exonym(language:String):String
		{
			switch (language)
			{
				case Language.ARMENIAN: return "Armenian";
				case Language.DUTCH: return "Dutch";
				case Language.ENGLISH: return "English";
				case Language.ESPERANTO: return "Esperanto";
				case Language.FRENCH: return "French";
				case Language.GERMAN: return "German";
				case Language.IDO: return "Ido";
				case Language.ITALIAN: return "Italian";
				case Language.JAPANESE: return "Japanese";
				case Language.PORTUGUESE: return "Portuguese";
				case Language.RUSSIAN: return "Russian";
				case Language.SPANISH: return "Spanish";
				case Language.SWEDISH: return "Swedish";
			}
			Log.error("Unknown language '" + language + "'", Language);

			return null;
		}

		/**
		 * Name of a geographical feature in an official or well-established language occurring in that area where the
		 * feature is located.
		 */
		public static function endonym(language:String):String
		{
			switch (language)
			{
				case Language.ARMENIAN: return "հայերէն";
				case Language.DUTCH: return "Nederlands";
				case Language.ENGLISH: return "English";
				case Language.ESPERANTO: return "Esperanto";
				case Language.FRENCH: return "le français";
				case Language.GERMAN: return "Deutsch";
				case Language.IDO: return "Ido";
				case Language.ITALIAN: return "italiano";
				case Language.JAPANESE: return "日本語, Nihongo";
				case Language.PORTUGUESE: return "português";
				case Language.RUSSIAN: return "russkiy yazyk";
				case Language.SPANISH: return "español";
				case Language.SWEDISH: return "svenska";
			}
			Log.error("Unknown language '" + language + "'", Language);

			return null;
		}

		public static function toString():String
		{
			return objectToString(Language);
		}
	}
}
