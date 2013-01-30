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
	import temple.core.behaviors.IBehavior;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;
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
	public class Slider extends AbstractDisplayObjectBehavior implements IBehavior
	{
		protected var _dragBehavior:DragBehavior;
		protected var _isSliding:Boolean;
		private var _orientation:String;
		private var _direction:String;

		public function Slider(target:InteractiveObject, bounds:Rectangle = null, orientation:String = "horizontal", direction:String = "ascending")
		{
			super(target);
			
			construct::slider(target, bounds, orientation, direction);
		}

		construct function slider(target:InteractiveObject, bounds:Rectangle, orientation:String, direction:String):void
		{
			_dragBehavior = new DragBehavior(target, bounds);
			_dragBehavior.addEventListener(DragBehaviorEvent.DRAGGING, handleDragging);
			_dragBehavior.addEventListener(DragBehaviorEvent.DRAG_START, handleDragStart);
			_dragBehavior.addEventListener(DragBehaviorEvent.DRAG_STOP, handleDragStop);

			this.orientation = orientation;
			this.direction = direction;
		}


		/**
		 * Get or set the value of the Slider (value between 0 and 1)
		 */
		public function get value():Number
		{
			if (_dragBehavior == null || !_dragBehavior.target || !(_dragBehavior.target as DisplayObject).parent) return NaN;
			
			var value:Number;
			
			var bounds:Rectangle = _dragBehavior.bounds;
			var targetBounds:Rectangle = (_dragBehavior.target as DisplayObject).getBounds((_dragBehavior.target as DisplayObject).parent);
			
			if (_orientation == Orientation.HORIZONTAL)
			{
				value = (targetBounds.x - bounds.x) / (bounds.width - targetBounds.width); 
			}
			else
			{
				value = (targetBounds.y - bounds.y) / (bounds.height - targetBounds.height);
			}
			
			if (_direction == Direction.DESCENDING)
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
			
			if (_dragBehavior == null || !_dragBehavior.target || !(_dragBehavior.target as DisplayObject).parent) return;
			
			value = Math.min(Math.max(value, 0), 1);
			
			var bounds:Rectangle = _dragBehavior.bounds;
			var target:DisplayObject = _dragBehavior.target as DisplayObject;
			var targetBounds:Rectangle = target.getBounds(target.parent);
			
			if (_direction == Direction.DESCENDING)
			{
				value = 1 - value;
			}
			
			if (_orientation == Orientation.HORIZONTAL)
			{
				target.x = bounds.x + (target.x - targetBounds.x) + (bounds.width - targetBounds.width) * value;  
			}
			else
			{
				target.y = bounds.y + (target.y - targetBounds.y) + (bounds.height - targetBounds.height) * value;  
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Get or set the orientation (Orientation.HORIZONTAL or Orientation.VERTICAL)
		 * 
		 * @see temple.common.enum.Orientation
		 */
		public function get orientation():String
		{
			return _orientation;
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
					_orientation = value;
					_dragBehavior.dragVertical = false;
					_dragBehavior.dragHorizontal = true;
					break;
				}
				case Orientation.VERTICAL:
				{
					_orientation = value;
					_dragBehavior.dragVertical = true;
					_dragBehavior.dragHorizontal = false;
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
			return _direction;
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
					_direction = value;
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
		public function get isSliding():Boolean
		{
			return _isSliding;
		}
		
		/**
		 * Get the bounds of the slider
		 */
		public function get bounds():Rectangle
		{
			return _dragBehavior ? _dragBehavior.bounds : null;
		}

		/**
		 * @private
		 */
		public function set bounds(value:Rectangle):void
		{
			var val:Number = this.value;
			_dragBehavior.bounds = value;
			this.value = val;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Returns a reference to the <code>DragBehavior</code> of the <code>Slider</code>.
		 */
		public function get dragBehavior():DragBehavior
		{
			return _dragBehavior;
		}
		
		/**
		 * @private
		 */
		protected function handleDragging(event:DragBehaviorEvent):void
		{
			dispatchEvent(new SliderEvent(SliderEvent.SLIDING, value));
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * @private
		 */
		protected function handleDragStart(event:DragBehaviorEvent):void
		{
			_isSliding = true;
			dispatchEvent(new SliderEvent(SliderEvent.SLIDE_START, value));
		}

		/**
		 * @private
		 */
		protected function handleDragStop(event:DragBehaviorEvent):void
		{
			_isSliding = false;
			dispatchEvent(new SliderEvent(SliderEvent.SLIDE_STOP, value));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_dragBehavior)
			{
				_dragBehavior.destruct();
				_dragBehavior = null;
			}
			super.destruct();
		}
	}
}
