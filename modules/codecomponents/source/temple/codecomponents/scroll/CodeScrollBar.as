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
	import flash.display.InteractiveObject;
	import temple.codecomponents.buttons.CodeButton;
	import temple.codecomponents.graphics.CodeBackground;
	import temple.common.enum.Direction;
	import temple.common.enum.Orientation;
	import temple.ui.scroll.IScrollPane;
	import temple.ui.scroll.ScrollBar;



	/**
	 * @author Thijs Broerse
	 */
	public class CodeScrollBar extends ScrollBar 
	{
		public function CodeScrollBar(orientation:String = Orientation.VERTICAL, size:Number = 160, autoHide:Boolean = true, scrollPane:IScrollPane = null)
		{
			this.orientation = orientation;
			
			switch (this.orientation)
			{
				case Orientation.HORIZONTAL:
				{
					this.width = size;
					break;
				}
				case Orientation.VERTICAL:
				{
					this.height = size;
					break;
				}
			}
			
			this.autoHide = autoHide;
			
			this.createUI();
			
			this.scrollPane = scrollPane;
		}

		private function createUI():void 
		{
			this.track = this.addChild(new CodeBackground()) as InteractiveObject;
			if (this.orientation == Orientation.VERTICAL)
			{
				this.button = this.addChild(new CodeButton()) as InteractiveObject;
				this.upButton = this.addChild(new CodeScrollButton(Orientation.VERTICAL, Direction.DESCENDING)) as InteractiveObject;
				this.downButton = this.addChild(new CodeScrollButton(Orientation.VERTICAL, Direction.ASCENDING)) as InteractiveObject;
			}
			else
			{
				this.button = this.addChild(new CodeButton()) as InteractiveObject;
				this.leftButton = this.addChild(new CodeScrollButton(Orientation.HORIZONTAL, Direction.DESCENDING)) as InteractiveObject;
				this.rightButton = this.addChild(new CodeScrollButton(Orientation.HORIZONTAL, Direction.ASCENDING)) as InteractiveObject;
			}
			CodeButton(this.button).outOnDragOut = false;
			this.autoSizeButton = true;
			this.minimalButtonSize = 20;
		}
	}
}