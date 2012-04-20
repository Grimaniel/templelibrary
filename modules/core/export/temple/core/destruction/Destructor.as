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
		templelibrary static const VERSION:String = "3.0.2";
		
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
