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

package temple.data.index 
{
	import temple.core.CoreObject;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	/**
	 * Abstract implementation of an Indexable class.
	 * 
	 * <p>Use this class as a base class for classes which must be stored in the Indexer.</p>
	 * 
	 * @see temple.data.index.Indexer
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractIndexable extends CoreObject implements IIndexable 
	{
		private var _id:String;
		private var _indexClass:Class;
		
		public function AbstractIndexable(id:String = null, indexClass:Class = null)
		{
			if (indexClass) this.indexClass = indexClass;
			if (id) this.id = id;
			this.toStringProps.push('id', 'indexClass');
		}
		
		/**
		 * @inheritDoc
		 */
		public function get id():String
		{
			return this._id;
		}
		
		/**
		 * @private
		 */
		public function set id(value:String):void
		{
			if (value == this._id)
			{
				return;
			}
			else if (this._id)
			{
				throwError(new TempleError(this, "Id is already set and can not be overwritten"));
			}
			else
			{
				this._id = value;
				Indexer.add(this, this.indexClass);
			}
		}
		
		/**
		 * The class on which this object is indexed. If null, the class is defined at runtime.
		 * Type can not be set after the id is set.
		 */
		[Transient]
		public function get indexClass():Class
		{
			return this._indexClass;
		}
		
		/**
		 * @private
		 */
		public function set indexClass(type:Class):void
		{
			if (this._id)
			{
				throwError(new TempleError(this, "indexClass can not be set when the id is already set."));
			}
			else
			{
				this._indexClass = type;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			Indexer.remove(this, this.indexClass);
			
			super.destruct();
		}
	}
}
