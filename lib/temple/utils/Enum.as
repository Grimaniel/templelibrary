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
 */
package temple.utils 
{
	import flash.utils.describeType;

	/**
	 * 
	 *	Reads the values of all constants (optionally of specified type) to an Array or Object.
	 *
	 *		var myConstantValues:Array = Enum.getEnumArray(MyVarsClass, Enum.STRING);
	 *	
	 *	or
	 *		 *		var myConstantNameValues:Object = Enum.getEnumHash(MyVarsClass, Enum.STRING);
	 *		
	 *	@example
	 *	<listing version="3.0">
	 *	var allPages:Array = Enum.getEnumArray(PageBranches);
	 *		
	 *	var havePageBranch:Boolean = allPages.indexOf(somePageBranch) > -1;
	 *	</listing>
	 *	
	 * @author Bart van der Schoor
	 */
	public final class Enum 
	{
		public static const STRING:String = 'String';
		public static const INT:String = 'int';
		public static const NUMBER:String = 'Number';

		public static function getEnumArray(type:Class, constType:String = Enum.STRING):Array
		{
			var arr:Array = new Array();
			var xml:XML = describeType(type);
			var list:XMLList = xml.child('constant');		
			for each(var node:XML in list)
			{
				if(type == null || node.@['type'] == constType)
				{
					arr.push(type[node.@['name']]);
				}
			}
			return arr;
		}

		public static function getEnumHash(type:Class, constType:String = Enum.STRING):Object
		{
			var arr:Object = new Object();
			var xml:XML = describeType(type);
			var list:XMLList = xml.child('constant');		
			for each(var node:XML in list)
			{
				if(type == null || node.@['type'] == constType)
				{
					arr[node.@['name']] = type[node.@['name']];
				}
			}
			return arr;
		}
		
		public static function getValue(type:Class, value:*):*
		{
			var xml:XML = describeType(type);
			var list:XMLList = xml.child('constant');		
			for each(var node:XML in list)
			{
				if(type == null || type[node.@['name']] == value)
				{
					return value;
				}
			}
			return null;
		}
	}
}
