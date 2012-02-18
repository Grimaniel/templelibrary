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

package temple.ui.pagination
{
	import temple.core.CoreObject;
	import temple.core.debug.IDebuggable;

	/**
	 * Divides an <code>Array</code> into paginated data and makes the Array paginatable.
	 * 
	 * @author Thijs Broerse
	 */
	public class ArrayPaginator extends CoreObject implements IPaginator, IPaginatedData, IDebuggable
	{
		private var _array:Array;
		private var _resultsPerPage:uint;
		private var _currentPage:uint;
		private var _debug:Boolean;
		
		public function ArrayPaginator(array:Array = null, resultsPerPage:uint = 10)
		{
			this._array = array;
			this._resultsPerPage = resultsPerPage;
			this.toStringProps.push("currentPage", "resultsPerPage", "totalPages");
		}
		
		/**
		 * Returns a reference to the original Array
		 */
		public function get array():Array
		{
			return this._array;
		}

		/**
		 * @private
		 */
		public function set array(value:Array):void
		{
			this._array = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get totalResults():uint
		{
			return this._array ? this._array.length : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get totalPages():int
		{
			return Math.ceil(this.totalResults / this._resultsPerPage);
		}

		/**
		 * @inheritDoc
		 */
		public function get resultsPerPage():uint
		{
			return this._resultsPerPage;
		}
		
		/**
		 * @private
		 */
		public function set resultsPerPage(value:uint):void
		{
			this._resultsPerPage = value;
			if (this.debug) this.logDebug("resultsPerPage: " + value);
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPage():uint
		{
			return this._currentPage;
		}

		/**
		 * @private
		 */
		public function set currentPage(value:uint):void
		{
			this._currentPage = value;
			if (this.debug) this.logDebug("currentPage: " + this._currentPage);
		}

		/**
		 * @inheritDoc
		 */
		public function get hasNextPage():Boolean
		{
			return this._currentPage < this.totalPages - 1;
		}

		/**
		 * @inheritDoc
		 */
		public function get hasPreviousPage():Boolean
		{
			return this._currentPage > 0;
		}

		/**
		 * @inheritDoc
		 */
		public function nextPage():void
		{
			if (this.hasNextPage) this._currentPage++;
		}

		/**
		 * @inheritDoc
		 */
		public function previousPage():void
		{
			if (this.hasPreviousPage) this._currentPage--;
		}

		/**
		 * @inheritDoc
		 */
		public function firstPage():void
		{
			this._currentPage = 0;
			if (this.debug) this.logDebug("firstPage");
		}

		/**
		 * @inheritDoc
		 */
		public function lastPage():void
		{
			this._currentPage = this.totalPages - 1;
			if (this.debug) this.logDebug("lastPage");
		}

		/**
		 * @inheritDoc
		 */
		public function gotoPage(page:uint):void
		{
			this._currentPage = page;
			if (this.debug) this.logDebug("gotoPage: " + page);
		}

		/**
		 * @inheritDoc
		 */
		public function get pagination():IPagination
		{
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function get data():Array
		{
			return this._array ? this._array.slice(this._currentPage * this._resultsPerPage, (this._currentPage + 1) * this._resultsPerPage) : null;
		}

		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._array = null;
			super.destruct();
		}
	}
}
