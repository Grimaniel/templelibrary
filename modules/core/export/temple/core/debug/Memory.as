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

package temple.core.debug
{
	import temple.core.Temple;
	import temple.core.debug.log.Log;
	import temple.core.templelibrary;

	import flash.utils.Dictionary;

	/**
	 * This class is used for Memory management. If <code>Temple.registerObjectsInMemory</code> is enabled, all Temple 
	 * objects are tracked in this class.
	 * 
	 * <p>The main reason for sites and games slowing down are memory leaks: objects that aren't properly removed from
	 * memory when they are no longer needed. The Temple was build to prevent this, and offers tools to solve this
	 * problem.</p>
	 * 
	 * <p>The Memory uses a weak reference for storing objects. Therefor this class is useful for tracking down
	 * possible memory leaks. If you have destructed an objects, but the object is still in Memory, you might have a 
	 * memory leak.</p>
	 * 
	 * <p>You can use the <code>MemoryDebugger</code> for debugging your application for memory leaks.</p>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * @see temple.core.debug.MemoryDebugger
	 * 
	 * @includeExample ../display/CoreDisplayObjectsExample.as
	 * 
	 * @author Thijs Broerse, Arjan van Wijk
	 */
	public final class Memory
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.5.1";
		
		private static var _registry:Dictionary;
		private static var _debug:Boolean; 

		/**
		 * Registers an object with a weak reference to track the object
		 * This only works when 'Temple.registerObjectsInMemory' is set to true or
		 * the forceRegister is set to true
		 * @param object The object to register in the memory
		 * @param object Force the registration of an object if 'Temple.registerObjectsInMemory' is set to false
		 * @example
		 * <listing version="3.0">
		 * // in the constructor of a class
		 * public function TestClass()
		 * {
		 * 		Memory.registerObject(this);
		 * }
		 * </listing> 
		 */
		public static function registerObject(object:Object, forceRegister:Boolean = false):void
		{
			if ((Temple.registerObjectsInMemory || forceRegister) && object)
			{
				if (!Memory._registry)
				{
					Memory._registry = new Dictionary(true);
					Log.warn("RegisterObjectsInMemory enabled: all Temple Objects are tracked", Memory);
				}
				
				if (Memory._registry[object])
				{
					Log.warn("Object '" + object + "' is already registered in Memory", Memory);
				}
				else
				{
					var registryId:uint = Registry.getId(object);
					
					// If not in Registry, add it there
					// Registry will add it to the memory again
					if (Temple.registerObjectsInMemory && registryId == 0)
					{
						Registry.add(object);
					}
					else
					{
						// If not in Registry, and 'Temple.registerObjectsInMemory' is set to false
						// add it here, because the Registry will not add it to the Memory again
						if (Temple.registerObjectsInMemory == false && registryId == 0) Registry.add(object);
						
						// get stack trace info
						var stacktrace:String;
						if (Temple.registerObjectsWithStack) stacktrace = new Error("Get stack").getStackTrace();
						if (stacktrace)
						{
							var a:Array = stacktrace.split("\n");
							var stackList:Array = new Array();
							for (var i:int = 1;i < a.length; i++) 
							{
								stackList.push(String(a[i]).substr(4));
							}
						}
						
						// store info about the object
						Memory._registry[object] = new RegistryInfo(stacktrace ? stackList.join("\n") : '', Registry.getId(object));

						if (Memory._debug) Log.debug("New object registered, id=" + registryId + ", object=" + object, Memory);
					}
				}
			}
		}

		/**
		 * If set to true, the Memory logs a message everytime an object is registered.
		 */
		public static function get debug():Boolean
		{
			return Memory._debug;
		}

		/**
		 * @private
		 */
		public static function set debug(value:Boolean):void
		{
			Memory._debug = value;
		}
		
		/**
		 * Reference to the registry. Only use this for debug purposes.
		 */
		templelibrary static function get registry():Dictionary
		{
			return Memory._registry;
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(Memory);
		}
	}
}
