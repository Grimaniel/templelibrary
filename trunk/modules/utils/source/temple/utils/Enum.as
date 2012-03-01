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
