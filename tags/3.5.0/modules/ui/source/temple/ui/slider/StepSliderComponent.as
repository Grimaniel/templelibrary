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

	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * Basic implementation of a StepSlider.
	 * 
	 * <p>A StepSliderComponent need at least a button and a track which can be set in the Flash IDE or by code. If set 
	 * in the IDE name the object which must act as track 'track' or 'mcTrack'. The button must be called 'button' or 
	 * 'mcButton'.</p>
	 * 
	 * @author Mark Knol
	 */
	public class StepSliderComponent extends SliderComponent
	{
		public function StepSliderComponent()
		{
			super();
		}

		override protected function createSlider(target:InteractiveObject, bounds:Rectangle):Slider
		{
			return new StepSlider(target, bounds);
		}
		
		/**
		 * Set the range of the values of the slider, so we can automatically calculate the outcome value
		 * @param min The lowest value of the slider
		 * @param max The highest value of the slider
		 */
		public function setRange(min:Number, max:Number):void 
		{
			StepSlider(slider).min = min;
			StepSlider(slider).max = max;
		}
		
		/**
		 * The minimal value of the slider 
		 */
		public function get min():Number
		{
			return StepSlider(slider).min;
		}
		
		/**
		 * @private
		 */
		public function set min(value:Number):void
		{
			StepSlider(slider).min = value;
		}
		
		/**
		 * The maximal value of the slider
		 */
		public function get max():Number
		{
			return StepSlider(slider).max;
		}
		
		/**
		 * @private
		 */
		public function set max(value:Number):void
		{
			StepSlider(slider).max = value;
		}
		
		/**
		 * The size of one step
		 */
		public function get stepSize():Number
		{
			return StepSlider(slider).stepSize;
		}
		
		/**
		 * @private
		 */
		public function set stepSize(value:Number):void
		{
			StepSlider(slider).stepSize = value;
		}

		override protected function handleTrackClick(event:MouseEvent):void
		{
			StepSlider(slider).templelibrary::value = (track.mouseX * track.scaleX / track.width);
			slider.value = slider.value;
		}
	}
}
