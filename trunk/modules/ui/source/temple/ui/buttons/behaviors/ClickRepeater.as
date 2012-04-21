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

package temple.ui.buttons.behaviors
{
	import temple.core.destruction.DestructEvent;
	import temple.core.utils.CoreTimer;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;
	import temple.utils.TimeOut;

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
	public class ClickRepeater extends AbstractDisplayObjectBehavior
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
			
			construct::clickRepeater(target, initDelay, repeatDelay, highSpeedWait, highSpeedDelay);
		}

		/**
		 * @private
		 */
		construct function clickRepeater(target:InteractiveObject, initDelay:uint, repeatDelay:uint, highSpeedWait:Number, highSpeedDelay:uint):void
		{
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
			
			this.displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
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
			this.displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
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
