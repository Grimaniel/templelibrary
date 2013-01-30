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
