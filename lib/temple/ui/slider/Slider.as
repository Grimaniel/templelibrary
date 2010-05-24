/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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
 */

package temple.ui.slider 
{
	import flash.display.InteractiveObject;
	import temple.behaviors.AbstractBehavior;
	import temple.behaviors.IBehavior;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.ui.behaviors.DragBehavior;
	import temple.ui.behaviors.DragBehaviorEvent;
	import temple.ui.layout.Direction;
	import temple.ui.layout.Orientation;

	import flash.display.DisplayObject;
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
	 * @author Thijs Broerse
	 */
	public class Slider extends AbstractBehavior implements IBehavior
	{
		protected var _orientation:String;
		protected var _direction:String;
		protected var _dragBehaviour:DragBehavior;
		protected var _sliding:Boolean;

		public function Slider(target:InteractiveObject, bounds:Rectangle = null, orientation:String = Orientation.HORIZONTAL, direction:String = Direction.ASCENDING)
		{
			super(target);
			
			this._dragBehaviour = new DragBehavior(target, bounds);
			this._dragBehaviour.addEventListener(DragBehaviorEvent.DRAGGING, this.handleDragging);
			this._dragBehaviour.addEventListener(DragBehaviorEvent.DRAG_START, this.handleDragStart);
			this._dragBehaviour.addEventListener(DragBehaviorEvent.DRAG_STOP, this.handleDragStop);

			this.orientation = orientation;
			this.direction = direction;
		}

		/**
		 * Get or set the value of the Slider (value between 0 and 1)
		 */
		public function get value():Number
		{
			if (this._dragBehaviour == null || !this._dragBehaviour.target || !(this._dragBehaviour.target as DisplayObject).parent) return NaN;
			
			var value:Number;
			
			var bounds:Rectangle = this._dragBehaviour.bounds;
			var targetBounds:Rectangle = (this._dragBehaviour.target as DisplayObject).getBounds((this._dragBehaviour.target as DisplayObject).parent);
			
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
			if(isNaN(value)) return;
			
			if(this._dragBehaviour == null || !this._dragBehaviour.target || !(this._dragBehaviour.target as DisplayObject).parent) return;
			
			if(value < 0)
			{
				value = 0;
			}
			else if(value > 1)
			{
				value = 1;
			}
			
			var bounds:Rectangle = this._dragBehaviour.bounds;
			var target:DisplayObject = this._dragBehaviour.target as DisplayObject;
			var targetBounds:Rectangle = target.getBounds(target.parent);
			
			if(this._direction == Direction.DESCENDING)
			{
				value = 1 - value;
			}
			
			if(this._orientation == Orientation.HORIZONTAL)
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
		 * @see temple.ui.layout.Orientation
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
			switch(value)
			{
				case Orientation.HORIZONTAL:
				{
					this._orientation = value;
					this._dragBehaviour.dragVertical = false;
					this._dragBehaviour.dragHorizontal = true;
					break;
				}
				case Orientation.VERTICAL:
				{
					this._orientation = value;
					this._dragBehaviour.dragVertical = true;
					this._dragBehaviour.dragHorizontal = false;
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
		 * @see temple.ui.layout.Direction
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
			switch(value)
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
			return this._dragBehaviour ? this._dragBehaviour.bounds : null;
		}

		/**
		 * @private
		 */
		public function set bounds(value:Rectangle):void
		{
			var val:Number = this.value;
			this._dragBehaviour.bounds = value;
			this.value = val;
		}
		
		protected function handleDragging(event:DragBehaviorEvent):void
		{
			this.dispatchEvent(new SliderEvent(SliderEvent.SLIDING, this.value));
		}

		protected function handleDragStart(event:DragBehaviorEvent):void
		{
			this._sliding = true;
			this.dispatchEvent(new SliderEvent(SliderEvent.SLIDE_START, this.value));
		}

		protected function handleDragStop(event:DragBehaviorEvent):void
		{
			this._sliding = false;
			this.dispatchEvent(new SliderEvent(SliderEvent.SLIDE_STOP, this.value));
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return super.toString() + (this._dragBehaviour ? ":" + (this._dragBehaviour.target as DisplayObject).name : '');
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this._dragBehaviour)
			{
				this._dragBehaviour.destruct();
				this._dragBehaviour = null;
			}
			super.destruct();
		}
	}
}
