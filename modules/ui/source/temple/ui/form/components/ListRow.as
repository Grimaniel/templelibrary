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
	import temple.ui.buttons.LabelButton;

	/**
	 * A ListRow visualizes an item in a list.
	 * 
	 *  <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see ../../../../../readme.html
	 * 
	 * @author Thijs Broerse
	 */
	public class ListRow extends LabelButton implements IListRow, IHasValue
	{
		private var _data:*;
		private var _index:uint;

		public function ListRow()
		{
			this.buttonBehavior.clickOnEnter = true;
			this.buttonBehavior.clickOnSpacebar = true;
		}

		/**
		 * @inheritDoc
		 */
		public function get data():*
		{
			return this._data ? this._data : this.label;
		}

		/**
		 * @inheritDoc
		 */
		public function set data(value:*):void
		{
			this._data = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get index():uint
		{
			return this._index;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set index(value:uint):void
		{
			this._index = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			return this.data;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._data = null;
			super.destruct();
		}
	}
}
