/*
include "../includes/License.as.inc";
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
		include "../includes/Version.as.inc";
		
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
