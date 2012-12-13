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

package temple.utils.color
{
	import temple.core.debug.objectToString;
	
	/**
	 * Data object for storing color value with some basic convertion method.
	 * 
	 * @author Bart van der Schoor
	 */
	public class ARGB
	{
		private static const _TO_STRING_PROPS:Vector.<String> = Vector.<String>(['red', 'green', 'blue', 'alpha']);
		
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
		
		/**
		 * Alpha amount (between 0 and 255)
		 */
		public var alpha:uint = 255;
		
		/**
		 * Red amount (between 0 and 255)
		 */
		public var red:uint;
		
		/**
		 * Green amount (between 0 and 255)
		 */
		public var green:uint;
		
		/**
		 * Blue amount (between 0 and 255)
		 */
		public var blue:uint;

		/**
		 * Create a new ARGB object.
		 * @param r the red component of the color. Value must be between 0 and 255 (0xFF)
		 * @param g the green component of the color. Value must be between 0 and 255 (0xFF)
		 * @param b the blue component of the color. Value must be between 0 and 255 (0xFF)
		 * @param a the alpha component of the color. Value must be between 0 and 255 (0xFF)
		 * 
		 */
		public function ARGB(red:uint = 0, green:uint = 0, blue:uint = 0, alpha:uint = 255)
		{
			this.red = red;
			this.green = green;
			this.blue = blue;
			this.alpha = alpha;
		}

		/**
		 * The color as uint value.
		 */
		public function get color():uint
		{
			return (this.alpha << 24) | (this.red << 16) | (this.green << 8) | this.blue;
		}

		/**
		 * @private
		 */
		public function set color(color:uint):void
		{
			this.alpha = color >> 24 & 0xFF;
			this.red = color >> 16 & 0xFF;
			this.green = color >> 8 & 0xFF;
			this.blue = color & 0xFF;
		}
		
		/**
		 * Returns the value as ARGB hexadecimal String
		 */
		public function getARGBHexString():String 
		{
			var aa:String = this.alpha.toString(16);
			var rr:String = this.red.toString(16);
			var gg:String = this.green.toString(16);
			var bb:String = this.blue.toString(16);
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
			var rr:String = this.red.toString(16);
			var gg:String = this.green.toString(16);
			var bb:String = this.blue.toString(16);
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
			return (this.red + this.green + this.blue) / (3 * 255);
		}
		
		public function getBrightness():Number
		{
			var _max:Number = Math.max(this.red, this.green, this.blue);
			//var _min:Number = Math.min(this.r, this.g, this.b);
			return _max / 255 * 100;
		}
		
		public function getSaturation():Number
		{
			var _max:Number = Math.max(this.red, this.green, this.blue);
			var _min:Number = Math.min(this.red, this.green, this.blue);
			return (_max != 0) ? (_max - _min) / _max * 100 : 0;
		}

		public function fromUINT(color:uint):ARGB
		{
			this.alpha = color >> 24 & 0xFF;
			this.red = color >> 16 & 0xFF;
			this.green = color >> 8 & 0xFF;
			this.blue = color & 0xFF;
			
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
			this.alpha = color >> 24 & 0xFF;
			this.red = color >> 16 & 0xFF;
			this.green = color >> 8 & 0xFF;
			this.blue = color & 0xFF;
			
			return this;
		}
		
		public function toString():String
		{
			return objectToString(this, _TO_STRING_PROPS);
		}
	}
}
