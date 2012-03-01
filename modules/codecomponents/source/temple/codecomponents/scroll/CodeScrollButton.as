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
