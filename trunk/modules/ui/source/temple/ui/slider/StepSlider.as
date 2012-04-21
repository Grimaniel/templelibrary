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
	import temple.core.templelibrary;
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
		 * @private
		 */
		templelibrary function get value():Number
		{
			return super.value;
		}

		/**
		 * @private
		 */
		templelibrary function set value(value:Number):void
		{
			super.value = value;
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
