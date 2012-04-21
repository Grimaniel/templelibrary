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

package temple.codecomponents.scroll 
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import temple.codecomponents.buttons.CodeButton;
	import temple.codecomponents.style.CodeStyle;
	import temple.common.enum.Direction;
	import temple.common.enum.Orientation;
	import temple.core.display.CoreShape;



	/**
	 * @author Thijs Broerse
	 */
	public class CodeScrollButton extends CodeButton 
	{
		public function CodeScrollButton(orientation:String = Orientation.VERTICAL, direction:String = Direction.ASCENDING, width:Number = 14, height:Number = 14, x:Number = 0, y:Number = 0)
		{
			super(width, height, x, y);
			
			// draw icon
			var icon:CoreShape = new CoreShape();
			this.addChild(icon);
			icon.x = width * .5;
			icon.y = height * .5;
			
			icon.graphics.beginFill(CodeStyle.iconColor, CodeStyle.iconAlpha);
			icon.graphics.lineStyle(0, 0x000000, 0, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 3);
			icon.graphics.moveTo(0, -3);
			icon.graphics.lineTo(4, 2);
			icon.graphics.lineTo(-4, 2);
			icon.graphics.lineTo(0, -3);
			icon.graphics.endFill();
			
			switch (orientation)
			{
				case Orientation.HORIZONTAL:
					switch (direction)
					{
						case Direction.ASCENDING:
							// right
							icon.rotation = 90;
							break;
						case Direction.DESCENDING:
							// left
							icon.rotation = -90;
							break;
					}
					break;
				case Orientation.VERTICAL:
					switch (direction)
					{
						case Direction.ASCENDING:
							// down
							icon.rotation = 180;
							break;
						case Direction.DESCENDING:
							// up
							icon.rotation = 0;
							break;
					}
					break;
			}
		}
	}
}
