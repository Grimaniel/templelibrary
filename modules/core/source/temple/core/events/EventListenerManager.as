/*
include "../includes/License.as.inc";
 */

package temple.core.events 
{
	import temple.core.destruction.DestructEvent;
	import temple.core.CoreObject;
	import temple.core.Temple;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.templelibrary;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;


	/**
	 * The EventListenerManager stores information about event listeners on an object. Since all listeners are stored
	 * they can easily be removed, by type, listener or all.
	 * 
	 * <p>The EventListenerManager only stores information about strong (non weak) listeners. Since storing a reference
	 * to listener will make the listener strong.</p>
	 * 
	 * @author Thijs Broerse (adapted from CasaLib)
	 */
	public final class EventListenerManager extends CoreObject implements IEventDispatcher, ICoreEventDispatcher 
	{
		include "../includes/Version.as.inc";
		
		/**
		 * If set to <code>true</code> the <code>EventListenerManager</code> will log a debug message when a weak event
		 * listener is set.
		 */
		public static var logWeakListeners:Boolean;
		
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the ButtonBehavior of a DisplayObject if the DisplayObject has ButtonBehavior. Otherwise null is returned. 
		 */
		public static function getInstance(target:IEventDispatcher):EventListenerManager
		{
			return EventListenerManager._dictionary[target] as EventListenerManager;
		}
		
		private var _target:IEventDispatcher;
		private var _events:Vector.<EventData>;
		private var _blockRequest:Boolean;

		/**
		 * Creates a new instance of a EventListenerManager. Do not create more then one EventListenerManager for each
		 * ICoreEventDispatcher!
		 * @param eventDispatcher the EventDispatcher of this EventListenerManager
		 */
		public function EventListenerManager(target:IEventDispatcher) 
		{
			if (target == null) throwError(new TempleArgumentError(this, "dispatcher can not be null"));
			if (EventListenerManager._dictionary[target]) throwError(new TempleError(this, target + " already has an EventListenerManager"));
			
			EventListenerManager._dictionary[this] = EventListenerManager._dictionary[target] = this;
			
			_target = target;
			_events = new Vector.<EventData>();
			_blockRequest = true;
			_target.addEventListener(DestructEvent.DESTRUCT, handleTargetDestructed);
			_blockRequest = false;
			
			super();
			
			toStringProps.push('target');
		}
		
		/**
		 * Returns a reference to the EventDispatcher
		 */
		public function get target():IEventDispatcher
		{
			return _target;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			_target.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if (!(_target is ICoreEventDispatcher)) templelibrary::addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @private
		 */
		templelibrary function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			// Don't store weak reference info, since storing the listener will make it strong
			if (useWeakReference)
			{
				if (EventListenerManager.logWeakListeners) logWarn("Weak listener used for '" + type + "'");
				return;
			}
			
			var i:int = _events.length;
			while (i--)
			{
				if (_events[i].equals(_target, type, listener, useCapture))
				{
					_events[i].once = false;
					return;
				}
			}
			_events.push(new EventData(_target, type, listener, useCapture, false, priority));
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			var i:int = _events.length;
			while (i--)
			{
				if (_events[i].equals(_target, type, listener, useCapture)) return;
			}
			_events.push(new EventData(_target, type, listener, useCapture, true, priority));
			_events.sort(sort);
			_target.addEventListener(type, handleOnceEvent, useCapture, priority);

		}

		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean 
		{
			return _target.dispatchEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return _target.hasEventListener(type);
		}

		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return _target.willTrigger(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			_target.removeEventListener(type, listener, useCapture);
			if (!(_target is ICoreEventDispatcher)) templelibrary::removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * @private
		 */
		templelibrary function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			if (!_events) return;
			var i:int = _events.length;
			while (i--)
			{
				if (_events[i].equals(_target, type, listener, useCapture))
				{
					_events.splice(i, 1)[0].destruct();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForType(type:String):void 
		{
			_blockRequest = true;
			var i:int = _events.length;
			while (i--) 
			{
				if (_events[i].type == type) 
				{
					_events.splice(i, 1)[0].destruct();
				}
			}
			_blockRequest = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllOnceEventListenersForType(type:String):void 
		{
			_blockRequest = true;
			var i:int = _events.length;
			var eventData:EventData;
			while (i--) 
			{
				eventData = _events[i];
				if (eventData.type == type && eventData.once) 
				{
					_events.splice(i, 1)[0].destruct();
				}
			}
			_blockRequest = false;
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForListener(listener:Function):void 
		{
			_blockRequest = true;
			var i:int = _events.length;
			while (i--) 
			{
				if (_events[i].listener == listener) 
				{
					_events.splice(i, 1)[0].destruct();
				}
			}
			_blockRequest = false;
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void 
		{
			_blockRequest = true;
			if (_events) while (_events.length) _events.pop().destruct();
			_blockRequest = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function listenTo(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			var manager:EventListenerManager = getInstance(dispatcher) || new EventListenerManager(dispatcher);
			manager.addEventListener(type, listener, useCapture, priority);
			var i:int = manager._events.length;
			while (i--)
			{
				if (manager._events[i].equals(dispatcher, type, listener, useCapture))
				{
					_events.push(manager._events[i]);
					return;
				}
			}
			logError("EventData not found");
		}
		
		/**
		 * @inheritDoc
		 */
		public function listenOnceTo(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			var manager:EventListenerManager = getInstance(dispatcher) || new EventListenerManager(dispatcher);
			manager.addEventListenerOnce(type, listener, useCapture, priority);
			var i:int = manager._events.length;
			while (i--)
			{
				if (manager._events[i].equals(dispatcher, type, listener, useCapture))
				{
					_events.push(manager._events[i]);
					return;
				}
			}
			logError("EventData not found");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get eventListenerManager():EventListenerManager
		{
			return this;
		}
		
		/**
		 * Returns a list of all listeners of the target (registered by the EventListenerManager)
		 */
		public function getInfo():Vector.<String>
		{
			var list:Vector.<String> = new Vector.<String>();
			if (_events &&  _events.length)
			{
				for each (var eventData:EventData in _events)
				{
					if (!eventData.isDestructed) list.push(eventData.dispatcher + "." + eventData.type + ": " + functionToString(eventData.listener));
				}
			}
			return list;
		}

		/**
		 * Returns the total amount of (strong) event listeners on the target of the EventListenerManager
		 */
		public function get numListeners():uint 
		{
			return _events ? _events.length : 0;
		}
		
		private function handleOnceEvent(event:Event):void 
		{
			_blockRequest = true;
			var i:int = _events ? _events.length : 0;
			var eventData:EventData;
			while (i--) 
			{
				if (_events == null) break;
				eventData = _events[i];
				if (eventData && eventData.type == event.type && eventData.once) 
				{
					eventData = _events.splice(i, 1)[0];
					var listener:Function = eventData.listener;
					eventData.destruct();
					if (listener.length == 1)
					{
						listener(event);
					}
					else
					{
						listener();
					}
				}
			}
			_blockRequest = false;
		}
		
		private function handleTargetDestructed(event:DestructEvent):void
		{
			destruct();
		}
		
		private function functionToString(func:Function):String 
		{
			try
			{
				Dictionary(func);
			}
			catch (error:Error)
			{
				var regExp:RegExp = /MC{(?:.*) (.*)}/g;
				var result:Array = regExp.exec(String(error.message));
				if (!result || !result[1]) return "function()";
				var s:String = String(result[1]);
				var i:int = s.indexOf("/");
				var className:String = s.substr(0, i);
				var functionName:String = s.substr(i);
				functionName = functionName.substr(functionName.indexOf("::") + 2);
				
				if (Temple.displayFullPackageInToString || className.indexOf('::') == -1)
				{
					return className + "." + functionName;
				}
				else
				{
					return className.split('::')[1] + "." + functionName;
				}
			}
			return null;
		}
		
		private function sort(a:EventData, b:EventData):int
		{
			return a.priority - b.priority;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (_target)
			{
				_target.removeEventListener(DestructEvent.DESTRUCT, handleTargetDestructed);
				delete EventListenerManager._dictionary[_target];
			}
			delete EventListenerManager._dictionary[this];
			
			removeAllEventListeners();
			
			for each (var eventData:EventData in _events) eventData.destruct();
			
			_target = null;
			_events = null;
			
			super.destruct();
		}
	}
}
import flash.events.IEventDispatcher;
import temple.core.CoreObject;

final class EventData extends CoreObject
{
	public var dispatcher:IEventDispatcher;
	public var type:String;
	public var listener:Function;
	public var useCapture:Boolean;
	public var once:Boolean;
	public var priority:int;
	
	public function EventData(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean, once:Boolean, priority:int) 
	{
		this.dispatcher = dispatcher;
		this.type = type;
		this.listener = listener;
		this.useCapture = useCapture;
		this.once = once;
		this.priority = priority;
		toStringProps.push('type');
	}

	public function equals(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean):Boolean 
	{
		return this.dispatcher == dispatcher && this.type == type && this.listener == listener && this.useCapture == useCapture;
	}

	/**
	 * Destructs the object
	 */
	override public function destruct():void
	{
		if (dispatcher && type && listener != null)
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		dispatcher = null;
		type = null;
		listener = null;
		super.destruct();
	}
}