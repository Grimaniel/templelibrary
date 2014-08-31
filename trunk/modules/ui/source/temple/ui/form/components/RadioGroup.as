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
	import temple.core.destruction.DestructEvent;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.data.collections.HashMap;
	import temple.ui.focus.FocusManager;
	import temple.ui.form.validation.IHasError;

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
	 * Class for implementing RadioGroups.
	 * @example
	 * Assume 3 objects of type CheckBox are placed on the stage, with instance names "mcRadio1", "mcRadio2", "mcRadio3"
	 * <listing version="3.0">
	 * // create new group, add radio buttons, select first buttonitemen to change event
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
	public class RadioGroup extends CoreEventDispatcher implements IRadioGroup, IHasValue, IHasError, IResettable, IFocusable, IDebuggable 
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
				RadioGroup._instances ||= new HashMap();
				
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

		private var _items:Vector.<Selection> = new Vector.<Selection>();
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
			addEventListener(Event.CHANGE, handleChange);
		}
		
		/**
		 * @inheritDoc
		 */
		public function add(item:ISelectable, value:* = null, selected:Boolean = false, tabIndex:int = -1):ISelectable 
		{
			if (!item) throwError(new TempleArgumentError(this, "Parameter 'item' not defined."));
			
			if (has(item)) return item;
			
			if (_debug) logDebug("add: " + item + ", value='" + value + "', selected=" + selected + "");
			
			if (item is IDebuggable) addToDebugManager(item as IDebuggable, this);
			
			var selection:Selection = new Selection(item, value, (tabIndex == -1 ? RadioGroup._NO_INDEX + _items.length : tabIndex));
			
			_items.push(selection);
			
			if (item is IRadioButton && IRadioButton(item).group != this) IRadioButton(item).group = this;
			
			if (item is IEventDispatcher)
			{
				IEventDispatcher(item).addEventListener(Event.CHANGE, handleButtonChange);
				IEventDispatcher(item).addEventListener(FocusEvent.FOCUS_IN, handleButtonFocusIn);
				IEventDispatcher(item).addEventListener(FocusEvent.FOCUS_OUT, handleButtonFocusOut);
				IEventDispatcher(item).addEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleKeyFocusChange);
				IEventDispatcher(item).addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				IEventDispatcher(item).addEventListener(DestructEvent.DESTRUCT, handleItemDestruct);
			}
			else
			{
				logWarn("item is not an IEventDispatcher, this might not work properly");
			}
			
			item.selected = selected;

			if (_prefillValue != null && _prefillValue == selection.value)
			{
				selection.item.selected = true;
				
				if (_debug) logDebug("add: buttons value is prefillValue, select item");
			}
			
			_items.sort(sortButtons);
			
			return item;
		}
		
		public function has(item:ISelectable):Boolean 
		{
			for each (var selection:Selection in _items)
			{
				if (selection.item == item) return true;
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(item:ISelectable):void
		{
			if (_items == null) return;
			
			var leni:int = _items.length;
			var selection:Selection;
			loop: for (var i:int = 0; i < leni ; i++)
			{
				selection = Selection(_items[i]);
				if (selection.item == item)
				{
					_items.splice(i, 1);
					if (item is IEventDispatcher)
					{
						IEventDispatcher(item).removeEventListener(Event.CHANGE, handleButtonChange);
						IEventDispatcher(item).removeEventListener(FocusEvent.FOCUS_IN, handleButtonFocusIn);
						IEventDispatcher(item).removeEventListener(FocusEvent.FOCUS_OUT, handleButtonFocusOut);
						IEventDispatcher(item).removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleKeyFocusChange);
						IEventDispatcher(item).removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
						IEventDispatcher(item).removeEventListener(DestructEvent.DESTRUCT, handleItemDestruct);
					}
					selection.destruct();
					
					if (item is IRadioButton) IRadioButton(item).group = null;
					
					break loop;
				}
			}
			
			if (item == _selected)
			{
				_selected = null;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * Removes all buttons from the group
		 */
		public function removeAllButtons():void
		{
			if (_items) while (_items.length) remove((_items[0] as Selection).item);
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * @inheritDoc
		 */
		public function get selected():ISelectable 
		{
			return _selected;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selected(value:ISelectable):void 
		{
			var oldSelectedButton:ISelectable = _selected;
			
			_selected = value;

			if (oldSelectedButton && oldSelectedButton != _selected) 
			{
				oldSelectedButton.selected = false;
			}
			
			if (_selected) 
			{
				_selected.selected = true;
				if (_selected != oldSelectedButton) dispatchEvent(new Event(Event.CHANGE));
			}
			else if (oldSelectedButton)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get items():Array 
		{
			if (_items == null) return null;
			
			var a:Array = new Array();
			var leni:uint = _items.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				a.push((_items[i] as Selection).item);
			}
			
			return a;
		}

		/**
		 * @return the value of the currently selected item as provided during addition; returns null if no item is selected. 
		 */
		public function get value():* 
		{
			if (_selected)
			{
				var leni:uint = _items.length;
				for (var i:uint = 0;i < leni; i++) 
				{
					var sel:Selection = _items[i];
					if (_selected == sel.item) return sel.value;
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
			setValue(value, false);
		}

		/**
		 * Set the value of the RadioGroup. Value can only be set to the value of one of his buttons. If no item with current value exists value will not be set.
		 * @param value the value to set to
		 * @param dispatchChangeEvent indicates if an Event.CHANGE event will be dispatched when the value is changed, true will dispatch an Event.CHANGE event, false will not 
		 */
		public function setValue(value:*, dispatchChangeEvent:Boolean = true):void
		{
			_dispatchChangeEvent = dispatchChangeEvent;

			
			for each (var selection:Selection in _items)
			{
				if (value == null)
				{
					selection.item.selected = false;
				}
				else if (selection.value == value)
				{
					if (_selected) _selected.selected = false;
					selection.item.selected = true;
					_selected = selection.item;
					_dispatchChangeEvent = true;
					return;
				}
			}
			if (_selected) _selected.selected = false;
			_selected = null;
			_dispatchChangeEvent = true;
			
			if (value != null)
			{
				// store value, maybe the item is added later
				_prefillValue = value;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get hasError():Boolean
		{
			return _hasError;
		}

		/**
		 * @inheritDoc 
		 */
		public function set hasError(value:Boolean):void
		{
			if (value)
			{
				showError();
			}
			else
			{
				hideError();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function showError(message:String = null):void 
		{
			_hasError = true;
			var leni:uint = _items.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var btn:IHasError = (_items[i] as Selection).item as IHasError;
				if (btn) btn.showError(message); 
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hideError():void 
		{
			_hasError = false;
			var leni:uint = _items.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var btn:IHasError = (_items[i] as Selection).item as IHasError;
				if (btn) btn.hideError(); 
			}
		}

		/**
		 * Reset the group by calling reset on all buttons if they implement IResettable, or deselecting &amp; enabling them 
		 */
		public function reset():void 
		{
			_dispatchChangeEvent = false;
			var leni:uint = _items.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var sel:Selection = _items[i];
				if (sel.item is IResettable)
				{
					(sel.item as IResettable).reset();
				}
				else 
				{
					var btn:ISelectable = sel.item;
					btn.selected = false;
				}
			}
			_selected = null;
			_dispatchChangeEvent = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return _focus;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			if (value == _focus) return;
			
			if (value)
			{
				if (_items && _items.length)
				{
					FocusManager.focus = Selection(_items[0]).item as InteractiveObject;
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
			return _name;
		}
		
		/**
		 * Indicates if tabbing with the Keyboard (by using the arrows) is enabled, default is true
		 */
		public function get keyboardTabbingEnabled():Boolean
		{
			return _keyboardTabbingEnabled;
		}
		
		/**
		 * @private
		 */
		public function set keyboardTabbingEnabled(value:Boolean):void
		{
			_keyboardTabbingEnabled = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
			DebugManager.setDebugForChildren(this, value);
		}

		/**
		 * Checks if one of the buttons has the given value
		 */
		public function hasValue(value:*):Boolean 
		{
			for each (var selection:Selection in _items)
			{
				if (selection.value == value) return true;
			}
			return false;
		}
		
		public function getValueForButton(item:ISelectable):*
		{
			for each (var selection:Selection in _items)
			{
				if (selection.item == item) return selection.value;
			}
			
			return null;
		}

		/**
		 * If set to true the RadioGroup will dispatch an FormElementEvent.SUBMIT on change and the form (if enabled) can be submitted
		 */
		public function get submitOnChange():Boolean
		{
			return _submitOnChange;
		}
		
		/**
		 * @private
		 */
		public function set submitOnChange(value:Boolean):void
		{
			_submitOnChange = value;
		}

		/**
		 * Selects the next item in the list
		 */
		public function next():void
		{
			var item:ISelectable;
			var leni:int = _items.length;
			for (var i:int = 0; i < leni ;i++)
			{
				if (Selection(_items[i]).item == _selected)
				{
					item = Selection(_items[++i < leni ? i : 0]).item;
					if (item is IFocusable)
					{
						(item as IFocusable).focus = true;
					}
					else
					{
						FocusManager.focus = item as InteractiveObject;
					}
					if (_selected) selected = item;
					return;
				}
			}
		}

		/**
		 * Selects the previous item in the list
		 */
		public function previous():void
		{
			var item:ISelectable;
			var leni:int = _items.length;
			for (var i:int = 0; i < leni ; i++) 
			{
				if (Selection(_items[i]).item == _selected)
				{
					item = Selection(_items[--i >= 0 ? i : leni-1]).item;
					if (item is IFocusable)
					{
						(item as IFocusable).focus = true;
					}
					else
					{
						FocusManager.focus = item as InteractiveObject;
					}
					if (_selected) selected = item;
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
				if (_selected != event.target)
				{
					var oldSelectedButton:ISelectable = _selected;

					_selected = ISelectable(event.target);
					
					if (oldSelectedButton) 
					{
						oldSelectedButton.selected = false;
					}
					if (_dispatchChangeEvent) dispatchEvent(new Event(Event.CHANGE));
				}
			}
			else if (_selected == event.target)
			{
				_selected = null;
				if (_dispatchChangeEvent) dispatchEvent(new Event(Event.CHANGE));
			}
		}

		/**
		 * @private
		 */
		protected function handleKeyDown(event:KeyboardEvent):void
		{
			if (_keyboardTabbingEnabled)
			{
				switch (event.keyCode)
				{
					case Keyboard.DOWN:
					case Keyboard.RIGHT:
					{
						event.stopPropagation();
						next();
						break;
					}	
					case Keyboard.UP:
					case Keyboard.LEFT:
					{
						event.stopPropagation();
						previous();
						break;
					}
					default:
						dispatchEvent(event.clone());
						break;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function handleButtonFocusIn(event:FocusEvent):void
		{
			_focus = true;
			dispatchEvent(event.clone());
		}
		
		/**
		 * @private
		 */
		protected function handleButtonFocusOut(event:FocusEvent):void
		{
			_focus = false;
			dispatchEvent(event.clone());
		}
		
		private function handleKeyFocusChange(event:FocusEvent):void 
		{
			event.preventDefault();
		}

		private function handleChange(event:Event):void
		{
			if (_submitOnChange) if (_submitOnChange) dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
		}
		
		private function handleItemDestruct(event:DestructEvent):void
		{
			if (event.target is ISelectable) remove(ISelectable(event.target));
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
			removeAllStrongEventListenersForType(Event.CHANGE);
			removeAllButtons();
			_selected = null;
			_items = null;
			
			if (_name) delete RadioGroup._instances[_name];
			
			super.destruct();
		}
	}
}
import temple.common.interfaces.IHasValue;
import temple.common.interfaces.ISelectable;
import temple.core.CoreObject;

final class Selection extends CoreObject
{
	public var item:ISelectable;
	public var position:int;
	
	private var _value:*;

	public function Selection(item:ISelectable, value:*, position:int) 
	{
		this.item = item;
		_value = value;
		this.position = position;
	}

	public function get value():*
	{
		return _value != null ? _value : item is IHasValue ? IHasValue(item).value : null;
	}

	public function set value(value:*):void
	{
		if (item is IHasValue)
		{
			IHasValue(item).value = value;
		}
		else
		{
			_value = value;
		}
	}
	
	override public function destruct():void
	{
		item = null;
		_value = null;
		
		super.destruct();
	}
}