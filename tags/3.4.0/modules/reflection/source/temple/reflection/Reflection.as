package temple.reflection
{
	import flash.display.DisplayObject;

	import temple.core.templelibrary;
	import temple.core.debug.objectToString;
	import temple.core.debug.log.Log;

	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 * Static class for optimizing the <code>describeType</code> call.
	 * 
	 * @author Thijs Broerse
	 */
	public final class Reflection
	{
		public static const currentDomain:ApplicationDomain = ApplicationDomain.currentDomain;
		
		private static const _cache:Dictionary = new Dictionary();
		
		private static var _debug:Boolean;

		/**
		 * Returns the output of the <code>describeType</code> method for an object. Uses a caching system for better performance.
		 * 
		 * @see #reflect()
		 */
		public static function get(object:*, domain:ApplicationDomain = null):XML
		{
			domain ||= Reflection.getDomain(object);

			Reflection._cache[domain] ||= {};
			
			var name:String = getQualifiedClassName(object);

			if (Reflection.debug)
			{
				var description:XML = Reflection.getDescription(object, name, domain);
				if (Reflection._cache[domain][name] && String(Reflection._cache[domain][name]) != String(description) && Reflection.isAccessible(name))
				{
					Log.error("descriptions of " + object + " doens't match", Reflection);
				}
				Reflection._cache[domain][name] = description;

				return description;
			}
			else
			{
				return Reflection._cache[domain][name] ||= Reflection.getDescription(object, name, domain);
			}
		}

		/**
		 * Resolves the <code>ApplicationDomain</code> of an object.
		 */
		public static function getDomain(object:*):ApplicationDomain
		{
			return object is DisplayObject && DisplayObject(object).loaderInfo && DisplayObject(object).loaderInfo.applicationDomain ? DisplayObject(object).loaderInfo.applicationDomain : Reflection.currentDomain;
		}

		/**
		 * Enables or disables debugging of this class.
		 */
		public static function get debug():Boolean
		{
			return Reflection._debug;
		}

		/**
		 * @private
		 */
		public static function set debug(value:Boolean):void
		{
			Reflection._debug = value;
		}

		/**
		 * @private
		 */
		templelibrary static function get cache():Dictionary
		{
			return Reflection._cache;
		}

		private static function getClassDefinitionByName(name:String, domain:ApplicationDomain, refType:Class = null):Class
		{
			if (name == "*" || name == "void" || !Reflection.isAccessible(name))
			{
				return null;
			}
			else if (domain.hasDefinition(name))
			{
				return domain.getDefinition(name) as Class;
			}
			return null;
		}

		private static function getDescription(object:*, name:String, domain:ApplicationDomain):XML
		{
			if (object === undefined) return null;
			if (object is Class) return describeType(object);
			return describeType(Reflection.getClassDefinitionByName(name, domain) || object);
		}

		/**
		 * Checks if this class is accessible through the getDefinition method.
		 * Returns false in the class is private or internal 
		 */
		private static function isAccessible(name:String):Boolean
		{
			return name.indexOf("::") != 0 && name.indexOf(".as$") == -1;
		}

		public static function toString():String
		{
			return objectToString(Reflection);
		}
	}
}
