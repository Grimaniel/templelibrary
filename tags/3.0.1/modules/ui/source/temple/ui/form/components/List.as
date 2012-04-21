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
	import temple.common.events.SelectEvent;
	import temple.common.interfaces.IResettable;
	import temple.common.interfaces.ISelectable;
	import temple.core.destruction.Destructor;
	import temple.core.destruction.IDestructible;
	import temple.core.display.CoreSprite;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.TempleRangeError;
	import temple.core.errors.throwError;
	import temple.data.collections.ICollection;
	import temple.ui.focus.FocusManager;
	import temple.ui.form.validation.IHasError;
	import temple.ui.scroll.ScrollComponent;
	import temple.ui.scroll.ScrollEvent;
	import temple.ui.states.StateHelper;
	import temple.utils.DefinitionProvider;
	import temple.utils.TimeOut;
	import temple.utils.propertyproxy.IPropertyProxy;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;


	/**
	 * A List let the user select from a (predefined) list of items. An item is a data object with or without a label.
	 * An item is visualized by a ListRow. For performance reasons the List does not create a row for each item, but
	 * only for the visible items (defined by the rowCount property). The rows are reused for the items when the user
	 * scrolls the List.
	 * 
	 * <p>A List extends the ScrollComponent and there for it supports scrolling, liquid and a ScrollBar.</p>
	 * 
	 * <p>A List needs at least a class which the List uses to create the rows. This class can be passed  in the
	 * constructor if you create a List by code. Or you can place one (ore more) items on the display list of the List
	 * in the Flash IDE. If the List is created in the Flash IDE, the List will automatically search it's display list
	 * for ListRows. If the List finds any ListRow it will remove the row and uses the class of this row to create the
	 * rows it needs.</p>
	 * 
	 * <p>You can use the ListRow class for the rows, or you can create you own row class. Make sure this row class
	 * implements IListRow.</p>
	 * 
	 * <p>A List can be used in a Form and supports ErrorStates.</p>
	 * 
	 * <p>The List also support keyboard navigation. You can use the following keys to control the
	 * List:
	 * <ul>
	 * 	<li>arrow keys: steps through the options of the List.</li>
	 * 	<li>space or enter: selects the focussed item of the List.</li>
	 * 	<li>shift: when an item is selected and the shift key is down, all items between the previous focussed item
	 * 	and the newly selected item will be selected (or deselected when they were already selected.) Note: this is
	 * 	only when allowMultipleSelection is set to true.</li>
	 * 	<li>controll: when an item is selected and the controll key is down, the item will be selected and the other
	 * 	selected items aren't deselected. (Or the item will be deselected when it was already selected.) Note: this
	 * 	is only when allowMultipleSelection is set to true.</li>
	 * 	<li>characters: selects an item of the list which matches the pressed character.</li>
	 * </ul>
	 * </p>
	 * 
	 * @see temple.ui.form.components.IList
	 * @see temple.ui.form.components.IListRow
	 * @see temple.ui.form.components.ListRow
	 * @see temple.ui.scroll.ScrollComponent
	 * @see temple.ui.scroll.ScrollBar
	 * @see temple.ui.form.Form
	 * @see temple.ui.states.error.IErrorState
	 * 
	 * @author Thijs Broerse
	 */
	public class List extends ScrollComponent implements IList, IHasError, IResettable
	{
		private static const _CLEAR_STRING_SEARCH_DELAY:Number = 500;

		private var _listRowClass:Class;
		
		private var _rows:Vector.<IListRow>;
		private var _items:Vector.<ListItemData>;
		private var _rowItemDictionary:Dictionary;
		private var _selectedItems:Vector.<ListItemData>;
		private var _allowMultipleSelection:Boolean;
		private var _autoDeselect:Boolean = true;
		private var _focus:Boolean;
		private var _focusItem:ListItemData;
		private var _lastSelectedItem:ListItemData;
		private var _wrapSearch:Boolean = true;
		private var _rowHeight:Number;
		private var _rowWidth:Number;
		private var _rowCount:uint;
		private var _searchOnKey:Boolean = true;
		private var _searchString:String = '';
		private var _clearSearchStringTimeOut:TimeOut;
		private var _dataSource:ICollection;
		private var _blockChangeEvent:Boolean;
		private var _toggle:Boolean;
		private var _blockResize:Boolean;
		private var _heightOffset:Number = 0;
		private var _itemPositionProxy:IPropertyProxy;
		private var _rowDataOffset:uint;
		private var _blockAutoScroll:Boolean;
		private var _hasError:Boolean;

		/**
		 * Creates a new List.
		 * @param listRowClass (optional): the Class of the list rows. If this is not specified, it will search the displaylist for an
		 * IListRow object and will use its class for all list rows. The IListRow object will be removed.
		 * <strong>NOTE:</strong> listRowClass must implement IListRow!
		 */
		public function List(listRowClass:Class = null, rowCount:uint = 10)
		{
			this._listRowClass = listRowClass;
			this._items = new Vector.<ListItemData>();
			this._rows = new Vector.<IListRow>();
			this._rowItemDictionary = new Dictionary(true);
			this._rowCount = rowCount;
			this._selectedItems = new Vector.<ListItemData>();
			
			var row:IListRow;
			var rowIndex:Number;
			
			// Loop children to see if there is any IListRow of so, save Class and remove from timeline
			for (var i:int = this.content.numChildren - 1; i >= 0; --i) 
			{
				row = this.content.getChildAt(i) as IListRow;
				if (row)
				{
					rowIndex = i;
					if (!this._rowHeight) this._rowHeight = row.height;
					if (!this._rowWidth) this._rowWidth = row.width + 1;
					
					if (this._listRowClass == null)
					{
						if (DefinitionProvider.hasDefinition(getQualifiedClassName(row)))
						{
							this._listRowClass = DefinitionProvider.getDefinition(getQualifiedClassName(row));
						}
						else
						{
							try
							{
								this._listRowClass = this.loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(row)) as Class;
							}
							catch(error:Error)
							{
								throwError(new TempleError(this, "Class for ListRow \"" + row + "\" not found, try to register the applicationdomain in the DefinitionProvider with DefinitionProvider.registerApplicationDomain(this.stage.loaderInfo.applicationDomain)"));
							}
						}
					}
					
					this._rows.push(row);

					this.content.removeChildAt(i);
				}
			}
			if (this._listRowClass == null) throwError(new TempleError(this, "No class found for rows"));
			
			this.snapToItem = true;
			
			this.addEventListener(FocusEvent.FOCUS_IN, this.handleFocusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
			this.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
			this.addEventListener(MouseEvent.CLICK, this.handleClick);
			
			if (this.content == this)
			{
				this.content = this.addChildAt(new CoreSprite(), rowIndex) as DisplayObjectContainer;
			}
			
			this.content.addEventListener(ScrollEvent.SCROLL, this.handleScroll);
			this.addEventListener(Event.RESIZE, this.content.dispatchEvent);
			
			super.height = 0;
			this.dispatchEvent(new Event(Event.RESIZE));
			
			FocusManager.init(this.stage);
		}

		/**
		 * @inheritDoc
		 */
		public function addItem(data:*, label:String = null):void
		{
			var index:uint = this._items.push(data is ListItemData ? data : new ListItemData(data, label)) - 1;
			if (index <= this._rowCount && index >= this._rows.length)
			{
				this.createRow();
			}
			else if (this._items.length <= this._rowCount + 1)
			{
				this.setRow(this._rows[index], this._items[index]);
				if (this._itemPositionProxy)
				{
					this._itemPositionProxy.setValue(this._rows[index], "y", this._rowHeight * index);
				}
				else
				{
					this._rows[index].y = this._rowHeight * index;
				}
			}
			
			if (!this._blockResize)
			{
				super.height = this._rowHeight * (this._items.length < this._rowCount ? this._items.length : this._rowCount) + this._heightOffset;
				this.dispatchEvent(new Event(Event.RESIZE));
			}
		}

		protected function createRow():void 
		{
			var row:IListRow = new this._listRowClass() as IListRow;
			if (!row)
			{
				throwError(new TempleError(this, "listRowClass does not implement IListRow"));
			}
			else
			{
				var index:uint = this._rowDataOffset + this._rows.length;
				var item:ListItemData = this._items[index];
				
				this.setRow(row, item);
				
				if (isNaN(this._rowHeight)) this._rowHeight = row.height;
				
				if (this._itemPositionProxy)
				{
					this._itemPositionProxy.setValue(row, "y", this._rowHeight * index);
				}
				else
				{
					row.y = this._rowHeight * index;
				}
				
				this.content.addChild(DisplayObject(row));
				this._rows.push(row);
				row.addEventListener(Event.CHANGE, this.handleItemChange);
			}
		}
		
		public function addItemAt(data:*, index:uint, label:String = null):void
		{
			this._items.splice(index, 0, new ListItemData(data, label));
			
			if (index <= this._rowCount + this._rowDataOffset)
			{
				var leni:int = this._rows.length;
				for (var i:int =  Math.max(index - this._rowDataOffset, 0); i < leni; i++)
				{
					this.setRow(this._rows[i], this._items[i + this._rowDataOffset]);
				}
			}
			super.height = this._rowHeight * (this._items.length < this._rowCount ? this._items.length : this._rowCount) + this._heightOffset;
			this.dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * @inheritDoc
		 */
		public function addItems(items:Array, labels:* = null):void
		{
			if (items == null) return;
			
			this._blockResize = true;
			
			var leni:int = items.length;
			for (var i:int = 0;i < leni; i++) 
			{
				if (labels is String)
				{
					if (labels in items[i])
					{
						this.addItem(items[i], items[i][labels]);
					}
					else
					{
						this.logWarn("addItems: item " + items[i] + " doesn't have a property '" + labels + "'");
					}
				}
				else if (labels is Array)
				{
					this.addItem(items[i], labels[i]);
				}
				else if (labels == null)
				{
					this.addItem(items[i]);
				}
				else
				{
					this.logError("addItems: invalid value for items: '" + items + "'");
				}
			}
			this._blockResize = false;
			super.height = this._rowHeight * (this._items.length < this._rowCount ? this._items.length : this._rowCount) + this._heightOffset;
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:uint):*
		{
			return index < this._items.length ? ListItemData(this._items[index]).data : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:*, index:uint, label:String = null):void
		{
			if (index < this._items.length)
			{
				var item:ListItemData = this._items[index];
				item.data = data;
				item.label = label;
				
				if (item.row && this._rowItemDictionary[item.row] == item) this.setRow(item.row, item);
				
				if (this._selectedItems.indexOf(item) != -1)
				{
					this.dispatchEvent(new Event(Event.CHANGE));
				}
			}
			else
			{
				throwError(new TempleRangeError(index, this._items.length, this, "There is no item at index " + index));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLabelAt(index:uint):String
		{
			if (index < this._items.length)
			{
				return this.getLabel(this._items[index]);
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLabelAt(index:uint, label:String):void
		{
			var listItemData:ListItemData;
			
			if (index < this._items.length && (listItemData = this._items[index]))
			{
				listItemData.label = label;
				if (listItemData.row && this._rowItemDictionary[listItemData.row] == listItemData)
				{
					listItemData.row.label = label;
				}
			}
			else
			{
				throwError(new TempleRangeError(index, this._items.length, this, "No item found at index " + index));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItem(data:*, label:String = null):Boolean
		{
			var item:ListItemData;
			for (var i:int = this._items.length - 1;i >= 0; --i) 
			{
				item = this._items[i];
				
				if (item.data === data && (item.label === label || label == null))
				{
					this._items.splice(i, 1);
					
					if (i <= this._rowCount + this._rowDataOffset)
					{
						var leni:int = this._rows.length;
						for (i =  Math.max(i - this._rowDataOffset, 0); i < leni; i++)
						{
							this.setRow(this._rows[i], this._items[i + this._rowDataOffset]);
						}
					}
					
					if (this._focusItem == item) this._focusItem = null;
					if (this._lastSelectedItem == item) this._lastSelectedItem = null;
					
					item.destruct();
					
					super.height = this._rowHeight * (this._items.length < this._rowCount ? this._items.length : this._rowCount) + this._heightOffset;
					this.dispatchEvent(new Event(Event.RESIZE));
					
					return true;
				}
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:uint):Boolean
		{
			if (this._items[index])
			{
				var item:ListItemData = this._items[index];
				
				this._items.splice(index, 1);
					
				if (index <= this._rowCount + this._rowDataOffset)
				{
					var leni:int = this._rows.length;
					for (index =  Math.max(index - this._rowDataOffset, 0); index < leni; index++)
					{
						this.setRow(this._rows[index], this._items[index + this._rowDataOffset]);
					}
				}
				
				if (this._focusItem == item) this._focusItem = null;
				if (this._lastSelectedItem == item) this._lastSelectedItem = null;
				
				item.destruct();
				
				super.height = this._rowHeight * (this._items.length < this._rowCount ? this._items.length : this._rowCount) + this._heightOffset;
				this.dispatchEvent(new Event(Event.RESIZE));
				
				return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAll():void
		{
			if (this._items)
			{
				while (this._items.length) ListItemData(this._items.shift()).destruct();
				this._focusItem = null;
				this._lastSelectedItem = null;
				this._rowDataOffset = 0;
				
				var leni:int = this._rows.length;
				for (var i:int = 0; i < leni; i++)
				{
					this.setRow(this._rows[i], null);
				}
				this.scrollBehavior.scrollV = 0;
				
				super.height = this._heightOffset;
				this.dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedIndex():int
		{
			return this._lastSelectedItem && this._items ? this._items.indexOf(this._lastSelectedItem) : -1;
		}

		/**
		 * @inheritDoc
		 */
		public function set selectedIndex(value:int):void
		{
			if (value == -1)
			{
				this.reset();
			}
			else if (this._items[value])
			{
				this.selectListItemData(this._items[value]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedItem():*
		{
			return this._lastSelectedItem ? this._lastSelectedItem.data : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedItem(value:*):void
		{
			for each (var item : ListItemData in this._items)
			{
				if (item.data == value)
				{
					this.selectListItemData(item);
					return;
				}
			}
			this.logWarn("selectedItem: not found '" + value + "'");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedLabel():String
		{
			return this.getLabel(this._lastSelectedItem);
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedLabel(value:String):void
		{
			for each (var item : ListItemData in this._items)
			{
				if (item.label == value)
				{
					this.selectListItemData(item);
					this.setFocusItem(item);
					break;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedItems():Array
		{
			var items:Array = new Array();
			
			var leni:int = this._items.length;
			var item:ListItemData;
			for (var i:int = 0; i < leni; i++)
			{
				item = ListItemData(this._items[i]);
				if (item.selected) items.push(item.data);
			}
			return items;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedItems(value:Array):void
		{
			var leni:int = this._items.length;
			var item:ListItemData;
			for (var i:int = 0; i < leni; i++)
			{
				item = ListItemData(this._items[i]);
				if (value.indexOf(item.data) != -1) this.selectListItemData(item);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedLabels():Array
		{
			var items:Array = new Array();
			
			var leni:int = this._items.length;
			var item:ListItemData;
			for (var i:int = 0; i < leni; i++)
			{
				item = ListItemData(this._items[i]);
				if (item.selected) items.push(this.getLabel(item));
			}
			return items;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedLabels(value:Array):void
		{
			var leni:int = this._items.length;
			var item:ListItemData;
			for (var i:int = 0; i < leni; i++)
			{
				item = ListItemData(this._items[i]);
				if (value.indexOf(item.label) != -1) this.selectListItemData(item);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function isItemSelected(data:*, label:String = null):Boolean
		{
			for each (var item : ListItemData in this._items) 
			{
				if (item.data === data && item.label === label) return item.selected;
			}
			
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function isIndexSelected(index:uint):Boolean
		{
			return index < this._items.length ? ListItemData(this._items[index]).selected : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():uint
		{
			return this._items ? this._items.length : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get allowMultipleSelection():Boolean
		{
			return this._allowMultipleSelection;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Allow multiple selection", type="Boolean", defaultValue=false)]
		public function set allowMultipleSelection(value:Boolean):void
		{
			this._allowMultipleSelection = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoDeselect():Boolean
		{
			return this._autoDeselect;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Auto deselect", type="Boolean", defaultValue=true)]
		public function set autoDeselect(value:Boolean):void
		{
			this._autoDeselect = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get rowHeight():Number
		{
			return this._rowHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function set rowHeight(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "RowHeight cannot be NaN"));
			
			if (this._rowHeight != value)
			{
				this._rowHeight = value;
				
				var leni:int = this._rows.length;
				for (var i:int = 0;i < leni; i++) 
				{
					IListRow(this._rows[i]).y = (i + this._rowDataOffset) * this._rowHeight;
				}
				
				super.height = this._rowCount * this._rowHeight + this._heightOffset;
				this.dispatchEvent(new Event(Event.RESIZE));
			}
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Row height", type="String")]
		public function set inspectableRowHeight(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.rowHeight = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get rowCount():uint
		{
			return this._rowCount;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Visible rows", type="Number", defaultValue=10)]
		public function set rowCount(value:uint):void
		{
			if (this._rowCount != value)
			{
				this._rowCount = value;
				super.height = this._rowCount * this._rowHeight + this.marginTop + this.marginBottom + this._heightOffset;
				this.updateRows();
				this.dispatchEvent(new Event(Event.RESIZE));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentHeight():Number 
		{
			return this._items ? this._items.length * this._rowHeight : 1;
		}

		override public function set height(value:Number):void 
		{
			if (this.height != value)
			{
				super.height = value;
				var rowCount:uint = Math.ceil((this.height - (this.marginTop + this.marginBottom + this._heightOffset)) / this._rowHeight);
				
				if (rowCount > this._rowCount) this._rowCount = rowCount;
				
				this.dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function sortItems(compareFunction:Function = null):void
		{
			this._items.sort(compareFunction || this.sortItemsAlphabetically);
			
			var leni:int = this._rows.length;
			for (var i:int = 0; i < leni; i++)
			{
				this.setRow(this._rows[i], this._items[i + this._rowDataOffset]);
			}
			this.updateRows();
		}

		private function sortItemsAlphabetically(item1:IListItemData, item2:IListItemData):Number
		{
			if (item1.label.toLowerCase() == item2.label.toLowerCase())
			{
				return 0;
			}
			else if (item1.label.toLowerCase() < item2.label.toLowerCase())
			{
				return -1;
			}
			return 1;
		}

		
		/**
		 * @inheritDoc
		 */
		public function get wrapSearch():Boolean
		{
			return this._wrapSearch;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Wrap search", type="Boolean", defaultValue=true)]
		public function set wrapSearch(value:Boolean):void
		{
			this._wrapSearch = value;
		}

		/**
		 * @inheritDoc
		 */
		public function searchOnString(string:String, caseSensitive:Boolean = false):void
		{
			if (this._items == null) return;
			
			if (this._clearSearchStringTimeOut) this._clearSearchStringTimeOut.destruct();
			this._clearSearchStringTimeOut = new TimeOut(this.clearSearchString, List._CLEAR_STRING_SEARCH_DELAY);

			this._searchString += string;
			
			var searchIndex:int = this._lastSelectedItem ? this.selectedIndex : -1;
			
			if (this._searchString.length == 1) searchIndex++;
			
			var match:Boolean = this.findFirstMatchingItem(this._searchString, caseSensitive, searchIndex,  this._items.length);
			
			if (!match && this._wrapSearch)
			{
				match = this.findFirstMatchingItem(this._searchString, caseSensitive, 0, searchIndex);
			}
			if (!match)
			{
				match = this.findFirstMatchingItem(string, caseSensitive, searchIndex+1,  this._items.length);
				if (!match && this._wrapSearch)
				{
					match = this.findFirstMatchingItem(string, caseSensitive, 0, searchIndex);
				}
			}
		}
		
		/**
		 * The colletion that is used to fill the List
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
		
		private function findFirstMatchingItem(string:String, caseSensitive:Boolean, startIndex:int, endIndex:int):Boolean
		{
			if (startIndex < 0) startIndex = 0;
			
			var label:String;
			for (var i:int = startIndex;i < endIndex; i++)
			{
				label = this.getLabel(this._items[i]);
				if (label && (label.substr(0, string.length) == string || !caseSensitive && label.substr(0, string.length).toLowerCase() == string.toLowerCase()))
				{
					this.selectedIndex = i;
					this.setFocusItem(this._items[i]);
					this.dispatchEvent(new Event(Event.CHANGE));
					return true;
				}
			}
			return false;
		}
		
		private function clearSearchString():void
		{
			this._searchString = '';
		}
		
		/**
		 * @inheritDoc
		 */
		public function get keySearch():Boolean
		{
			return this._searchOnKey;
		}
		
		/**
		 * @private
		 */
		public function set keySearch(value:Boolean):void
		{
			this._searchOnKey = value;
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
				if (!this._focusItem && this._lastSelectedItem)
				{
					this._focusItem = this._lastSelectedItem;
				}
				else if (!this._focusItem && this._items.length)
				{
					this._focusItem = this._items[0];
				}
				if (this._focusItem && this._focusItem.row && this._rowItemDictionary[this._focusItem.row] == this._focusItem)
				{
					this._focusItem.row.focus = value;
					if (!this._allowMultipleSelection) this.selectListItemData(this._focusItem);
				}
			}
			else if (this._focus)
			{
				FocusManager.focus = null;
			}
		}		
		
		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			if (this._selectedItems.length == 0)
			{
				return null;
			}
			else if (this._selectedItems.length == 1 && !this._allowMultipleSelection)
			{
				return ListItemData(this._selectedItems[0]).data;
			}
			else
			{
				var values:Array = new Array();
				
				var leni:int = this._selectedItems.length;
				for (var i:int = 0;i < leni; i++) 
				{
					values.push(ListItemData(this._selectedItems[i]).data);
				}
				return values;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			for each (var item : ListItemData in this._items)
			{
				if (item.data == value)
				{
					this.selectListItemData(item);
					return;
				}
			}
			if (value == null)
			{
				this.selectListItemData(null);
			}
			else
			{
				this.logError("value '" + value + "' not found in List");
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
			StateHelper.showError(this, message);
		}
		
		/**
		 * @inheritDoc 
		 */
		public function hideError():void 
		{
			this._hasError = false;
			StateHelper.hideError(this);
		}

		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			while (this._selectedItems && this._selectedItems.length)
			{
				var listitem:ListItemData = ListItemData(this._selectedItems.shift());
				listitem.selected = false;
				if (this._rowItemDictionary[listitem.row] == listitem && listitem.row is ISelectable) ISelectable(listitem.row).selected = false;
			}
		}
		
		/**
		 * If set to true the List will snap its scroll position to the items
		 */
		public function get snapToItem():Boolean
		{
			return this.scrollBehavior.snapToStep;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Snap to item", type="Boolean", defaultValue="true")]
		public function set snapToItem(value:Boolean):void
		{
			this.scrollBehavior.snapToStep = value;
		}
		
		/**
		 * Indicates if a selected item can be deselected by clicking it again
		 */
		public function get toggle():Boolean
		{
			return this._toggle;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Toggle", type="Boolean", defaultValue=false)]
		public function set toggle(value:Boolean):void
		{
			this._toggle = value;
		}
		
		/**
		 * Extra size to be added to the height of the scrollRect. Usefull if the ListItems uses a hairline as a border. Set this value to 1 if you want to see this line at the bottom of the List.
		 * @default 0
		 */
		public function get heightOffset():Number
		{
			return this._heightOffset;
		}
		
		/**
		 * @private
		 */
		public function set heightOffset(value:Number):void
		{
			if (isNaN(value)) value = 0;
			this._heightOffset = value;
			super.height = this._rowCount * this._rowHeight + this._heightOffset;
		}
		
		/**
		 * IPropertyProxy to set the initial position of every item. Use this for creating a 'show animation'.
		 */
		public function get itemPositionProxy():IPropertyProxy
		{
			return this._itemPositionProxy;
		}
		
		/**
		 * @private
		 */
		public function set itemPositionProxy(value:IPropertyProxy):void
		{
			this._itemPositionProxy = value;
		}

		public function updateRows():void 
		{
			if (!this._rows || !this._rows.length || !this.content || !this.content.scrollRect) return;
			
			// check if we have enough rows
			while (this._items.length > this._rows.length && this._rows.length < this._rowCount + 1)
			{
				this.createRow();
			}
			
			// scroll down, move all rows above the top to the buttom of the list
			var row:IListRow = this._rows[0];
			while (row.y < (this.content.scrollRect.y - this._rowHeight) && this._rowDataOffset + this._rows.length < this._items.length)
			{
				row.y += this._rows.length * this._rowHeight;
				this.setRow(row, this._items[this._rowDataOffset + this._rows.length]);
				this._rows.push(this._rows.shift());
				row = this._rows[0];
				this._rowDataOffset++;
			}
			
			// scroll up, move rows at the bottom to the top (if needed)
			while (row.y > this.content.scrollRect.y + (this._rowDataOffset ? 0 : this.marginTop))
			{
				row = this._rows.pop();
				this._rows.unshift(row);
				row.y -= this._rows.length * this._rowHeight;
				if (this._rowDataOffset) this.setRow(row, this._rowDataOffset ? this._items[--this._rowDataOffset] : null);
			}
		}
		
		public function get listRowClass():Class
		{
			return this._listRowClass;
		}

		public function set listRowClass(value:Class):void
		{
			this._listRowClass = value;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function selectItem(data:*):Boolean
		{
			for each (var item : ListItemData in this._items)
			{
				if (item.data == data)
				{
					this.selectListItemData(item);
					return true;
				}
			}
			return false;
		}

		/**
		 * @inheritDoc 
		 */
		public function deselectItem(data:*):Boolean
		{
			for each (var item : ListItemData in this._items)
			{
				if (item.data == data)
				{
					this.deselectListItemData(item);
					return true;
				}
			}
			return false;
		}
		
		protected function get rows():Vector.<IListRow>
		{
			return this._rows;
		}
		
		protected function get items():Vector.<ListItemData>
		{
			return this._items;
		}

		protected function setRow(row:IListRow, item:ListItemData):void 
		{
			this._rowItemDictionary[row] = item;
			if (item)
			{
				row.visible = true;
				row.data = item.data;
				row.label = this.getLabel(item);
				if (row is ISelectable) ISelectable(row).selected = item.selected;
				row.focus = item == this._focusItem;
				row.index = this._items.indexOf(item);
				item.row = row;
				this.content.addChild(DisplayObject(row));
			}
			else
			{
				row.visible = false;
				row.data = null;
				row.label = null;
				if (row is ISelectable) ISelectable(row).selected = false;
				row.focus = false;
				
				if (row.parent == this.content) this.content.removeChild(DisplayObject(row));
			}
		}
		
		protected function get rowDataOffset():uint
		{
			return this._rowDataOffset;
		}

		protected function set rowDataOffset(value:uint):void
		{
			this._rowDataOffset = value;
		}

		private function toggleSelectItem(row:IListRow, ctrlKey:Boolean = false, shiftKey:Boolean = false):void
		{
			if (row == null) return;
			
			var item:ListItemData = this._rowItemDictionary[row];
			
			this._blockChangeEvent = true;
			
			if (this._allowMultipleSelection && shiftKey && this.selectedIndex != -1)
			{
				this._blockAutoScroll = true;
				var lastSelectedIndex:uint = this.selectedIndex;
				var itemIndex:int = this._items.indexOf(item);
				var i:int;
				
				if (lastSelectedIndex < itemIndex)
				{
					for (i = lastSelectedIndex;i < itemIndex; i++) 
					{
						this.selectListItemData(this._items[i]);
					}
				}
				else if (lastSelectedIndex > itemIndex)
				{
					for (i = lastSelectedIndex;i > itemIndex; i--)
					{
						this.selectListItemData(this._items[i]);
					}
				}
				this._blockAutoScroll = false;
			}
			else if (!(this._allowMultipleSelection && (ctrlKey || this._autoDeselect == false)) && this._selectedItems.length)
			{
				while (this._selectedItems.length)
				{
					var listitem:ListItemData = ListItemData(this._selectedItems.shift());
					if (listitem != item)
					{
						listitem.selected = false;
						if (this._rowItemDictionary[listitem.row] == listitem && listitem.row is ISelectable) ISelectable(listitem.row).selected = false;
					}
				}
			}
			if (item.selected && this._toggle)
			{
				this.deselectListItemData(item);
			}
			else
			{
				this.selectListItemData(item);
			}
			this._blockChangeEvent = false;
		}

		private function selectListItemData(item:ListItemData):void
		{
			this._blockChangeEvent = true;
			if (!this._allowMultipleSelection && this._selectedItems.length)
			{
				// remove old selection
				while (this._selectedItems.length)
				{
					var listitem:ListItemData = ListItemData(this._selectedItems.shift());
					if (listitem != item)
					{
						listitem.selected = false;
						if (this._rowItemDictionary[listitem.row] == listitem && listitem.row is ISelectable) ISelectable(listitem.row).selected = false;
					}
				}
			}
			if (item)
			{
				item.selected = true;
				if (this._rowItemDictionary[item.row] == item && item.row is ISelectable) ISelectable(item.row).selected = true;
			}
			
			if (item && this._selectedItems.indexOf(item) == -1) this._selectedItems.push(item);
			
			this._lastSelectedItem = item;
			if (!this._blockAutoScroll) this.scrollToItem(item);
			this.dispatchEvent(new Event(Event.CHANGE));
			this._blockChangeEvent = false;
		}

		private function deselectListItemData(item:ListItemData):void
		{
			this._blockChangeEvent = true;
			item.selected = false;
			if (this._rowItemDictionary[item.row] == item && item.row is ISelectable) ISelectable(item.row).selected = false;
			
			var index:int;
			while ((index = this._selectedItems.indexOf(item)) != -1)
			{
				this._selectedItems.splice(index, 1);
			}
			
			if (this._lastSelectedItem == item)
			{
				this._lastSelectedItem = this._selectedItems.length ? this._selectedItems[this._selectedItems.length - 1] : null; 
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
			this.dispatchEvent(new SelectEvent(SelectEvent.DESELECT, item.data));
			this._blockChangeEvent = false;
		}

		private function handleClick(event:MouseEvent):void
		{
			if (event.target is IListRow) this.toggleSelectItem(IListRow(event.target), event.ctrlKey, event.shiftKey);
		}
		
		private function handleItemChange(event:Event):void
		{
			if (this._blockChangeEvent) return;
			
			// reselect item if selected item is changed to update the value
			if (this.selectedItem && this._rowItemDictionary[event.target] == this.selectedItem) this.selectListItemData(this.selectedItem);
		}

		private function handleKeyDown(event:KeyboardEvent):void
		{
			var focusIndex:int;
			var item:ListItemData;
			switch (event.keyCode)
			{
				case Keyboard.LEFT:
				case Keyboard.UP:
				{
					event.stopPropagation();
					focusIndex = this._items.indexOf(this._focusItem);
					if (focusIndex > 0)
					{
						item = ListItemData(this._items[focusIndex - 1]);
						this.scrollToItem(item);
						FocusManager.focus = InteractiveObject(item.row);
						this._focusItem = item;
						if (!this._allowMultipleSelection) this.selectListItemData(item);
					}
					break;
				}
				case Keyboard.RIGHT:
				case Keyboard.DOWN:
				{
					event.stopPropagation();
					focusIndex = this._items.indexOf(this._focusItem);
					if (focusIndex < this._items.length - 1)
					{
						item = ListItemData(this._items[focusIndex + 1]);
						this.scrollToItem(item);
						FocusManager.focus = InteractiveObject(item.row);
						this._focusItem = item;
						if (!this._allowMultipleSelection) this.selectListItemData(item);
					}
					break;
				}
				default:
				{
					if (this._searchOnKey)
					{
						event.stopPropagation();
						// search for an item starting with this character
						this.searchOnString(String.fromCharCode(event.charCode).toUpperCase());
					}
					break;
				} 
			}
		}
		
		protected function scrollToItem(item:ListItemData):void
		{
			var index:int = this._items.indexOf(item);
			if (item == null || index == -1) return;
			
			if (index * this._rowHeight + this._rowHeight > this.scrollV + this.height)
			{
				this.scrollVTo(index * this._rowHeight - this.height + this._rowHeight);
			}
			else if (index * this._rowHeight < this.scrollV)
			{
				this.scrollVTo(index * this._rowHeight);
			}
		}
		
		private function handleFocusIn(event:FocusEvent):void 
		{
			if (event.target is IListRow) this.setFocusItem(ListItemData(this._rowItemDictionary[IListRow(event.target)]));
			this._focus = true;
		}

		private function handleFocusOut(event:FocusEvent):void 
		{
			if (this._rowItemDictionary[event.target] == this._focusItem || event.target == this)
			{
				this._focusItem = null;
				this._focus = false;
			}
			else
			{
				FocusManager.focus = this;
			}
		}
		
		private function handleScroll(event:ScrollEvent):void 
		{
			this.updateRows();
		}

		private function setFocusItem(item:ListItemData):void
		{
			if (this._focusItem != item)
			{
				this._focusItem = item;
				if (item)
				{
					if (item.row && this._rowItemDictionary[item.row] == item) this._focusItem.row.focus = true;
					this.scrollToItem(item);
				}
			}
		}

		private function getLabel(item:ListItemData): String
		{
			if (item == null)
			{
				return null;
			}
			else if (item.label != null)
			{
				return item.label;
			}
			else if ('label' in item.data)
			{
				return item.data['label'];
			}
			return String(item.data);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this.removeAllStrongEventListenersForType(Event.CHANGE);
			
			if (this._items)
			{
				this.removeAll();
				this._items = null;
			}
			if (this._rows)
			{
				Destructor.destruct(this._rows);
				this._rows = null;
			}
			
			this._rowItemDictionary = null;
			this._selectedItems = null;
			
			if (this._clearSearchStringTimeOut)
			{
				this._clearSearchStringTimeOut.destruct();
				this._clearSearchStringTimeOut = null;
			}
			if (this._dataSource)
			{
				if (this._dataSource is IDestructible) IDestructible(this._dataSource).destruct();
				this._dataSource = null;
			}
			
			this._listRowClass = null;
			this._searchString = null;
			this._focusItem = null;
			this._lastSelectedItem = null;
			this._itemPositionProxy = null;
			
			super.destruct();
		}
	}
}