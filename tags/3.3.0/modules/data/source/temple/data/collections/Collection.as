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