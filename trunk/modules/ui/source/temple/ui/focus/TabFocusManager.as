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

package temple.ui.focus 
{
	import temple.common.interfaces.IEnableable;
	import temple.common.interfaces.IFocusable;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.utils.keys.KeyManager;

	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;


	/**
	 * @eventType flash.events.KeyboardEvent.KEY_DOWN
	 */
	[Event(name = "keyDown", type = "flash.events.KeyboardEvent")]

	/**
	 * Class for managing focus on UI components that implement IFocusable.
	 * 
	 * <p>Use of this class overrides default tab button behavior. Only UI components added to an instance of this class
	 * can get focus through use of the tab key. Consecutive presses on the TAB key will cycle through the list of items
	 * in order of addition, unless a specific tab index has been set on any of them. With SHIFT-TAB the list is cycled 
	 * in reversed order.</p>
	 * 
	 * @example
	 * Suppose two objects of type InputField have been defined on the timeline, with instance names "mcName" &amp; "mcEmail". Use the following code to allow focus management on them:
	 * <listing version="3.0">
	 * 	focusManager = new TabFocusManager();
	 * 	focusManager.add(mcName);
	 * 	focusManager.add(mcEmail);
	 * 	</listing>
	 * 	
	 * 	@author Thijs Broerse
	 */
	public class TabFocusManager extends CoreEventDispatcher implements IFocusable, IDebuggable, IEnableable
	{
		private var _items:Vector.<ItemData>;
		private var _loop:Boolean;
		private var _debug:Boolean;
		private var _enabled:Boolean = true;

		/**
		 * Constructor
		 */
		public function TabFocusManager(loop:Boolean = true) 
		{
			_loop = loop;
			_items = new Vector.<ItemData>();
			addToDebugManager(this);
		}

		/**
		 * Clear list of focus elements
		 */
		public function clear():void 
		{
			while (_items.length) remove(ItemData(_items.shift()).item);
		}

		/**
		 * Sets the focus to a specific element.
		 * @param inItem: previously added item
		 */
		public function setFocus(item:IFocusable):void 
		{
			item.focus = true;
		}

		/**
		 * Add an item for focus management; optionally set the tab index for the item.
		 * @param item item to be used in focus management
		 * @param position zero-based, optional. If ommitted (or set to -1), it will be added to the end of the list. If an element was already found at the position specifed, it will be inserted prior to the existing element
		 * @return Boolean indicating if addition was successfull.
		 */
		public function add(item:IFocusable, tabIndex:int = -1):Boolean 
		{
			if (debug) logDebug("add: " + item);
			
			// check if element exists
			if (item == null) 
			{
				throwError(new TempleError(this, "No element specified for addition"));
			}

			// check if already added	
			if (indexOf(item) != -1) 
			{
				logWarn("addElement: Element already in list: " + item);
				return false;
			}
			
			if (item is IEventDispatcher)
			{
				(item as IEventDispatcher).addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				(item as IEventDispatcher).addEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleKeyFocusChange);
			}
			
			// add element depending on value of position
			if (tabIndex == -1 || _items.length == 0) 
			{
				_items.push(new ItemData(item, tabIndex));
			}
			else 
			{
				var leni:int = _items.length;
				var tempItem:ItemData;
				for (var i:int = 0;i < leni; i++)
				{
					tempItem = ItemData(_items[i]);
					
					if (tempItem.position >= tabIndex || tempItem.position == -1)
					{
						_items.splice(i, 0, new ItemData(item, tabIndex));
						break;
					}
					else if (i == leni - 1)
					{
						_items.push(new ItemData(item, tabIndex));
					}
				}
			}
			if (debug) logDebug("items: " + _items);
			
			return true;
		}

		/**
		 * Removes an element
		 */
		public function remove(item:IFocusable):void
		{
			if (item is IEventDispatcher)
			{
				(item as IEventDispatcher).removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				(item as IEventDispatcher).removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleKeyFocusChange);
			}
			for (var i:int = _items.length - 1;i >= 0; i--) 
			{
				if (ItemData(_items[i]).item == item)
				{
					ItemData(_items.splice(i, 1)[0]).destruct();
					return;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return getCurrentFocusIndex() != -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			var item:IFocusable = getCurrentFocusItem();
			
			if (value && !item)
			{
				if (_items.length)
				{
					// check if shift key is pressed
					if (KeyManager.isDown(Keyboard.SHIFT))
					{
						ItemData(_items[_items.length - 1]).item.focus = true;
					}
					else
					{
						ItemData(_items[0]).item.focus = true;
					}
				}
			}
			else if (!value && item) item.focus = false;
		}
		
		/**
		 * A Boolean that indicates if tabbiing should loop. If true, the first item will get the focus when tabbing on the last item.
		 * @default true
		 */
		public function get loop():Boolean
		{
			return _loop;
		}
		
		/**
		 * @private
		 */
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			_enabled = true;
		}

		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			_enabled = false;
		}

		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}

		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		/**
		 * Returns a clone of the item list
		 */
		public function get items():Array
		{
			if (_items)
			{
				var items:Array = [];
				var leni:int = _items.length;
				for (var i:int = 0; i < leni; i++)
				{
					items.push(ItemData(_items[i]).item);
				}
				return items;
			}
			return null;
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
		}
		
		private function handleKeyDown(event:KeyboardEvent):void
		{
			if (_enabled && event.keyCode == Keyboard.TAB)
			{
				if (debug) logDebug("handleKeyDown: tab received from: " + event.target + ", through: " + event.currentTarget);
				
				if (event.shiftKey)
				{
					if (_loop || getCurrentFocusIndex() > 0)
					{
						event.stopImmediatePropagation();
						focusPreviousItem();
					}
					else
					{
						dispatchEvent(event.clone());
					}
				}
				else if (_loop || getCurrentFocusIndex() < _items.length - 1)
				{
					event.stopImmediatePropagation();
					focusNextItem();
				}
				else
				{
					dispatchEvent(event.clone());
				}
			}
		}

		/**
		 * Set focus to next item in list.
		 */
		public function focusNextItem():void 
		{
			if (debug) logDebug("focusNextItem: ");
			
			// check if focus is in current list
			var index:Number = getCurrentFocusIndex();
			if (index == -1) return;
	
			// store previous focus
			var prev:Number = index;
			
			var item:IFocusable;
			
			while (item == null)
			{
				// increment & check limit
				index++;
				if (index > _items.length - 1) index = 0;
				
				if (index == prev)
				{
					// we checked all items, no next item found
					return;
				}
				
				item = ItemData(_items[index]).item;
				
				// check if new item is enabled, if not, set to null so we check next
				if (item is IEnableable && IEnableable(item).enabled == false)
				{
					item = null;
				}
			}
			item.focus = true;
		}

		/**
		 * Set focus to previous item in list.
		 */
		public function focusPreviousItem():void 
		{
			if (debug) logDebug("focusPreviousItem: ");
			
			// check if focus is in current list
			var index:Number = getCurrentFocusIndex();
			if (index == -1) return;
	
			// store previous focus
			var prev:Number = index;
			
			var item:IFocusable;
			
			while (item == null)
			{
				// decrement & check limit
				index--;
				if (index < 0) index = _items.length - 1;
				
				if (index == prev)
				{
					// we checked all items, no next item found
					return;
				}
				
				item = ItemData(_items[index]).item;
				
				// check if new item is enabled, if not, set to null so we check next
				if (item is IEnableable && IEnableable(item).enabled == false)
				{
					item = null;
				}
			}
			item.focus = true;
		}

		/**
		 * Checks if any of our elements has focus and returns its index
		 * @return the index of the current item, or -1 if none was found
		 */
		public function getCurrentFocusIndex():int 
		{
			if (!_items) return -1;
			
			var len:uint = _items.length;
			for (var i:int = 0;i < len; ++i) 
			{
				if (ItemData(_items[i]).item.focus) return i;
			}
			return -1;
		}

		public function getCurrentFocusItem():IFocusable 
		{
			var len:uint = _items.length;
			for (var i:int = 0;i < len; ++i) 
			{
				if (ItemData(_items[i]).item.focus) return ItemData(_items[i]).item;
			}
			return null;
		}

		private function indexOf(item:IFocusable):int
		{
			var leni:int = _items.length;
			for (var i:int = 0;i < leni; i++)
			{
				if (ItemData(_items[i]).item == item) return i;
			}
			return -1;
		}
		
		private function handleKeyFocusChange(event:FocusEvent):void 
		{
			event.preventDefault();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_items)
			{
				clear();
				_items = null;
			}
			
			super.destruct();
		}
	}
}
import temple.common.interfaces.IFocusable;
import temple.core.CoreObject;

class ItemData extends CoreObject
{
	public var item:IFocusable;
	public var position:int;

	public function ItemData(item:IFocusable, position:int) 
	{
		toStringProps.push('position', 'item');
		this.item = item;
		this.position = position;
	}
	
	override public function destruct():void
	{
		item = null;
		super.destruct();
	}
}