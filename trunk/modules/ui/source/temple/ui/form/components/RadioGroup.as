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

package temple.ui.form.components 
{
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.IResettable;
	import temple.common.interfaces.ISelectable;
	import temple.core.debug.DebugManager;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;
	import temple.core.debug.log.Log;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.data.collections.HashMap;
	import temple.ui.focus.FocusManager;
	import temple.ui.form.validation.IHasError;
	import temple.utils.types.ArrayUtils;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;


	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name = "change", type = "flash.events.Event")]

	/**
	 * Class for implementing radio button groups.
	 * @example
	 * Assume 3 objects of type CheckBox are placed on the stage, with instance names "mcRadio1", "mcRadio2", "mcRadio3"
	 * <listing version="3.0">
	 * // create new group, add radio buttons, select first button, listen to change event
	 * var rg:RadioGroup = new RadioGroup();
	 * rg.add(mcRadio1, "1");
	 * rg.add(mcRadio2, "2");
	 * rg.add(mcRadio3, "3");
	 * 
	 * // select one
	 * rg.selected = mcRadio1);
	 * rg.addEventListener(Event.CHANGE, handleRadioGroupChanged);
	 * </listing>
	 * 
	 * @see temple.ui.form.Form
	 * 
	 * @author Thijs Broerse
	 */
	public class RadioGroup extends CoreEventDispatcher implements IRadioGroup, IHasValue, IHasError, IResettable, IFocusable, ISetValue, IDebuggable 
	{
		private static const _NO_INDEX:int = 10000;

		private static var _instances:HashMap;

		/**
		 * Static function to get instances by name. Multiton implementation
		 * @param name the name of the RadioGroup
		 * @param createIfNull if set to true automatically creates a new RadioGroup if no 
		 */
		public static function getInstance(name:String, createIfNull:Boolean = true):RadioGroup
		{
			if (RadioGroup._instances && RadioGroup._instances[name])
			{
				return RadioGroup._instances[name] as RadioGroup;
			}
			else if (createIfNull)
			{
				RadioGroup._instances ||= new HashMap("RadioGroups");
				
				var radioGroup:RadioGroup = RadioGroup._instances[name] = new RadioGroup();
				radioGroup._name = name;
				radioGroup.toStringProps.push('name');
				
				return radioGroup;
			}
			Log.error("getInstance: no instance with name '" + name + "' found", RadioGroup);
			
			return null;
		}
		
		/**
		 * Static function to check if an instance with a specific name exists
		 * @param name the name of the RadioGroup
		 * @param createIfNull if set to true automatically creates a new RadioGroup if no 
		 */
		public static function hasInstance(name:String):Boolean
		{
			if (RadioGroup._instances && RadioGroup._instances[name])
			{
				return true;
			}
			return false;
		}
		
		/** @private */
		protected var _selected:ISelectable;
		/** @private */
		protected var _dispatchChangeEvent:Boolean = true;

		/** objects of type Selection */
		private var _buttons:Array = new Array();
		private var _focus:Boolean;
		private var _name:String;
		private var _prefillValue:*;
		private var _debug:Boolean;
		private var _keyboardTabbingEnabled:Boolean = true;
		private var _submitOnChange:Boolean;
		private var _hasError:Boolean;

		/**
		 * Create a new RadioGroup. 
		 */
		public function RadioGroup()
		{
			this.addEventListener(Event.CHANGE, this.handleChange);
		}
		
		/**
		 * @inheritDoc
		 */
		public function add(item:ISelectable, value:* = null, selected:Boolean = false, tabIndex:int = -1):ISelectable 
		{
			if (!item) throwError(new TempleArgumentError(this, "Parameter 'button' not defined."));
			
			if (ArrayUtils.inArrayField(this._buttons, 'button', item)) return item;
			
			if (this._debug) this.logDebug("addButton: " + item + ", value='" + value + "', selected=" + selected + "");
			
			if (item is IDebuggable) addToDebugManager(item as IDebuggable, this);
			
			var selection:Selection = new Selection(item, value, (tabIndex == -1 ? RadioGroup._NO_INDEX + this._buttons.length : tabIndex));
			
			this._buttons.push(selection);
			
			if (item is IRadioButton && IRadioButton(item).group != this) IRadioButton(item).group = this;
			
			if (item is IEventDispatcher)
			{
				IEventDispatcher(item).addEventListener(Event.CHANGE, this.handleButtonChange);
				IEventDispatcher(item).addEventListener(FocusEvent.FOCUS_IN, this.handleButtonFocusIn, false, 0, true);
				IEventDispatcher(item).addEventListener(FocusEvent.FOCUS_OUT, this.handleButtonFocusOut, false, 0, true);
				IEventDispatcher(item).addEventListener(FocusEvent.KEY_FOCUS_CHANGE, this.handleKeyFocusChange, false, 0, true);
				IEventDispatcher(item).addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown, false, 0, true);
			}
			else
			{
				this.logWarn("item is not an IEventDispatcher, this might not work properly");
			}
			
			item.selected = selected;

			if (this._prefillValue != null && this._prefillValue == selection.value)
			{
				selection.button.selected = true;
				
				if (this._debug) this.logDebug("addButton: buttons value is prefillValue, select button");
			}
			
			this._buttons.sort(sortButtons);
			
			return item;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(button:ISelectable):void
		{
			if (button == this._selected) this._selected = null;
			
			if (this._buttons == null) return;
			
			var leni:int = this._buttons.length;
			var selection:Selection;
			for (var i:int = 0; i < leni ; i++)
			{
				selection = Selection(this._buttons[i]);
				if (selection.button == button)
				{
					this._buttons.splice(i, 1);
					if (button is IEventDispatcher)
					{
						IEventDispatcher(button).removeEventListener(Event.CHANGE, this.handleButtonChange);
						IEventDispatcher(button).removeEventListener(FocusEvent.FOCUS_IN, this.handleButtonFocusIn);
						IEventDispatcher(button).removeEventListener(FocusEvent.FOCUS_OUT, this.handleButtonFocusOut);
						IEventDispatcher(button).removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, this.handleKeyFocusChange);
						IEventDispatcher(button).removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
					}
					selection.destruct();
					
					if (button is IRadioButton) IRadioButton(button).group = null;
					
					return;
				}
			}
		}
		
		/**
		 * Removes all buttons from the group
		 */
		public function removeAllButtons():void
		{
			if (this._buttons) while (this._buttons.length) this.remove((this._buttons[0] as Selection).button);
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * @inheritDoc
		 */
		public function get selected():ISelectable 
		{
			return this._selected;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selected(value:ISelectable):void 
		{
			var oldSelectedButton:ISelectable = this._selected;
			
			this._selected = value;

			if (oldSelectedButton && oldSelectedButton != this._selected) 
			{
				oldSelectedButton.selected = false;
			}
			
			if (this._selected) 
			{
				this._selected.selected = true;
				if (this._selected != oldSelectedButton) this.dispatchEvent(new Event(Event.CHANGE));
			}
			else if (oldSelectedButton)
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get items():Array 
		{
			if (this._buttons == null) return null;
			
			var a:Array = new Array();
			var leni:uint = this._buttons.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				a.push((this._buttons[i] as Selection).button);
			}
			
			return a;
		}

		/**
		 * @return the value of the currently selected button as provided during addition; returns null if no button is selected. 
		 */
		public function get value():* 
		{
			if (this._selected)
			{
				var leni:uint = this._buttons.length;
				for (var i:uint = 0;i < leni; i++) 
				{
					var sel:Selection = this._buttons[i];
					if (this._selected == sel.button) return sel.value;
				}
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * An Event.CHANGE will not be dispatched. If you want a Event.CHANGE event be dispatched, use setValue().
		 */
		public function set value(value:*):void
		{
			this.setValue(value, false);
		}

		/**
		 * Set the value of the RadioGroup. Value can only be set to the value of one of his buttons. If no button with current value exists value will not be set.
		 * @param value the value to set to
		 * @param dispatchChangeEvent indicates if an Event.CHANGE event will be dispatched when the value is changed, true will dispatch an Event.CHANGE event, false will not 
		 */
		public function setValue(value:*, dispatchChangeEvent:Boolean = true):void
		{
			this._dispatchChangeEvent = dispatchChangeEvent;

			
			for each (var selection:Selection in this._buttons)
			{
				if (value == null)
				{
					selection.button.selected = false;
				}
				else if (selection.value == value)
				{
					if (this._selected) this._selected.selected = false;
					selection.button.selected = true;
					this._selected = selection.button;
					this._dispatchChangeEvent = true;
					return;
				}
			}
			this._selected = null;
			this._dispatchChangeEvent = true;
			
			if (value != null)
			{
				this.logWarn("setValue:button with value '" + value + "' not found, value is stored if the button is added later");
				
				// store value, maybe the button is added later
				this._prefillValue = value;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get hasError():Boolean
		{
			return this._hasError;
		}

		/**
		 * @inheritDoc 
		 */
		public function set hasError(value:Boolean):void
		{
			if (value)
			{
				this.showError();
			}
			else
			{
				this.hideError();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function showError(message:String = null):void 
		{
			this._hasError = true;
			var leni:uint = this._buttons.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var btn:IHasError = (this._buttons[i] as Selection).button as IHasError;
				if (btn) btn.showError(message); 
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hideError():void 
		{
			this._hasError = false;
			var leni:uint = this._buttons.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var btn:IHasError = (this._buttons[i] as Selection).button as IHasError;
				if (btn) btn.hideError(); 
			}
		}

		/**
		 * Reset the group by calling reset on all buttons if they implement IResettable, or deselecting &amp; enabling them 
		 */
		public function reset():void 
		{
			this._dispatchChangeEvent = false;
			var leni:uint = this._buttons.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var sel:Selection = this._buttons[i];
				if (sel.button is IResettable)
				{
					(sel.button as IResettable).reset();
				}
				else 
				{
					var btn:ISelectable = sel.button;
					btn.selected = false;
				}
			}
			this._selected = null;
			this._dispatchChangeEvent = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return this._focus;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			if (value == this._focus) return;
			
			if (value)
			{
				if (this._buttons && this._buttons.length)
				{
					FocusManager.focus = Selection(this._buttons[0]).button as InteractiveObject;
				}
			}
			else
			{
				FocusManager.focus = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return this._name;
		}
		
		/**
		 * Indicates if tabbing with the Keyboard (by using the arrows) is enabled, default is true
		 */
		public function get keyboardTabbingEnabled():Boolean
		{
			return this._keyboardTabbingEnabled;
		}
		
		/**
		 * @private
		 */
		public function set keyboardTabbingEnabled(value:Boolean):void
		{
			this._keyboardTabbingEnabled = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
			DebugManager.setDebugForChildren(this, value);
		}

		/**
		 * Checks if one of the buttons has the given value
		 */
		public function hasValue(value:*):Boolean 
		{
			for each (var selection:Selection in this._buttons)
			{
				if (selection.value == value) return true;
			}
			return false;
		}

		/**
		 * If set to true the RadioGroup will dispatch an FormElementEvent.SUBMIT on change and the form (if enabled) can be submitted
		 */
		public function get submitOnChange():Boolean
		{
			return this._submitOnChange;
		}
		
		/**
		 * @private
		 */
		public function set submitOnChange(value:Boolean):void
		{
			this._submitOnChange = value;
		}

		/**
		 * Selects the next button in the list
		 */
		public function next():void
		{
			var item:ISelectable;
			var leni:int = this._buttons.length;
			for (var i:int = 0; i < leni ;i++)
			{
				if (Selection(this._buttons[i]).button == this._selected)
				{
					item = Selection(this._buttons[++i < leni ? i : 0]).button;
					if (item is IFocusable)
					{
						(item as IFocusable).focus = true;
					}
					else
					{
						FocusManager.focus = item as InteractiveObject;
					}
					if (this._selected) this.selected = item;
					return;
				}
			}
		}

		/**
		 * Selects the previous button in the list
		 */
		public function previous():void
		{
			var item:ISelectable;
			var leni:int = this._buttons.length;
			for (var i:int = 0; i < leni ; i++) 
			{
				if (Selection(this._buttons[i]).button == this._selected)
				{
					item = Selection(this._buttons[--i >= 0 ? i : leni-1]).button;
					if (item is IFocusable)
					{
						(item as IFocusable).focus = true;
					}
					else
					{
						FocusManager.focus = item as InteractiveObject;
					}
					if (this._selected) this.selected = item;
					return;
				}
			}
		}

		/**
		 * @private
		 */
		protected function handleButtonChange(event:Event):void
		{
			if (!(event.target is ISelectable)) return;
			
			if (ISelectable(event.target).selected)
			{
				if (this._selected != event.target)
				{
					var oldSelectedButton:ISelectable = this._selected;

					this._selected = ISelectable(event.target);
					
					if (oldSelectedButton) 
					{
						oldSelectedButton.selected = false;
					}
					if (this._dispatchChangeEvent) this.dispatchEvent(new Event(Event.CHANGE));
				}
			}
			else if (this._selected == event.target)
			{
				this._selected = null;
				if (this._dispatchChangeEvent) this.dispatchEvent(new Event(Event.CHANGE));
			}
		}

		/**
		 * @private
		 */
		protected function handleKeyDown(event:KeyboardEvent):void
		{
			if (this._keyboardTabbingEnabled)
			{
				switch (event.keyCode)
				{
					case Keyboard.DOWN:
					case Keyboard.RIGHT:
					{
						event.stopPropagation();
						this.next();
						break;
					}	
					case Keyboard.UP:
					case Keyboard.LEFT:
					{
						event.stopPropagation();
						this.previous();
						break;
					}
					default:
						this.dispatchEvent(event.clone());
						break;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function handleButtonFocusIn(event:FocusEvent):void
		{
			this._focus = true;
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * @private
		 */
		protected function handleButtonFocusOut(event:FocusEvent):void
		{
			this._focus = false;
			this.dispatchEvent(event.clone());
		}
		
		private function handleKeyFocusChange(event:FocusEvent):void 
		{
			event.preventDefault();
		}

		private function handleChange(event:Event):void
		{
			if (this._submitOnChange) if (this._submitOnChange) this.dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
		}

		private function sortButtons(a:Selection, b:Selection):int
		{
			return a.position - b.position;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this.removeAllStrongEventListenersForType(Event.CHANGE);
			this.removeAllButtons();
			this._selected = null;
			this._buttons = null;
			
			if (this._name) delete RadioGroup._instances[this._name];
			
			super.destruct();
		}
	}
}
import temple.common.interfaces.IHasValue;
import temple.common.interfaces.ISelectable;
import temple.core.CoreObject;
import temple.ui.form.components.ISetValue;

final class Selection extends CoreObject
{
	public var button:ISelectable;
	public var position:int;
	
	private var _value:*;

	public function Selection(button:ISelectable, value:*, position:int) 
	{
		this.button = button;
		this._value = value;
		this.position = position;
	}

	public function get value():*
	{
		return this._value != null ? this._value : button is IHasValue ? IHasValue(button).value : null;
	}

	public function set value(value:*):void
	{
		if (this.button is ISetValue)
		{
			ISetValue(this.button).value = value;
		}
		else
		{
			this._value = value;
		}
	}
	
	override public function destruct():void
	{
		this.button = null;
		
		super.destruct();
	}
}