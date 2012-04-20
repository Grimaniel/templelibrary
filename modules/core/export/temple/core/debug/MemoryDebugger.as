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
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.2";
		
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
