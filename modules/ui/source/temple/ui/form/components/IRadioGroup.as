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
	import temple.common.interfaces.ISelectable;
	import temple.core.events.ICoreEventDispatcher;

	/**
	 * @author Thijs Broerse
	 */
	public interface IRadioGroup extends ICoreEventDispatcher
	{
		/**
		 * Get the name of the group
		 */
		function get name():String;
		
		/**
		 *	Add a button to the group
		 *	@param item the ISelectable to add
		 *	@param value value of the button. When the button is selected this will be the value of the group
		 *	@param selected set if the buttons should be selected
		 *	@param tabIndex the order of the button in tabbing, -1 means at the end
		 *	
		 *	@return the added item
		 */
		function add(item:ISelectable, value:* = null, selected:Boolean = false, tabIndex:int = -1):ISelectable;
		
		/**
		 * Removes an item from the group
		 * @param item the ISelectable item to remove
		 */
		function remove(item:ISelectable):void
		
		/**
		 *	Get or set the specified button (can be null to deselect current selection)
		 */
		function get selected():ISelectable;

		/**
		 * @private
		 */
		function set selected(value:ISelectable):void;
		
		/**
		 * @return all items in this group; objects of type ISelectable
		 */
		function get items():Array;
	}
}
