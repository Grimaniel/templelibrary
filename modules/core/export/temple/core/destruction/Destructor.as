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

package temple.core.destruction 
{
	import temple.core.templelibrary;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**
	 * The Destructor is a helper class for destruction. It can destruct several types of objects.
	 * 
	 * <p>All methods are static so therefore this class does not need to be instantiated</p>
	 * 
	 * @author Thijs Broerse
	 */
	public final class Destructor 
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.0";
		
		/**
		 * Recursively destructs the object and all its descendants.
		 * Note: This method always returns null. Useful if you want to destruct and clear an object in one line of code:
		 * 
		 * <listing version="3.0">
		 * this._someObject = Destructor.destruct(this._someObject);
		 * </listing>
		 * 
		 * @returns untyped null 
		 */
		public static function destruct(object:*):*
		{
			if (!object) return null;
			
			if (object is IDestructible)
			{
				if (!IDestructible(object).isDestructed) IDestructible(object).destruct();
			}
			else if (object is DisplayObject)
			{
				if (IEventDispatcher(object).hasEventListener(DestructEvent.DESTRUCT))
				{
					IEventDispatcher(object).dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
				}
				
				if (object is DisplayObjectContainer)
				{
					if (object is MovieClip)
					{
						MovieClip(object).stop();
					}
					Destructor.destructChildren(DisplayObjectContainer(object));
				}
				else if (object is Bitmap && (object as Bitmap).bitmapData)
				{
					(object as Bitmap).bitmapData = null;
				}
				
				if (DisplayObject(object).parent)
				{
					if (DisplayObject(object).parent is Loader)
					{
						Loader(DisplayObject(object).parent).unload();
					}
					else
					{
						DisplayObject(object).parent.removeChild(object);
					}
				}
			}
			else if (object is Array)
			{
				while ((object as Array).length)
				{
					Destructor.destruct((object as Array).shift());
				}
			}
			else if (getQualifiedClassName(object).indexOf("__AS3__.vec::Vector.") === 0) // Vector
			{
				while (object.length)
				{
					Destructor.destruct(object.shift());
				}
			}
			return null;
		}

		/**
		 * Recursivly destructs all children, grandchildren, grand-grandchildren, etc. of an displayobject
		 */
		public static function destructChildren(object:DisplayObjectContainer):void
		{
			if (object is Loader)
			{
				Loader(object).unload();
				return;
			}
			
			for (var i:int = object.numChildren-1; i >= 0 ; i--)
			{
				// if child is removed by another destructible, skip this index
				if (i >= object.numChildren) continue;
				
				Destructor.destruct(object.getChildAt(i));
			}
		}
	}
}
