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

package temple.utils.types
{
	import temple.core.ICoreObject;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.utils.ObjectType;
	import temple.utils.AccessorAccess;

	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Proxy;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * This class contains some functions for Objects.
	 * 
	 * @author Thijs Broerse
	 */
	public final class ObjectUtils
	{
		/**
		 * Checks if the value is a primitive (String, Number, int, uint or Boolean)
		 */
		public static function isPrimitive(value:*):Boolean
		{
			if (value is String || value is Number || value is int || value is uint || value is Boolean || value == null)
			{
				return true;
			}
			return false;
		}

		/**
		 * Get the Class of an Object
		 */
		public static function getClass(object:Object):Class
		{
			return getDefinitionByName(getQualifiedClassName(object)) as Class;
		}

		/**
		 * Checks if the object has (one or more) values
		 */
		public static function hasValues(object:Object):Boolean
		{
			if (object is Array) return (object as Array).length > 0;

			for (var key:* in object)
			{
				return true;
			}
			key;

			var description:XML = describeType(object);

			return description.variable.length() || description.accessor.length();
		}

		/**
		 * Counts the number of elements in an Object
		 */
		public static function length(object:Object):int
		{
			var count:int = 0;
			for (var key:* in object)
			{
				count++;
			}
			key;
			return count;
		}

		/**
		 * Checks if the object is dynamic
		 */
		public static function isDynamic(object:Object):Boolean
		{
			var type:XML = describeType(object);
			return type.@isDynamic.toString() == "true";
		}

		/**
		 * Converts a typed object to an untyped dynamic object
		 */
		public static function toDynamic(object:Object):Object
		{
			var result:Object = new Object();
			for each (var node : XML in describeType(object).accessor.(@access == AccessorAccess.READWRITE || @access == AccessorAccess.READONLY))
			{
				result[node.@name] = object[node.@name];
			}
			return result;
		}
		
		/**
		 * Creates a clone of an object.
		 */
		public static function clone(object:Object):Object
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			byteArray.position = 0;
			return byteArray.readObject();
		}

		/**
		 * Copies properties of an Object to a new of existing object. Works only for dynamic properties.
		 * @param from source object.
		 * @param to optional target (defaults to new generic Object)
		 * @param fieldNames optional array with names specifing which properties to copy
		 */
		public static function copy(from:Object, to:Object = null, fieldNames:Array = null):Object
		{
			if (from == null) throwError(new TempleArgumentError(ObjectUtils, 'null from'));

			to ||= {};

			var name:String;
			var ret:String;

			if (fieldNames)
			{
				for each (name in fieldNames)
				{
					if (!to.hasOwnProperty(name))
					{
						ret += '- no ' + name + ' in to ' + to + '\n';
					}
					else if (!from.hasOwnProperty(name))
					{
						ret += '- no ' + name + ' in from ' + from + '\n';
					}
					else
					{
						to[name] = from[name];
					}
				}
				if (ret)
				{
					Log.warn('Propper.copyFrom: \n' + ret, ObjectUtils);
				}
			}
			else
			{
				var isDynamic:Boolean = ObjectUtils.isDynamic(to);
				
				for (name in from)
				{
					if (isDynamic || to.hasOwnProperty(name))
					{
						to[name] = from[name];
					}
				}
			}
			return to;
		}

		/**
		 * Get the keys and properties of an object.
		 * 
		 * @param object the object to get the properties of.
		 * @param accessorAccess the type of access (read, write, readwrite) of the properties. If null, all properties are returned
		 * @param namespaces a list of namespaces of the properties you want to receive.
		 * 	If null, only properties without namespace are returned.
		 * 	If the list is empty (length is 0), properties of all namespaces are returned
		 * 
		 * @return an Array of all the keys
		 * 
		 * @see temple.utils.AccessorAccess
		 */
		public static function getProperties(object:Object, accessorAccess:String = null, namespaces:Vector.<Namespace> = null):Vector.<String>
		{
			var keys:Vector.<String> = new Vector.<String>();
			var key:*;
			
			if (namespaces && namespaces.length) var uris:Vector.<String> = Vector.<String>(namespaces);

			for (key in object)
			{
				keys.push(key);
			}
			if (!(object is Array))
			{
				var description:XML = describeType(object);

				// variables
				var leni:int = description.variable.length();
				for (var i:int = 0; i < leni; i++)
				{
					if (namespaces == null && !description.variable[i].hasOwnProperty("@uri") || 
						namespaces && 
							(namespaces.length == 0
							||
							description.variable[i].hasOwnProperty("@uri") && uris.indexOf(String(description.variable[i].@uri)) != -1))
					{
						keys.push(String(description.variable[i].@name));
					}
				}

				// getters / setters
				var properties:XMLList;
				
				switch (accessorAccess)
				{
					case AccessorAccess.READONLY:
					case AccessorAccess.WRITEONLY:
					case AccessorAccess.READWRITE:
					{
						properties = description.accessor.(@access == AccessorAccess.READWRITE);
						break;
					}
					case AccessorAccess.READ:
					{
						properties = description.accessor.(@access != AccessorAccess.WRITEONLY);
						break;
					}
					case AccessorAccess.WRITE:
					{
						properties = description.accessor.(@access != AccessorAccess.READONLY);
						break;
					}
					case AccessorAccess.READ_OR_WRITE_ONLY:
					{
						properties = description.accessor.(@access != AccessorAccess.READONLY);
						break;
					}
					case AccessorAccess.ALL:
					case null:
					{
						properties = description.accessor;
						break;
					}
					default:
					{
						throwError(new TempleArgumentError(ObjectUtils, "invalid value for accessorAccess '" + accessorAccess + "'"));
						break;
					}
				}
				
				if (namespaces == null)
				{
					properties = properties.(!hasOwnProperty("@uri"));
				}
				else if (uris)
				{
					properties = properties.accessor.(hasOwnProperty("@uri") && uri.indexOf(String(@uri)) != -1);
				}
				
				leni = properties.length();

				for (i = 0; i < leni; i++)
				{
					keys.push(String(properties[i].@name));
				}
			}
			return keys;
		}
		
		/**
		 * Get the keys of an object.
		 * @return an Array of all the keys
		 */
		public static function getKeys(object:Object):Array
		{
			var keys:Array = new Array();
			for (var key:* in object)
			{
				keys.push(key);
			}
			return keys;
		}

		/**
		 * Get the values of an object.
		 * @return an Array of all values.
		 */
		public static function getValues(object:Object):Array
		{
			var values:Array = new Array();
			for each (var value:* in object)
			{
				values.push(value);
			}
			return values;
		}

		/**
		 * Check if there are properties defined
		 * @return true if we have properties
		 */
		public static function hasKeys(object:Object):Boolean
		{
			for (var key:* in object)
			{
				return true;
				key;
			}
			return false;
		}

		/**
		 * Converts an object to a readable String
		 */
		public static function convertToString(object:*):String
		{
			if (object is ICoreObject)
			{
				return String(object as ICoreObject);
			}
			else if (typeof(object) == ObjectType.STRING)
			{
				return object == null ? "null" : "\"" + object + "\"";
			}
			else if (object is XML)
			{
				return (object as XML).toXMLString();
			}
			else if (object is TextField)
			{
				return objectToString(object, Vector.<String>(['name', 'text']));
			}
			else if (object is DisplayObject)
			{
				return objectToString(object, Vector.<String>(['name']));
			}
			else if (object is Function)
			{
				return FunctionUtils.functionToString(object);
			}
			else if (object is Proxy)
			{
				try
				{
					return String(object);
				}
				catch (error:Error)
				{
					return "?";
				}
				
			}
			return String(object);
		}

		/**
		 * Compact format Object-properties to debug-string (Array.join()-like), usually simple non-recursive bulletted lists
		 * - propaA = 11
		 * - propaB = 22
		 * - propaC = 33
		 */
		public static function simpleJoin(object:Object, sort:Boolean = true, post:String = '\n', pre:String = ' - ', glue:String = ' = ', seperator:String = ''):String
		{
			if (!object)
			{
				return '(null)' + post;
			}
			var arr:Array = [];
			for (var name:String in object)
			{
				arr.push(pre + name + glue + object[name] + post);
			}
			if (arr.length == 0)
			{
				return '(empty)' + post;
			}
			if (sort)
			{
				arr.sort();
			}
			return arr.join(seperator);
		}

		/**
		 * Compact Object-properties to one-line debug string 
		 * propA:11,propB:22,propC:33
		 */
		public static function simpleJoinS(object:Object):String
		{
			return ObjectUtils.simpleJoin(object, true, '', '', ':', ',');
		}
		
		/**
		 * Returns an inverted object with all values as key and keys as value.
		 */
		public static function invert(object:Object):Object
		{
			var inverted:Object = {};
			for (var key : String in object)
			{
				inverted[object[key]] = key;
			}
			return inverted;
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(ObjectUtils);
		}
	}
}