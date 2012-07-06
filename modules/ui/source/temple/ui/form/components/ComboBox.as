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
	import temple.common.interfaces.IHasValue;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.data.collections.ICollection;
	import temple.ui.label.ILabel;
	import temple.ui.scroll.ScrollBehavior;
	import temple.ui.states.StateHelper;
	import temple.ui.states.open.IOpenState;
	import temple.utils.FrameDelay;
	import temple.utils.propertyproxy.IPropertyProxy;
	import temple.utils.types.DisplayObjectContainerUtils;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
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
	public class ComboBox extends InputField implements IList, ILabel
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
				this._list = list;
			}
			else
			{
				this._list = DisplayObjectContainerUtils.findChildOfType(this, IList) as IList;
			}
			
			if (this._list == null) throwError(new TempleError(this, "No List found"));
			
			this.addEventListener(MouseEvent.CLICK, this.handleClick);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouseWheel);
			this.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.handleMouseFocusChange);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);

			this._list.addEventListener(Event.CHANGE, this.handleListChanged);
			this._list.addEventListener(MouseEvent.CLICK, this.handleClick);
			this._list.addEventListener(FocusEvent.FOCUS_IN, this.handleListEvent);
			this._list.addEventListener(FocusEvent.FOCUS_OUT, this.handleListEvent, false, -1);
			this._list.addEventListener(KeyboardEvent.KEY_DOWN, this.handleListEvent);
			this._list.addEventListener(Event.REMOVED_FROM_STAGE, this.handleListRemovedFromStage, false, int.MAX_VALUE);
			this._list.addEventListener(Event.REMOVED_FROM_STAGE, this.handleListRemovedFromStage, true, int.MAX_VALUE);
			
			this.close();
			this.submitOnEnter = false;
			this.selectTextOnFocus = false;
		}

		/**
		 * Opens the drop-down list. Only opens if there are items in the list.
		 */
		public function open():void
		{
			if (!this._list.length) return; 
			
			if (this._closeDelay) this._closeDelay.destruct();
			
			if (!this._isOpen)
			{
				this._list.visible = true;
				this._isOpen = true;
				
				if (this._openOnTop && this.stage)
				{
					var position:Point = this.localToGlobal(new Point(this._list.x, this._list.y));
					this.stage.addChild(DisplayObject(this._list));
					this._list.position = position;
				}
				else
				{
					this.addChild(DisplayObject(this._list));
				}
				StateHelper.showState(this, IOpenState);
				
				this.dispatchEvent(new Event(Event.OPEN));
			}
		}

		/**
		 * Closes the drop-down list.
		 */
		public function close():void
		{
			if (this._list.focus) this.focus = true;
			this._isOpen = false;
			
			if (this.stage && this._list.parent == this.stage)
			{
				this._list.position = this.globalToLocal(new Point(this._list.x, this._list.y));
			}
			// remove list from display list to prevent its height being added to the height of the ComboBox.
			if (this._list.parent)
			{
				this._list.parent.removeChild(this._list as DisplayObject);
			}
			
			StateHelper.hideState(this, IOpenState);
			
			this.dispatchEvent(new Event(Event.CLOSE));
		}

		/**
		 * Gets a reference to the List component that the ComboBox component contains.
		 */
		public function get list():IList
		{
			return this._list;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItem(data:*, label:String = null):void
		{
			this._list.addItem(data, label);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItemAt(data:*, index:uint, label:String = null):void
		{
			this._list.addItemAt(data, index, label);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItems(items:Array, labels:* = null):void
		{
			this._list.addItems(items, labels);
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasItem(value:*):Boolean
		{
			return this._list.hasItem(value);
		}

		/**
		 * @inheritDoc
		 */
		public function getItem(value:*, fromIndex:int = 0):*
		{
			return this._list.getItem(value, fromIndex);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:uint):*
		{
			return this._list.getItemAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:*, index:uint, label:String = null):void
		{
			this._list.setItemAt(data, index, label);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLabel(value:*, fromIndex:int = 0):String
		{
			return this._list.getLabel(value, fromIndex);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLabelAt(index:uint):String
		{
			return this._list.getLabelAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLabelAt(index:uint, label:String):void
		{
			this._list.setLabelAt(index, label);
			
			if (this._list.selectedIndex == index)
			{
				if (this._labelProxy)
				{
					this._labelProxy.setValue(this, "text", IHasValue(this._list).value);
				}
				else
				{
					this.text = this._list.selectedLabel;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function isItemSelected(data:*, label:String = null):Boolean
		{
			return this._list.isItemSelected(data, label);
		}
		
		/**
		 * @inheritDoc
		 */
		public function isIndexSelected(index:uint):Boolean
		{
			return this._list.isIndexSelected(index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItem(data:*, label:String = null):Boolean
		{
			var success:Boolean = this._list.removeItem(data, label);
			if (!this.length) this.close();
			return success;
		}

		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:uint):Boolean
		{
			var success:Boolean = this._list.removeItemAt(index);
			if (!this.length) this.close();
			return success;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAll():void
		{
			this._list.removeAll();
			this.reset();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedIndex():int
		{
			return this._list.selectedIndex;
		}

		/**
		 * @inheritDoc
		 */
		public function set selectedIndex(value:int):void
		{
			this._list.selectedIndex = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedItem():*
		{
			return this._list.selectedItem;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedItem(value:*):void
		{
			this._list.selectedItem = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedLabel():String
		{
			return this._list.selectedLabel;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedLabel(value:String):void
		{
			this._list.selectedLabel = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedItems():Array
		{
			return this._list.selectedItems;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedItems(value:Array):void
		{
			this._list.selectedItems = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedLabels():Vector.<String>
		{
			return this._list.selectedLabels;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedLabels(value:Vector.<String>):void
		{
			this._list.selectedLabels = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():uint
		{
			return this._list.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get allowMultipleSelection():Boolean
		{
			return this._list.allowMultipleSelection;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Allow multiple selection", type="Boolean", defaultValue=false)]
		public function set allowMultipleSelection(value:Boolean):void
		{
			this._list.allowMultipleSelection = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoDeselect():Boolean
		{
			return this._list.autoDeselect;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoDeselect(value:Boolean):void
		{
			this._list.autoDeselect = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get rowHeight():Number
		{
			return this._list.rowHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function set rowHeight(value:Number):void
		{
			this._list.rowHeight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get rowCount():uint
		{
			return this._list.rowCount;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Visible rows", type="Number", defaultValue=10)]
		public function set rowCount(value:uint):void
		{
			this._list.rowCount = value;
		}

		/**
		 * @inheritDoc
		 */
		public function sort(compareFunction:Function):void
		{
			this._list.sort(compareFunction);
		}

		/**
		 * @inheritDoc
		 */
		public function sortOn(names:*, options:* = 0, ...args:*):void
		{
			this._list.sortOn.apply(null, [names, options].concat(args));
		}

		/**
		 * @inheritDoc
		 */
		public function get wrapSearch():Boolean
		{
			return this._list.wrapSearch;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Wrap search", type="Boolean", defaultValue=true)]
		public function set wrapSearch(value:Boolean):void
		{
			this._list.wrapSearch = value;
		}

		/**
		 * @inheritDoc
		 */
		public function searchOnString(string:String, caseSensitive:Boolean = false):void
		{
			this._list.searchOnString(string, caseSensitive);
		}

		/**
		 * @inheritDoc
		 */
		public function get keySearch():Boolean
		{
			return this._list.keySearch;
		}

		/**
		 * @inheritDoc
		 */
		public function set keySearch(value:Boolean):void
		{
			this._list.keySearch = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get scrollBehavior():ScrollBehavior
		{
			return this._list.scrollBehavior;
		}
		
		/**
		 * @inheritDoc 
		 */
		[Inspectable(name="Enabled", type="Boolean", defaultValue=true)]
		override public function set enabled(value:Boolean):void 
		{
			this.mouseEnabled = this.mouseChildren = this.textField.mouseEnabled = value;
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
			return this._list.selectedIndex != -1 ? (this._list as IHasValue).value : (this.editable ? super.value : null);
		}

		/**
		 * @inheritDoc
		 */
		override public function set value(value:*):void
		{
			(this._list as ISetValue).value = value;
			
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
			this._list.reset();
			super.reset();
			this.close();
		}
		
		/**
		 * The colletion that is used to fill the ComboBox
		 */
		public function get dataSource():ICollection 
		{
			return this._dataSource;
		}

		/**
		 * @private
		 */
		[Collection(name="Data source", collectionClass="temple.data.collections.Collection", collectionItem="temple.ui.form.components.ListItemData",identifier="label")]
		public function set dataSource(value:ICollection):void 
		{
			this._dataSource = value;
			
			var leni:int = this._dataSource.length;
			for (var i:int = 0; i < leni ; i++)
			{
				this.addItem(this._dataSource.getItemAt(i));
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
			return this._openOnTop;
		}
		
		/**
		 * @private
		 */
		public function set openOnTop(value:Boolean):void
		{
			this._openOnTop = value;
		}
		
		/**
		 * A Boolean which indicates if the ComboBox should close if an item in the List is selected.
		 */
		public function get autoClose():Boolean
		{
			return this._autoClose;
		}
		
		/**
		 * @private
		 */
		public function set autoClose(value:Boolean):void
		{
			this._autoClose = value;
		}
		
		/**
		 * Proxy for setting the label of the ComboBox based on the value of the list
		 */
		public function get labelProxy():IPropertyProxy
		{
			return this._labelProxy;
		}
		
		/**
		 * @private
		 */
		public function set labelProxy(value:IPropertyProxy):void
		{
			this._labelProxy = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get label():String
		{
			return this.text;
		}

		/**
		 * @inheritDoc
		 */
		public function set label(value:String):void
		{
			this.text = value;
		}
		
		/**
		 * A Boolean which indicates if the ComboBox is currently opened.
		 */
		public function get isOpen():Boolean
		{
			return this._isOpen;
		}
		
		/**
		 * @inheritDoc
		 */
		public function selectItem(data:*):Boolean
		{
			return this._list.selectItem(data);
		}

		/**
		 * @inheritDoc
		 */
		public function deselectItem(data:*):Boolean
		{
			return this._list.deselectItem(data);
		}
		
		override protected function updateHint():void 
		{
			if (!this.focus || !this._showsHint || this.textField.type == TextFieldType.INPUT) 
			{
				super.updateHint();
			}
		}
		
		protected function handleListChanged(event:Event):void
		{
			if (this.isDestructed) return;
			
			if (this._list.selectedIndex != -1)
			{
				if (this._labelProxy)
				{
					this._labelProxy.setValue(this, "text", IHasValue(this._list).value);
				}
				else
				{
					this.text = this._list.selectedLabel;
				}
			}
			else
			{
				this.dispatchEvent(new Event(Event.CHANGE));
				
				if (this.submitOnChange)
				{
					this.dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
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
					this.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, NaN, NaN, null, event.ctrlKey, event.altKey, event.shiftKey));
					break;
				}
				case Keyboard.UP:
				case Keyboard.DOWN:
				{
					if (!this._list.focus)
					{
						event.stopPropagation();
						this.open();
						this._list.focus = true;
					}
					break;
				}
				case Keyboard.ESCAPE:
				{
					event.stopPropagation();
					this.close();
					break;
				}
				default:
				{
					if (!this._list.focus && this.keySearch)
					{
						event.preventDefault();
						// search for an item starting with this character
						this.searchOnString(String.fromCharCode(event.charCode).toUpperCase());
						break;
					}
				}
			}
		}
		
		private function handleListEvent(event:Event):void 
		{
			if (!this.contains(this._list as DisplayObject))
			{
				this.dispatchEvent(event.clone());
			}
		}

		protected function handleClick(event:MouseEvent):void
		{
			if (this._autoClose && event.currentTarget == this._list && event.target is IListRow || !this._list.contains(event.target as DisplayObject))
			{
				if (this._isOpen)
				{
					this.close();
				}
				else
				{
					this.open();
				}
			}
		}
		
		protected function handleMouseWheel(event:MouseEvent):void
		{
			if (event.target is DisplayObject && (event.target == this._list || this._list.contains(event.target as DisplayObject))) return;
			
			if (event.delta > 0)
			{
				this._list.selectedIndex--;
			}
			else
			{
				this._list.selectedIndex++;
			}
			event.stopPropagation();
		}
		
		protected function handleListFocusChange(event:FocusEvent):void
		{
			event.stopImmediatePropagation();
			this.open();
		}

		override protected function handleFocusIn(event:FocusEvent):void 
		{
			super.handleFocusIn(event);
			if (this._closeDelay) this._closeDelay.destruct();
		}

		override protected function handleFocusOut(event:FocusEvent):void 
		{
			if (event.relatedObject == null || !this.contains(event.relatedObject) && !this._list.contains(event.relatedObject))
			{
				super.handleFocusOut(event);
				if (this._autoClose)
				{
					if (this._closeDelay) this._closeDelay.destruct();
					this._closeDelay = new FrameDelay(this.close);
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
			if (this._isOpen)
			{
				this.close();
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
			this.removeAllStrongEventListenersForType(Event.CHANGE);
			
			if (this._list && !this._list.isDestructed)
			{
				this._list.removeEventListener(Event.CHANGE, this.handleListChanged);
				this._list.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleListRemovedFromStage);
				this._list.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleListRemovedFromStage, true);
				this._list.destruct();
				this._list = null;
			}
			if (this._closeDelay)
			{
				this._closeDelay.destruct();
				this._closeDelay = null;
			}
			this._dataSource = null;
			this._labelProxy = null;
			
			super.destruct();
		}
	}
}