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
package temple.utils 
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;

	/**
	 * 	Utils for working with public static constants (list, validate etc)
	 *	
	 *	@example
	 *	<listing version="3.0">
	 *	
	 *	//get values
	 *	var myValues:Array = Enum.getArray(MyVarsClass, Enum.STRING);
	 *	var myNameValues:Object = Enum.getHash(MyVarsClass, Enum.STRING);
	 *	
	 *	//check values
	 *	if(Enum.hasValue(MyValidateConst, myValue))
	 *	{
	 *		...
	 *	}	
	 *	if(Enum.hasConstant(MyValidateConst, myConstName))
	 *	{
	 *		...
	 *	}
	 *	
	 *	</listing>
	 *	
	 * @author Bart van der Schoor
	 */
	public final class Enum 
	{
		/**
		 * Get an Array with constant-values from given Class
		 * 
		 * @param type the Class to check for constants 
		 * @param constType optionaly specifiy a type of value to check
		 * @return the 
		 */
		public static function getArray(type:Class, constType:Class = null):Array
		{
			var arr:Array = [];
			var className:String = constType ? getQualifiedClassName(constType) : null;
			for each (var node:XML in describeType(type).children().(name() == 'variable' || name() == 'constant'))
			{
				if (constType == null || node.@['type'] == className)
				{
					arr.push(type[node.@['name']]);
				}
			}
			return arr;
		}
		/**
		 * Get a generic Object with constant-names as key and constant-values as value from given Class
		 * 
		 * @param type the Class to check for constants 
		 * @param constType optionaly specifiy a type of value to check
		 * @return the 
		 */
		public static function getHash(type:Class, constType:Class = null):Object
		{
			var obj:Object = {};
			var className:String = constType ? getQualifiedClassName(constType) : null;
			for each (var node:XML in describeType(type).children().(name() == 'variable' || name() == 'constant'))
			{
				if (constType == null || node.@['type'] == className)
				{
					obj[node.@['name']] = type[node.@['name']];
				}
			}
			return obj;
		}
		
		/**
		 * Validates a constant value, return it if found, otherwise return alt 
		 * 
		 * @param type the Class to check for constants 
		 * @param value the value we look for
		 * @param alt optionaly specifiy what to return if not found
		 * @param constType optionaly specifiy a type of value to check
		 * @return value if defined, otherwise alt
		 */
		public static function getValue(type:Class, value:*, alt:*=null, constType:Class = null):*
		{
			var className:String = constType ? getQualifiedClassName(constType) : null;
			for each (var node:XML in describeType(type).children().(name() == 'variable' || name() == 'constant'))
			{
				if ((constType == null || node.@['type'] == className) && type[node.@['name']] == value)
				{
					return value;
				}
			}
			return alt;
		}
		
		/**
		 * Check if the class has a constant defined with this value
		 * 
		 * @param type the Class to check for constants 
		 * @param value the constants value we look for
		 * @param constType optionaly specifiy a type of value to check
		 * @return true if found
		 */
		public static function hasValue(type:Class, value:*, constType:Class = null):Boolean
		{
			var className:String = constType ? getQualifiedClassName(constType) : null;
			for each (var node:XML in describeType(type).children().(name() == 'variable' || name() == 'constant'))
			{
				if ((constType == null || node.@['type'] == className) && value == type[node.@['name']])
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * Check if the class has a constant defined with this name
		 * 
		 * @param type the Class to check for constants 
		 * @param constant the name of the constant we look for
		 * @param constType optionaly specifiy a type of value to check
		 * @return true if found
		 */
		public static function hasConstant(type:Class, constant:String, constType:Class = null):Boolean
		{
			var className:String = constType ? getQualifiedClassName(constType) : null;
			for each (var node:XML in describeType(type).children().(name() == 'variable' || name() == 'constant'))
			{
				if ((constType == null || node.@['type'] == className) && node.@['name'] == constant)
				{
					return true;
				}
			}
			return false;
		}
	}
}
