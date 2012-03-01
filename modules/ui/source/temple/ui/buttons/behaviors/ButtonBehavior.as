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
						this._eventTunneler = new EventTunneler(target as Sprite, ButtonEvent.UPDATE);
						
						(target as Sprite).buttonMode = true;
						if (target.hasOwnProperty(BaseButton.hitAreaInstanceName) && target[BaseButton.hitAreaInstanceName] is Sprite)
						{
							(target as Sprite).hitArea = target[BaseButton.hitAreaInstanceName] as Sprite;
							(target[BaseButton.hitAreaInstanceName] as Sprite).visible = false;
						}
					}
				}
			}

			target.addEventListener(MouseEvent.ROLL_OVER, this.handleRollOver);
			target.addEventListener(MouseEvent.ROLL_OUT, this.handleRollOut);
			target.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
			target.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			target.addEventListener(MouseEvent.CLICK, this.handleClick);
			target.addEventListener(FocusEvent.FOCUS_IN, this.handleFocusIn);
			target.addEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
			target.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
			target.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp);
			
			this._inDelayTimer = new CoreTimer(0);
			this._inDelayTimer.addEventListener(TimerEvent.TIMER, this.handleInDelay);
			
			this._outDelayTimer = new CoreTimer(0);
			this._outDelayTimer.addEventListener(TimerEvent.TIMER, this.handleOutDelay);
			
			if (target.stage)
			{
				this._stage = target.stage;
				this._stage.addEventListener(Event.MOUSE_LEAVE, this.handleMouseLeave);
				this._stage.addEventListener(Event.DEACTIVATE, this.handleMouseLeave);
				FocusManager.init(this._stage);
			}
			else
			{
				target.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set over(value:Boolean):void
		{
			if (this.over != value)
			{
				super.over = value;
				this.update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set lockOver(value:Boolean):void
		{
			if (this.lockOver != value)
			{
				super.lockOver = value;
				this.update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set down(value:Boolean):void
		{
			if (this.down != value)
			{
				super.down = value;
				this.update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set lockDown(value:Boolean):void
		{
			if (this.lockDown != value)
			{
				super.lockDown = value;
				this.update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set selected(value:Boolean):void
		{
			if (this.selected != value)
			{
				super.selected = value;
				this.update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set disabled(value:Boolean):void
		{
			if (this.disabled != value)
			{
				super.disabled = value;
				this.update();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void
		{
			if (this.focus != value)
			{
				super.focus = value;
				this.update();
			}
		}
		
		/**
		 * Get or set the delay before mouse over is performed, in milliseconds.
		 */
		public function get inDelay():Number
		{
			return this._inDelayTimer.delay;
		}
		
		/**
		 * @private
		 */
		public function set inDelay(value:Number):void
		{
			if (this._inDelayTimer.delay != value && !isNaN(value))
			{
				this._inDelayTimer.delay = value;
			}
		}

		/**
		 * (Hysteresis) delay before mouse out action is performed, in milliseconds.
		 */
		public function get outDelay():Number
		{
			return this._outDelayTimer.delay;
		}
		
		/**
		 * @private
		 */
		public function set outDelay(value:Number):void
		{
			if (this._outDelayTimer.delay != value && !isNaN(value))
			{
				this._outDelayTimer.delay = value;
			}
		}

		/**
		 * Indicates if the ButtonBehavior should go in out state (true) when dragging (mouse out while mouse down) out the target.
		 * If set to false, buttons stays in down state when dragging out. Default: true
		 */
		public function get outOnDragOut():Boolean
		{
			return this._outOnDragOut;
		}
		
		/**
		 * @private
		 */
		public function set outOnDragOut(value:Boolean):void
		{
			this._outOnDragOut = value;
		}
		
		/**
		 * Indicates if the ButtonBehavior should go in down state (true) when dragging (mouse in while mouse down) in the target.
		 */
		public function get downOnDragIn():Boolean
		{
			return this._downOnDragIn;
		}

		/**
		 * @private
		 */
		public function set downOnDragIn(value:Boolean):void
		{
			this._downOnDragIn = value;
		}
		
		/**
		 * Indicates if the target should dispatch a CLICK event when the target has focus and the spacebar is pressed. Default: true
		 */
		public function get clickOnSpacebar():Boolean
		{
			return this._clickOnSpacebar;
		}
		
		/**
		 * @private
		 */
		public function set clickOnSpacebar(value:Boolean):void
		{
			this._clickOnSpacebar = value;
		}
		
		/**
		 * Indicates if the target should dispatch a CLICK event when the target has focus and the spacebar is pressed. Default: true
		 */
		public function get clickOnEnter():Boolean
		{
			return this._clickOnEnter;
		}
		
		/**
		 * @private
		 */
		public function set clickOnEnter(value:Boolean):void
		{
			this._clickOnEnter = value;
		}
		
		/**
		 * Updates all IButtonDesignBehaviors of this ButtonBehavior
		 */
		public function update():void
		{
			if (this.enabled)
			{
				if (this.debug) this.logDebug("update: over=" + this.over + ", down=" + this.down + ", selected=" + this.selected + ", disabled=" + this.disabled);
				
				this.displayObject.dispatchEvent(new ButtonEvent(ButtonEvent.UPDATE, this));
				this.dispatchEvent(new ButtonEvent(ButtonEvent.UPDATE, this, false));
			}
			else if (this.debug) this.logWarn("ButtonBehavior is disabled");
		}

		private function handleRollOver(event:MouseEvent):void
		{
			if (this.debug) this.logDebug("handleRollOver");
			
			super.over = true;
			if (!super.down) super.down = event.buttonDown && this._downOnDragIn;
			this.resetTimers();
			this._inDelayTimer.start();
		}

		private function handleRollOut(event:MouseEvent):void
		{
			if (this.debug) this.logDebug("handleRollOut");
			
			this.resetTimers();

			if (this.over)
			{
				super.over = false;
				if (this._outDelayTimer.delay > 0)
				{
					this._outDelayTimer.start();
				}
				else
				{
					this.onOutDelay();
				}
			}
		}

		private function handleMouseDown(event:MouseEvent):void
		{
			if (this.debug) this.logDebug("handleMouseDown");
			
			this.resetTimers();
			this.down = true;
		}
		
		private function handleMouseUp(event:MouseEvent):void
		{
			if (this.debug) this.logDebug("handleMouseUp");
			
			this.resetTimers();
			this.down = false;
		}
		
		private function handleClick(event:MouseEvent):void
		{
			if (this.debug) this.logDebug("handleClick");
		}
		
		private function handleInDelay(event:TimerEvent):void
		{
			this.resetTimers();
			this.update();
		}
		
		private function handleOutDelay(event:TimerEvent):void
		{
			this.onOutDelay();
		}
		
		private function onOutDelay():void
		{
			this.resetTimers();
			
			super.over = false;
			
			if (this.down)
			{
				if (this._outOnDragOut)
				{
					this.down = false;
				}
				else
				{
					this._stage.addEventListener(MouseEvent.MOUSE_UP, this.handleStageMouseUp, false, 0, true);
				}
			}
			else
			{
				this.update();
			}
		}
		
		private function handleAddedToStage(event:Event):void
		{
			this.displayObject.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			this._stage = this.displayObject.stage;
			this._stage.addEventListener(Event.MOUSE_LEAVE, this.handleMouseLeave);
			this._stage.addEventListener(Event.DEACTIVATE, this.handleMouseLeave);
			FocusManager.init(this._stage);
		}

		private function resetTimers():void 
		{
			if (this._inDelayTimer) this._inDelayTimer.reset();
			if (this._outDelayTimer) this._outDelayTimer.reset();
		}

		
		private function handleStageMouseUp(event:MouseEvent):void
		{
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleStageMouseUp);
			if (this.down)
			{
				if (this.debug) this.logDebug("handleStageMouseUp");
				this.resetTimers();
				this.down = false;
			}
		}
		
		private function handleMouseLeave(event:Event):void
		{
			if (this.over)
			{
				if (this.debug) this.logDebug("handleMouseLeave");
				super.down = false;
				this.over = false;
			}
		}
		
		private function handleFocusIn(event:FocusEvent):void
		{
			this.focus = true;
		}

		private function handleFocusOut(event:FocusEvent):void
		{
			this.focus = false;
		}
		
		private function handleKeyDown(event:KeyboardEvent):void
		{
			if (this._clickOnEnter && event.keyCode == KeyCode.ENTER || this._clickOnSpacebar && event.keyCode == KeyCode.SPACE)
			{
				event.stopPropagation();
				this.displayObject.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false, NaN, NaN, null, event.ctrlKey, event.altKey, event.shiftKey));
				this.displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, NaN, NaN, null, event.ctrlKey, event.altKey, event.shiftKey));
			}
		}

		private function handleKeyUp(event:KeyboardEvent):void
		{
			if (this._clickOnEnter && event.keyCode == KeyCode.ENTER || this._clickOnSpacebar && event.keyCode == KeyCode.SPACE)
			{
				event.stopPropagation();
				this.displayObject.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, NaN, NaN, null, event.ctrlKey, event.altKey, event.shiftKey));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.target) delete ButtonBehavior._dictionary[this.target];
			
			if (this.displayObject)
			{
				this.displayObject.removeEventListener(MouseEvent.ROLL_OVER, this.handleRollOver);
				this.displayObject.removeEventListener(MouseEvent.ROLL_OUT, this.handleRollOut);
				this.displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
				this.displayObject.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
				this.displayObject.removeEventListener(MouseEvent.CLICK, this.handleClick);
				this.displayObject.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
				this.displayObject.removeEventListener(FocusEvent.FOCUS_IN, this.handleFocusIn);
				this.displayObject.removeEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
				this.displayObject.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
				this.displayObject.removeEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp);
			}
			if (this._inDelayTimer)
			{
				this._inDelayTimer.destruct();
				this._inDelayTimer = null;
			}
			if (this._outDelayTimer)
			{
				this._outDelayTimer.destruct();
				this._outDelayTimer = null;
			}
			if (this._stage)
			{
				this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleStageMouseUp);
				this._stage.removeEventListener(Event.MOUSE_LEAVE, this.handleMouseLeave);
				this._stage.removeEventListener(Event.DEACTIVATE, this.handleMouseLeave);
				this._stage = null;
			}
			if (this._eventTunneler)
			{
				this._eventTunneler.destruct();
				this._eventTunneler = null;
			}
			super.destruct();
		}
	}
}
