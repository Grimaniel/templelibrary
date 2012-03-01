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
	import flash.utils.getDefinitionByName;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.utils.DefinitionProvider;

	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 * This class contains some functions for Classes.
	 *
	 * @author Bart van der Schoor
	 * 
	 */
	public final class ClassUtils 
	{
		private static var _isTypeCache:Object = new Object();
		
		private static const _GLUE:String = '|';
		private static const _TYPE:String = 'type';
		
		/**
		 * Checks if a class is type of an other class. 
		 * Is 'compare' of 'to' type/interface? Without making an instance.
		 * Includes a cache for great power!
		 * With recursive type hierarchy-search:
		 * 
		 * @example
		 * <listing version="3.0">
		 * ClassUtils.isTypeOf(MovieClip, DisplayObject) == true;
		 * ClassUtils.isTypeOf(DisplayObject, MovieClip) == false;
		 * ClassUtils.isTypeOf(DisplayObject, IBitmapDrawable) == true;
		 * ClassUtils.isTypeOf(IBitmapDrawable, DisplayObject) == false;
		 * ClassUtils.isTypeOf(MovieClip, IBitmapDrawable) == true;
		 * ClassUtils.isTypeOf(MovieClip, MovieClip) == true;
		 * </listing>
		 */
		public static function isTypeOf(compare:Class, to:Class):Boolean
		{
			if (compare == null) throwError(new TempleArgumentError(ClassUtils, 'null compare'));
			if (to == null) throwError(new TempleArgumentError(ClassUtils, 'null to'));			
			
			if (compare == to)
			{
				return true;
			}
			
			//recurses
			return ClassUtils.digIsTypeOf(getQualifiedClassName(compare), getQualifiedClassName(to));
		}

		//TODO needs garbage collection (tiles..)
		private static function digIsTypeOf(compQName:String, toQName:String):Boolean
		{
			if(compQName == toQName)
			{
				return true;
			}
			var key:String = compQName + _GLUE + toQName;
			if(key in ClassUtils._isTypeCache)
			{
				return ClassUtils._isTypeCache[key] > 0;
			}
			
			var compare:Class;
			if (DefinitionProvider.isInitialized)
			{
				compare = DefinitionProvider.getDefinition(compQName);
			}
			else
			{
				compare = getDefinitionByName(compQName) as Class;
			}
			if(!compare)
			{
				throwError(new TempleArgumentError(ClassUtils, 'ClassUtils cannot lookup for QName:' + compQName));
			}
			var xml:XML = describeType(compare);
			var list:XMLList;
			var elem:XML;
			
			for each (elem in xml.child('extendsClass'))
			{
				if(elem.@[ClassUtils._TYPE] == toQName)
				{
					ClassUtils._isTypeCache[key] = getTimer();
					return true;	
				}
			}
			
			list = xml.child('factory');
			
			for each (elem in list.child('implementsInterface'))
			{
				if(elem.@[ClassUtils._TYPE] == toQName || ClassUtils.digIsTypeOf(elem.@[ClassUtils._TYPE], toQName))
				{
					ClassUtils._isTypeCache[key] = getTimer();
					return true;	
				}
			}
			
			for each (elem in list.child('extendsClass'))
			{
				if(elem.@[ClassUtils._TYPE] == toQName || ClassUtils.digIsTypeOf(elem.@[ClassUtils._TYPE], toQName))
				{
					ClassUtils._isTypeCache[key] = getTimer();
					return true;	
				}
			}
			ClassUtils._isTypeCache[key] = -1;
			return false;
		}
		
		/**
		 * compare lots of types at once
		 */
		public static function isMultiTypeOf(compareClasses:Array, to:Class):Boolean
		{
			if (compareClasses == null) return throwError(new TempleArgumentError(ClassUtils, 'null compare'));
			if (to == null) return throwError(new TempleArgumentError(ClassUtils, 'null toClasses'));			
			
			for each(var def:Class in compareClasses)
			{
				if(!ClassUtils.isTypeOf(def, to))
				{
					return false;
				}
			}
			return true;
		}

		/**
		 * compare one type to multiple types at once (IXMLParseble, IObjectParseble, IMagicInjectable, AbstractDataUnit)
		 */
		public static function isTypeOfMulti(compare:Class, toClasses:Array):Boolean
		{
			if (compare == null) return throwError(new TempleArgumentError(ClassUtils, 'null compare'));
			if (toClasses == null) return throwError(new TempleArgumentError(ClassUtils, 'null toClasses'));			
			
			for each(var def:Class in toClasses)
			{
				if(!ClassUtils.isTypeOf(compare, def))
				{
					return false;
				}
			}
			return true;
		}

		/**
		 * Clears the cache of the type checking methods
		 */
		public static function clearCache():void
		{
			ClassUtils._isTypeCache = new Object();
		}

		public static function garbageCollect(maxAgeSeconds:Number = 300):void
		{
			var rem:Array = [];
			var lim:int = getTimer() - (maxAgeSeconds * 1000);
			var name:String;
			for(name in _isTypeCache)
			{
				if(_isTypeCache[name] < lim)
				{
					rem.push[name];
				}
			}
			for each(name in rem)
			{
				delete _isTypeCache[name];
			}
		}

		/**
		 * Returns cache information as a String dump.
		 */
		public static function getInfo():String
		{
			var ret:String = '';
			for(var key:String in _isTypeCache)
			{
				ret += '\n\t- ' + key + '  = ' + _isTypeCache[key] + '';
			}
			return ret;
		}

		/**
		 * Check if a given Class has a parameterless constructor.
		 * (Somewhat expensive (describeType) so take care.)
		 */
		public static function hasSimpleConstructor(checkType:Class):Boolean
		{
			var factoryList:XMLList = describeType(checkType)['factory'];
			if(factoryList.elements('constructor').length() > 0)
			{
				return false;	
			}
			return true;
		}

		public static function numericQName(type:String):Boolean
		{
			return type == 'Number' || type == 'int' || type == 'uint'; //NaN? will sneaky mess you up
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(ClassUtils);
		}
	}
}
