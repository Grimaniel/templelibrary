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

package temple.common.enum
{
	import flash.utils.Dictionary;
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
		public static function get(enumClass:Class, value:*):Enumerator
		{
			var className:String = getQualifiedClassName(enumClass);
			return Enumerator._lookup[className] ? Enumerator._lookup[className][value] : null;
		}
		
		private var _value:*;
		
		/**
		 * Abstract class. This class cannot be instantiated directly. You always need extend this class.
		 * 
		 * @private
		 */
		public function Enumerator(value:*)
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
				
				if (!Enumerator._lookup[className]) Enumerator._lookup[className] = new Dictionary();
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
		public final function get value():*
		{
			return this._value;
		}
		
		/**
		 * @private
		 */
		public function valueOf():*
		{
			return this._value;
		}
		
		/**
		 * @private
		 */
		public final function toString():*
		{
			return value;
		}
	}
}
