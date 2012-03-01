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

package temple.ui.form.components 
{
	import temple.common.interfaces.IHasValue;
	import temple.core.destruction.IDestructible;
	import temple.utils.types.StringUtils;

	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * <code>InputField</code> with predefined options which are suggested when the user types in the
	 * <code>AutoCompleteInputField</code>. The suggestions are based in the input of the user.
	 * 
	 * @author Thijs Broerse
	 */
	public class AutoCompleteInputField extends ComboBox 
	{
		private var _items:Array;
		private var _filter:String;
		private var _inSearch:Boolean = false;
		private var _caseSensitive:Boolean = false;
		private var _maxResults:uint = 50;
		private var _minSearchLength:uint = 0;
		private var _onlyAllowMatch:Boolean;

		public function AutoCompleteInputField(textField:TextField = null, list:IList = null)
		{
			super(textField, list);
			
			this._filter = "";
			this._items = new Array();
			this.textField.addEventListener(Event.CHANGE, this.handleInputChange);
			
			this.editable = true;
			this.keySearch = false;
		}

		/**
		 * @inheritDoc 
		 */
		override public function get value():* 
		{
			if (this._onlyAllowMatch)
			{
				return IHasValue(this.list).value;
			}
			else
			{
				return this.trimValue ? StringUtils.trim(this.text) : this.text;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function set value(value:*):void 
		{
			for each (var itemData : IListItemData in this._items) 
			{
				if (itemData.data == value)
				{
					value = itemData.label;
					break;
				}
			}
			
			this._filter = value;
			if (!this.filterItems())
			{
				super.value = value;
			}
		}

		/**
		 * @inheritDoc 
		 */
		override public function addItem(data:*, label:String = null):void
		{
			this._items.push(new ListItemData(data, label || this.generateLabel(data))) - 1;
			this.filterItem(this._items[this._items.length - 1]);
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function addItemAt(data:*, index:uint, label:String = null):void
		{
			this._items.splice(index, 0, new ListItemData(data, label || this.generateLabel(data)));
			this.filterItem(this._items[index]);
		}

		/**
		 * @inheritDoc 
		 */
		override public function addItems(items:Array, labels:* = null):void
		{
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
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeItem(data:*, label:String = null):Boolean
		{
			if (label == null) label = this.generateLabel(data);
			var item:IListItemData;
			for (var i:int = this._items.length - 1;i >= 0; --i) 
			{
				item = this._items[i];
				if (item.data === data && item.label === label)
				{
					this._items.splice(i, 1);
					item.destruct();
					return true;
				}
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		override public function removeItemAt(index:uint):Boolean
		{
			if (this._items[index])
			{
				var item:IListItemData = this._items[index];
				this._items.splice(index, 1);
				item.destruct();
				
				return true;
			}
			return false;
		}
		
		/**
		 * Indicates if the match is only the begin of the word, or also within the word
		 * where:
		 *  true: search within words
		 *  false (default): search only the begin
		 */
		public function get inSearch():Boolean
		{
			return this._inSearch;
		}
		
		/**
		 * @private
		 */
		public function set inSearch(value:Boolean):void
		{
			this._inSearch = value;
			this.filterItems();
		}
		
		/**
		 * Indicates if the match is case sensitive
		 */
		public function get caseSensitive():Boolean
		{
			return this._caseSensitive;
		}
		
		/**
		 * @private
		 */
		public function set caseSensitive(value:Boolean):void
		{
			this._caseSensitive = value;
			this.filterItems();
		}
		
		/**
		 * The maximum amount of results shown in the list. 0 means infinity (not recommended).
		 */
		public function get maxResults():uint
		{
			return this._maxResults;
		}
		
		/**
		 * @private
		 */
		public function set maxResults(value:uint):void
		{
			this._maxResults = value;
		}
		
		/**
		 * Minimal length of the search string before results are shown.
		 */
		public function get minSearchLength():uint
		{
			return this._minSearchLength;
		}
		
		/**
		 * @private
		 */
		public function set minSearchLength(value:uint):void
		{
			this._minSearchLength = value;
		}
		
		/**
		 * If set to true, only values who are in the list are allowed
		 */
		public function get onlyAllowMatch():Boolean
		{
			return this._onlyAllowMatch;
		}
		
		/**
		 * @private
		 */
		public function set onlyAllowMatch(value:Boolean):void
		{
			this._onlyAllowMatch = value;
		}

		/**
		 * Filter all the items based on the text in the InputField
		 * @return true if there is a perfect match
		 */
		public function filterItems():Boolean
		{
			this.list.removeAll();
			var match:Boolean;
			for (var i:int = 0,leni:int = this._items.length;i < leni; i++)
			{
				match = this.filterItem(this._items[i]) || match;
			}
			return match;
		}

		/**
		 * Filter an item based on it's label and the _filter.
		 * @return if there is an exact match, the selected item is returned
		 */
		protected function filterItem(item:IListItemData):Boolean
		{
			if (this._maxResults && this.list.length >= this._maxResults) return false;
			if (this._minSearchLength && (!this._filter || this._filter.length < this._minSearchLength)) return false;
			
			if (this._caseSensitive && !this._inSearch && item.label.substr(0, this._filter.length) == this._filter
			|| !this._caseSensitive && !this._inSearch && item.label.substr(0, this._filter.length).toLowerCase() == this._filter.toLowerCase()
			||  this._caseSensitive &&  this._inSearch && item.label.indexOf(this._filter) != -1
			|| !this._caseSensitive &&  this._inSearch && item.label.toLowerCase().indexOf(this._filter.toLowerCase()) != -1)
			{
				this.list.addItem(item.data, item.label);
				if (item.label == this._filter || !this._caseSensitive && item.label.toLowerCase() == this._filter.toLowerCase())
				{
					// temperary remove listener for CHANGE events to prevent recursive loops
					this.textField.removeEventListener(Event.CHANGE, this.handleInputChange);
					this.list.selectedItem = item.data;
					this.textField.addEventListener(Event.CHANGE, this.handleInputChange);
					return true;
				}
			}
			return false;
		}

		protected function handleInputChange(event:Event):void
		{
			this._filter = this.text;
			
			if (this.filterItems())
			{
				this.close();
			}
			else if (this.list.length > 0)
			{
				this.open();
			}
			else
			{
				this.close();
			}
		}
		
		private function generateLabel(data:Object): String
		{
			return data && data.hasOwnProperty('label') ? data['label'] : String(data);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._items)
			{
				for (var i:int = 0,leni:int = this._items.length;i < leni; i++)
				{
					var item:* = this._items[i];
					if (item is IDestructible) IDestructible(item).destruct();
					item = null;
				}
			}
			
			this._items = null;
			this._filter = null;
			
			super.destruct();
		}
	}
}