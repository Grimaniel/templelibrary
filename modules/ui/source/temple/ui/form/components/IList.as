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
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.IResettable;
	import temple.core.display.ICoreDisplayObject;
	import temple.core.display.IDisplayObjectContainer;
	import temple.core.events.ICoreEventDispatcher;
	import temple.ui.scroll.ScrollBehavior;

	/**
	 * A <code>List</code> is a <code>DisplayObject</code> for showing a set of data and let's the user select one or
	 * multiple items. A <code>List</code> can be used in a <code>Form</code>. A single item is displayed in the
	 * <code>List</code> as a <code>IListRow</code>.
	 * 
	 * <p>A <code>List</code> is also used in a <code>ComboBox</code>.</p>
	 * 
	 * @see temple.ui.form.components.List
	 * @see temple.ui.form.components.ComboBox
	 * @see temple.ui.form.Form
	 * @see temple.ui.form.components.IListRow
	 * @see temple.ui.form.components.ListRow
	 * 
	 * @author Thijs Broerse
	 */
	public interface IList extends ICoreEventDispatcher, IDisplayObjectContainer, IHasValue, ISetValue, IFocusable, ICoreDisplayObject, IResettable
	{
		/**
		 * Add an items to the list.
		 */
		function addItem(data:*, label:String = null):void

		/**
		 * Add an items to the list at a specific index.
		 */
		function addItemAt(data:*, index:uint, label:String = null):void
		
		/**
		 * Adds more items at once.
		 * @param items the items to add
		 * @param labels an optional value for specifying the labels for the items.
		 * 	If labels is an Array the value with the same index as the item is used as label.
		 * 	If labels is a String, the property with this name of the item is used as label.
		 */
		function addItems(items:Array, labels:* = null):void
		
		/**
		 * Gets the item on a specific position.
		 */
		function getItemAt(index:uint):*
		
		/**
		 * Sets the item on a specific position.
		 */
		function setItemAt(data:*, index:uint, label:String = null):void

		/**
		 * Gets the label of the item on a specific position.
		 */
		function getLabelAt(index:uint):String

		/**
		 * Sets the label of the item on a specific position.
		 */
		function setLabelAt(index:uint, label:String):void
		
		/**
		 * Checks whether the specified item is selected in the list.
		 */
		function isItemSelected(data:*, label:String = null):Boolean

		/**
		 * Checks whether the specified index is selected in the list.
		 */
		function isIndexSelected(index:uint):Boolean

		/**
		 * Removes the specified item from the list.
		 * Returns a Boolean which indicates if the removal was successful.
		 */
		function removeItem(data:*, label:String = null):Boolean
		
		/**
		 * Removes an item on a specific position.
		 * Returns a Boolean which indicates if the removal was successful.
		 */
		function removeItemAt(index:uint):Boolean
		
		/**
		 * Removes all items from the list.  
		 */
		function removeAll():void
				
		/**
		 * Get or set the index of the current selected item.
		 * Of multiple selections is true, the index of the last selected item is returned.
		 * NOTE: index is zero based, so 0 will be the first item.
		 * A value of -1 indicates that no item is selected.
		 */
		function get selectedIndex():int
		
		/**
		 * @private
		 */
		function set selectedIndex(value:int):void
		
		/**
		 * Get the current selected item.
		 * Of multiple selections is true, the last selected item is returned.
		 */
		function get selectedItem():*
		
		/**
		 * @private
		 */
		function set selectedItem(value:*):void

		/**
		 * Get the label of the selected item.
		 * Of multiple selections is true, the label of the last selected item is returned
		 */
		function get selectedLabel():String
		
		/**
		 * @private
		 */
		function set selectedLabel(value:String):void

		/**
		 * Gets or sets an array that contains the objects for the items that were selected from the multiple-selection list.
		 */
		function get selectedItems():Array
		
		/**
		 * @private
		 */
		function set selectedItems(value:Array):void
		
		/**
		 * Get the labels of the selected items
		 */
		function get selectedLabels():Array
		
		/**
		 * @private
		 */
		function set selectedLabels(value:Array):void
		
		/**
		 * Gets the number of items in the list.
		 */
		function get length():uint
		
		/**
		 * indicates if multiple selection (select more then one item) is allowed.
		 * Set if multiple selection (select more then one item) is allowed, default it is not allowed.
		 */
		function get allowMultipleSelection():Boolean
		
		/**
		 * @private
		 */
		function set allowMultipleSelection(value:Boolean):void
		
		/**
		 * Indicates if the previous selection would automaticly be deselected if a new item is selected, unless shift or ctrl key is pressed.
		 * Only works if allowMultipleSelection equals true.
		 */
		function get autoDeselect():Boolean
		
		/**
		 * @private
		 */
		function set autoDeselect(value:Boolean):void
		
		/**
		 * Get or set the height of a single row.
		 */
		function get rowHeight():Number
		
		/**
		 * @private
		 */
		function set rowHeight(value:Number):void
		
		/**
		 * The number of rows that are at least partially visible in the list.
		 */
		function get rowCount():uint
		
		/**
		 * @private
		 */
		function set rowCount(value:uint):void
		
		/**
		 * Sorts the items in the list. This method sorts according to the function provided as the compareFunction parameter.
		 * @param compareFunction A optional comparison method that determines the behavior of the sort.
		 * The specified method must take two arguments of the base type <code>IListItemData</code> and return a Number:
		 * @example
		 * <listing version="3.0">
		 * function compare(item1:IListItemData, item2:IListItemData):Number {}
		 * </listing>
		 * The logic of the compareFunction function is that, given two elements x and y, the function returns one of the following three values:
		 * <ul>
		 * 	<li>a negative number, if x should appear before y in the sorted sequence</li>
		 * 	<li>0, if x equals y</li>
		 * 	<li>a positive number, if x should appear after y in the sorted sequence</li>
		 * </ul>
		 * If no sortFunction is specified, the items will be sorted alphabetically on their label.
		 * 
		 * @see temple.ui.form.components.IListItemData
		 */
		function sortItems(compareFunction:Function = null):void
		
		/**
		 * Indicates if a search automaticly should continue to the begin when reaching the end .
		 */
		function get wrapSearch():Boolean
		
		/**
		 * @private
		 */
		function set wrapSearch(value:Boolean):void
		
		/**
		 * Select the first (or next) item starting with 'string'.
		 * @param string: the string to search for.
		 * @param caseSensitive (optional): set the case sensitive, default false.
		 */
		function searchOnString(string:String, caseSensitive:Boolean = false):void
		
		/**
		 * Indicate if auto select on keyboard is true.
		 * If set to true, user can use keyboard to automaticly select next (or first) item starting with the key.
		 */
		function get keySearch():Boolean
		
		/**
		 * @private
		 */
		function set keySearch(value:Boolean):void

		/**
		 * Returns a reference to the ScrollBehavior of the List.
		 */
		function get scrollBehavior():ScrollBehavior;
		
		/**
		 * Select an item
		 * @return true if the select was successful, otherwise false
		 */
		function selectItem(data:*):Boolean;
		
		/**
		 * Deselect an item
		 * @return true if the deselect was successful, otherwise false
		 */
		function deselectItem(data:*):Boolean;
	}
}
