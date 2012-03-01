/*
include "../includes/License.as.inc";
 */

package temple.core.debug 
{
	import flash.events.TimerEvent;
	import flash.system.System;
	
	import temple.core.Temple;
	import temple.core.debug.log.Log;
	import temple.core.destruction.IDestructible;
	import temple.core.utils.CoreTimer;
	import temple.core.templelibrary;

	/**
	 * The MemoryDebugger can be used to check for Memory leaks. On interval it will check the Memory class for
	 * destructed object which aren't removed by the Garbage collector. Destructed objects will be logged. This class
	 * will only work is Temple.registerObjectsInMemory is enabled.
	 * 
	 * <p>If destructed objects can't be removed by the garbage collector means that you have a Memory leak. Check if
	 * you cleared all references to this object.</p>
	 * 
	 * <p><strong>Note: only use this class for debug purposes!</strong></p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new MemoryDebugger();
	 * </listing> 
	 * 
	 * @see temple.core.debug.Memory
	 * @see temple.core.Temple
	 * @see temple.core.debug.log.Log
	 * 
	 * @includeExample ../display/CoreDisplayObjectsExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class MemoryDebugger 
	{
		include "../includes/Version.as.inc";
		
		private var _timer:CoreTimer;
		private var _includeCreationStack:Boolean;

		/**
		 * Creates a new MemoryDebugger instance.
		 * @param interval the time (in milliseconds) between every Memory check.
		 * @param includeCreationStack indicates if a stackTrace of the object construction should be included in the
		 * log messages.
		 */
		public function MemoryDebugger(interval:uint = 2000, includeCreationStack:Boolean = false)
		{
			if (Temple.registerObjectsInMemory)
			{
				if (includeCreationStack)
				{
					if (!Temple.registerObjectsWithStack)
					{
						Log.warn("Temple.registerObjectsWithStack is turned off", MemoryDebugger);
					}
					this._includeCreationStack = includeCreationStack;
				}
				
				this._timer = new CoreTimer(interval);
				this._timer.addEventListener(TimerEvent.TIMER, this.handleTimerEvent);
				this._timer.start();
			}
			else
			{
				Log.warn("Temple.registerObjectsInMemory is turned off", MemoryDebugger);
			}
		}
		
		/**
		 * Indicates if the creation stack should be included in the log messages
		 */
		public function get includeCreationStack():Boolean
		{
			return this._includeCreationStack;
		}
		
		/**
		 * @private
		 */
		public function set includeCreationStack(value:Boolean):void
		{
			this._includeCreationStack = value;
		}

		private function handleTimerEvent(event:TimerEvent):void 
		{
			System.gc();
			
			var total:uint;
			var totalDestructed:uint;
			var destructed:String = "";
			
			for (var object:* in Memory.templelibrary::registry)
			{
				total++;
				if (object is IDestructible && (object as IDestructible).isDestructed)
				{
					totalDestructed++;
					destructed += "\n\t" + String(object) + " (" + getClassName(object) + ")";
					if (this._includeCreationStack) destructed += "\n" + RegistryInfo(Memory.templelibrary::registry[object]).stack;
				}
			}
			if (totalDestructed)
			{
				Log.warn("Total objects in Memory: " + total + ". Destructed, but still in Memory: " + totalDestructed + destructed, MemoryDebugger);
			}
			else
			{
				Log.info("Total objects in Memory: " + total, MemoryDebugger);
			}
		}

		/**
		 * @private
		 */
		public static function toString():String 
		{
			return objectToString(MemoryDebugger);
		}
	}
}