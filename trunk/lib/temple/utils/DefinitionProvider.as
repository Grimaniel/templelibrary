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
package temple.utils 
{
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.debug.getClassName;
	import temple.debug.log.Log;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Central static register, for easy Class definition retrieval over multiple SWF's.
	 * 
	 *  @example
	 *  <p>To register the SWF at the DefinitionProvider:</p>
	 * <listing version="3.0">
	 * DefinitionProvider.registerApplicationDomain(loader.loaderInfo.applicationDomain);
	 * </listing>
	 * 
	 *  @example
	 *  <p>To retrieve a class from the DefinitionProvider:</p>
	 * <listing version="3.0">
	 * var def:Class = DefinitionProvider.getDefinition('SomeClassName');
	 * </listing>
	 *
	 * @author Bart van der Schoor
	 * 
	 */
	public final class DefinitionProvider
	{
		private static var _isInitialized:Boolean = false;
		private static var _domainRegister:Dictionary;
		private static var _definitionCache:Object;
		private static var _debug:Boolean;
		
		public static function init():void
		{
			if(DefinitionProvider._isInitialized == false)
			{
				DefinitionProvider._isInitialized = true;
				DefinitionProvider._domainRegister = new Dictionary(false); //maybe weak keys?
				DefinitionProvider._definitionCache = new Object();
				if (DefinitionProvider.debug) Log.debug("DefinitionProvider initialized", DefinitionProvider);
			}
		}
		
		/**
		 * 	check if we have a Class definition in all registered ApplicationDomains.
		 */
		public static function hasDefinition(name:String):Boolean
		{
			if(name == null || name == '') throwError(new ArgumentError('null or empty name'));
			
			if(DefinitionProvider._isInitialized == true)
			{
				//check our cache
				if(DefinitionProvider._definitionCache[name] !== undefined)
				{
					return true;
				}
				else
				{
					//loop up in registered ApplicationDomain's
					var def:Class;
					for each (var appDomain:ApplicationDomain in DefinitionProvider._domainRegister)
					{
						if(appDomain.hasDefinition(name))
						{
							DefinitionProvider._definitionCache[name] = appDomain.getDefinition(name);
							return true;
						}
					}
					//cannot find it
					return false;
				}
			}
			else
			{
				return false;
			}	
		}
		
		/**
		 * Find a Class definition in all registered ApplicationDomains.
		 */
		public static function getDefinition(name:String):Class
		{
			if(DefinitionProvider._isInitialized == true)
			{
				//check our cache
				if(DefinitionProvider._definitionCache[name] !== undefined)
				{
					return Class(DefinitionProvider._definitionCache[name]);
				}
				else
				{
					//loop up in registered ApplicationDomain's
					var def:Class;
					for each (var appDomain:ApplicationDomain in DefinitionProvider._domainRegister)
					{
						if(appDomain.hasDefinition(name))
						{
							def = Class(appDomain.getDefinition(name));
							DefinitionProvider._definitionCache[name] = def;
							return def;
						}
					}
					//cannot find it
					throwError(new TempleArgumentError(DefinitionProvider, 'DefinitionProvider cannot find a definiton for \''+name+'\' in the loaded library\'s'));
					return null;
				}
			}
			else
			{
				throwError(new TempleError(DefinitionProvider, 'DefinitionProvider is not initialized: you didn\'t call init() or registerApplicationDomain()'));
			}
			return null;	
		}
		
		/**
		 * Counts the number of time a definition exists. Useful for debug purposes.
		 */
		public static function countDefinition(name:String):uint
		{
			var count:uint = 0;
			
			if(DefinitionProvider._isInitialized == true)
			{
				for each (var appDomain:ApplicationDomain in DefinitionProvider._domainRegister)
				{
					if(appDomain.hasDefinition(name))
					{
						count++;
					}
				}
			}
			else
			{
				throwError(new TempleError(DefinitionProvider, 'DefinitionProvider is not initialized: you didn\'t call init() or registerApplicationDomain()'));
			}
			return count;	
		}

		/**
		 * Resolve a whole bunch of Class definition lookups
		 */
		public static function getDefinitionList(classNameArray:String):Array
		{
			var arr:Array = new Array();
			var iLim:uint = classNameArray.length;
			for(var i:uint = 0;i < iLim;i++)
			{
				arr.push(DefinitionProvider.getDefinition(classNameArray[i]));
			}
			return arr;
		}
		
		/**
		 * Register a ApplicationDomain for Class definition lookups.
		 */
		public static function registerApplicationDomain(appDomain:ApplicationDomain):void
		{
			DefinitionProvider.init();
			if (DefinitionProvider._domainRegister[appDomain])
			{
				Log.info(appDomain + 'allready registerd', DefinitionProvider.toString());
				return;
			}
			if (DefinitionProvider.debug) Log.debug("registerApplicationDomain " + appDomain, DefinitionProvider);
			
			DefinitionProvider._domainRegister[appDomain] = appDomain;
		}
		
		/**
		 * Unregister a ApplicationDomain for Class definition lookups.
		 */
		public static function unregisterApplicationDomain(appDomain:ApplicationDomain):void
		{
			if(DefinitionProvider._isInitialized)
			{
				if(DefinitionProvider._domainRegister[appDomain] != undefined)
				{
					delete DefinitionProvider._domainRegister[appDomain];
				}
				
				DefinitionProvider.clearDefinitionCache();
			}
		}
		
		/**
		 * Returns a definition as an Object. The retrieved class will be instantiated.
		 */
		public static function getAsObject(name:String):Object
		{			
			var def:Class = DefinitionProvider.getDefinition(name);
			return Object(new def());
		}
		
		/**
		 * Returns a definition as a DisplayObject.
		 */
		public static function getAsDisplayObject(name:String):DisplayObject
		{			
			var def:Class = DefinitionProvider.getDefinition(name);
			return DisplayObject(new def());
		}
		
		/**
		 * Returns a definition as a Sprite.
		 */
		public static function getAsSprite(name:String):Sprite
		{			
			var def:Class = DefinitionProvider.getDefinition(name);
			return Sprite(new def());
		}
		
		/**
		 * Returns a definition as a MovieClip.
		 */
		public static function getAsMovieClip(name:String):MovieClip
		{			
			var def:Class = DefinitionProvider.getDefinition(name);
			return MovieClip(new def());
		}
		
		/**
		 * Returns a definition as a Sound.
		 */
		public static function getAsSound(name:String):Sound
		{			
			var def:Class = DefinitionProvider.getDefinition(name);
			return Sound(new def());
		}
		
		/**
		 * Returns a definition as a Bitmap.
		 */
		public static function getAsBitmap(name:String, smoothing:Boolean=true, snapping:String=null):Bitmap
		{	
			snapping = snapping ? snapping : PixelSnapping.AUTO;
			var def:Class = DefinitionProvider.getDefinition(name);
			return new Bitmap(BitmapData(new def(null, null)), snapping, smoothing);
		}
		
		/**
		 * Returns a definition as a BitmapData.
		 */
		public static function getAsBitmapData(name:String):BitmapData
		{	
			var def:Class = DefinitionProvider.getDefinition(name);
			return BitmapData(new def(null, null));
		}
		
		/**
		 * Makes a simple clone of a DisplayObject 
		 */
		public static function simpleDisplayTypeClone(object:DisplayObject, graphicOnly:Boolean=false):DisplayObject
		{
			var name:String = getQualifiedClassName(object);
			var def:Class = DefinitionProvider.getDefinition(name);
			var clone:DisplayObject = DisplayObject(new def());
			
			if(graphicOnly == false)
			{
				clone.transform.matrix = object.transform.matrix.clone();
			}
			return clone;
		}
		
		/**
		 *	ditch current definitionCache (eg: kill references to loaded SFW's class-definitions)
		 */
		public static function clearDefinitionCache():void
		{
			DefinitionProvider._definitionCache = new Object();
		}
		
		/**
		 * Enable/disable debug mode.
		 */
		public static function get debug():Boolean
		{
			return DefinitionProvider._debug;
		}
		
		/**
		 * @private
		 */
		public static function set debug(value:Boolean):void
		{
			DefinitionProvider._debug = value;
		}
		
		public static function toString():String
		{
			return getClassName(DefinitionProvider);
		}
		
		public function DefinitionProvider()
		{
			throwError(new TempleError(this, "DefinitionProvider can not be instantiated"));
		}
	}
}
