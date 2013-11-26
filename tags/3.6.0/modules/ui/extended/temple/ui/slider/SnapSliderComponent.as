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
	import flash.display.InteractiveObject;
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
	public class SnapSliderComponent extends StepSliderComponent
	{
		public function SnapSliderComponent()
		{
			super();
		}
		
		/**
		 * Duration of the snap animation
		 */
		public function get duration():Number
		{
			return SnapSlider(slider).duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:Number):void
		{
			SnapSlider(slider).duration = value;
		}

		/**
		 * Ease of the snap animation
		 */
		public function get ease():Function
		{
			return SnapSlider(slider).ease;
		}

		/**
		 * @private
		 */
		public function set ease(value:Function):void
		{
			SnapSlider(slider).ease = value;
		}

		override protected function createSlider(target:InteractiveObject, bounds:Rectangle):Slider
		{
			return new SnapSlider(target, bounds);
		}
	}
}
