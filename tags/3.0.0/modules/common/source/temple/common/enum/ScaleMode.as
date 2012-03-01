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

package temple.common.enum 
{
	/**
	 * This class contains possible values for <code>scaleMode</code>.
	 * 
	 * @author Thijs Broerse
	 */
	public final class ScaleMode 
	{
		/**
		 * Specifies that everything be visible in the specified area without trying to preserve the original aspect ratio. Distortion can occur.
		 */
		public static const EXACT_FIT:String = "exactFit";
		
		/**
		 * Specifies that everything fill the specified area, without distortion but possibly with some cropping, while maintaining the original aspect ratio.
		 */
		public static const NO_BORDER:String = "noBorder";

		/**
		 * Specifies that the size be fixed, so that it remains unchanged even as the size of the specified area changes. Cropping might occur if the specified area is smaller than the content.
		 */
		public static const NO_SCALE:String = "noScale";

		/**
		 * Specifies that everything be visible in the specified area without distortion while maintaining the original aspect ratio. Borders can appear on two sides.
		 */
		public static const SHOW_ALL:String = "showAll";
	}
}
