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

package temple.codecomponents.windows
{
	import temple.common.enum.Align;
	import temple.common.enum.ScaleMode;
	import temple.ui.layout.liquid.LiquidContainer;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeDesktop extends LiquidContainer
	{
		public function CodeDesktop(width:Number = NaN, height:Number = NaN)
		{
			super(width, height, ScaleMode.NO_SCALE, Align.TOP_LEFT);
			
			this.addEventListener(Event.ADDED, this.handleAdded);
			this.addEventListener(WindowEvent.ADD, this.handleWindowAdd);
		}

		private function handleAdded(event:Event):void
		{
			if (event.target is IWindow)
			{
				this.dispatchEvent(new WindowEvent(WindowEvent.ADD, IWindow(event.target)));
			}
		}

		private function handleWindowAdd(event:WindowEvent):void
		{
			if (event.window.parent != this)
			{
				event.stopPropagation();
				this.addChild(DisplayObject(event.window));
			}
		}
	}
}
