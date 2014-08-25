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
	 * 	mcButton.addEventListener(MouseEvent.CLICK, handleButtonClick);
	 * 	new ClickRepeater(mcButton);
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
			_initDelay = initDelay;
			_repeatDelay = repeatDelay;
			_highSpeedWait = highSpeedWait;
			_highSpeedDelay = highSpeedDelay;
			
			target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			target.addEventListener(MouseEvent.CLICK, dispatchEvent);
			target.addEventListener(DestructEvent.DESTRUCT, handleTargetDestructed);

			_timer = new CoreTimer(_initDelay);
			_timer.addEventListener(TimerEvent.TIMER, handleTimerEvent);
		}

		
		/**
		 * Set the delay of the first repeat in milliseconds
		 */
		public function get initDelay():uint
		{
			return _initDelay;
		}
		
		/**
		 * @private
		 */
		public function set initDelay(delay:uint):void 
		{
			_initDelay = delay;
		}

		/**
		 * Set the 2nd and following repeats in milliseconds
		 */
		public function get repeatDelay():uint
		{
			return _repeatDelay;
		}
		
		/**
		 * @private
		 */
		public function set repeatDelay(delay:uint):void 
		{
			_repeatDelay = delay;
		}
		
		/**
		 * the delay of the repeats in milliseconds in highspeed mode
		 */
		public function get highSpeedDelay():uint
		{
			return _highSpeedDelay;
		}
		
		/**
		 * @private
		 */
		public function set highSpeedDelay(value:uint):void
		{
			_highSpeedDelay = value;
		}
		
		/**
		 * the number of milliseconds to wait before go in to 'highspeed' mode, if NaN highspeed mode is disabled
		 */
		public function get highSpeedWait():uint
		{
			return _highSpeedWait;
		}
		
		/**
		 * @private
		 */
		public function set highSpeedWait(value:uint):void
		{
			_highSpeedWait = value;
		}
		
		private function handleMouseDown(event:MouseEvent):void 
		{
			if (_stage == null) _stage = displayObject.stage;
			
			_stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			
			displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
			displayObject.addEventListener(MouseEvent.ROLL_OUT, handleTargetRollOut);
			displayObject.addEventListener(MouseEvent.ROLL_OVER, handleTargetRollOver);

			_timer.delay = _initDelay;
			_currentDelay = _repeatDelay;
			_timer.start();
			
			_mouseOverTarget = true;
			
			if (!isNaN(_highSpeedWait))
			{
				_highSpeedWaitTimeOut = new TimeOut(setHighSpeed, _highSpeedWait);
			}
		}
		
		private function handleMouseUp(event:MouseEvent):void 
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			if (_mouseOverTarget) displayObject.addEventListener(MouseEvent.CLICK, handleClick, false, int.MAX_VALUE);
			displayObject.removeEventListener(MouseEvent.ROLL_OUT, handleTargetRollOut);
			displayObject.removeEventListener(MouseEvent.ROLL_OVER, handleTargetRollOver);
			_timer.stop();
			if (_highSpeedWaitTimeOut) _highSpeedWaitTimeOut.destruct();
		}

		private function handleClick(event:MouseEvent):void
		{
			displayObject.removeEventListener(MouseEvent.CLICK, handleClick, false);
			event.stopImmediatePropagation();
		}
		
		private function handleTargetRollOut(event:MouseEvent):void
		{
			_timer.stop();
			_mouseOverTarget = false;
			if (_highSpeedWaitTimeOut) _highSpeedWaitTimeOut.destruct();
		}

		private function handleTargetRollOver(event:MouseEvent):void
		{
			_mouseOverTarget = true;
			_timer.start();
			displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
		}

		private function handleTimerEvent(event:TimerEvent):void
		{
			_timer.delay = _currentDelay;
			displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
		}
		
		private function handleTargetDestructed(event:DestructEvent):void
		{
			destruct();
		}
		
		private function setHighSpeed():void
		{
			_currentDelay = _highSpeedDelay;
		}

		/**
		 * Distroys the ClickRepeater
		 */
		override public function destruct():void
		{
			if (displayObject)
			{
				displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				displayObject.removeEventListener(DestructEvent.DESTRUCT, handleTargetDestructed);
			}
			if (_stage)
			{
				_stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
				_stage = null;
			}
			if (_timer)
			{
				_timer.destruct();
				_timer = null;
			}
			if (_highSpeedWaitTimeOut)
			{
				_highSpeedWaitTimeOut.destruct();
				_highSpeedWaitTimeOut = null;
			}
			super.destruct();
		}
	}
}
