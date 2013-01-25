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
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.utils.CoreTimer;
	import temple.ui.buttons.BaseButton;
	import temple.ui.eventtunneling.EventTunneler;
	import temple.ui.focus.FocusManager;
	import temple.utils.keys.KeyCode;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;

	/**
	 * @eventType temple.ui.buttons.behaviors.ButtonEvent.UPDATE
	 */
	[Event(name = "ButtonEvent.update", type = "temple.ui.buttons.behaviors.ButtonEvent")]
	
	/**
	 * The ButtonBehavior can make every DisplayObject act like a button. The ButtonBehavior keeps track of status of the button.
	 * The status of the button indicates if the mouse is currently up, over or down the button or if the button is selected of disabled.
	 * The the reaction of mouseOver and mouseOut Events can be delayed.
	 * 
	 * <p>The status of the buttons is dispatch in a tunneled ButtonEvent on all the children (and grandchildren etc.) of the button.
	 * This Button is used by ButtonDesignBehaviors to show the current status.</p> 
	 * 
	 * @see temple.ui.eventtunneling.EventTunneler
	 * @see temple.ui.buttons.behaviors.IButtonDesignBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class ButtonBehavior extends AbstractButtonBehavior
	{
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the ButtonBehavior of a DisplayObject if the DisplayObject has ButtonBehavior. Otherwise null is returned. 
		 */
		public static function getInstance(target:DisplayObject):ButtonBehavior
		{
			return ButtonBehavior._dictionary[target] as ButtonBehavior;
		}
		
		private var _stage:Stage;
		private var _eventTunneler:EventTunneler;
		private var _inDelayTimer:CoreTimer;
		private var _outDelayTimer:CoreTimer;
		private var _outOnDragOut:Boolean = true;
		private var _downOnDragIn:Boolean = false;
		private var _clickOnEnter:Boolean = false;
		private var _clickOnSpacebar:Boolean = false;
		
		/**
		 * 
		 */
		public function ButtonBehavior(target:InteractiveObject)
		{
			super(target);
			
			if (ButtonBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has ButtonBehavior"));
			
			ButtonBehavior._dictionary[target] = this;
			
			if (target is InteractiveObject)
			{
				if (target is DisplayObjectContainer)
				{
					(target as DisplayObjectContainer).mouseChildren = false;

					// act as button
					if (target is Sprite)
					{
						_eventTunneler = new EventTunneler(target as Sprite, ButtonEvent.UPDATE);
						
						(target as Sprite).buttonMode = true;
						if (target.hasOwnProperty(BaseButton.hitAreaInstanceName) && target[BaseButton.hitAreaInstanceName] is Sprite)
						{
							(target as Sprite).hitArea = target[BaseButton.hitAreaInstanceName] as Sprite;
							(target[BaseButton.hitAreaInstanceName] as Sprite).visible = false;
						}
					}
				}
			}

			target.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			target.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			target.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			target.addEventListener(MouseEvent.CLICK, handleClick);
			target.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
			target.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
			target.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			target.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			
			_inDelayTimer = new CoreTimer(0);
			_inDelayTimer.addEventListener(TimerEvent.TIMER, handleInDelay);
			
			_outDelayTimer = new CoreTimer(0);
			_outDelayTimer.addEventListener(TimerEvent.TIMER, handleOutDelay);
			
			if (target.stage)
			{
				_stage = target.stage;
				_stage.addEventListener(Event.MOUSE_LEAVE, handleMouseLeave);
				_stage.addEventListener(Event.DEACTIVATE, handleMouseLeave);
				FocusManager.init(_stage);
			}
			else
			{
				target.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set over(value:Boolean):void
		{
			if (over != value)
			{
				super.over = value;
				update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set lockOver(value:Boolean):void
		{
			if (lockOver != value)
			{
				super.lockOver = value;
				update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set down(value:Boolean):void
		{
			if (down != value)
			{
				super.down = value;
				update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set lockDown(value:Boolean):void
		{
			if (lockDown != value)
			{
				super.lockDown = value;
				update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set selected(value:Boolean):void
		{
			if (selected != value)
			{
				super.selected = value;
				update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set disabled(value:Boolean):void
		{
			if (disabled != value)
			{
				super.disabled = value;
				update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void
		{
			if (focus != value)
			{
				super.focus = value;
				update();
			}
		}
		
		/**
		 * Get or set the delay before mouse over is performed, in milliseconds.
		 */
		public function get inDelay():Number
		{
			return _inDelayTimer.delay;
		}
		
		/**
		 * @private
		 */
		public function set inDelay(value:Number):void
		{
			if (_inDelayTimer.delay != value && !isNaN(value))
			{
				_inDelayTimer.delay = value;
			}
		}

		/**
		 * (Hysteresis) delay before mouse out action is performed, in milliseconds.
		 */
		public function get outDelay():Number
		{
			return _outDelayTimer.delay;
		}
		
		/**
		 * @private
		 */
		public function set outDelay(value:Number):void
		{
			if (_outDelayTimer.delay != value && !isNaN(value))
			{
				_outDelayTimer.delay = value;
			}
		}

		/**
		 * Indicates if the ButtonBehavior should go in out state (true) when dragging (mouse out while mouse down) out the target.
		 * If set to false, buttons stays in down state when dragging out. Default: true
		 */
		public function get outOnDragOut():Boolean
		{
			return _outOnDragOut;
		}
		
		/**
		 * @private
		 */
		public function set outOnDragOut(value:Boolean):void
		{
			_outOnDragOut = value;
		}
		
		/**
		 * Indicates if the ButtonBehavior should go in down state (true) when dragging (mouse in while mouse down) in the target.
		 */
		public function get downOnDragIn():Boolean
		{
			return _downOnDragIn;
		}

		/**
		 * @private
		 */
		public function set downOnDragIn(value:Boolean):void
		{
			_downOnDragIn = value;
		}
		
		/**
		 * Indicates if the target should dispatch a CLICK event when the target has focus and the spacebar is pressed. Default: true
		 */
		public function get clickOnSpacebar():Boolean
		{
			return _clickOnSpacebar;
		}
		
		/**
		 * @private
		 */
		public function set clickOnSpacebar(value:Boolean):void
		{
			_clickOnSpacebar = value;
		}
		
		/**
		 * Indicates if the target should dispatch a CLICK event when the target has focus and the spacebar is pressed. Default: true
		 */
		public function get clickOnEnter():Boolean
		{
			return _clickOnEnter;
		}
		
		/**
		 * @private
		 */
		public function set clickOnEnter(value:Boolean):void
		{
			_clickOnEnter = value;
		}
		
		/**
		 * Updates all IButtonDesignBehaviors of this ButtonBehavior
		 */
		public function update():void
		{
			if (enabled)
			{
				if (debug) logDebug("update: over=" + over + ", down=" + down + ", selected=" + selected + ", disabled=" + disabled);
				
				displayObject.dispatchEvent(new ButtonEvent(ButtonEvent.UPDATE, this));
				dispatchEvent(new ButtonEvent(ButtonEvent.UPDATE, this, false));
			}
			else if (debug) logWarn("ButtonBehavior is disabled");
		}

		private function handleRollOver(event:MouseEvent):void
		{
			if (debug) logDebug("handleRollOver");
			
			super.over = true;
			if (!super.down) super.down = event.buttonDown && _downOnDragIn;
			resetTimers();
			_inDelayTimer.start();
		}

		private function handleRollOut(event:MouseEvent):void
		{
			if (debug) logDebug("handleRollOut");
			
			resetTimers();

			if (over)
			{
				super.over = false;
				if (_outDelayTimer.delay > 0)
				{
					_outDelayTimer.start();
				}
				else
				{
					onOutDelay();
				}
			}
		}

		private function handleMouseDown(event:MouseEvent):void
		{
			if (debug) logDebug("handleMouseDown");
			
			resetTimers();
			down = true;
		}
		
		private function handleMouseUp(event:MouseEvent):void
		{
			if (debug) logDebug("handleMouseUp");
			
			resetTimers();
			down = false;
		}
		
		private function handleClick(event:MouseEvent):void
		{
			if (debug) logDebug("handleClick");
		}
		
		private function handleInDelay(event:TimerEvent):void
		{
			resetTimers();
			update();
		}
		
		private function handleOutDelay(event:TimerEvent):void
		{
			onOutDelay();
		}
		
		private function onOutDelay():void
		{
			resetTimers();
			
			super.over = false;
			
			if (down)
			{
				if (_outOnDragOut)
				{
					down = false;
				}
				else
				{
					_stage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp, false, 0, true);
				}
			}
			else
			{
				update();
			}
		}
		
		private function handleAddedToStage(event:Event):void
		{
			displayObject.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			_stage = displayObject.stage;
			_stage.addEventListener(Event.MOUSE_LEAVE, handleMouseLeave);
			_stage.addEventListener(Event.DEACTIVATE, handleMouseLeave);
			FocusManager.init(_stage);
		}

		private function resetTimers():void 
		{
			if (_inDelayTimer) _inDelayTimer.reset();
			if (_outDelayTimer) _outDelayTimer.reset();
		}

		
		private function handleStageMouseUp(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
			if (down)
			{
				if (debug) logDebug("handleStageMouseUp");
				resetTimers();
				down = false;
			}
		}
		
		private function handleMouseLeave(event:Event):void
		{
			if (over)
			{
				if (debug) logDebug("handleMouseLeave");
				super.down = false;
				over = false;
			}
		}
		
		private function handleFocusIn(event:FocusEvent):void
		{
			focus = true;
		}

		private function handleFocusOut(event:FocusEvent):void
		{
			focus = false;
		}
		
		private function handleKeyDown(event:KeyboardEvent):void
		{
			if (_clickOnEnter && event.keyCode == KeyCode.ENTER || _clickOnSpacebar && event.keyCode == KeyCode.SPACE)
			{
				event.stopPropagation();
				displayObject.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false, NaN, NaN, null, event.ctrlKey, event.altKey, event.shiftKey));
				displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, NaN, NaN, null, event.ctrlKey, event.altKey, event.shiftKey));
			}
		}

		private function handleKeyUp(event:KeyboardEvent):void
		{
			if (_clickOnEnter && event.keyCode == KeyCode.ENTER || _clickOnSpacebar && event.keyCode == KeyCode.SPACE)
			{
				event.stopPropagation();
				displayObject.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, NaN, NaN, null, event.ctrlKey, event.altKey, event.shiftKey));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (target) delete ButtonBehavior._dictionary[target];
			
			if (displayObject)
			{
				displayObject.removeEventListener(MouseEvent.ROLL_OVER, handleRollOver);
				displayObject.removeEventListener(MouseEvent.ROLL_OUT, handleRollOut);
				displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				displayObject.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
				displayObject.removeEventListener(MouseEvent.CLICK, handleClick);
				displayObject.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
				displayObject.removeEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
				displayObject.removeEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
				displayObject.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				displayObject.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			}
			if (_inDelayTimer)
			{
				_inDelayTimer.destruct();
				_inDelayTimer = null;
			}
			if (_outDelayTimer)
			{
				_outDelayTimer.destruct();
				_outDelayTimer = null;
			}
			if (_stage)
			{
				_stage.removeEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
				_stage.removeEventListener(Event.MOUSE_LEAVE, handleMouseLeave);
				_stage.removeEventListener(Event.DEACTIVATE, handleMouseLeave);
				_stage = null;
			}
			if (_eventTunneler)
			{
				_eventTunneler.destruct();
				_eventTunneler = null;
			}
			super.destruct();
		}
	}
}
