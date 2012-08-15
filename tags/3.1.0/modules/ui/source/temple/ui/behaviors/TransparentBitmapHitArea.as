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
