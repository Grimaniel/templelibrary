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

package temple.data.collections 
{
	import temple.core.CoreObject;
	import temple.core.destruction.IDestructible;

	/**
	 * Class for storing a list of data object.
	 * 
	 * <p>This class is used to pass a list of data to a UI Component from the Component Inspector in the Flash IDE.</p>
	 * 
	 * @author Thijs Broerse
	 */
	public class Collection extends CoreObject implements ICollection
	{
		private var _items:Array;

		public function Collection(items:Array = null) 
		{
			if (items)
			{
				this._items = items;
			}
			else
			{
				this._items = new Array();
			}
		}

		/**
		 * @inheritDoc 
		 */
		public function addItem(item:Object):Boolean 
		{
			if (item != null ) 
			{
				this._items.push(item);
				return true;
			} 
			return false;
		}

		/**
		 * @inheritDoc 
		 */
		public function clear():void 
		{
			this._items = new Array();
		}

		/**
		 * @inheritDoc 
		 */
		public function getItemAt(index:Number):Object 
		{
			return(this._items[index]);
		}

		/**
		 * @inheritDoc 
		 */
		public function get length():int 
		{
			return this._items.length;
		}

		/**
		 * @inheritDoc 
		 */
		override public function destruct():void
		{
			if (this._items)
			{
				for each (var item : Object in this._items)
				{
					if (item is IDestructible) (item as IDestructible).destruct();
				}
				this._items = null;
			}
			
			super.destruct();
		}
	}
}