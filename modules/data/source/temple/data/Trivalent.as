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

package temple.data
{
	import temple.common.enum.Enumerator;

	/**
	 * In logic, a three-valued logic (also trivalent, ternary, or trinary logic, sometimes abbreviated 3VL) is any of
	 * several many-valued logic systems in which there are three truth values indicating true, false and some
	 * indeterminate third value. This is contrasted with the more commonly known bivalent logics (such as classical
	 * sentential or boolean logic) which provide only for true and false.
	 * 
	 * @see http://en.wikipedia.org/wiki/Ternary_logic
	 * 
	 * @author Thijs Broerse
	 */
	public final class Trivalent extends Enumerator
	{
		public static const TRUE:Trivalent = new Trivalent("true");
		
		public static const FALSE:Trivalent = new Trivalent("false");
		
		public static const UNDEFINED:Trivalent = null;
		
		/**
		 * Get a Trivalent by his value.
		 * @param value the value of the Trivalent
		 */
		public static function get(value:String):Trivalent
		{
			return Enumerator.get(Trivalent, value) as Trivalent;
		}
		
		/**
		 * @private
		 */
		public function Trivalent(value:String)
		{
			super(value);
		}
	}
}
