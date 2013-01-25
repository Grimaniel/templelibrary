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
	/**
	 * Utility methods for locales. A locale is a <code>String</code> containing the ISO Language Code and ISO Country
	 * Code seperated with an underscore (_).
	 * 
	 * @author Thijs Broerse
	 */
	public final class LocaleUtils
	{
		/**
		 * Get the language code from a locale code
		 */
		public static function getLanguageCode(locale:String):String
		{
			return locale && locale.indexOf("_") ? locale.split("_")[0] : null;
		}

		/**
		 * Get the country code from a locale code
		 */
		public static function getCountryCode(locale:String):String
		{
			return locale && locale.indexOf("_") ? locale.split("_")[1] : null;
		}

		public static function getExonymLanguageName(locale:String):String
		{
			return Language.exonym(LocaleUtils.getLanguageCode(locale));
		}

		public static function getEndonymLanguageName(locale:String):String
		{
			return Language.endonym(LocaleUtils.getLanguageCode(locale));
		}

		public static function getExonymCountryName(locale:String):String
		{
			return Country.exonym(LocaleUtils.getCountryCode(locale));
		}

		public static function getEndonymCountryName(locale:String):String
		{
			return Country.endonym(LocaleUtils.getCountryCode(locale));
		}
	}
}
