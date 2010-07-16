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

package temple.debug 
{
	import temple.Temple;
	import temple.core.CoreTimer;
	import temple.debug.log.Log;
	import temple.destruction.IDestructible;

	import flash.events.TimerEvent;

	/**
	 * The MemoryDebugger can be used to check for Memory leaks. On interval it will check the Memory class for destructed object which aren't removed by the Garbage collector.
	 * Destructed objects will be logged. This class will only work is Temple.registerObjectsInMemory is enabled.
	 * 
	 * <p>If destructed objects can't be removed by the garbage collector means that you have a Memory leak. Check if you cleared all references to this object.</p>
	 * 
	 * <p><strong>Note: only use this class for debug purposes!</strong></p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new MemoryDebugger();
	 * </listing> 
	 * 
	 * @see temple.debug.Memory
	 * @see temple.Temple
	 * @see temple.debug.log.Log
	 * 
	 * @author Thijs Broerse
	 */
	public class MemoryDebugger 
	{
		private var _timer:CoreTimer;
		private var _includeCreationStack:Boolean;

		/**
		 * Creates a new MemoryDebugger instance.
		 * @param interval the time (in miliseconds) between every Memory check.
		 * @param includeCreationStack indicates if a stackTrace of the object construction should be included in the log messages.
		 */
		public function MemoryDebugger(interval:uint = 2000, includeCreationStack:Boolean = false)
		{
			this._includeCreationStack = includeCreationStack;
			
			if (Temple.registerObjectsInMemory)
			{
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
			Memory.forceGarbageCollection();
			
			var total:uint;
			var totalDestructed:uint;
			var destructed:String = "";
			
			for (var object:* in Memory.registry)
			{
				total++;
				if (object is IDestructible && (object as IDestructible).isDestructed)
				{
					totalDestructed++;
					destructed += "\n" + String(object);
					if (this._includeCreationStack) destructed += "\n" + RegistryInfo(Memory.registry[object]).stack;
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

		public static function toString():String 
		{
			return getClassName(MemoryDebugger);
		}
	}
}