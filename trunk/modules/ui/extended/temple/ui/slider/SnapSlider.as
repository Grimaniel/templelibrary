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
	import temple.utils.propertyproxy.TargetPropertyProxy;
	import temple.utils.types.NumberUtils;

	import com.greensock.TweenLite;
	import com.greensock.easing.Ease;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Thijs Broerse
	 */
	public class SnapSlider extends StepSlider
	{
		private var _targetValue:Number;
		private var _proxy:Object;
		private var _duration:Number;
		private var _ease:Ease;
		
		public function SnapSlider(target:InteractiveObject, bounds:Rectangle, min:Number = 0, max:Number = 1, stepSize:Number = .1, orientation:String = Orientation.HORIZONTAL, direction:String = Direction.ASCENDING, duration:Number = .25, ease:Ease = null)
		{
			super(target, bounds, min, max, stepSize, orientation, direction);
			_proxy = {};
			dragBehavior.positionProxy = new TargetPropertyProxy(_proxy);
			_duration = duration;
			_ease = ease;
		}
		
		/**
		 * Duration of the snap animation
		 */
		public function get duration():Number
		{
			return _duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:Number):void
		{
			_duration = value;
		}

		/**
		 * Ease of the snap animation
		 */
		public function get ease():Ease
		{
			return _ease;
		}

		/**
		 * @private
		 */
		public function set ease(value:Ease):void
		{
			_ease = value;
		}
		
		/**
		 * Get or set the value of the Slider (value between 0 and 1)
		 */
		override public function get value():Number
		{
			if (_dragBehavior == null || !_dragBehavior.target || !(_dragBehavior.target as DisplayObject).parent) return NaN;
			
			var value:Number;
			
			var bounds:Rectangle = _dragBehavior.bounds;
			var targetBounds:Rectangle = (_dragBehavior.target as DisplayObject).getBounds((_dragBehavior.target as DisplayObject).parent);
			
			targetBounds.x = _proxy.x || 0;
			targetBounds.y = _proxy.y || 0;
			
			if (orientation == Orientation.HORIZONTAL)
			{
				value = (targetBounds.x - bounds.x) / (bounds.width - targetBounds.width); 
			}
			else
			{
				value = (targetBounds.y - bounds.y) / (bounds.height - targetBounds.height);
			}
			
			value = Math.min(Math.max(value, 0), 1);
			
			if (direction == Direction.DESCENDING)
			{
				value = 1 - value;
			}
			return NumberUtils.roundToNearest(min + value * (max - min), stepSize);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set value(value:Number):void
		{
			value = (NumberUtils.roundToNearest(value, stepSize) - min) / (max - min);
			
			if (isNaN(value)) return;
			
			if (_dragBehavior == null || !_dragBehavior.target || !(_dragBehavior.target as DisplayObject).parent) return;
			
			value = Math.min(Math.max(value, 0), 1);
			
			var bounds:Rectangle = _dragBehavior.bounds;
			var target:DisplayObject = _dragBehavior.target as DisplayObject;
			var targetBounds:Rectangle = target.getBounds(target.parent);
			
			if (direction == Direction.DESCENDING)
			{
				value = 1 - value;
			}
			
			var x:Number;
			var y:Number;
			
			if (orientation == Orientation.HORIZONTAL)
			{
				x = bounds.x + (target.x - targetBounds.x) + (bounds.width - targetBounds.width) * value;
				
				if (_targetValue != x)
				{
					_targetValue = x;
					dispatchEvent(new Event(Event.CHANGE));
					TweenLite.to(target, _duration, {x: x, ease: _ease});
				}
			}
			else
			{
				y = bounds.y + (target.y - targetBounds.y) + (bounds.height - targetBounds.height) * value;
				
				if (_targetValue != y)
				{
					_targetValue = y;
					dispatchEvent(new Event(Event.CHANGE));
					TweenLite.to(target, _duration, {x: x, ease: _ease});
				}  
			}
		}
	}
}
