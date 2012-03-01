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
	import temple.utils.types.StringUtils;

	/**
	 * This class contains some static utility method for handling Cascading Style Sheets.
	 * 
	 * @author Thijs Broerse
	 */
	public final class CSSUtils 
	{
		/**
		 * Converts a style (CSS) string to an object
		 * 
		 * Example:
		 * 		color:#FF0000;font-weight:bold;font-size:12px;width:40%;
		 * 		
		 * 	Will result in:
		 * 	
		 * 		{
		 * 			color: 0xFF0000,
		 * 			font-weight:'bold',
		 * 			font-size:12,
		 * 			width: 0.4
		 * 		}
		 * 		
		 * 	@param style the css string to convert
		 * 	@param lowerCaseKeys if set to true, the keys will be converted to lowercase
		 */
		public static function styleToObject(style:String, lowerCaseKeys:Boolean = true):Object
		{
			var object:Object = new Object();
			
			var list:Array = style.split(";");
			
			var prop:Array;
			var leni:int = list.length;
			for (var i:int = 0; i < leni ; i++)
			{
				prop = String(list[i]).split(':');
				if (prop[0] && prop[1]) object[StringUtils.trim(lowerCaseKeys ? String(prop[0]).toLowerCase() : prop[0])] = CSSUtils.convertCSSValue(prop[1]);
			}
			return object;
		}

		/**
		 * Converts a CSS value (String) to a Flash value:
		 * 
		 * 		'bold' -> 'bold'
		 * 		12px -> 12
		 * 		#00FF00 -> 0x00FF00
		 * 		40% -> .4
		 */
		public static function convertCSSValue(value:String):*
		{
			var r:Number;
			var g:Number;
			var b:Number;
			
			value = StringUtils.trim(value);
			
			// Check for Number
			if (!isNaN(Number(value)))
			{
				return Number(value);
			}
			
			// Check for .px value
			if (value.substr(-2) == "px" && !isNaN(Number(value.substr(0, value.length - 2))))
			{
				return Number(value.substr(0, value.length- 2));
			}
			
			// Check for color
			if (value.substr(0,1) == "#")
			{
				switch (value.length)
				{
					// #00F
					case 4:
						r = parseInt((value.substr(1, 1)+value.substr(1, 1)), 16);
						g = parseInt((value.substr(2, 1)+value.substr(2, 1)), 16);
						b = parseInt((value.substr(3, 1)+value.substr(3, 1)), 16);
						break;
					
					// #0000FF
					case 7:
					default:
						r = parseInt(value.substr(1, 2), 16);
						g = parseInt(value.substr(3, 2), 16);
						b = parseInt(value.substr(5, 2), 16);
						break;
				}
				return (r << 16) + (g << 8) + b;
			}
			
			// check for percentage
			if (value.substr(-1) == "%" && !isNaN(Number(value.substr(0, value.length - 1))))
			{
				return Number(value.substr(0, value.length-1)) * .01;
			}
			
			// check for firefox color: rgb(255, 255, 255)
			if (value.substr(0,4) == 'rgb(' && value.substr(-1) == ')')
			{
				var colors:Array = value.substring(4, value.length-1).split(',');
				r = Number(StringUtils.trim(colors[0]));
				g = Number(StringUtils.trim(colors[1]));
				b = Number(StringUtils.trim(colors[2]));
				
				return (r << 16) + (g << 8) + b;
			}
			
			return value;
		}
	}
}
