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
