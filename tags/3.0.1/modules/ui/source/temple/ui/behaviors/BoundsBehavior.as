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
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * @eventType temple.ui.behaviors.BoundsBehaviorEvent.BOUNCED
	 */
	[Event(name = "BoundsBehaviorEvent.bounced", type = "temple.ui.behaviors.BoundsBehaviorEvent")]

	/**
	 * Behavior the keep DisplayObject within a bounds. Used as base class for other Behaviors like DragBehavior
	 * 
	 * @includeExample BoundsBehaviorExample.as
	 * 
	 * @author Arjan van Wijk
	 */
	public class BoundsBehavior extends AbstractDisplayObjectBehavior 
	{
		public static const TOP:String = "top"; 
		public static const RIGHT:String = "right"; 
		public static const BOTTOM:String = "bottom";
		public static const LEFT:String = "left";
		
		private var _bounds:Rectangle;

		public function BoundsBehavior(target:DisplayObject, bounds:Rectangle = null)
		{
			super(target);
			
			if (bounds) this.bounds = bounds;
			
			// dispath BoundsBehaviorEvent on target
			this.addEventListener(BoundsBehaviorEvent.BOUNCED, target.dispatchEvent);
		}
		
		/**
		 * The bounds limits the dragging. The object can only be dragged with this area
		 */
		public function get bounds():Rectangle
		{
			return this._bounds;
		}

		/**
		 * @private
		 */
		public function set bounds(value:Rectangle):void
		{
			this._bounds = value;
			
			this.keepInBounds();
		}

		/**
		 * Checks if the DisplayObject is still in bounds, if not if will be moved to put it in bounds
		 */
		public function keepInBounds():void
		{
			// Keep in bounds, checking for parent is allowed, since this is in a mouse event
			if (this._bounds)
			{
				var target:DisplayObject = this.displayObject;
				
				var objectbounds:Rectangle = target.getBounds(target.parent);
				
				// check x
				// check smaller
				if (this._bounds.width >= objectbounds.width)
				{
					if (objectbounds.left < this._bounds.left)
					{
						target.x += this._bounds.left - objectbounds.left;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, this, BoundsBehavior.LEFT));
					}
				
					else if (objectbounds.right > this._bounds.right)
					{
						target.x -= objectbounds.right - this._bounds.right;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, this, BoundsBehavior.RIGHT));
					}
				}
				// check larger
				else
				{
					if (objectbounds.left > this._bounds.left)
					{
						target.x += this._bounds.left - objectbounds.left;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, this, BoundsBehavior.LEFT));
					}
					else if (objectbounds.right < this._bounds.right)
					{
						target.x -= objectbounds.right - this._bounds.right;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, this, BoundsBehavior.RIGHT));
					}
				}
				
				// check y
				// check smaller
				if (this._bounds.height >= objectbounds.height)
				{
					if (objectbounds.top < this._bounds.top)
					{
						target.y += this._bounds.top - objectbounds.top;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, this, BoundsBehavior.TOP));
					}
					else if (objectbounds.bottom > this._bounds.bottom)
					{
						target.y -= objectbounds.bottom - this._bounds.bottom;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, this, BoundsBehavior.BOTTOM));
					}
				}
				// check larger
				else
				{
					if (objectbounds.top > this._bounds.top)
					{
						target.y += this._bounds.top - objectbounds.top;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, this, BoundsBehavior.TOP));
					}
					else if (objectbounds.bottom < this._bounds.bottom)
					{
						target.y -= objectbounds.bottom - this._bounds.bottom;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, this, BoundsBehavior.BOTTOM));
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._bounds = null;
			super.destruct();
		}
	}
}
