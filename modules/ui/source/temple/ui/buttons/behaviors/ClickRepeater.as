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

package temple.ui.buttons.behaviors
{
	import temple.core.behaviors.AbstractBehavior;
	import temple.core.destruction.DestructEvent;
	import temple.core.utils.CoreTimer;
	import temple.utils.TimeOut;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;


	/**
	 * @eventType flash.events.MouseEvent.CLICK
	 */
	[Event(name = "click", type = "flash.events.MouseEvent")]
	
	/**
	 * The ClickRepeater class makes an InteractiveObject repeating the MouseEvent.CLICK event, while the user hold down the mouse button on the object.
	 * Useful for srollButtons to make a ScrollPane scroll while pressing the button.
	 * 
	 * You can set the delay of the first repeating and all other repeatings. You can also enable the 'highSpeed' by passing the delay.
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	this.mcButton.addEventListener(MouseEvent.CLICK, this.handleButtonClick);
	 * 	new ClickRepeater(this.mcButton);
	 * </listing>
	 * 
	 * @includeExample ClickRepeaterExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ClickRepeater extends AbstractBehavior
	{
		private var _initDelay:uint;
		private var _repeatDelay:uint;
		private var _highSpeedDelay:uint;
		private var _currentDelay:uint;
		private var _highSpeedWait:Number;
		private var _highSpeedWaitTimeOut:TimeOut;
		private var _timer:CoreTimer;
		private var _stage:Stage;
		private var _mouseOverTarget:Boolean;

		/**
		 * Create a new ClickRepeater
		 * @param target the InteractiveObject that should repeat the click event
		 * @param initDelay the delay of the first repeat in milliseconds
		 * @param repeatDelay the delay of the following repeats in milliseconds
		 * @param highSpeedWait the number of milliseconds to wait before go in to 'highspeed' mode, if NaN highspeed mode is disabled
		 * @param highSpeedDelay the delay of the repeats in milliseconds in highspeed mode
		 */
		public function ClickRepeater(target:InteractiveObject, initDelay:uint = 500, repeatDelay:uint = 70, highSpeedWait:Number = NaN, highSpeedDelay:uint = 20):void 
		{
			super(target);
			
			this._initDelay = initDelay;
			this._repeatDelay = repeatDelay;
			this._highSpeedWait = highSpeedWait;
			this._highSpeedDelay = highSpeedDelay;
			
			target.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
			target.addEventListener(DestructEvent.DESTRUCT, this.handleTargetDestructed);

			this._timer = new CoreTimer(this._initDelay);
			this._timer.addEventListener(TimerEvent.TIMER, this.handleTimerEvent);
		}
		
		/**
		 * Returns a reference to the DisplayObject
		 */
		public function get displayObject():DisplayObject
		{
			return this.target as DisplayObject;
		}
		
		/**
		 * Set the delay of the first repeat in milliseconds
		 */
		public function get initDelay():uint
		{
			return this._initDelay;
		}
		
		/**
		 * @private
		 */
		public function set initDelay(delay:uint):void 
		{
			this._initDelay = delay;
		}

		/**
		 * Set the 2nd and following repeats in milliseconds
		 */
		public function get repeatDelay():uint
		{
			return this._repeatDelay;
		}
		
		/**
		 * @private
		 */
		public function set repeatDelay(delay:uint):void 
		{
			this._repeatDelay = delay;
		}
		
		/**
		 * the delay of the repeats in milliseconds in highspeed mode
		 */
		public function get highSpeedDelay():uint
		{
			return this._highSpeedDelay;
		}
		
		/**
		 * @private
		 */
		public function set highSpeedDelay(value:uint):void
		{
			this._highSpeedDelay = value;
		}
		
		/**
		 * the number of milliseconds to wait before go in to 'highspeed' mode, if NaN highspeed mode is disabled
		 */
		public function get highSpeedWait():uint
		{
			return this._highSpeedWait;
		}
		
		/**
		 * @private
		 */
		public function set highSpeedWait(value:uint):void
		{
			this._highSpeedWait = value;
		}
		
		private function handleMouseDown(event:MouseEvent):void 
		{
			if (this._stage == null) this._stage = this.displayObject.stage;
			
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			this._stage.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp, false, 0, true);
			
			this.displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
			this.displayObject.addEventListener(MouseEvent.ROLL_OUT, this.handleTargetRollOut);
			this.displayObject.addEventListener(MouseEvent.ROLL_OVER, this.handleTargetRollOver);

			this._timer.delay = this._initDelay;
			this._currentDelay = this._repeatDelay;
			this._timer.start();
			
			this._mouseOverTarget = true;
			
			if (!isNaN(this._highSpeedWait))
			{
				this._highSpeedWaitTimeOut = new TimeOut(this.setHighSpeed, this._highSpeedWait);
			}
		}
		
		private function handleMouseUp(event:MouseEvent):void 
		{
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			if (this._mouseOverTarget) this.displayObject.addEventListener(MouseEvent.CLICK, this.handleClick, false, int.MAX_VALUE);
			this.displayObject.removeEventListener(MouseEvent.ROLL_OUT, this.handleTargetRollOut);
			this.displayObject.removeEventListener(MouseEvent.ROLL_OVER, this.handleTargetRollOver);
			this._timer.stop();
			if (this._highSpeedWaitTimeOut) this._highSpeedWaitTimeOut.destruct();
		}

		private function handleClick(event:MouseEvent):void
		{
			this.displayObject.removeEventListener(MouseEvent.CLICK, this.handleClick, false);
			event.stopImmediatePropagation();
		}
		
		private function handleTargetRollOut(event:MouseEvent):void
		{
			this._timer.stop();
			this._mouseOverTarget = false;
			if (this._highSpeedWaitTimeOut) this._highSpeedWaitTimeOut.destruct();
		}

		private function handleTargetRollOver(event:MouseEvent):void
		{
			this._mouseOverTarget = true;
			this._timer.start();
			this.displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
		}

		private function handleTimerEvent(event:TimerEvent):void
		{
			this._timer.delay = this._currentDelay;
			this.displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
		}
		
		private function handleTargetDestructed(event:DestructEvent):void
		{
			this.destruct();
		}
		
		private function setHighSpeed():void
		{
			this._currentDelay = this._highSpeedDelay;
		}

		/**
		 * Distroys the ClickRepeater
		 */
		override public function destruct():void
		{
			if (this.displayObject)
			{
				this.displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
				this.displayObject.removeEventListener(DestructEvent.DESTRUCT, this.handleTargetDestructed);
			}
			if (this._stage)
			{
				this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
				this._stage = null;
			}
			if (this._timer)
			{
				this._timer.destruct();
				this._timer = null;
			}
			if (this._highSpeedWaitTimeOut)
			{
				this._highSpeedWaitTimeOut.destruct();
				this._highSpeedWaitTimeOut = null;
			}
			super.destruct();
		}
	}
}
