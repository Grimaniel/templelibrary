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

package temple.codecomponents.buttons 
{
	import temple.codecomponents.graphics.CodeGraphicsRectangle;
	import temple.codecomponents.style.CodeStyle;
	import temple.ui.buttons.MultiStateButton;

	/**
	 * @includeExample CodeButtonExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CodeButton extends MultiStateButton 
	{
		public function CodeButton(width:Number = 14, height:Number = 14, x:Number = 0, y:Number = 0)
		{
			this.addChild(new CodeGraphicsRectangle(width, height, CodeStyle.buttonColor, CodeStyle.buttonAlpha)).filters = CodeStyle.buttonFilters;
			
			this.x = x;
			this.y = y;
			
			this.addChild(new ButtonOverState(width, height));
			this.addChild(new ButtonDownState(width, height));
		}
	}
}
import temple.codecomponents.style.CodeStyle;
import temple.ui.states.down.DownFadeState;
import temple.ui.states.over.OverFadeState;

class ButtonOverState extends OverFadeState
{
	public function ButtonOverState(width:Number, height:Number) 
	{
		super(.1, .25);
		
		this.graphics.beginFill(CodeStyle.buttonOverstateColor, CodeStyle.buttonOverstateAlpha);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
		this.filters = CodeStyle.buttonFilters;
	}
}

class ButtonDownState extends DownFadeState
{
	public function ButtonDownState(width:Number, height:Number) 
	{
		super(0, .25);
		
		this.graphics.beginFill(CodeStyle.buttonDownstateColor, CodeStyle.buttonDownstateAlpha);
		this.graphics.drawRect(0, 0, width, height);
		this.graphics.endFill();
		this.filters = CodeStyle.buttonDownFilters;
	}
}