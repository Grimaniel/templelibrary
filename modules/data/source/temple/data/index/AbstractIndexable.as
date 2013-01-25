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
			toStringProps.push('id', 'indexClass');
		}
		
		/**
		 * @inheritDoc
		 */
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * @private
		 */
		public function set id(value:String):void
		{
			if (value == _id)
			{
				return;
			}
			else if (_id)
			{
				throwError(new TempleError(this, "Id is already set (" + _id + ") and can not be overwritten (" + value + ")"));
			}
			else if (value)
			{
				_id = value;
				Indexer.add(this, indexClass);
			}
		}
		
		/**
		 * The class on which this object is indexed. If null, the class is defined at runtime.
		 * Type can not be set after the id is set.
		 */
		[Transient]
		public function get indexClass():Class
		{
			return _indexClass;
		}
		
		/**
		 * @private
		 */
		[Temple]
		public function set indexClass(type:Class):void
		{
			if (_id)
			{
				throwError(new TempleError(this, "indexClass can not be set when the id is already set."));
			}
			else
			{
				_indexClass = type;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			Indexer.remove(this, indexClass);
			
			super.destruct();
		}
	}
}
