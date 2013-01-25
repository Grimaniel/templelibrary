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
	import temple.common.interfaces.IHasValue;
	import temple.core.display.CoreSprite;
	import temple.ui.buttons.behaviors.ScrubBehavior;
	import temple.ui.form.components.ISetValue;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * Basic implementation of a Slider.
	 * 
	 * <p>A SliderComponent need at least a button and a track which can be set in the Flash IDE or by code. If set in the IDE
	 * name the object which must act as track 'track' or 'mcTrack'. The button must be called 'button' or 'mcButton'.</p>
	 * 
	 * @author Mark Knol
	 */
	public class SliderComponent extends CoreSprite implements IHasValue, ISetValue
	{
		/**
		 * Instance name of a child which acts as button for the ScrollBar.
		 */
		public static var buttonInstanceName:String = "mcButton";

		/**
		 * Instance name of a child which acts as track for the ScrollBar.
		 */
		public static var trackInstanceName:String = "mcTrack";
		
		protected var _slider:Slider;
		private var _button:InteractiveObject;
		private var _track:InteractiveObject;
		private var _trackScrubber:ScrubBehavior;
		
		public function SliderComponent()
		{	
			track ||= getChildByName(trackInstanceName) as InteractiveObject;
			button ||= getChildByName(buttonInstanceName) as InteractiveObject;
			
			toStringProps.push("value");
		}

		public function get button():InteractiveObject
		{
			return _button;
		}
		
		/**
		 * @private
		 */
		public function set button(value:InteractiveObject):void
		{
			if (_button)
			{
				if (_slider)
				{
					_slider.destruct();
					_slider = null;
				}
			}
			_button = value;
			
			if (_button)
			{
				_slider = createSlider(button, _track ? _track.getRect(this) : null);
				_slider.addEventListener(SliderEvent.SLIDE_START, dispatchEvent);
				_slider.addEventListener(SliderEvent.SLIDING, dispatchEvent);
				_slider.addEventListener(SliderEvent.SLIDE_STOP, dispatchEvent);
				_slider.addEventListener(Event.CHANGE, dispatchEvent);
			}
		}

		protected function createSlider(target:InteractiveObject, bounds:Rectangle):Slider
		{
			return new Slider(target, bounds);
		}
		
		public function get track():InteractiveObject
		{
			return _track;
		}
		
		/**
		 * @private
		 */
		public function set track(value:InteractiveObject):void
		{
			if (_track)
			{
				_track.removeEventListener(MouseEvent.CLICK, handleTrackClick);
				if (_trackScrubber)
				{
					_trackScrubber.destruct();
					_trackScrubber = null;
				}
			}
			
			_track = value;
			
			if (_track)
			{
				_track.addEventListener(MouseEvent.CLICK, handleTrackClick);
				_trackScrubber = new ScrubBehavior(_track);
				
				
				if (_slider)
				{
					_slider.bounds = _track.getRect(this);
				}
			}
		}
		
		public function get slider():Slider
		{
			return _slider;
		}

		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			return _slider.value;
		}

		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			_slider.value = value;
		}
		
		public function get isSliding():Boolean
		{
			return _slider.isSliding;
		}
		
		/**
		 * Get or set the direction (Direction.ASCENDING or Direction.DESCENDING)
		 * 
		 * @see temple.common.enum.Direction
		 */
		public function get direction():String
		{
			return _slider.direction;
		}
		
		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			_slider.direction = value;
		}
		
		protected function handleTrackClick(event:MouseEvent):void
		{
			value = _track.mouseX * _track.scaleX / _track.width;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
