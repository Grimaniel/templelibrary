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
 */

package temple.destruction 
{
	import temple.core.CoreObject;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * The EventListenerManager store information about event listeners on an object. Since all listeners are stored they can easely be removed, by type, listener or all.
	 * The EventListenerManager only stores information about strong (non weak) listeners. Since storing a reference to listener will make the listener strong.
	 * 
	 * @author Thijs Broerse (adapted from CasaLib)
	 */
	public final class EventListenerManager extends CoreObject implements IEventDispatcher, IDestructibleEventDispatcher 
	{
		private var _target:IEventDispatcher;
		private var _events:Array;
		private var _blockRequest:Boolean;

		/**
		 * Returns a list of all listeners of the dispatcher (registered by the EventListenerManager)
		 * @param dispatcher The dispatcher you want info about
		 */
		public static function getDispatcherInfo(dispatcher:IDestructibleEventDispatcher):Array
		{
			var list:Array = new Array();
			var listenerManager:EventListenerManager = dispatcher.eventListenerManager;
			if (listenerManager && listenerManager._events.length)
			{
				for each (var eventData:EventData in listenerManager._events)
				{
					list.push(eventData.type);
				}
			}
			return list;
		}

		/**
		 * Creates a new instance of a EventListenerManager. Do not create more one EventListenerManager for each IDestructibleEventDispatcher!
		 * @param eventDispatcher the EventDispatcher of this EventListenerManager
		 */
		public function EventListenerManager(eventDispatcher:IDestructibleEventDispatcher) 
		{
			this._target = eventDispatcher;
			this._events = new Array();
			
			super();
			
			if(eventDispatcher == null) throwError(new TempleArgumentError(this, "dispatcher can not be null"));
			if(eventDispatcher.eventListenerManager) throwError(new TempleError(this, "dispatcher already has an EventListenerManager"));
		}
		
		/**
		 * Returns a reference to the EventDispatcher
		 */
		public function get target():IEventDispatcher
		{
			return this._target;
		}

		/**
		 * Registers an event listening to the EventListenerManager
		 * 	
		 * @param type The type of event.
		 * @param listener The listener function that processes the event.
		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
		 * @param priority The priority level of the event listener.
		 * @param useWeakReference Determines whether the reference to the listener is strong or weak.
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			// Don't store weak reference info, since storing the listener will make it strong
			if(useWeakReference) return;
			
			var l:int = this._events.length;
			var eventData:EventData;
			while (l--)
			{
				eventData = this._events[l] as EventData;
				if ((eventData).equals(type, listener, useCapture))
				{
					eventData.once = false;
					return;
				}
			}
			this._events.push(new EventData(type, listener, useCapture, false, priority));
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			var l:int = this._events.length;
			while (l--)
			{
				if ((this._events[l] as EventData).equals(type, listener, useCapture)) return;
			}
			this._events.push(new EventData(type, listener, useCapture, true, priority));
			this._events.sortOn("priority");
			this._target.addEventListener(type, this.handleOnceEvent, useCapture, priority);
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean 
		{
			return this._target.dispatchEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return this._target.hasEventListener(type);
		}

		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this._target.willTrigger(type);
		}

		/**
		 * Notifies the ListenerManager instance that a listener has been removed from the IEventDispatcher.
		 * 	
		 * @param type The type of event.
		 * @param listener The listener function that processes the event.
		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			if (this._blockRequest || !this._events) return;
			var l:int = this._events.length;
			while (l--)
			{
				if ((this._events[l] as EventData).equals(type, listener, useCapture))
				{
					EventData(this._events.splice(l, 1)[0]).destruct();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForType(type:String):void 
		{
			this._blockRequest = true;
			
			var l:int = this._events.length;
			var eventData:EventData;
			while (l--) 
			{
				eventData = this._events[l];
				if (eventData.type == type) 
				{
					eventData = this._events.splice(l, 1)[0];
					if (this._target) this._target.removeEventListener(eventData.type, eventData.listener, eventData.useCapture);
					eventData.destruct();
				}
			}
			this._blockRequest = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllOnceEventListenersForType(type:String):void 
		{
			this._blockRequest = true;
			var l:int = this._events.length;
			var eventData:EventData;
			while (l--) 
			{
				eventData = this._events[l];
				if (eventData.type == type && eventData.once) 
				{
					eventData = this._events.splice(l, 1)[0];
					if (this._target) this._target.removeEventListener(eventData.type, eventData.listener, eventData.useCapture);
					eventData.destruct();
				}
			}
			this._blockRequest = false;
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForListener(listener:Function):void 
		{
			this._blockRequest = true;
			var l:int = this._events.length;
			var eventData:EventData;
			while (l--) 
			{
				eventData = this._events[l];
				
				if (eventData.listener == listener) 
				{
					eventData = this._events.splice(l, 1)[0];
					
					if (this._target) this._target.removeEventListener(eventData.type, eventData.listener, eventData.useCapture);
					
					eventData.destruct();
				}
			}
			this._blockRequest = false;
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void 
		{
			this._blockRequest = true;
			if (this._events)
			{
				var l:int = this._events.length;
				var eventData:EventData;
				while (l--) 
				{
					eventData = this._events.splice(l, 1)[0];
					
					if (this._target) this._target.removeEventListener(eventData.type, eventData.listener, eventData.useCapture);
					
					eventData.destruct();
				}
			}
			this._blockRequest = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get eventListenerManager():EventListenerManager
		{
			return this;
		}
		
		private function handleOnceEvent(event:Event):void 
		{
			this._blockRequest = true;
			var l:int = this._events.length;
			var eventData:EventData;
			while (l--) 
			{
				eventData = this._events[l];
				if (eventData && eventData.type == event.type && eventData.once) 
				{
					eventData = this._events.splice(l, 1)[0];
					var listener:Function = eventData.listener;
					if (this._target) this._target.removeEventListener(eventData.type, eventData.listener, eventData.useCapture);
					eventData.destruct();
					listener(event);
				}
			}
			this._blockRequest = false;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			this.removeAllEventListeners();
			
			for each (var eventData:EventData in this._events) eventData.destruct();
			
			this._target = null;
			this._events = null;
			
			super.destruct();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return super.toString() + ": " + this._target;
		}
	}
}

import temple.debug.getClassName;

class EventData
{
	public var type:String;
	public var listener:Function;
	public var useCapture:Boolean;
	public var once:Boolean;
	public var priority:int;
	
	public function EventData(type:String, listener:Function, useCapture:Boolean, once:Boolean, priority:int) 
	{
		this.type = type;
		this.listener = listener;
		this.useCapture = useCapture;
		this.once = once;
		this.priority = priority;
		super();
	}

	public function equals(type:String, listener:Function, useCapture:Boolean):Boolean 
	{
		return this.type == type && this.listener == listener && this.useCapture == useCapture;
	}

	/**
	 * Destructs the object
	 */
	public function destruct():void
	{
		this.type = null;
		this.listener = null;
	}
	
	public function toString():String
	{
		return getClassName(this) + ": " + this.type;
	}
}