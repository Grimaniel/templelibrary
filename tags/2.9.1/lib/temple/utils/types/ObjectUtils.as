/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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

package temple.utils.types 
{
	import temple.core.ICoreObject;
	import temple.data.Enumerator;
	import temple.data.xml.XMLParser;
	import temple.debug.getClassName;
	import temple.utils.ObjectType;

	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
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
		 * Indicates if a Date will be fully traced (including all properties) on traceObject() (true) or only as a simple String (false)
		 */
		public static var subTraceDate:Boolean = false;

		/**
		 * Indicates if a constant will be traced on traceObject() (true) or not (false)
		 */
		public static var traceConstants:Boolean = false;

		/**
		 * Indicates if a methods will be traced on traceObject() (true) or not (false)
		 */
		public static var traceMethods:Boolean = false;
		
		/**
		 *
		 */
		public static function isPrimitive(value:*):Boolean
		{
			if (value is String || value is Number || value is int || value is uint || value == null)
			{
				return true;	
			}
			return false;
		}
		
		/**
		 * Recursively traces the properties of an object
		 * @param object object to trace
		 * @param maxDepth indicates the recursive factor
		 * @param doTrace indicates if the function will trace the output or only return it
		 * 
		 * @return the object tree as String
		 */
		public static function traceObject(object:Object, maxDepth:uint = 3, doTrace:Boolean = true, traceDuplicates:Boolean = true):String
		{
			var output:String = ObjectUtils._traceObject(object, maxDepth, traceDuplicates ? null : new Dictionary(true));
			
			if (doTrace) trace(output);
			
			return output;
		}

		private static function _traceObject(object:Object, maxDepth:uint = 3, objects:Dictionary = null, inOpenChar:String = null, isInited:Boolean = false, openChar:String = null, tabs:String = ""):String
		{
			var output:String = "";
			
			// every time this function is called we'll add another tab to the indention in the output window
			tabs += "\t";
			
			if (maxDepth < 0 )
			{
				output += tabs + "\n(...)";
				output += "\n" + tabs + ((inOpenChar == "[") ? "]" : "}");
				return output;
			}
			
			if (!isInited) 
			{
				isInited = true;
				output += ObjectUtils.objectToString(object) + " (" + getClassName(object) + ")";
				
				if (object is String) 
				{
					output += " (" + (object as String).length + ")";
					return output; 
				}
				else if (object is uint || object is int) 
				{
					output += " (0x" + Number(object).toString(16).toUpperCase() + ")";
					return output; 
				}
				else if (object is Array) 
				{
					output += " (" + (object as Array).length + ")"; 
					if ((object as Array).length) inOpenChar = openChar = "[";
				}
				else if (!ObjectUtils.isPrimitive(object)) 
				{
					inOpenChar = openChar = "\u007B";
					
					if (ObjectUtils.isDynamic(object))
					{
						output += " (dynamic)";
					}
				}
				
				if (openChar) output += "\n" + openChar;
			}
			
			var variables:Array;
			var key:*;

			if (object is Array)
			{
				
				variables = new Array();
				for (key in object)
				{
					variables.push(new ObjectVariableData(key));
				}
			}
			else
			{
				var description:XML = describeType(object);
				
				// variables
				variables = XMLParser.parseList(description.variable, ObjectVariableData, true);
				
				// getters
				variables = variables.concat(XMLParser.parseList(description.accessor, ObjectVariableData, true));

				// constants
				if (ObjectUtils.traceConstants) variables = variables.concat(XMLParser.parseList(description.constant, ObjectVariableData, true));

				// method
				if (ObjectUtils.traceMethods) variables = variables.concat(XMLParser.parseList(description.method, ObjectVariableData, true));
				
				// dynamic values
				for (key in object)
				{
					variables.push(new ObjectVariableData(key));
				}
				// sort variables alphabaticly
				variables = variables.sortOn('name', Array.CASEINSENSITIVE);
			}
			
			var variable:*;
			
			// an object for temporary storing the key. Needed to prefend duplicates
			var keys:Object = {};
			
			var leni:int = variables.length;
			for (var i:int = 0;i < leni; i++) 
			{
				var vardata:ObjectVariableData = variables[i] as ObjectVariableData;
				
				if (vardata.name == "textSnapshot" || vardata.name == null || keys[vardata.name]) continue;
				
				keys[vardata.name] = true;
				
				try
				{
					variable = object[vardata.name];
				}
				catch (e:Error)
				{
					variable = e.message;
				}
				
				// determine what's inside...
				switch (typeof(variable))
				{
					case ObjectType.STRING:
					{
						output += "\n" + tabs + vardata.name + ": \"" + variable + "\" (" + (vardata.type ? vardata.type : getClassName(variable)) + ")" ;
						break;
					}
					case ObjectType.OBJECT:
					{
						// check to see if the variable is an array.
						if (variable is Array) 
						{
							if ((objects == null || !objects[variable]) && ObjectUtils.hasValues(variable) && maxDepth)
							{
								if (objects) objects[variable] = true;
								
								output += "\n" + tabs + vardata.name + ": Array(" + (variable as Array).length + ")\n" + tabs + "[";
								output += ObjectUtils._traceObject(variable, maxDepth - 1, objects, "[", isInited, openChar, tabs);
							}
							else
							{
								output += "\n" + tabs + vardata.name + ": Array(" + (variable as Array).length + ") []";
							}
						}
						else if (variable is ByteArray)
						{
							output += "\n" + tabs + vardata.name + ": " + uint(ByteArray(variable).bytesAvailable / 1024) + "KB " + (['AMF0',,,'AMF3'][(ByteArray(variable).objectEncoding)]) + " position:" + ByteArray(variable).position + " (ByteArray)";
						}
						else if (variable is Enumerator)
						{
							output += "\n" + tabs + vardata.name + ": " + variable + (vardata.type ? " (" + getClassName(variable || vardata.type) + ")" : "") + " (" + getClassName(Enumerator) + ")";
						}
						else 
						{
							// object, make exception for Date
							if ((objects == null || !objects[variable]) && (variable && maxDepth && (ObjectUtils.subTraceDate || !(variable is Date))))
							{
								if (objects) objects[variable] = true;
								
								// recursive call
								output += "\n" + tabs + vardata.name + ": " + variable;
								if (ObjectUtils.hasValues(variable))
								{
									if (ObjectUtils.isDynamic(variable))
									{
										output += " (dynamic)";
									}
									
									output += "\n" + tabs + "\u007B";
									output += ObjectUtils._traceObject(variable, maxDepth - 1, objects, "\u007B", isInited, openChar, tabs);
								}
							}
							else
							{
								output += "\n" + tabs + vardata.name + ": " + variable + (vardata.type ? " (" + (vardata.type == "*" ? vardata.type : getClassName(variable || vardata.type)) + ")" : "") + (objects && objects[variable] ? " (duplicate)" : "");
							}
						}
						break;
					}
					case ObjectType.FUNCTION:
					{
						output += "\n" + tabs + vardata.name + "(";
						
						if (vardata.xml.parameter && vardata.xml.parameter is XMLList)
						{
							var lenj:int = (vardata.xml.parameter as XMLList).length();
							var optional:Boolean = false;
							for (var j:int = 0; j < lenj; j++)
							{
								if (j) output += ", ";
								if (!optional && vardata.xml.parameter[j].@optional == "true")
								{
									optional = true;
									output += "(";
								}
								output += "arg" + vardata.xml.parameter[j].@index + ":" + getClassName(String(vardata.xml.parameter[j].@type));
							}
							if (optional) output += ")";
						}
						output += ") (" + getClassName(variable) + ")";
						break;
					}
					default:				
					{
						vardata.type ||= getClassName(variable);
						
						//variable is not an object nor string, just trace it out normally
						output += "\n" + tabs + vardata.name + ": " + variable + " (" + vardata.type + ")";
						
						// add value as hex for uints
						if (vardata.type == "uint" || vardata.type == "int") output += " 0x" + uint(variable).toString(16).toUpperCase();
						
						break;
					}
				}
			}
			
			// here we need to displaying the closing '}' or ']', so we bring
			// the indent back a tab, and set the outerchar to be it's matching
			// closing char, then display it in the output window
			tabs = tabs.substr(0, tabs.length - 1);
			 
			if (inOpenChar) output += "\n" + tabs + ((inOpenChar == "[") ? "]" : "}");
			
			return output;
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
			for each (var node : XML in describeType(object).accessor.(@access == 'readwrite' || @access == 'readonly'))
			{
				result[node.@name] = object[node.@name];
			}
			return result;
		}
		
		/**
		 * Creates a copy of an object. Works only for dynamic properties.
		 */
		public static function clone(object:Object):Object
		{
			var copy:Object = new Object();
			for (var key:* in object)
			{
				copy[key] = object[key];
			}
			return copy;
		}
		
		/**
		 * Get the keys and properties of an object.
		 * @return an Array of all the keys
		 */
		public static function getProperties(object:Object):Array
		{
			var keys:Array = new Array();
			var key:*;
			
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
					keys.push(String(description.variable[i].@name));
				}
				
				// getters
				var getters:XMLList = description.accessor.(@access != "writeonly");
				
				leni = getters.length();
				
				for (i = 0; i < leni; i++)
				{
					keys.push(String(getters[i].@name));
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
		 * Check if there are proerties defined
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
		public static function objectToString(object:*):String
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
			else if (object is DisplayObject)
			{
				return getClassName(object) + ": " + ObjectUtils.objectToString((object as DisplayObject).name);
			}
			else if (object is Function)
			{
				return FunctionUtils.functionToString(object);
			}
			return String(object);
		}

		/**
		 * Lazy get a property from a object, with alt/default-value (if object is null or property is undefined)
		 * 
		 * very usefull for bulk JSON/Object-data import 
		 */
		public static function getValueAlt(obj:Object, name:String, alt:*):*
		{
			if(obj && obj && name in obj)
			{
				return obj[name];
			}
			return alt;
		}
		/**
		 * Lazy get a boolean-property from an object (using BooleanUtils.getBoolean), with alt/default-value (if object is null or property is undefined)
		 * 
		 * very usefull for bulk JSON/Object-data import
		 */
		public static function getBooleanAlt(obj:Object, name:String, alt:Boolean):Boolean
		{
			if(obj && name in obj)
			{
				return BooleanUtils.getBoolean(obj[name]);
			}
			return alt;
		}
		
		/**
		 * Compact format Object-properties to debug-string (Array.join()-like), usually simple non-recursive bulletted lists
		 * - propaA = 11
		 * - propaB = 22
		 * - propaC = 33
		 */
		public static function simpleJoin(obj:Object, sort:Boolean = true, post:String = '\n', pre:String = ' - ', glue:String = ' = ',seperator:String = ''):String
		{
			if(!obj)
			{
				return '(null)' + post;
			}
			var arr:Array = [];
			for(var name:String in obj)
			{
				arr.push(pre + name + glue + obj[name] + post);
			}
			if(arr.length == 0)
			{
				return '(empty)' + post;
			}
			if(sort)
			{
				arr.sort();
			}
			return arr.join(seperator);
		}
		
		/**
		 * Compact Object-properties to one-line debug string 
		 * propA:11,propB:22,propC:33
		 */
		public static function simpleJoinS(obj:Object):String
		{
			return ObjectUtils.simpleJoin(obj, true, '', '', ':', ',');
		}
		
		public static function toString():String
		{
			return objectToString(ObjectUtils);
		}
	}
}