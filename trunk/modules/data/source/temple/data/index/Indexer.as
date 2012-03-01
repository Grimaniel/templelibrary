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
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * The Indexer stores IIndexable object based on there type (Class) and id, so this combination must be unique.
	 * The Indexer is used for easy retrieve objects based on there id. Specially useful when parsing data (from the backend)
	 * and map id's to the real objects.
	 * 
	 * @includeExample JSONIndexExample.as  
	 * 
	 * @author Thijs Broerse
	 */
	public class Indexer 
	{
		/**
		 * Static getter on the class of the IIndexable object which returns the type of the object. This method is used by the 'add()' method to define the type when no type is passed."
		 */
		public static const INDEX_CLASS:String = "indexClass";
		
		private static const _INDEX:Dictionary = new Dictionary();

		/**
		 * Add an object to the Indexer.
		 */
		public static function add(object:IIndexable, type:Class = null):void 
		{
			if (!object.id)
			{
				throwError(new TempleError(Indexer, "Object does not have an id"));
			}
			else
			{
				if (type)
				{
					if (!(object is type)) throwError(new TempleArgumentError(Indexer, "This is not the correct type for object \"" + object + "\""));
				}
				else
				{
					type = getDefinitionByName(getQualifiedClassName(object)) as Class;
					
					if (Object(type).hasOwnProperty(INDEX_CLASS) && type[INDEX_CLASS] is Class && object is type[INDEX_CLASS])
					{
						type = type[INDEX_CLASS];
					}
				}
				if (!Indexer._INDEX[type]) Indexer._INDEX[type] = {};
				
				if (Indexer._INDEX[type][object.id] && Indexer._INDEX[type][object.id] != object)
				{
					throwError(new TempleError(Indexer, "Indexer already has a \"" + getQualifiedClassName(type) + "\" with the same id: " + Indexer._INDEX[type][object.id] + ".\n" + object + " can not be added."));
				}
				else
				{
					Indexer._INDEX[type][object.id] = object;
				}
			}
		}
		
		/**
		 * Removes an object from the Indexer.
		 */
		public static function remove(object:IIndexable, type:Class = null):void 
		{
			if (!object.id)
			{
				throwError(new TempleError(Indexer, "Object does not have an id"));
			}
			else
			{
				if (type)
				{
					if (!(object is type)) throwError(new TempleArgumentError(Indexer, "This is not the correct type for object \"" + object + "\""));
				}
				else
				{
					type = getDefinitionByName(getQualifiedClassName(object)) as Class;
				}
				if (Indexer._INDEX[type])
				{
					delete Indexer._INDEX[type][object.id];
				}
				
			}
		}
		
		/**
		 * Get an object based on his type (Class) and id.
		 */
		public static function get(type:Class, id:String):IIndexable 
		{
			return Indexer._INDEX[type] && Indexer._INDEX[type][id] ? Indexer._INDEX[type][id] : null;
		}

		/**
		 * Checks if the Indexer has an object with this type (Class) and id.
		 */
		public static function has(type:Class, id:String = null):Boolean 
		{
			return Indexer._INDEX[type] && (id == null || Indexer._INDEX[type][id]);
		}

		/**
		 * Clears a single object, all objects of a specific type, or all object stored in the Indexer.
		 * @param type defines the type of object(s) that must be removed from the Indexer. If set to null, all objects will be removed from the Indexer.
		 * @param id defined the id of the object that must be removed from the Indexer. If set to null, all objects of the given type will be removed.
		 */
		public static function clear(type:Class = null, id:String = null):void 
		{
			if (type == null)
			{
				for (var key:Object in Indexer._INDEX)
				{
					delete Indexer._INDEX[key];
				}
			}
			else if (id != null)
			{
				delete Indexer._INDEX[type][id];
			}
			else
			{
				delete Indexer._INDEX[type];
			}
		}

		
		public static function toString() : String
		{
			return objectToString(Indexer);
		}
	}
}
