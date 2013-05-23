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
