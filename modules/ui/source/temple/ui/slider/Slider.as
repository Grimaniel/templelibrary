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

package temple.ui.slider 
{
	import temple.common.enum.Direction;
	import temple.common.enum.Orientation;
	import temple.core.behaviors.AbstractBehavior;
	import temple.core.behaviors.IBehavior;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.DragBehavior;
	import temple.ui.behaviors.DragBehaviorEvent;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Rectangle;



	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * @eventType temple.ui.slider.SliderEvent.SLIDING
	 */
	[Event(name="SliderEvent.sliding", type="temple.ui.slider.SliderEvent")]
	
	/**
	 * @eventType temple.ui.slider.SliderEvent.SLIDE_START
	 */
	[Event(name="SliderEvent.slideStart", type="temple.ui.slider.SliderEvent")]
	
	/**
	 * @eventType temple.ui.slider.SliderEvent.SLIDE_STOP
	 */
	[Event(name="SliderEvent.slideStop", type="temple.ui.slider.SliderEvent")]

	/**
	 * @includeExample SliderExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class Slider extends AbstractBehavior implements IBehavior
	{
		protected var _orientation:String;
		protected var _direction:String;
		protected var _dragBehavior:DragBehavior;
		protected var _sliding:Boolean;

		public function Slider(target:InteractiveObject, bounds:Rectangle = null, orientation:String = Orientation.HORIZONTAL, direction:String = Direction.ASCENDING)
		{
			super(target);
			
			this._dragBehavior = new DragBehavior(target, bounds);
			this._dragBehavior.addEventListener(DragBehaviorEvent.DRAGGING, this.handleDragging);
			this._dragBehavior.addEventListener(DragBehaviorEvent.DRAG_START, this.handleDragStart);
			this._dragBehavior.addEventListener(DragBehaviorEvent.DRAG_STOP, this.handleDragStop);

			this.orientation = orientation;
			this.direction = direction;
		}

		/**
		 * Get or set the value of the Slider (value between 0 and 1)
		 */
		public function get value():Number
		{
			if (this._dragBehavior == null || !this._dragBehavior.target || !(this._dragBehavior.target as DisplayObject).parent) return NaN;
			
			var value:Number;
			
			var bounds:Rectangle = this._dragBehavior.bounds;
			var targetBounds:Rectangle = (this._dragBehavior.target as DisplayObject).getBounds((this._dragBehavior.target as DisplayObject).parent);
			
			if (this._orientation == Orientation.HORIZONTAL)
			{
				value = (targetBounds.x - bounds.x) / (bounds.width - targetBounds.width); 
			}
			else
			{
				value = (targetBounds.y - bounds.y) / (bounds.height - targetBounds.height);
			}
			
			if (this._direction == Direction.DESCENDING)
			{
				value = 1 - value;
			}
			return value;
		}

		/**
		 * @private
		 */
		public function set value(value:Number):void
		{
			if (isNaN(value)) return;
			
			if (this._dragBehavior == null || !this._dragBehavior.target || !(this._dragBehavior.target as DisplayObject).parent) return;
			
			if (value < 0)
			{
				value = 0;
			}
			else if (value > 1)
			{
				value = 1;
			}
			
			var bounds:Rectangle = this._dragBehavior.bounds;
			var target:DisplayObject = this._dragBehavior.target as DisplayObject;
			var targetBounds:Rectangle = target.getBounds(target.parent);
			
			if (this._direction == Direction.DESCENDING)
			{
				value = 1 - value;
			}
			
			if (this._orientation == Orientation.HORIZONTAL)
			{
				target.x = bounds.x + (target.x - targetBounds.x) + (bounds.width - targetBounds.width) * value;  
			}
			else
			{
				target.y = bounds.y + (target.y - targetBounds.y) + (bounds.height - targetBounds.height) * value;  
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Get or set the orientation (Orientation.HORIZONTAL or Orientation.VERTICAL)
		 * 
		 * @see temple.common.enum.Orientation
		 */
		public function get orientation():String
		{
			return this._orientation;
		}
		
		/**
		 * @private
		 */
		public function set orientation(value:String):void
		{
			switch (value)
			{
				case Orientation.HORIZONTAL:
				{
					this._orientation = value;
					this._dragBehavior.dragVertical = false;
					this._dragBehavior.dragHorizontal = true;
					break;
				}
				case Orientation.VERTICAL:
				{
					this._orientation = value;
					this._dragBehavior.dragVertical = true;
					this._dragBehavior.dragHorizontal = false;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "Invalid value for orientation '" + value + "'"));
					break;
				}
			}
		}
		
		/**
		 * Get or set the direction (Direction.ASCENDING or Direction.DESCENDING)
		 * 
		 * @see temple.common.enum.Direction
		 */
		public function get direction():String
		{
			return this._direction;
		}
		
		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			switch (value)
			{
				case Direction.ASCENDING:
				case Direction.DESCENDING:
				{
					this._direction = value;
					break;
				}
				default:
				{
					throwError(new TempleError(this, "Invalid value for direction '" + value + "'"));
				}
			}
		}
		
		/**
		 * Indicates if the Slider is sliding 
		 */
		public function get sliding():Boolean
		{
			return this._sliding;
		}
		
		/**
		 * Get the bounds of the slider
		 */
		public function get bounds():Rectangle
		{
			return this._dragBehavior ? this._dragBehavior.bounds : null;
		}

		/**
		 * @private
		 */
		public function set bounds(value:Rectangle):void
		{
			var val:Number = this.value;
			this._dragBehavior.bounds = value;
			this.value = val;
		}
		
		/**
		 * @private
		 */
		protected function handleDragging(event:DragBehaviorEvent):void
		{
			this.dispatchEvent(new SliderEvent(SliderEvent.SLIDING, this.value));
		}

		/**
		 * @private
		 */
		protected function handleDragStart(event:DragBehaviorEvent):void
		{
			this._sliding = true;
			this.dispatchEvent(new SliderEvent(SliderEvent.SLIDE_START, this.value));
		}

		/**
		 * @private
		 */
		protected function handleDragStop(event:DragBehaviorEvent):void
		{
			this._sliding = false;
			this.dispatchEvent(new SliderEvent(SliderEvent.SLIDE_STOP, this.value));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._dragBehavior)
			{
				this._dragBehavior.destruct();
				this._dragBehavior = null;
			}
			super.destruct();
		}
	}
}
