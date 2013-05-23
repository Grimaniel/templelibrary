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
	import temple.core.templelibrary;
	import temple.data.collections.ICollection;
	import temple.ui.focus.FocusManager;
	import temple.ui.form.validation.IHasError;
	import temple.ui.scroll.ScrollComponent;
	import temple.ui.scroll.ScrollEvent;
	import temple.ui.states.StateHelper;
	import temple.utils.DefinitionProvider;
	import temple.utils.TimeOut;
	import temple.utils.propertyproxy.IPropertyProxy;
	import temple.utils.types.VectorUtils;

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
			_listRowClass = listRowClass;
			_items = new Vector.<ListItemData>();
			_rows = new Vector.<IListRow>();
			_rowItemDictionary = new Dictionary(true);
			_rowCount = rowCount;
			_selectedItems = new Vector.<ListItemData>();
			
			var row:IListRow;
			var rowIndex:Number;
			
			// Loop children to see if there is any IListRow of so, save Class and remove from timeline
			for (var i:int = content.numChildren - 1; i >= 0; --i) 
			{
				row = content.getChildAt(i) as IListRow;
				if (row)
				{
					rowIndex = i;
					if (!_rowHeight) _rowHeight = row.height;
					if (!_rowWidth) _rowWidth = row.width + 1;
					
					if (_listRowClass == null)
					{
						if (DefinitionProvider.hasDefinition(getQualifiedClassName(row)))
						{
							_listRowClass = DefinitionProvider.getDefinition(getQualifiedClassName(row));
						}
						else
						{
							try
							{
								_listRowClass = loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(row)) as Class;
							}
							catch(error:Error)
							{
								throwError(new TempleError(this, "Class for ListRow \"" + row + "\" not found, try to register the applicationdomain in the DefinitionProvider with DefinitionProvider.registerApplicationDomain(stage.loaderInfo.applicationDomain)"));
							}
						}
					}
					row.addEventListener(Event.REMOVED_FROM_STAGE, handleRowRemovedFromStage, false, int.MAX_VALUE);
					_rows.push(row);

					content.removeChildAt(i);
				}
			}
			if (_listRowClass == null) throwError(new TempleError(this, "No class found for rows"));
			
			snapToItem = true;
			
			addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
			addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			addEventListener(MouseEvent.CLICK, handleClick);
			
			if (content == this)
			{
				content = addChildAt(new CoreSprite(), rowIndex) as DisplayObjectContainer;
			}
			
			content.addEventListener(ScrollEvent.SCROLL, handleScroll);
			addEventListener(Event.RESIZE, content.dispatchEvent);
			
			super.height = 0;
			dispatchEvent(new Event(Event.RESIZE));
			
			FocusManager.init(stage);
		}

		/**
		 * @inheritDoc
		 */
		public function addItem(data:*, label:String = null):void
		{
			var index:uint = _items.push(data is ListItemData ? data : new ListItemData(data, label)) - 1;
			if (index <= _rowCount && index >= _rows.length)
			{
				createRow();
			}
			else if (_items.length <= _rowCount + 1)
			{
				setRow(_rows[index], _items[index]);
				if (_itemPositionProxy)
				{
					_itemPositionProxy.setValue(_rows[index], "y", _rowHeight * index);
				}
				else
				{
					_rows[index].y = _rowHeight * index;
				}
			}
			
			if (!_blockResize)
			{
				super.height = _rowHeight * (_items.length < _rowCount ? _items.length : _rowCount) + _heightOffset;
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		protected function createRow():void 
		{
			var row:IListRow = new _listRowClass() as IListRow;
			if (!row)
			{
				throwError(new TempleError(this, "listRowClass does not implement IListRow"));
			}
			else
			{
				var index:uint = _rowDataOffset + _rows.length;
				var item:ListItemData = _items[index];
				
				setRow(row, item);
				
				if (isNaN(_rowHeight)) _rowHeight = row.height;
				
				if (_itemPositionProxy)
				{
					_itemPositionProxy.setValue(row, "y", _rowHeight * index);
				}
				else
				{
					row.y = _rowHeight * index;
				}
				
				content.addChild(DisplayObject(row));
				_rows.push(row);
				row.addEventListener(Event.REMOVED_FROM_STAGE, handleRowRemovedFromStage, false, int.MAX_VALUE);
				row.addEventListener(Event.CHANGE, handleItemChange);
			}
		}
		
		public function addItemAt(data:*, index:uint, label:String = null):void
		{
			_items.splice(index, 0, new ListItemData(data, label));
			
			if (index <= _rowCount + _rowDataOffset)
			{
				var leni:int = _rows.length;
				for (var i:int =  Math.max(index - _rowDataOffset, 0); i < leni; i++)
				{
					setRow(_rows[i], _items[i + _rowDataOffset]);
				}
			}
			super.height = _rowHeight * (_items.length < _rowCount ? _items.length : _rowCount) + _heightOffset;
			dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * @inheritDoc
		 */
		public function addItems(items:Array, labels:* = null):void
		{
			if (items == null) return;
			
			_blockResize = true;
			
			var leni:int = items.length;
			for (var i:int = 0;i < leni; i++) 
			{
				if (labels is String)
				{
					if (labels in items[i])
					{
						addItem(items[i], items[i][labels]);
					}
					else
					{
						logWarn("addItems: item " + items[i] + " doesn't have a property '" + labels + "'");
					}
				}
				else if (labels is Array)
				{
					addItem(items[i], labels[i]);
				}
				else if (labels == null)
				{
					addItem(items[i]);
				}
				else
				{
					logError("addItems: invalid value for items: '" + items + "'");
				}
			}
			_blockResize = false;
			super.height = _rowHeight * Math.min(_items.length, _rowCount) + _heightOffset;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasItem(value:*):Boolean
		{
			for (var i:int = 0, leni:int = _items.length; i < leni; i++)
			{
				if (_items[i].data == value) return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItem(value:*, fromIndex:int = 0):*
		{
			if (fromIndex < _items.length)
			{
				for (var i:int = 0, leni:int = _items.length; i < leni; i++)
				{
					if (_items[i].data == value) return value;
				}
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:uint):*
		{
			return index < _items.length ? _items[index].data : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:*, index:uint, label:String = null):void
		{
			if (index < _items.length)
			{
				var item:ListItemData = _items[index];
				item.data = data;
				item.label = label;
				
				if (item.row && _rowItemDictionary[item.row] == item) setRow(item.row, item);
				
				if (_selectedItems.indexOf(item) != -1)
				{
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
			else
			{
				throwError(new TempleRangeError(index, _items.length, this, "There is no item at index " + index));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLabel(value:*, fromIndex:int = 0):String
		{
			if (fromIndex < _items.length)
			{
				for (var i:int = 0, leni:int = _items.length; i < leni; i++)
				{
					if (_items[i].data == value) return getListItemLabel(_items[i]);
				}
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLabelAt(index:uint):String
		{
			if (index < _items.length)
			{
				return getListItemLabel(_items[index]);
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLabelAt(index:uint, label:String):void
		{
			var listItemData:ListItemData;
			
			if (index < _items.length && (listItemData = _items[index]))
			{
				listItemData.label = label;
				if (listItemData.row && _rowItemDictionary[listItemData.row] == listItemData)
				{
					listItemData.row.label = label;
				}
			}
			else
			{
				throwError(new TempleRangeError(index, _items.length, this, "No item found at index " + index));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItem(data:*, label:String = null):Boolean
		{
			var item:ListItemData;
			for (var i:int = _items.length - 1;i >= 0; --i) 
			{
				item = _items[i];
				
				if (item.data === data && (item.label === label || label == null))
				{
					_items.splice(i, 1);
					
					if (i <= _rowCount + _rowDataOffset)
					{
						var leni:int = _rows.length;
						for (i =  Math.max(i - _rowDataOffset, 0); i < leni; i++)
						{
							setRow(_rows[i], _items[i + _rowDataOffset]);
						}
					}
					
					if (_focusItem == item) _focusItem = null;
					if (_lastSelectedItem == item) _lastSelectedItem = null;
					
					item.destruct();
					
					super.height = _rowHeight * (_items.length < _rowCount ? _items.length : _rowCount) + _heightOffset;
					dispatchEvent(new Event(Event.RESIZE));
					
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
			if (_items[index])
			{
				var item:ListItemData = _items[index];
				
				_items.splice(index, 1);
					
				if (index <= _rowCount + _rowDataOffset)
				{
					var leni:int = _rows.length;
					for (index =  Math.max(index - _rowDataOffset, 0); index < leni; index++)
					{
						setRow(_rows[index], _items[index + _rowDataOffset]);
					}
				}
				
				if (_focusItem == item) _focusItem = null;
				if (_lastSelectedItem == item) _lastSelectedItem = null;
				
				item.destruct();
				
				super.height = _rowHeight * (_items.length < _rowCount ? _items.length : _rowCount) + _heightOffset;
				dispatchEvent(new Event(Event.RESIZE));
				
				return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAll():void
		{
			if (_items)
			{
				while (_items.length) _items.shift().destruct();
				_focusItem = null;
				_lastSelectedItem = null;
				_rowDataOffset = 0;
				
				var leni:int = _rows.length;
				for (var i:int = 0; i < leni; i++)
				{
					setRow(_rows[i], null);
				}
				scrollBehavior.scrollV = 0;
				
				super.height = _heightOffset;
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedIndex():int
		{
			return _lastSelectedItem && _items ? _items.indexOf(_lastSelectedItem) : -1;
		}

		/**
		 * @inheritDoc
		 */
		public function set selectedIndex(value:int):void
		{
			if (value == -1)
			{
				reset();
			}
			else if (value in _items)
			{
				selectListItemData(_items[value]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedItem():*
		{
			return _lastSelectedItem ? _lastSelectedItem.data : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedItem(value:*):void
		{
			for each (var item:ListItemData in _items)
			{
				if (item.data == value)
				{
					selectListItemData(item);
					return;
				}
			}
			logWarn("selectedItem: not found '" + value + "'");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedLabel():String
		{
			return getListItemLabel(_lastSelectedItem);
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedLabel(value:String):void
		{
			for each (var item:ListItemData in _items)
			{
				if (item.label == value)
				{
					selectListItemData(item);
					setFocusItem(item);
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
			
			var leni:int = _items.length;
			var item:ListItemData;
			for (var i:int = 0; i < leni; i++)
			{
				item = _items[i];
				if (item.selected) items.push(item.data);
			}
			return items;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedItems(value:Array):void
		{
			var leni:int = _items.length;
			var item:ListItemData;
			for (var i:int = 0; i < leni; i++)
			{
				item = _items[i];
				if (value.indexOf(item.data) != -1) selectListItemData(item);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedLabels():Vector.<String>
		{
			var items:Vector.<String> = new Vector.<String>();
			
			var leni:int = _items.length;
			var item:ListItemData;
			for (var i:int = 0; i < leni; i++)
			{
				item = _items[i];
				if (item.selected) items.push(getListItemLabel(item));
			}
			return items;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedLabels(value:Vector.<String>):void
		{
			var leni:int = _items.length;
			var item:ListItemData;
			for (var i:int = 0; i < leni; i++)
			{
				item = _items[i];
				if (value.indexOf(item.label) != -1) selectListItemData(item);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function isItemSelected(data:*, label:String = null):Boolean
		{
			for each (var item:ListItemData in _items) 
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
			return index < _items.length ? _items[index].selected : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():uint
		{
			return _items ? _items.length : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Allow multiple selection", type="Boolean", defaultValue=false)]
		public function set allowMultipleSelection(value:Boolean):void
		{
			_allowMultipleSelection = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoDeselect():Boolean
		{
			return _autoDeselect;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Auto deselect", type="Boolean", defaultValue=true)]
		public function set autoDeselect(value:Boolean):void
		{
			_autoDeselect = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get rowHeight():Number
		{
			return _rowHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function set rowHeight(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "RowHeight cannot be NaN"));
			
			if (_rowHeight != value)
			{
				_rowHeight = value;
				
				var leni:int = _rows.length;
				for (var i:int = 0;i < leni; i++) 
				{
					IListRow(_rows[i]).y = (i + _rowDataOffset) * _rowHeight;
				}
				
				super.height = _rowCount * _rowHeight + _heightOffset;
				dispatchEvent(new Event(Event.RESIZE));
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
				rowHeight = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get rowCount():uint
		{
			return _rowCount;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Visible rows", type="Number", defaultValue=10)]
		public function set rowCount(value:uint):void
		{
			if (_rowCount != value)
			{
				_rowCount = value;
				super.height = _rowCount * _rowHeight + marginTop + marginBottom + _heightOffset;
				updateRows();
				dispatchEvent(new Event(Event.RESIZE));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentHeight():Number 
		{
			return _items ? _items.length * _rowHeight : 1;
		}

		override public function set height(value:Number):void 
		{
			if (height != value)
			{
				super.height = value;
				var rowCount:uint = Math.ceil((height - (marginTop + marginBottom + _heightOffset)) / _rowHeight);
				
				if (rowCount > _rowCount) _rowCount = rowCount;
				
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/**
		 * @inheritDoc
		 */
		public function sort(compareFunction:Function):void
		{
			_items.sort(compareFunction);
			
			setRows();
			updateRows();
		}

		/**
		 * @inheritDoc
		 */
		public function sortOn(names:*, options:* = 0, ...args:*):void
		{
			VectorUtils.sortOn.apply(null, [_items, names, options].concat(args));
			
			setRows();
			updateRows();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get wrapSearch():Boolean
		{
			return _wrapSearch;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Wrap search", type="Boolean", defaultValue=true)]
		public function set wrapSearch(value:Boolean):void
		{
			_wrapSearch = value;
		}

		/**
		 * @inheritDoc
		 */
		public function searchOnString(string:String, caseSensitive:Boolean = false):void
		{
			if (_items == null) return;
			
			if (_clearSearchStringTimeOut) _clearSearchStringTimeOut.destruct();
			_clearSearchStringTimeOut = new TimeOut(clearSearchString, List._CLEAR_STRING_SEARCH_DELAY);

			_searchString += string;
			
			var searchIndex:int = _lastSelectedItem ? selectedIndex : -1;
			
			if (_searchString.length == 1) searchIndex++;
			
			var match:Boolean = findFirstMatchingItem(_searchString, caseSensitive, searchIndex,  _items.length);
			
			if (!match && _wrapSearch)
			{
				match = findFirstMatchingItem(_searchString, caseSensitive, 0, searchIndex);
			}
			if (!match)
			{
				match = findFirstMatchingItem(string, caseSensitive, searchIndex+1,  _items.length);
				if (!match && _wrapSearch)
				{
					match = findFirstMatchingItem(string, caseSensitive, 0, searchIndex);
				}
			}
		}
		
		/**
		 * The colletion that is used to fill the List
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
		
		private function findFirstMatchingItem(string:String, caseSensitive:Boolean, startIndex:int, endIndex:int):Boolean
		{
			if (startIndex < 0) startIndex = 0;
			
			var label:String;
			for (var i:int = startIndex;i < endIndex; i++)
			{
				label = getListItemLabel(_items[i]);
				if (label && (label.substr(0, string.length) == string || !caseSensitive && label.substr(0, string.length).toLowerCase() == string.toLowerCase()))
				{
					selectedIndex = i;
					setFocusItem(_items[i]);
					dispatchEvent(new Event(Event.CHANGE));
					return true;
				}
			}
			return false;
		}
		
		private function clearSearchString():void
		{
			_searchString = '';
		}
		
		/**
		 * @inheritDoc
		 */
		public function get keySearch():Boolean
		{
			return _searchOnKey;
		}
		
		/**
		 * @private
		 */
		public function set keySearch(value:Boolean):void
		{
			_searchOnKey = value;
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
				if (!_focusItem && _lastSelectedItem)
				{
					_focusItem = _lastSelectedItem;
				}
				else if (!_focusItem && _items.length)
				{
					_focusItem = _items[0];
				}
				if (_focusItem && _focusItem.row && _rowItemDictionary[_focusItem.row] == _focusItem)
				{
					_focusItem.row.focus = value;
					if (!_allowMultipleSelection) selectListItemData(_focusItem);
				}
			}
			else if (_focus)
			{
				FocusManager.focus = null;
			}
		}		
		
		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			if (_selectedItems.length == 0)
			{
				return null;
			}
			else if (_selectedItems.length == 1 && !_allowMultipleSelection)
			{
				return _selectedItems[0].data;
			}
			else
			{
				var values:Array = new Array();
				
				var leni:int = _selectedItems.length;
				for (var i:int = 0;i < leni; i++) 
				{
					values.push(_selectedItems[i].data);
				}
				return values;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			for each (var item:ListItemData in _items)
			{
				if (item.data == value)
				{
					selectListItemData(item);
					return;
				}
			}
			if (value == null)
			{
				selectListItemData(null);
			}
			else
			{
				logError("value '" + value + "' not found in List");
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
			StateHelper.showError(this, message);
			dispatchEvent(new FormElementErrorEvent(FormElementErrorEvent.SHOW_ERROR, message));
		}
		
		/**
		 * @inheritDoc 
		 */
		public function hideError():void 
		{
			_hasError = false;
			StateHelper.hideError(this);
			dispatchEvent(new FormElementErrorEvent(FormElementErrorEvent.HIDE_ERROR));
		}

		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			while (_selectedItems && _selectedItems.length)
			{
				var listitem:ListItemData = _selectedItems.shift();
				listitem.selected = false;
				if (_rowItemDictionary[listitem.row] == listitem && listitem.row is ISelectable) ISelectable(listitem.row).selected = false;
			}
			_lastSelectedItem = null;
		}
		
		/**
		 * If set to true the List will snap its scroll position to the items
		 */
		public function get snapToItem():Boolean
		{
			return scrollBehavior.snapToStep;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Snap to item", type="Boolean", defaultValue="true")]
		public function set snapToItem(value:Boolean):void
		{
			scrollBehavior.snapToStep = value;
		}
		
		/**
		 * Indicates if a selected item can be deselected by clicking it again
		 */
		public function get toggle():Boolean
		{
			return _toggle;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Toggle", type="Boolean", defaultValue=false)]
		public function set toggle(value:Boolean):void
		{
			_toggle = value;
		}
		
		/**
		 * Extra size to be added to the height of the scrollRect. Usefull if the ListItems uses a hairline as a border. Set this value to 1 if you want to see this line at the bottom of the List.
		 * @default 0
		 */
		public function get heightOffset():Number
		{
			return _heightOffset;
		}
		
		/**
		 * @private
		 */
		public function set heightOffset(value:Number):void
		{
			if (isNaN(value)) value = 0;
			_heightOffset = value;
			super.height = _rowCount * _rowHeight + _heightOffset;
		}
		
		/**
		 * IPropertyProxy to set the initial position of every item. Use this for creating a 'show animation'.
		 */
		public function get itemPositionProxy():IPropertyProxy
		{
			return _itemPositionProxy;
		}
		
		/**
		 * @private
		 */
		public function set itemPositionProxy(value:IPropertyProxy):void
		{
			_itemPositionProxy = value;
		}

		public function updateRows():void 
		{
			if (!_rows || !_rows.length || !content || !content.scrollRect) return;
			
			// check if we have enough rows
			while (_items.length > _rows.length && _rows.length < _rowCount + 1)
			{
				createRow();
			}
			
			// remove rows we don't use
			while (_rows.length > _rowCount + 1) _rows.pop().destruct();
			
			// scroll down, move all rows above the top to the buttom of the list
			var row:IListRow = _rows[0];
			while (row.y < (content.scrollRect.y - _rowHeight) && _rowDataOffset + _rows.length < _items.length)
			{
				row.y += _rows.length * _rowHeight;
				setRow(row, _items[_rowDataOffset + _rows.length]);
				_rows.push(_rows.shift());
				row = _rows[0];
				_rowDataOffset++;
			}
			
			// scroll up, move rows at the bottom to the top (if needed)
			while (row.y > content.scrollRect.y + (_rowDataOffset ? 0 : marginTop))
			{
				row = _rows.pop();
				_rows.unshift(row);
				row.y -= _rows.length * _rowHeight;
				if (_rowDataOffset) setRow(row, _items[--_rowDataOffset]);
			}
		}
		
		public function get listRowClass():Class
		{
			return _listRowClass;
		}

		public function set listRowClass(value:Class):void
		{
			_listRowClass = value;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function selectItem(data:*):Boolean
		{
			for each (var item:ListItemData in _items)
			{
				if (item.data == data)
				{
					selectListItemData(item);
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
			for each (var item:ListItemData in _items)
			{
				if (item.data == data)
				{
					deselectListItemData(item);
					return true;
				}
			}
			return false;
		}
		
		protected function get rows():Vector.<IListRow>
		{
			return _rows;
		}
		
		protected function get items():Vector.<ListItemData>
		{
			return _items;
		}

		/**
		 * @private
		 */
		templelibrary function get items():Vector.<ListItemData>
		{
			return _items;
		}
		
		private function setRows():void
		{
			var leni:int = _rows.length;
			var totalItems:int = _items.length;
			for (var i:int = 0; i < leni; i++)
			{
				setRow(_rows[i], i + _rowDataOffset < totalItems ? _items[i + _rowDataOffset] : null);
			}
		}

		protected function setRow(row:IListRow, item:ListItemData):void 
		{
			_rowItemDictionary[row] = item;
			if (item)
			{
				row.visible = true;
				row.data = item.data;
				row.label = getListItemLabel(item);
				if (row is ISelectable) ISelectable(row).selected = item.selected;
				row.focus = item == _focusItem;
				row.index = _items.indexOf(item);
				item.row = row;
				content.addChild(DisplayObject(row));
			}
			else
			{
				row.visible = false;
				row.data = null;
				row.label = null;
				if (row is ISelectable) ISelectable(row).selected = false;
				row.focus = false;
				
				if (row.parent == content) content.removeChild(DisplayObject(row));
			}
		}
		
		protected function get rowDataOffset():uint
		{
			return _rowDataOffset;
		}

		protected function set rowDataOffset(value:uint):void
		{
			_rowDataOffset = value;
		}

		private function toggleSelectItem(row:IListRow, ctrlKey:Boolean = false, shiftKey:Boolean = false):void
		{
			if (row == null) return;
			
			var item:ListItemData = _rowItemDictionary[row];
			
			_blockChangeEvent = true;
			
			if (_allowMultipleSelection && shiftKey && selectedIndex != -1)
			{
				_blockAutoScroll = true;
				var lastSelectedIndex:uint = selectedIndex;
				var itemIndex:int = _items.indexOf(item);
				var i:int;
				
				if (lastSelectedIndex < itemIndex)
				{
					for (i = lastSelectedIndex;i < itemIndex; i++) 
					{
						selectListItemData(_items[i]);
					}
				}
				else if (lastSelectedIndex > itemIndex)
				{
					for (i = lastSelectedIndex;i > itemIndex; i--)
					{
						selectListItemData(_items[i]);
					}
				}
				_blockAutoScroll = false;
			}
			else if (!(_allowMultipleSelection && (ctrlKey || _autoDeselect == false)) && _selectedItems.length)
			{
				while (_selectedItems.length)
				{
					var listitem:ListItemData = _selectedItems.shift();
					if (listitem != item)
					{
						listitem.selected = false;
						if (_rowItemDictionary[listitem.row] == listitem && listitem.row is ISelectable) ISelectable(listitem.row).selected = false;
					}
				}
			}
			if (item.selected && _toggle)
			{
				deselectListItemData(item);
			}
			else
			{
				selectListItemData(item);
			}
			_blockChangeEvent = false;
		}

		private function selectListItemData(item:ListItemData):void
		{
			_blockChangeEvent = true;
			if (!_allowMultipleSelection && _selectedItems.length)
			{
				// remove old selection
				while (_selectedItems.length)
				{
					var listitem:ListItemData = _selectedItems.shift();
					if (listitem != item)
					{
						listitem.selected = false;
						if (_rowItemDictionary[listitem.row] == listitem && listitem.row is ISelectable) ISelectable(listitem.row).selected = false;
					}
				}
			}
			if (item)
			{
				item.selected = true;
				if (_rowItemDictionary[item.row] == item && item.row is ISelectable) ISelectable(item.row).selected = true;
			}
			
			if (item && _selectedItems.indexOf(item) == -1) _selectedItems.push(item);
			
			_lastSelectedItem = item;
			if (!_blockAutoScroll) scrollToItem(item);
			dispatchEvent(new Event(Event.CHANGE));
			_blockChangeEvent = false;
		}

		private function deselectListItemData(item:ListItemData):void
		{
			_blockChangeEvent = true;
			item.selected = false;
			if (_rowItemDictionary[item.row] == item && item.row is ISelectable) ISelectable(item.row).selected = false;
			
			var index:int;
			while ((index = _selectedItems.indexOf(item)) != -1)
			{
				_selectedItems.splice(index, 1);
			}
			
			if (_lastSelectedItem == item)
			{
				_lastSelectedItem = _selectedItems.length ? _selectedItems[_selectedItems.length - 1] : null; 
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			dispatchEvent(new SelectEvent(SelectEvent.DESELECT, item.data));
			_blockChangeEvent = false;
		}

		private function handleClick(event:MouseEvent):void
		{
			if (event.target is IListRow) toggleSelectItem(IListRow(event.target), event.ctrlKey, event.shiftKey);
		}
		
		private function handleItemChange(event:Event):void
		{
			if (_blockChangeEvent) return;
			
			// reselect item if selected item is changed to update the value
			if (selectedItem && _rowItemDictionary[event.target] == selectedItem) selectListItemData(selectedItem);
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
					focusIndex = _items.indexOf(_focusItem);
					if (focusIndex > 0)
					{
						item = _items[focusIndex - 1];
						scrollToItem(item);
						FocusManager.focus = InteractiveObject(item.row);
						_focusItem = item;
						if (!_allowMultipleSelection) selectListItemData(item);
					}
					break;
				}
				case Keyboard.RIGHT:
				case Keyboard.DOWN:
				{
					event.stopPropagation();
					focusIndex = _items.indexOf(_focusItem);
					if (focusIndex < _items.length - 1)
					{
						item = _items[focusIndex + 1];
						scrollToItem(item);
						FocusManager.focus = InteractiveObject(item.row);
						_focusItem = item;
						if (!_allowMultipleSelection) selectListItemData(item);
					}
					break;
				}
				default:
				{
					if (_searchOnKey)
					{
						event.stopPropagation();
						// search for an item starting with this character
						searchOnString(String.fromCharCode(event.charCode).toUpperCase());
					}
					break;
				} 
			}
		}
		
		protected function scrollToItem(item:ListItemData):void
		{
			var index:int = _items.indexOf(item);
			if (item == null || index == -1) return;
			
			if (index * _rowHeight + _rowHeight > scrollV + height)
			{
				scrollVTo(index * _rowHeight - height + _rowHeight);
			}
			else if (index * _rowHeight < scrollV)
			{
				scrollVTo(index * _rowHeight);
			}
		}
		
		private function handleFocusIn(event:FocusEvent):void 
		{
			if (event.target is IListRow) setFocusItem(_rowItemDictionary[IListRow(event.target)]);
			_focus = true;
		}

		private function handleFocusOut(event:FocusEvent):void 
		{
			if (_rowItemDictionary[event.target] == _focusItem || event.target == this)
			{
				_focusItem = null;
				_focus = false;
			}
			else
			{
				FocusManager.focus = this;
			}
		}
		
		private function handleScroll(event:ScrollEvent):void 
		{
			updateRows();
		}

		private function setFocusItem(item:ListItemData):void
		{
			if (_focusItem != item)
			{
				_focusItem = item;
				if (item)
				{
					if (item.row && _rowItemDictionary[item.row] == item) _focusItem.row.focus = true;
					scrollToItem(item);
				}
			}
		}

		private function getListItemLabel(item:ListItemData): String
		{
			if (item == null)
			{
				return null;
			}
			else if (item.label != null)
			{
				return item.label;
			}
			else if (item.data && 'label' in item.data)
			{
				return item.data['label'];
			}
			return String(item.data);
		}
		
		private function handleRowRemovedFromStage(event:Event):void
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
			removeAllStrongEventListenersForType(Event.RESIZE);
			removeAllStrongEventListenersForType(ScrollEvent.SCROLL);
			
			if (_items)
			{
				removeAll();
				_items = null;
			}
			if (_rows)
			{
				Destructor.destruct(_rows);
				_rows = null;
			}
			
			_rowItemDictionary = null;
			_selectedItems = null;
			
			if (_clearSearchStringTimeOut)
			{
				_clearSearchStringTimeOut.destruct();
				_clearSearchStringTimeOut = null;
			}
			if (_dataSource)
			{
				if (_dataSource is IDestructible) IDestructible(_dataSource).destruct();
				_dataSource = null;
			}
			
			_listRowClass = null;
			_searchString = null;
			_focusItem = null;
			_lastSelectedItem = null;
			_itemPositionProxy = null;
			
			super.destruct();
		}
	}
}