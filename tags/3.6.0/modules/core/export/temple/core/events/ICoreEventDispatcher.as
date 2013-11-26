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

package temple.core.events 
{
	import temple.core.ICoreObject;
	import temple.core.destruction.IDestructible;
	
	import flash.events.IEventDispatcher;

	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]

	/**
	 * ICoreEventDispatcher will automatic remove all strong (non weak) listeners on the object when it is destructed.
	 * 
	 * @author Thijs Broerse
	 */
	public interface ICoreEventDispatcher extends IEventDispatcher, IDestructible, ICoreObject
	{
		/**
		 * Registers an event listening to the EventListenerManager which will only be called once. After the event is dispatched and all once listeners are called, the once listeners are removed.
		 * 	
		 * @param type The type of event.
		 * @param listener The listener function that processes the event.
		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
		 * @param priority The priority level of the event listener.
		 * 
		 * @includeExample ../display/CoreLoaderExample.as
		 */
		function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void 

		/**
		 * Removes all strong (non-weak) EventListeners of a specific type.
		 * 	
		 * @param type The type of event.
		 */
		function removeAllStrongEventListenersForType(type:String):void;

		/**
		 * Removes all once EventListeners of a specific type.
		 * 	
		 * @param type The type of event.
		 */
		function removeAllOnceEventListenersForType(type:String):void;

		/**
		 * Removes all strong (non weak) EventListeners that are handled by a specified listener.
		 * 	
		 * @param listener The listener function that handles the event.
		 */
		function removeAllStrongEventListenersForListener(listener:Function):void;

		/**
		 * Removes all strong (non weak) EventListeners.
		 */
		function removeAllEventListeners():void;
		
		/**
		 * Adds an EventListener on an other object and stores the reference, so it can automatically be removed.
		 */
		function listenTo(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void;

		/**
		 * Adds a once EventListener on an other object and stores the reference, so it can automatically be removed.
		 */
		function listenOnceTo(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void;

		[Temple]
		/**
		 * Returns a reference to the EventListenerManager.
		 */
		function get eventListenerManager():EventListenerManager;
	}
}
