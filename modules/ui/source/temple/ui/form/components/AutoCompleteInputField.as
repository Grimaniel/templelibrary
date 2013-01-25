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
	import temple.ui.focus.FocusManager;
	import temple.utils.types.StringUtils;
	import temple.utils.types.VectorUtils;

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
		private var _items:Vector.<IListItemData>;
		private var _filter:String;
		private var _inSearch:Boolean = false;
		private var _caseSensitive:Boolean = false;
		private var _maxResults:uint = 50;
		private var _minSearchLength:uint = 0;
		private var _onlyAllowMatch:Boolean;

		public function AutoCompleteInputField(textField:TextField = null, list:IList = null)
		{
			super(textField, list);
			
			_filter = "";
			_items = new Vector.<IListItemData>();
			textField.addEventListener(Event.CHANGE, handleInputChange);
			
			editable = true;
			keySearch = false;
		}

		/**
		 * @inheritDoc 
		 */
		override public function get value():* 
		{
			if (_onlyAllowMatch)
			{
				return IHasValue(list).value;
			}
			else
			{
				return trimValue ? StringUtils.trim(text) : text;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function set value(value:*):void 
		{
			for each (var itemData : IListItemData in _items) 
			{
				if (itemData.data == value)
				{
					value = itemData.label;
					break;
				}
			}
			
			_filter = value;
			if (!filterItems())
			{
				super.value = value;
			}
		}

		/**
		 * @inheritDoc 
		 */
		override public function addItem(data:*, label:String = null):void
		{
			_items.push(new ListItemData(data, label || generateLabel(data))) - 1;
			filterItem(_items[_items.length - 1]);
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function addItemAt(data:*, index:uint, label:String = null):void
		{
			_items.splice(index, 0, new ListItemData(data, label || generateLabel(data)));
			filterItem(_items[index]);
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
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeItem(data:*, label:String = null):Boolean
		{
			if (label == null) label = generateLabel(data);
			var item:IListItemData;
			for (var i:int = _items.length - 1;i >= 0; --i) 
			{
				item = _items[i];
				if (item.data === data && item.label === label)
				{
					_items.splice(i, 1);
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
			if (_items[index])
			{
				var item:IListItemData = _items[index];
				_items.splice(index, 1);
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
			return _inSearch;
		}
		
		/**
		 * @private
		 */
		public function set inSearch(value:Boolean):void
		{
			_inSearch = value;
			filterItems();
		}
		
		/**
		 * Indicates if the match is case sensitive
		 */
		public function get caseSensitive():Boolean
		{
			return _caseSensitive;
		}
		
		/**
		 * @private
		 */
		public function set caseSensitive(value:Boolean):void
		{
			_caseSensitive = value;
			filterItems();
		}
		
		/**
		 * The maximum amount of results shown in the list. 0 means infinity (not recommended).
		 */
		public function get maxResults():uint
		{
			return _maxResults;
		}
		
		/**
		 * @private
		 */
		public function set maxResults(value:uint):void
		{
			_maxResults = value;
		}
		
		/**
		 * Minimal length of the search string before results are shown.
		 */
		public function get minSearchLength():uint
		{
			return _minSearchLength;
		}
		
		/**
		 * @private
		 */
		public function set minSearchLength(value:uint):void
		{
			_minSearchLength = value;
		}
		
		/**
		 * If set to true, only values who are in the list are allowed
		 */
		public function get onlyAllowMatch():Boolean
		{
			return _onlyAllowMatch;
		}
		
		/**
		 * @private
		 */
		public function set onlyAllowMatch(value:Boolean):void
		{
			_onlyAllowMatch = value;
		}

		/**
		 * Filter all the items based on the text in the InputField
		 * @return true if there is a perfect match
		 */
		public function filterItems():Boolean
		{
			if (!_items) return false;
			
			list.removeAll();
			var match:Boolean;
			for (var i:int = 0,leni:int = _items.length;i < leni; i++)
			{
				match = filterItem(_items[i]) || match;
			}
			return match;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function sort(compareFunction:Function):void
		{
			_items.sort(compareFunction);
			
			super.sort(compareFunction);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function sortOn(names:*, options:* = 0, ...args):void
		{
			VectorUtils.sortOn.apply(null, [_items, names, options].concat(args));
			
			super.sortOn.apply(null, [names, options].concat(args));
		}

		/**
		 * Filter an item based on it's label and the _filter.
		 * @return if there is an exact match, the selected item is returned
		 */
		protected function filterItem(item:IListItemData):Boolean
		{
			if (_maxResults && list.length >= _maxResults) return false;
			if (_minSearchLength && (!_filter || _filter.length < _minSearchLength)) return false;
			
			if (_caseSensitive && !_inSearch && item.label.substr(0, _filter.length) == _filter
			|| !_caseSensitive && !_inSearch && item.label.substr(0, _filter.length).toLowerCase() == _filter.toLowerCase()
			||  _caseSensitive &&  _inSearch && item.label.indexOf(_filter) != -1
			|| !_caseSensitive &&  _inSearch && item.label.toLowerCase().indexOf(_filter.toLowerCase()) != -1)
			{
				list.addItem(item.data, item.label);
				if (item.label == _filter || !_caseSensitive && item.label.toLowerCase() == _filter.toLowerCase())
				{
					// temperary remove listener for CHANGE events to prevent recursive loops
					textField.removeEventListener(Event.CHANGE, handleInputChange);
					list.selectedItem = item.data;
					textField.addEventListener(Event.CHANGE, handleInputChange);
					return true;
				}
			}
			return false;
		}

		protected function handleInputChange(event:Event):void
		{
			_filter = text;
			
			if (FocusManager.focus == textField)
			{
				if (filterItems())
				{
					close();
				}
				else if (list.length > 0)
				{
					open();
				}
				else
				{
					close();
				}
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
			if (_items) while(_items.length) _items.shift().destruct();
			
			_items = null;
			_filter = null;
			
			super.destruct();
		}
	}
}