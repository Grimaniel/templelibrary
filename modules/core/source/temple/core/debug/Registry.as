/*
include "../includes/License.as.inc";
 */

package temple.core.debug 
{
	import temple.core.Temple;
	import temple.core.debug.log.Log;
	import temple.core.destruction.Destructor;

	import flash.utils.Dictionary;

	/**
	 * This class holds objects with their unique id to identify them when needed.
	 * 
	 * <p>The Registry class stores objects in a weak-referenced Dictionary with an auto-incrementing id as value.  
	 * This class is used internally by the Temple for logging (where the unique id identifies the logging object),
	 * in the DebugManager and for storing objects in the Memory class (when 'Temple.registerObjectsInMemory' is set to
	 * true, all objects added to the Registry are also added to the Memory class to track their memory usage)</p>
	 * 
	 * <p>Having the Registry track all objects makes debugging of your code easier, since all logging and debugging
	 * functions specify which object traces a certain message.</p>
	 * 
	 * <p>If you make use of the Temple's CoreObjects (or their descendants) your objects will automatically be added to
	 * the Registry, so no extra action is needed to use the Registry. If you want to manually add your own objects to
	 * the Registry, you can do so by using the add function.</p>
	 *
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @author Arjan van Wijk
	 */
	public final class Registry 
	{
		private static const _objectList:Dictionary = new Dictionary(true);
		
		private static var _objectId:uint;
		
		/**
		 * Adds an object the the Registry. When '<code>Temple.registerObjectsInMemory</code>' is set to
		 * <code>true</code>, the object is also added to the <code>Memory</code><br />
		 * Throws a warning when the object is added before.
		 * 
		 * @param object The object to add
		 * @return uint An unique id for the object added
	 	 * @see temple.core.debug.Memory#registerObject()
	 	 * @see temple.core.Temple#registerObjectsInMemory
		 * 
		 * @example
		 * <listing version="3.0">
		 * // In the constructor
		 * public function TestClass()
		 * {
		 * 		var id:uint = Registry.add(this);
		 * }
		 * 
		 * // or after creating an object
		 * var testClass:TestClass = new TestClass();
		 * var id:uint = Registry.add(testClass);
		 * </listing>
		 */
		public static function add(object:*):uint
		{
			if (Registry._objectList[object])
			{
				Log.warn("add: object '" + object + "' is already registered in Registry", Registry);
				
				return Registry._objectList[object];
			}
			else
			{
				Registry._objectList[object] = ++Registry._objectId;
				
				if (Temple.registerObjectsInMemory && object)
				{
					Memory.registerObject(object);
				}
				if (Registry._objectId == uint.MAX_VALUE)
				{
					Log.warn("Max value reached in Registry", Registry);
				}
				return Registry._objectId;
			}
		}
		
		/**
		 * Gets the object by id.
		 * @param id the unique id of the object
		 * @return the object
		 * @example
		 * <listing version="3.0">
		 * var object:* = Registry.getObject(id);
		 * </listing>
		 * 
		 * Note: this function is slow, use only for debugging.
		 */
		public static function getObject(id:uint):*
		{
			if (Registry._objectList)
			{
				for (var object:* in Registry._objectList)
				{
					if (Registry._objectList[object] == id) return object;
				}
			}
			return null;
		}
		
		/**
		 * Gets objects by id.
		 * @param ids a list of object ids
		 * @return the objects
		 */
		public static function getObjects(ids:Vector.<uint>):Array
		{
			if (Registry._objectList && ids && ids.length)
			{
				var objects:Array = [];
				for (var object:* in Registry._objectList)
				{
					if (ids.indexOf(Registry._objectList[object]) != -1)
					{
						objects.push(object);
						if (objects.length == ids.length) return objects;
					}
				}
			}
			return objects;
		}
		
		/**
		 * Gets the id of an object
		 * @param object The object added in the registry before
		 * @return uint The id of the Object
		 * @example
		 * <listing version="3.0">
		 * var objectId:uint = Registry.getId(object);
		 * </listing>
		 */
		public static function getId(object:*):uint
		{
			return Registry._objectList[object];
		}

		/**
		 * Destruct all objects in Registry
		 */
		public static function destructAll():void
		{
			for (var object:Object in Registry._objectList) Destructor.destruct(object);
		}
		
		public static function toString() : String
		{
			return objectToString(Registry);
		}
	}
}
