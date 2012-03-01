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
	import temple.core.CoreObject;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class ListItemData extends CoreObject  implements IListItemData
	{
		internal var selected:Boolean;
		internal var row:IListRow;
		
		private var _data:*;
		private var _label:String;
	
		public function ListItemData(data:* = null, label:String = null) 
		{
			this._data = data;
			this._label = label;
			this.toStringProps.push('label', 'data');
		}
		
		/**
		 * @inheritDoc
		 */
		public function get data() : *
		{
			return this._data;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(type="String")]
		public function set data(value : *) : void
		{
			this._data = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get label() : String
		{
			return this._label;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(type="String")]
		public function set label(value : String) : void
		{
			this._label = value;
		}
	
		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			this._data = null;
			this._label = null;
			this.row = null;
			
			super.destruct();
		}
	}
}
