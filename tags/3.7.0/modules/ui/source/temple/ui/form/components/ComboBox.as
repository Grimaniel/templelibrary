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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.IOpenable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.data.collections.ICollection;
	import temple.ui.labels.ILabel;
	import temple.ui.scroll.ScrollBehavior;
	import temple.ui.states.StateHelper;
	import temple.ui.states.open.IOpenState;
	import temple.utils.FrameDelay;
	import temple.utils.propertyproxy.IPropertyProxy;
	import temple.utils.types.DisplayObjectContainerUtils;

	
	/**
	 * A ComboBox let the user select from a (predefined) list of options.
	 * A ComboBox is a combination of an InputField and a List. When the ComboBox is closed (collapsed),
	 * the List is not visible. If the ComboBox is opened (expanded) the List is visible. The user 
	 * selects an option from the List by clicking on an item in the List.
	 * 
	 * <p>The ComboBox extends the InputField and therefor it needs (at least) a TextField. I also needs
	 * a List (or an object which implements IList). The TextField and List can be passed through the
	 * constructor, when you create a ComboBox by code.</p>
	 * <p>If you want to create a ComboBox in the Flash IDE you just need to add a TextField and a List
	 * on the display list of the ComboBox. Make sure you set the class
	 * (temple.ui.form.components.ComboBox) of the ComboBox as base class.</p>
	 * 
	 * <p>A ComboBox can be used in a Form and supports ErrorStates, FocusStates and OpenStates.</p>
	 * 
	 * <p>The ComboBox also support keyboard navigation. You can use the following keys to control the
	 * ComboBox:
	 * <ul>
	 * 	<li>arrow keys: opens the ComboBox and steps through the options of the list.</li>
	 * 	<li>space or enter: selects the focussed item of the list.</li>
	 * 	<li>escape: closes the ComboBox</li>
	 * 	<li>characters: selects an item of the list which matches the pressed character.</li>
	 * </ul>
	 * </p>
	 * 
	 * @see temple.ui.form.components.InputField
	 * @see temple.ui.form.components.List
	 * @see temple.ui.form.components.IList
	 * @see temple.ui.form.Form
	 * @see temple.ui.states.error.IErrorState
	 * @see temple.ui.states.focus.IFocusState
	 * @see temple.ui.states.open.IOpenState
	 * 
	 * @includeExample ./ComboBoxExample.as
	 * @includeExample ./ComboBoxComponentExample.as
	 * @includeExample ../FormExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ComboBox extends InputField implements IList, ILabel, IOpenable
	{
		private var _list:IList;
		private var _isOpen:Boolean;
		private var _dataSource:ICollection;
		private var _openOnTop:Boolean = true;
		
		private var _autoClose:Boolean = true;
		private var _closeDelay:FrameDelay;
		private var _labelProxy:IPropertyProxy;

		/**
		 * Creates a new ComboBox. If you create a ComboBox by code you must provide a TextField and a List.
		 * If you create a ComboBox in the Flash IDE you can place a TextField and a List on the display list
		 * of the ComboBox.
		 * @param textField the TextField of the ComboBox, must be provided when creating a ComboBox in code.
		 * @param list the list of the ComboBox, must be provided when creating a ComboBox in code.
		 */
		public function ComboBox(textField:TextField = null, list:IList = null)
		{
			super(textField);
			
			if (list)
			{
				_list = list;
			}
			else
			{
				_list = DisplayObjectContainerUtils.getChildOfType(this, IList) as IList;
			}
			
			if (_list == null) throwError(new TempleError(this, "No List found"));
			
			addEventListener(MouseEvent.CLICK, handleClick);
			addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, handleMouseFocusChange);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);

			_list.addEventListener(Event.CHANGE, handleListChanged);
			_list.addEventListener(MouseEvent.CLICK, handleClick);
			_list.addEventListener(FocusEvent.FOCUS_IN, handleListEvent);
			_list.addEventListener(FocusEvent.FOCUS_OUT, handleListEvent, false, -1);
			_list.addEventListener(KeyboardEvent.KEY_DOWN, handleListEvent);
			_list.addEventListener(Event.REMOVED_FROM_STAGE, handleListRemovedFromStage, false, int.MAX_VALUE);
			_list.addEventListener(Event.REMOVED_FROM_STAGE, handleListRemovedFromStage, true, int.MAX_VALUE);
			
			close();
			submitOnEnter = false;
			selectTextOnFocus = false;
		}

		/**
		 * Opens the drop-down list. Only opens if there are items in the list.
		 */
		public function open():void
		{
			if (!_list.length) return; 
			
			if (_closeDelay) _closeDelay.destruct();
			
			if (!_isOpen)
			{
				_list.visible = true;
				_isOpen = true;
				
				if (_openOnTop && stage)
				{
					var position:Point = localToGlobal(new Point(_list.x, _list.y));
					stage.addChild(DisplayObject(_list));
					_list.position = position;
				}
				else
				{
					addChild(DisplayObject(_list));
				}
				StateHelper.showState(this, IOpenState);
				
				dispatchEvent(new Event(Event.OPEN));
			}
		}

		/**
		 * Closes the drop-down list.
		 */
		public function close():void
		{
			if (_list.focus) focus = true;
			_isOpen = false;
			
			if (stage && _list.parent == stage)
			{
				_list.position = globalToLocal(new Point(_list.x, _list.y));
			}
			// remove list from display list to prevent its height being added to the height of the ComboBox.
			if (_list.parent)
			{
				_list.parent.removeChild(_list as DisplayObject);
			}
			
			StateHelper.hideState(this, IOpenState);
			
			dispatchEvent(new Event(Event.CLOSE));
		}

		/**
		 * Gets a reference to the List component that the ComboBox component contains.
		 */
		public function get list():IList
		{
			return _list;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItem(data:*, label:String = null):void
		{
			_list.addItem(data, label);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItemAt(data:*, index:uint, label:String = null):void
		{
			_list.addItemAt(data, index, label);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItems(items:Array, labels:* = null):void
		{
			_list.addItems(items, labels);
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasItem(value:*):Boolean
		{
			return _list.hasItem(value);
		}

		/**
		 * @inheritDoc
		 */
		public function getItem(value:*, fromIndex:int = 0):*
		{
			return _list.getItem(value, fromIndex);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:uint):*
		{
			return _list.getItemAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:*, index:uint, label:String = null):void
		{
			_list.setItemAt(data, index, label);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLabel(value:*, fromIndex:int = 0):String
		{
			return _list.getLabel(value, fromIndex);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLabelAt(index:uint):String
		{
			return _list.getLabelAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLabelAt(index:uint, label:String):void
		{
			_list.setLabelAt(index, label);
			
			if (_list.selectedIndex == index)
			{
				if (_labelProxy)
				{
					_labelProxy.setValue(this, "text", IHasValue(_list).value);
				}
				else
				{
					text = _list.selectedLabel;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function isItemSelected(data:*, label:String = null):Boolean
		{
			return _list.isItemSelected(data, label);
		}
		
		/**
		 * @inheritDoc
		 */
		public function isIndexSelected(index:uint):Boolean
		{
			return _list.isIndexSelected(index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItem(data:*, label:String = null):Boolean
		{
			var success:Boolean = _list.removeItem(data, label);
			if (!length) close();
			return success;
		}

		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:uint):Boolean
		{
			var success:Boolean = _list.removeItemAt(index);
			if (!length) close();
			return success;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAll():void
		{
			_list.removeAll();
			reset();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedIndex():int
		{
			return _list.selectedIndex;
		}

		/**
		 * @inheritDoc
		 */
		public function set selectedIndex(value:int):void
		{
			_list.selectedIndex = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedItem():*
		{
			return _list.selectedItem;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedItem(value:*):void
		{
			_list.selectedItem = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedLabel():String
		{
			return _list.selectedLabel;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedLabel(value:String):void
		{
			_list.selectedLabel = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedItems():Array
		{
			return _list.selectedItems;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedItems(value:Array):void
		{
			_list.selectedItems = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedLabels():Vector.<String>
		{
			return _list.selectedLabels;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedLabels(value:Vector.<String>):void
		{
			_list.selectedLabels = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():uint
		{
			return _list.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get allowMultipleSelection():Boolean
		{
			return _list.allowMultipleSelection;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Allow multiple selection", type="Boolean", defaultValue=false)]
		public function set allowMultipleSelection(value:Boolean):void
		{
			_list.allowMultipleSelection = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoDeselect():Boolean
		{
			return _list.autoDeselect;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoDeselect(value:Boolean):void
		{
			_list.autoDeselect = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get rowHeight():Number
		{
			return _list.rowHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function set rowHeight(value:Number):void
		{
			_list.rowHeight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get rowCount():uint
		{
			return _list.rowCount;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Visible rows", type="Number", defaultValue=10)]
		public function set rowCount(value:uint):void
		{
			_list.rowCount = value;
		}

		/**
		 * @inheritDoc
		 */
		public function sort(compareFunction:Function):void
		{
			_list.sort(compareFunction);
		}

		/**
		 * @inheritDoc
		 */
		public function sortOn(names:*, options:* = 0, ...args:*):void
		{
			_list.sortOn.apply(null, [names, options].concat(args));
		}

		/**
		 * @inheritDoc
		 */
		public function get wrapSearch():Boolean
		{
			return _list.wrapSearch;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Wrap search", type="Boolean", defaultValue=true)]
		public function set wrapSearch(value:Boolean):void
		{
			_list.wrapSearch = value;
		}

		/**
		 * @inheritDoc
		 */
		public function searchOnString(string:String, caseSensitive:Boolean = false):void
		{
			_list.searchOnString(string, caseSensitive);
		}

		/**
		 * @inheritDoc
		 */
		public function get keySearch():Boolean
		{
			return _list.keySearch;
		}

		/**
		 * @inheritDoc
		 */
		public function set keySearch(value:Boolean):void
		{
			_list.keySearch = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get scrollBehavior():ScrollBehavior
		{
			return _list.scrollBehavior;
		}
		
		/**
		 * @inheritDoc 
		 */
		[Inspectable(name="Enabled", type="Boolean", defaultValue=true)]
		override public function set enabled(value:Boolean):void 
		{
			mouseEnabled = mouseChildren = textField.mouseEnabled = value;
		}

		/**
		 * Gets or sets a Boolean value that indicates whether the ComboBox component is editable or read-only.
		 * A value of true indicates that the ComboBox component is editable; a value of false indicates that it is not.
		 * 
		 * <p>In an editable ComboBox component, a user can enter values into the text box that do not appear in the drop-down list.
		 * The text box displays the text of the item in the list. If a ComboBox component is not editable, text cannot be entered into the text box.</p>
		 */
		override public function get editable():Boolean 
		{
			return super.editable;
		}

		/**
		 * @inheritDoc
		 */
		override public function get value():* 
		{
			return _list.selectedIndex != -1 ? (_list as IHasValue).value : (editable ? super.value : null);
		}

		/**
		 * @inheritDoc
		 */
		override public function set value(value:*):void
		{
			_list.value = value;
			
			if (this.value != value)
			{
				super.value = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			_list.reset();
			super.reset();
			close();
		}
		
		/**
		 * The colletion that is used to fill the ComboBox
		 */
		public function get dataSource():ICollection 
		{
			return _dataSource;
		}

		/**
		 * @private
		 */
		[Collection(name="Data source", collectionClass="temple.data.collections.Collection", collectionItem="temple.ui.form.components.ListItemData",identifier="label")]
		public function set dataSource(value:ICollection):void 
		{
			_dataSource = value;
			
			var leni:int = _dataSource.length;
			for (var i:int = 0; i < leni ; i++)
			{
				addItem(_dataSource.getItemAt(i));
			}
		}

		/**
		 * @inheritDoc
		 * 
		 * Overridden to get rid of Inspectable
		 */
		override public function set submitOnEnter(value:Boolean):void
		{
			super.submitOnEnter = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Overridden to get rid of Inspectable
		 */
		override public function set prefillText(value:String):void 
		{
			super.prefillText = value;
		}
		
		/**
		 * A Boolean that indicates if the List should open on top of everything else on the stage.
		 * @default true
		 */
		public function get openOnTop():Boolean
		{
			return _openOnTop;
		}
		
		/**
		 * @private
		 */
		public function set openOnTop(value:Boolean):void
		{
			_openOnTop = value;
		}
		
		/**
		 * A Boolean which indicates if the ComboBox should close if an item in the List is selected.
		 */
		public function get autoClose():Boolean
		{
			return _autoClose;
		}
		
		/**
		 * @private
		 */
		public function set autoClose(value:Boolean):void
		{
			_autoClose = value;
		}
		
		/**
		 * Proxy for setting the label of the ComboBox based on the value of the list
		 */
		public function get labelProxy():IPropertyProxy
		{
			return _labelProxy;
		}
		
		/**
		 * @private
		 */
		public function set labelProxy(value:IPropertyProxy):void
		{
			_labelProxy = value;
		}
		
		/**
		 * A Boolean which indicates if the ComboBox is currently opened.
		 */
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		/**
		 * @inheritDoc
		 */
		public function selectItem(data:*):Boolean
		{
			return _list.selectItem(data);
		}

		/**
		 * @inheritDoc
		 */
		public function deselectItem(data:*):Boolean
		{
			return _list.deselectItem(data);
		}
		
		override protected function updateHint():void 
		{
			if (!focus || !showsHint || textField.type == TextFieldType.INPUT) 
			{
				super.updateHint();
			}
		}
		
		protected function handleListChanged(event:Event):void
		{
			if (isDestructed) return;
			
			if (_list.selectedIndex != -1)
			{
				if (_labelProxy)
				{
					_labelProxy.setValue(this, "text", IHasValue(_list).value);
				}
				else
				{
					text = _list.selectedLabel;
				}
			}
			else
			{
				dispatchEvent(new Event(Event.CHANGE));
				
				if (submitOnChange)
				{
					dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
				}
			}
		}
		
		override protected function handleKeyDown(event:KeyboardEvent):void
		{
			super.handleKeyDown(event);
			
			switch (event.keyCode)
			{
				case Keyboard.SPACE:
				case Keyboard.ENTER:
				{
					event.stopPropagation();
					dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, NaN, NaN, null, event.ctrlKey, event.altKey, event.shiftKey));
					break;
				}
				case Keyboard.UP:
				case Keyboard.DOWN:
				{
					if (!_list.focus)
					{
						event.stopPropagation();
						open();
						_list.focus = true;
					}
					break;
				}
				case Keyboard.ESCAPE:
				{
					event.stopPropagation();
					close();
					break;
				}
				default:
				{
					if (!_list.focus && keySearch)
					{
						event.preventDefault();
						// search for an item starting with this character
						searchOnString(String.fromCharCode(event.charCode).toUpperCase());
						break;
					}
				}
			}
		}
		
		private function handleListEvent(event:Event):void 
		{
			if (!contains(_list as DisplayObject))
			{
				dispatchEvent(event.clone());
			}
		}

		protected function handleClick(event:MouseEvent):void
		{
			if (!isDestructed && (_autoClose && event.currentTarget == _list && event.target is IListRow || !_list.contains(event.target as DisplayObject)))
			{
				if (_isOpen && !allowMultipleSelection)
				{
					close();
				}
				else
				{
					open();
				}
			}
		}
		
		protected function handleMouseWheel(event:MouseEvent):void
		{
			if (event.target is DisplayObject && (event.target == _list || _list.contains(event.target as DisplayObject))) return;
			
			if (event.delta > 0)
			{
				_list.selectedIndex--;
			}
			else
			{
				_list.selectedIndex++;
			}
			event.stopPropagation();
		}
		
		protected function handleListFocusChange(event:FocusEvent):void
		{
			event.stopImmediatePropagation();
			open();
		}

		override protected function handleFocusIn(event:FocusEvent):void 
		{
			super.handleFocusIn(event);
			if (_closeDelay) _closeDelay.destruct();
		}

		override protected function handleFocusOut(event:FocusEvent):void 
		{
			if (event.relatedObject == null || !contains(event.relatedObject) && !_list.contains(event.relatedObject))
			{
				super.handleFocusOut(event);
				if (_autoClose)
				{
					if (_closeDelay) _closeDelay.destruct();
					_closeDelay = new FrameDelay(close);
				}
			}
			else
			{
				event.stopImmediatePropagation();
			}
		}

		private function handleMouseFocusChange(event:FocusEvent):void 
		{
			event.preventDefault();
		}
		
		private function handleRemovedFromStage(event:Event):void
		{
			if (_isOpen)
			{
				close();
			}
		}
		
		private function handleListRemovedFromStage(event:Event):void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			removeAllStrongEventListenersForType(Event.CHANGE);
			
			if (_list && !_list.isDestructed)
			{
				_list.removeEventListener(Event.CHANGE, handleListChanged);
				_list.removeEventListener(Event.REMOVED_FROM_STAGE, handleListRemovedFromStage);
				_list.removeEventListener(Event.REMOVED_FROM_STAGE, handleListRemovedFromStage, true);
				_list.destruct();
				_list = null;
			}
			if (_closeDelay)
			{
				_closeDelay.destruct();
				_closeDelay = null;
			}
			_dataSource = null;
			_labelProxy = null;
			
			super.destruct();
		}
	}
}