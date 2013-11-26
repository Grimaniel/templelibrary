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
		private var _invertHorizontal:Boolean;
		private var _invertVertical:Boolean;
		
		public function ScrollDragBehavior(target:InteractiveObject, dragButton:InteractiveObject = null, dragHorizontal:Boolean = true, dragVertical:Boolean = true, invert:Boolean = false)
		{
			super(target, target.scrollRect, dragButton, dragHorizontal, dragVertical);
			this.invert = invert;
		}
		
		/**
		 * 
		 */
		public function get invertHorizontal():Boolean
		{
			return _invertHorizontal;
		}

		/**
		 * @private
		 */
		public function set invertHorizontal(value:Boolean):void
		{
			_invertHorizontal = value;
		}

		/**
		 * 
		 */
		public function get invertVertical():Boolean
		{
			return _invertVertical;
		}

		/**
		 * @private
		 */
		public function set invertVertical(value:Boolean):void
		{
			_invertVertical = value;
		}
		
		/**
		 * 
		 */
		public function get invert():Boolean
		{
			return _invertHorizontal && _invertVertical;
		}

		/**
		 * @private
		 */
		public function set invert(value:Boolean):void
		{
			_invertHorizontal = _invertVertical = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function keepInBounds():void
		{
			var scrollRect:Rectangle = displayObject.scrollRect;
			
			scrollRect.x = Math.min(scrollRect.x, displayObject.transform.pixelBounds.width - displayObject.scrollRect.width);
			scrollRect.x = Math.max(scrollRect.x, 0);
			scrollRect.y = Math.min(scrollRect.y, displayObject.transform.pixelBounds.height - displayObject.scrollRect.height);
			scrollRect.y = Math.max(scrollRect.y, 0);
			
			displayObject.scrollRect = scrollRect;
		}
		
		/**
		 * @private
		 */
		override protected function handleMouseDown(event:MouseEvent):void
		{
			if (displayObject.scrollRect)
			{
				super.handleMouseDown(event);
				_startDragOffset = new Point(
					(_invertHorizontal ? -1 : 1) * displayObject.scrollRect.topLeft.x - displayObject.parent.mouseX,
					(_invertVertical ? -1 : 1) * displayObject.scrollRect.topLeft.y - displayObject.parent.mouseY);
			}
		}

		/**
		 * @private
		 */
		override protected function handleMouseMove(event:MouseEvent):void 
		{
			var scrollRect:Rectangle = displayObject.scrollRect;
			
			if (dragHorizontal)
			{
				scrollRect.x = (_invertHorizontal ? -1 : 1) * (_startDragOffset.x + displayObject.parent.mouseX);
			}
			
			if (dragVertical)
			{
				scrollRect.y = (_invertHorizontal ? -1 : 1) * (_startDragOffset.y + displayObject.parent.mouseY);
			}
			
			displayObject.scrollRect = scrollRect;
			displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, scrollRect.x, scrollRect.y, displayObject.transform.pixelBounds.width - displayObject.scrollRect.width, displayObject.transform.pixelBounds.height - displayObject.scrollRect.height));
			
			keepInBounds();
			
			dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAGGING, this));
		}
	}
}
