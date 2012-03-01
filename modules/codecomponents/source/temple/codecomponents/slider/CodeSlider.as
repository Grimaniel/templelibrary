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
	import temple.ui.slider.Slider;
	import temple.ui.slider.SliderEvent;




	/**
	 * @author Thijs Broerse
	 */
	public class CodeSlider extends CoreSprite implements IHasValue, ISetValue
	{
		private var _track:InteractiveObject;
		private var _button:InteractiveObject;
		private var _slider:Slider;
		
		public function CodeSlider(width:Number = 200, height:Number = 10, direction:String = Direction.ASCENDING)
		{
			this._track = this.addChild(new CodeBackground(width, height)) as InteractiveObject;
			this._button = this.addChild(new CodeButton(Math.min(width, height), Math.min(width, height))) as InteractiveObject;
			this._slider = new Slider(this._button, this._track.getRect(this), height > width ? Orientation.VERTICAL : Orientation.HORIZONTAL, direction);
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

		public function get slider():Slider
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
