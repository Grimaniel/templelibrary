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

package temple.codecomponents.slider
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import temple.codecomponents.buttons.CodeButton;
	import temple.codecomponents.graphics.CodeBackground;
	import temple.common.enum.Direction;
	import temple.common.enum.Orientation;
	import temple.common.interfaces.IHasValue;
	import temple.core.display.CoreSprite;
	import temple.ui.form.components.ISetValue;
	import temple.ui.slider.SliderEvent;
	import temple.ui.slider.StepSlider;




	/**
	 * @author Thijs Broerse
	 */
	public class CodeStepSlider extends CoreSprite implements IHasValue, ISetValue
	{
		private var _track:InteractiveObject;
		private var _button:InteractiveObject;
		private var _slider:StepSlider;
		
		public function CodeStepSlider(width:Number = 200, height:Number = 10, min:Number = 0, max:Number = 1, stepSize:Number = .1, direction:String = Direction.ASCENDING)
		{
			this._track = this.addChild(new CodeBackground(width, height)) as InteractiveObject;
			this._button = this.addChild(new CodeButton(Math.min(width, height), Math.min(width, height))) as InteractiveObject;
			this._slider = new StepSlider(this._button, this._track.getRect(this), min, max, stepSize, height > width ? Orientation.VERTICAL : Orientation.HORIZONTAL, direction);
			CodeButton(this._button).outOnDragOut = false;
			
			this._slider.addEventListener(SliderEvent.SLIDE_START, this.dispatchEvent);
			this._slider.addEventListener(SliderEvent.SLIDING, this.handleSliding);
			this._slider.addEventListener(SliderEvent.SLIDE_STOP, this.dispatchEvent);
			this._slider.addEventListener(Event.CHANGE, this.dispatchEvent);
		}

		public function get track():InteractiveObject
		{
			return this._track;
		}

		public function get button():InteractiveObject
		{
			return this._button;
		}

		public function get slider():StepSlider
		{
			return this._slider;
		}

		public function get value():*
		{
			return this._slider.value;
		}

		public function set value(value:*):void
		{
			this._slider.value = value;
		}
		
		private function handleSliding(event:SliderEvent):void
		{
			this.dispatchEvent(event);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
