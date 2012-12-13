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
			return this._invertHorizontal;
		}

		/**
		 * @private
		 */
		public function set invertHorizontal(value:Boolean):void
		{
			this._invertHorizontal = value;
		}

		/**
		 * 
		 */
		public function get invertVertical():Boolean
		{
			return this._invertVertical;
		}

		/**
		 * @private
		 */
		public function set invertVertical(value:Boolean):void
		{
			this._invertVertical = value;
		}
		
		/**
		 * 
		 */
		public function get invert():Boolean
		{
			return this._invertHorizontal && this._invertVertical;
		}

		/**
		 * @private
		 */
		public function set invert(value:Boolean):void
		{
			this._invertHorizontal = this._invertVertical = value;
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
			if (this.displayObject.scrollRect)
			{
				super.handleMouseDown(event);
				this._startDragOffset = new Point(
					(this._invertHorizontal ? -1 : 1) * this.displayObject.scrollRect.topLeft.x - this.displayObject.parent.mouseX,
					(this._invertVertical ? -1 : 1) * this.displayObject.scrollRect.topLeft.y - this.displayObject.parent.mouseY);
			}
		}

		/**
		 * @private
		 */
		override protected function handleMouseMove(event:MouseEvent):void 
		{
			var scrollRect:Rectangle = this.displayObject.scrollRect;
			
			if (this.dragHorizontal)
			{
				scrollRect.x = (this._invertHorizontal ? -1 : 1) * (this._startDragOffset.x + this.displayObject.parent.mouseX);
			}
			
			if (this.dragVertical)
			{
				scrollRect.y = (this._invertHorizontal ? -1 : 1) * (this._startDragOffset.y + this.displayObject.parent.mouseY);
			}
			
			this.displayObject.scrollRect = scrollRect;
			this.displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, scrollRect.x, scrollRect.y, this.displayObject.transform.pixelBounds.width - this.displayObject.scrollRect.width, this.displayObject.transform.pixelBounds.height - this.displayObject.scrollRect.height));
			
			this.keepInBounds();
			
			this.dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAGGING, this));
		}
	}
}
