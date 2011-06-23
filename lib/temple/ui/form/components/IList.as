/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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
	import temple.ui.IResettable;
	import temple.core.ICoreDisplayObject;
	import temple.destruction.IDestructibleEventDispatcher;
	import temple.ui.IDisplayObjectContainer;
	import temple.ui.focus.IFocusable;
	import temple.ui.form.validation.IHasValue;
	import temple.ui.scroll.ScrollBehavior;

	/**
	 * @author Thijs Broerse
	 */
	public interface IList extends IDestructibleEventDispatcher, IDisplayObjectContainer, IHasValue, ISetValue, IFocusable, ICoreDisplayObject, IResettable
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
		 */
		function addItems(items:Array, labels:Array = null):void
		
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
		 * Gets or sets the number of rows that are at least partially visible in the list. 
		 */
		function get rowCount():uint
		
		/**
		 * @private
		 */
		function set rowCount(value:uint):void
		
		/**
		 * Sorts the items in the list.
		 */
		function sortItems(...sortArgs):void
		
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
	}
}
