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

package temple.ui 
{
	import temple.core.display.CoreSprite;

	/**
	 * A simple dot, useful for development and debug purposes.
	 *
	 * @author Bart van der Schoor
	 */
	public class Dot extends CoreSprite
	{
		private var _radius:Number = 1;
		private var _color:uint;
		private var _alpha:Number;

		public function Dot(radius:Number = 5, color:uint = 0xFF0000, alpha:Number = 1)
		{
			draw(radius, color, alpha);
		}

		public function draw(radius:Number = 5, color:uint = 0xFF0000, alpha:Number = 1):Dot
		{
			_alpha = alpha;
			_color = color;
			_radius = radius;
			
			redraw();
			
			return this;
		}
		
		public function redraw():Dot
		{
			graphics.clear();
			graphics.beginFill(_color, _alpha);
			graphics.drawCircle(0, 0, _radius);
			graphics.endFill();
			return this;
		}
		
		public function drawAt(x:Number = 0, y:Number = 0, radius:Number = 5, color:uint = 0xFF0000, alpha:uint = 1):Dot
		{
			this.x = x;
			this.y = y;
			return draw(radius, color, alpha);
		}
		
		public function get radius():Number
		{
			return _radius;
		}
	}
}
