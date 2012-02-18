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

package temple.ui.slider 
{
	import temple.common.enum.Direction;
	import temple.common.enum.Orientation;
	import temple.ui.behaviors.DragBehaviorEvent;
	import temple.utils.types.NumberUtils;

	import flash.display.InteractiveObject;
	import flash.geom.Rectangle;


	/**
	 * @includeExample StepSliderExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class StepSlider extends Slider 
	{
		protected var _min:Number;
		protected var _max:Number;
		protected var _stepSize:Number;
		
		public function StepSlider(target:InteractiveObject, bounds:Rectangle, min:Number = 0, max:Number = 1, stepSize:Number = .1, orientation:String = Orientation.HORIZONTAL, direction:String = Direction.ASCENDING)
		{
			super(target, bounds, orientation, direction);
			
			this._min = min;
			this._max = max;
			this._stepSize = stepSize;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Value is rounded to the stepSize
		 */
		override public function get value():Number
		{
			return NumberUtils.roundToNearest(this._min + super.value * (this._max - this._min), this._stepSize);
		}

		/**
		 * @inheritDoc
		 */
		override public function set value(value:Number):void
		{
			super.value = (NumberUtils.roundToNearest(value, this._stepSize) - this._min) / (this._max - this._min);
		}
		
		/**
		 * Set the range of the values of the slider, so we can automatically calculate the outcome value
		 * @param min The lowest value of the slider
		 * @param max The highest value of the slider
		 */
		public function setRange(min:Number, max:Number):void 
		{
			this.min = min;
			this.max = max;
		}
		
		/**
		 * The minimal value of the slider 
		 */
		public function get min():Number
		{
			return this._min;
		}
		
		/**
		 * @private
		 */
		public function set min(value:Number):void
		{
			this._min = value;
		}
		
		/**
		 * The maximal value of the slider
		 */
		public function get max():Number
		{
			return this._max;
		}
		
		/**
		 * @private
		 */
		public function set max(value:Number):void
		{
			this._max = value;
		}
		
		/**
		 * The size of one step
		 */
		public function get stepSize():Number
		{
			return this._stepSize;
		}
		
		/**
		 * @private
		 */
		public function set stepSize(value:Number):void
		{
			this._stepSize = value;
		}
		
		/**
		 * @private
		 */
		override protected function handleDragging(event:DragBehaviorEvent):void
		{
			// assign to self to snap
			this.value = this.value;
			
			super.handleDragging(event);
		}
	}
}
