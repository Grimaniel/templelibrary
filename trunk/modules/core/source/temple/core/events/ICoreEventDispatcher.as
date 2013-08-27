/*
include "../includes/License.as.inc";
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