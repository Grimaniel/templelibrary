/*
include "../includes/License.as.inc";
 */

package temple.core.events 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import temple.core.ICoreObject;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.templelibrary;


	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]
	
	/**
	 * Base class for all EventDispatchers in the Temple. The CoreEventDispatcher handles some core features of the Temple:
	 * <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Event dispatch optimization.</li>
	 * 	<li>Easy remove of all EventListeners.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * </ul>
	 * 
	 * <p>You should always use and/or extend the CoreEventDispatcher instead of EventDispatchers if you want to make use of the Temple features.</p>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreEventDispatcher extends EventDispatcher implements ICoreEventDispatcher, ICoreObject
	{
		include "../includes/ConstructNamespace.as.inc";
		
		private const _toStringProps:Vector.<String> = new Vector.<String>();
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _registryId:uint;
		private var _emptyPropsInToString:Boolean = true;

		/**
		 * Creates a new CoreEventDispatcher.
		 *	
		 * @param target The target object for events dispatched to the EventDispatcher object.
		 */
		public function CoreEventDispatcher(target:IEventDispatcher = null) 
		{
			super(target);
			
			construct::coreEventDispatcher(target);
		}
		
		/**
		 * @private
		 */
		construct function coreEventDispatcher(target:IEventDispatcher):void
		{
			_registryId = Registry.add(this);
			target;
		}
		
		include "../includes/CoreObjectMethods.as.inc";
		
		include "../includes/CoreEventDispatcherMethods.as.inc";

		include "../includes/LogMethods.as.inc";
		
		include "../includes/ToStringPropsMethods.as.inc";
		
		include "../includes/ToStringMethods.as.inc";
		
		include "../includes/IsDestructed.as.inc";

		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (_isDestructed) return;
			
			dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			if (_eventListenerManager)
			{
				_eventListenerManager.destruct();
				_eventListenerManager = null;
			}
			_isDestructed = true;
		}
	}
}