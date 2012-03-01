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

package temple.ui.behaviors 
{
	import flash.display.Bitmap;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * Blocks mouse events for transparent parts of a Bitmap.
	 * 
	 * @author Thijs Broerse
	 */
	public class TransparentBitmapHitArea extends AbstractDisplayObjectBehavior 
	{
		private var _threshold:uint;
		private var _hitarea:Bitmap;
		
		public function TransparentBitmapHitArea(target:InteractiveObject, hitarea:Bitmap, threshold:uint = 0)
		{
			super(target);
			
			target.mouseEnabled = true;
			
			this._hitarea = hitarea;
			this._threshold = threshold;
			
			if (target.stage)
			{
				target.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
			}
			else
			{
				target.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			}
		}

		private function handleAddedToStage(event:Event):void 
		{
			this.interactiveObject.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			this.interactiveObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
		}

		/**
		 * Same as target, but typed as InteractiveObject
		 */
		public function get interactiveObject():InteractiveObject 
		{
			return this.target as InteractiveObject;
		}
		
		public function get hitarea():Bitmap
		{
			return this._hitarea;
		}

		public function get threshold():uint
		{
			return this._threshold;
		}
		
		public function set threshold(value:uint):void
		{
			this._threshold = value;
		}
		
		private function handleMouseMove(event:MouseEvent):void 
		{
			this.interactiveObject.mouseEnabled = this.hitarea.bitmapData.hitTest(new Point(0, 0), this._threshold, new Point(this.hitarea.mouseX, this.hitarea.mouseY));
		}
	}
}
