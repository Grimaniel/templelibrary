/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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
 
 package temple.utils.color
{
	import temple.debug.objectToString;
	
	/**
	 * Data object for storing color value with some basic convertion method.
	 * 
	 * @author Bart van der Schoor
	 */
	public class ARGB
	{
		private static const _TO_STRING_PROPS:Array = ['r', 'g', 'b', 'a'];
		
		/**
		 * Converts a red, green, blue and alpha value to a single ARGB uint.
		 * @param r the red component of the color. Value must be between 0 and 255 (0xFF)
		 * @param g the green component of the color. Value must be between 0 and 255 (0xFF)
		 * @param b the blue component of the color. Value must be between 0 and 255 (0xFF)
		 * @param a the alpha component of the color. Value must be between 0 and 255 (0xFF)
		 */
		public static function getColor(r:uint, g:uint, b:uint, a:uint = 255):uint 
		{
			return (a << 24) | (r << 16) | (g << 8) | b;
		}
		
		/**
		 * Creates an ARBG object from a color value.
		 */
		public static function fromColor(color:int):ARGB
		{
			var a:ARGB = new ARGB();
			a.color = color;
			return a;
		}
		
		public var a:uint = 255;
		public var r:uint;
		public var g:uint;
		public var b:uint;

		/**
		 * Create a new ARGB object.
		 * @param r the red component of the color. Value must be between 0 and 255 (0xFF)
		 * @param g the green component of the color. Value must be between 0 and 255 (0xFF)
		 * @param b the blue component of the color. Value must be between 0 and 255 (0xFF)
		 * @param a the alpha component of the color. Value must be between 0 and 255 (0xFF)
		 * 
		 */
		public function ARGB(r:uint = 0, g:uint = 0, b:uint = 0, a:uint = 255)
		{
			this.a = a;
			this.r = r;
			this.g = g;
			this.b = b;
		}

		/**
		 * The color as uint value.
		 */
		public function get color():uint
		{
			return (this.a << 24) | (this.r << 16) | (this.g << 8) | this.b;
		}

		/**
		 * @private
		 */
		public function set color(color:uint):void
		{
			this.a = color >> 24 & 0xFF;
			this.r = color >> 16 & 0xFF;
			this.g = color >> 8 & 0xFF;
			this.b = color & 0xFF;
		}
		
		/**
		 * Returns the value as ARGB hexadecimal String
		 */
		public function getARGBHexString():String 
		{
			var aa:String = this.a.toString(16);
			var rr:String = this.r.toString(16);
			var gg:String = this.g.toString(16);
			var bb:String = this.b.toString(16);
			aa = (aa.length == 1) ? '0' + aa : aa;
			rr = (rr.length == 1) ? '0' + rr : rr;
			gg = (gg.length == 1) ? '0' + gg : gg;
			bb = (bb.length == 1) ? '0' + bb : bb;
			return (aa + rr + gg + bb).toUpperCase();
		}
		
		/**
		 * Returns the value as RGB hexadecimal String
		 */
		public function getRGBHexString():String 
		{
			var rr:String = this.r.toString(16);
			var gg:String = this.g.toString(16);
			var bb:String = this.b.toString(16);
			rr = (rr.length == 1) ? '0' + rr : rr;
			gg = (gg.length == 1) ? '0' + gg : gg;
			bb = (bb.length == 1) ? '0' + bb : bb;
			return (rr + gg + bb).toUpperCase();
		}
		
		/**
		 * Returns the uncorrected greyscale value
		 */
		public function getAverage():Number
		{
			return (this.r + this.g + this.b) / (3 * 255);
		}
		
		public function getBrightness():Number
		{
			var _max:Number = Math.max(this.r, this.g, this.b);
			//var _min:Number = Math.min(this.r, this.g, this.b);
			return _max / 255 * 100;
		}
		
		public function getSaturation():Number
		{
			var _max:Number = Math.max(this.r, this.g, this.b);
			var _min:Number = Math.min(this.r, this.g, this.b);
			return (_max != 0) ? (_max - _min) / _max * 100 : 0;
		}

		public function fromUINT(color:uint):ARGB
		{
			this.a = color >> 24 & 0xFF;
			this.r = color >> 16 & 0xFF;
			this.g = color >> 8 & 0xFF;
			this.b = color & 0xFF;
			
			return this;
		}
		
		//parse standard hex color-string: FFFFFFFF, 0xFFFFFFFF, #FFFFFFFF
		public function fromString(hex:String):ARGB
		{
			if(hex.length < 1)
			{
				return this;			
			}			
			if(hex.substr(0, 2) == '0x')
			{
				hex = hex.substr(2);
			}
			else if(hex.substr(0, 1) == '#')
			{
				hex = hex.substr(1);
			}
			//chop zeroes
			var i:uint = 0;
			while(hex.substr(i, 1) == '0' || i > hex.length)
			{
				hex = hex.substr(i);
				i++;
			}
			
			var color:uint = parseInt(hex, 16); 
			this.a = color >> 24 & 0xFF;
			this.r = color >> 16 & 0xFF;
			this.g = color >> 8 & 0xFF;
			this.b = color & 0xFF;
			
			return this;
		}
		
		
		
		public function toString():String
		{
			return objectToString(this, _TO_STRING_PROPS);
		}
	}
}
