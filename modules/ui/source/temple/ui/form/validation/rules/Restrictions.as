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

package temple.ui.form.validation.rules 
{

	/**
	 * Class contains some predefined restrictions for <code>InputFields</code>
	 * 
	 * @see temple.ui.form.components.InputField#restrict
	 * 
	 * @author Thijs Broerse
	 */
	public class Restrictions 
	{
		public static const NUMERIC:String = "0-9";
		public static const DASH:String = "\\-";
		public static const INTEGERS:String = Restrictions.NUMERIC + Restrictions.DASH;
		public static const NUMBERS:String = Restrictions.INTEGERS + ".";
		public static const LOWERCASE:String = "a-z";
		public static const UPPERCASE:String = "A-Z";
		public static const ALPHABETIC:String = Restrictions.LOWERCASE + Restrictions.UPPERCASE;
		public static const ALPHANUMERIC:String = Restrictions.ALPHABETIC + Restrictions.NUMERIC;
		public static const SPACE:String = " ";
		public static const BACK_SLASH:String = "\\\\";
		public static const FORWARD_SLASH:String = "/";

		/**
		 * Cannot be used in conjunction with other restrictions
		 */
		public static const NO_SPECIAL_CHARS:String = "^#$\\^|;\\\\<>{}[]";
		
		public static const EMAIL:String = Restrictions.INTEGERS + Restrictions.ALPHABETIC + Restrictions.SPACE + Restrictions.DASH + "@._";
		public static const DUTCH_POSTALCODE:String = Restrictions.NUMERIC + Restrictions.UPPERCASE;
		public static const DATE:String = Restrictions.NUMERIC + Restrictions.SPACE + Restrictions.DASH + Restrictions.BACK_SLASH + Restrictions.FORWARD_SLASH;
	}
}
