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
package temple.common.enum
{
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Base class for enumerator classes with enumerable values.
	 * 
	 * <p>An Enumerator is used for strong type constants. If you have a property with 
	 * restricted values you can define these by using an Enumerator class as type of 
	 * the property.</p>
	 * 
	 * <p>Flash uses String values for enumerable properties (like stage.align), but 
	 * these values are not strict. Although only the values in the StageAlign class are
	 * valid, it is possible to set invalid values, like "this is not a valid value".</p>
	 * 
	 * <listing version="3.0">stage.align = "this is not a valid value";</listing>
	 * 
	 * <p>Of course this causes a runtime error, but no compile time error. String typed
	 * enumerable values cannot be checked at compile time. Using an Enumerator solves
	 * this problem.</p>
	 * 
	 * <p>To use the Enumerator you need to extend the Enumerator class and define all 
	 * constants inside this class with the same type as the class.</p>
	 * 
	 * <listing version="3.0">
package
{
	import temple.data.Enumerator;

	public final class Gender extends Enumerator
	{
		public static const MALE:Gender = new Gender("male");
		public static const FEMALE:Gender = new Gender("female");
		
		public function Gender(value:String)
		{
			super(value);
		}
	}
}
</listing>
	 * 
	 * <p>Type the property of your object as this class. In this case you can only set
	 * this property with instances of this class.</p>
	 * 
	 * <listing version="3.0">
package
{
	public class Person
	{
		public var name:String;
		public var gender:Gender;
	}
}
</listing>
	 *
	 * <p>Since new instances of an Enumerator can only be constructed inside the body
	 * (outside the constructor and methods) of the extended Enumerator class, it is
	 * possible to restrict the possible value of your property.</p>
	 *
	 * <p>The following code generated a runtime error since extended Enumerator can not
	 * be created outside his class definition.</p> 
	 * <listing version="3.0">
var person:Person = new Person();
person.gender = new Gender("some value");</listing>
	 * 
	 * <p><strong>Note:</strong> You should always define an Enumerator class as final, so it can not be extended.</p>
	 * 
	 * <p>Based on Mattes Groeger's "Strong typed constants".
	 * <a href="http://blog.mattes-groeger.de/actionscript/strong-typed-constants/" target="_blank">http://blog.mattes-groeger.de/actionscript/strong-typed-constants/</a>
	 * </p>
	 *  
	 * @includeExample EnumeratorExample.as
	 * @includeExample Gender.as
	 * @includeExample Person.as
	 * 
	 * @author Thijs Broerse
	 */
	public class Enumerator
	{
		private static const _lookup:Object = {};

		/**
		 * Get the value of an enumerator class based on the class and the value.
		 * 
		 * <listing version="3.0">var gender:Gender = Enumerator.get(Gender, "male") as Gender;</listing>
		 */
		public static function get(enumClass:Class, value:String):Enumerator
		{
			var className:String = getQualifiedClassName(enumClass);
			return Enumerator._lookup[className] ? Enumerator._lookup[className][value] : null;
		}
		
		private var _value:String;
		
		/**
		 * Abstract class. This class cannot be instantiated directly. You always need extend this class.
		 * 
		 * @private
		 */
		public function Enumerator(value:String)
		{
			var className:String = getQualifiedClassName(this);
			var definition:Object = getDefinitionByName(className);
			
			if (definition == Enumerator)
			{
				throwError(new TempleError(this, "Abstract class, you can't create an instance of this class"));
			}
			else if (definition != null)
			{
				throwError(new TempleError(this, "Instantiation not allowed, use statics of Class '" + getQualifiedClassName(this) + "'"));
			}
			else
			{
				this._value = value;
				
				if (!Enumerator._lookup[className]) Enumerator._lookup[className] = {};
				if (Enumerator._lookup[className][this._value])
				{
					throwError(new TempleArgumentError(this, "An Enumerator of type '" + className + "' with the same value ('" + this._value + "') is already registered."));
				}
				else
				{
					Enumerator._lookup[className][this._value] = this;
				}
			}
		}

		/**
		 * The value of the Enumarator.
		 */
		public final function get value():String
		{
			return this._value;
		}
		
		/**
		 * @private
		 */
		public final function toString() : String
		{
			return value;
		}
	}
}
