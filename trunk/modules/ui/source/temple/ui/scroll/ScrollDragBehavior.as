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
 
package temple.ui.scroll 
{
	import temple.ui.behaviors.DragBehavior;
	import temple.ui.behaviors.DragBehaviorEvent;

	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Thijs Broerse
	 */
	public class ScrollDragBehavior extends DragBehavior 
	{
		public function ScrollDragBehavior(target:InteractiveObject, dragButton:InteractiveObject = null, dragHorizontal:Boolean = true, dragVertical:Boolean = true)
		{
			super(target, target.scrollRect, dragButton, dragHorizontal, dragVertical);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function keepInBounds():void
		{
			var scrollRect:Rectangle = this.displayObject.scrollRect;
			
			scrollRect.x = Math.min(scrollRect.x, this.displayObject.transform.pixelBounds.width - this.displayObject.scrollRect.width);
			scrollRect.x = Math.max(scrollRect.x, 0);
			scrollRect.y = Math.min(scrollRect.y, this.displayObject.transform.pixelBounds.height - this.displayObject.scrollRect.height);
			scrollRect.y = Math.max(scrollRect.y, 0);
			
			this.displayObject.scrollRect = scrollRect;
		}

		/**
		 * @private
		 */
		override protected function handleMouseDown(event:MouseEvent):void
		{
			super.handleMouseDown(event);
			
			this._startDragOffset = new Point(this.displayObject.scrollRect.topLeft.x - this.displayObject.parent.mouseX, this.displayObject.scrollRect.topLeft.y - this.displayObject.parent.mouseY);
		}

		/**
		 * @private
		 */
		override protected function handleMouseMove(event:MouseEvent):void 
		{
			var scrollRect:Rectangle = this.displayObject.scrollRect;
			
			if (this.dragHorizontal)
			{
				scrollRect.x = this._startDragOffset.x + this.displayObject.parent.mouseX;
			}
			
			if (this.dragVertical)
			{
				scrollRect.y = this._startDragOffset.y + this.displayObject.parent.mouseY;
			}
			
			this.displayObject.scrollRect = scrollRect;
			this.displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, scrollRect.x, scrollRect.y, this.displayObject.transform.pixelBounds.width - this.displayObject.scrollRect.width, this.displayObject.transform.pixelBounds.height - this.displayObject.scrollRect.height));
			
			this.keepInBounds();
			
			this.dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAGGING, this));
		}

		
	}
}
