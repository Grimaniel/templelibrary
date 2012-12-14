package temple.reflection
{
	import flash.system.ApplicationDomain;
	import temple.utils.AccessorAccess;

	/**
	 * Utility methods for handling the <code>describeType</code> XML, returned by the <code>Reflection</code> class. 
	 * 
	 * @see Reflection
	 * 
	 * @author Thijs Broerse
	 */
	public final class ReflectionUtils
	{
		/**
		 * Returns the names of the variables with specific metadata
		 */
		public static function findVariablesWithMetaData(object:*, tag:String, value:String = null, key:String = null):XMLList
		{
			var metadata:XMLList;
			return Reflection.get(object)..variable.
			(
				metadata &&
				metadata.
				(
					@name == tag && value == null && key == null
					||
					@name == tag &&
					(
						arg.
						(
							(
								value == null || @value == value
							)
							&&
							(
								key == null || @key == key || @key == ""
							)
						)
					)
					.@value[0] == value
				)
				.@name[0] == tag).@name;
		}

		/**
		 * Returns the meta data of a variable of an object
		 */
		public static function getMetaDataOfVariable(object:*, variable:String, tag:String = null):XMLList
		{
			return Reflection.get(object)..variable.(@name == variable).metadata.(tag == null || @name == tag);
		}

		/**
		 * Converts the arguments XMLList to an object
		 */
		public static function argsToObject(metadata:XMLList):Object
		{
			var object:Object = {};
			
			metadata.arg.(object[@key] = @value);
			
			return object;
		}

		/**
		 * Gets the type of a variable of an object as a String
		 */
		public static function getNameOfTypeOfVariable(object:*, variable:String):String
		{
			return Reflection.get(object)..variable.(@name == variable).@type;
		}

		/**
		 * Gets the type of a getter/setter of an object as a String
		 */
		public static function getNameOfTypeOfAccessor(object:*, accessor:String):String
		{
			return Reflection.get(object)..accessor.(@name == accessor).@type;
		}
		
		/**
		 * Gets the type of a property of an object as a String
		 */
		public static function getNameOfTypeOfProperty(object:*, property:String):String
		{
			return Reflection.get(object)..*.(hasOwnProperty('@name') && @name == property).@type;
		}

		/**
		 * Returns the type of a variable as a Class
		 */
		public static function getTypeOfVariable(object:*, variable:String):Class
		{
			var name:String = ReflectionUtils.getNameOfTypeOfVariable(object, variable);
			var domain:ApplicationDomain = Reflection.getDomain(object);
			return name && domain.hasDefinition(name) ? domain.getDefinition(name) as Class : null;
		}

		/**
		 * Checks if an object has a property with a specific namespace
		 */
		public static function hasNamespacedProperty(object:*, scope:Namespace, variable:String):*
		{
			return Reflection.get(object)..variable.(hasOwnProperty("@uri") && @uri == scope && @name == variable).length();
		}

		/**
		 * Returns the access type (read, write, readwrite) of a variable of an object
		 */
		public static function getAccessorAccess(object:*, variable:String):String
		{
			return Reflection.get(object)..accessor.(@name == variable).@access;
		}

		/**
		 * Checks if a variable of an object is readable
		 */
		public static function isReadable(object:*, variable:String):Boolean
		{
			switch (ReflectionUtils.getAccessorAccess(object, variable))
			{
				case AccessorAccess.READONLY:
				case AccessorAccess.READWRITE:
					return true;
			}
			return false;
		}

		/**
		 * Checks if a variable of an object is writable
		 */
		public static function isWritable(object:*, variable:String):Boolean
		{
			switch (ReflectionUtils.getAccessorAccess(object, variable))
			{
				case AccessorAccess.WRITEONLY:
				case AccessorAccess.READWRITE:
					return true;
			}
			return false;
		}

		/**
		 * Returns the number of argument of a constructor of an object
		 */
		public static function getNumConstructorArguments(object:*):uint
		{
			return Reflection.get(object)..constructor.parameter.length();
		}

		/**
		 * Returns the type of a constructor argument of a specific object
		 * 
		 * @param object the object to introspect
		 * @param i the index of the constructor argument to inspect
		 */
		public static function getConstructorArgumentType(object:*, i:uint):Class
		{
			var type:String = Reflection.get(object)..constructor.parameter[i].@type;
			var domain:ApplicationDomain = Reflection.getDomain(object);
			
			return type && domain.hasDefinition(type) ? domain.getDefinition(type) as Class : null;
		}
	}
}
