/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
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

package temple.core.events 
{
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
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.0";
		
		private var _target:IEventDispatcher;
		private var _events:Vector.<EventData>;
		private var _blockRequest:Boolean;

		/**
		 * Creates a new instance of a EventListenerManager. Do not create more one EventListenerManager for each ICoreEventDispatcher!
		 * @param eventDispatcher the EventDispatcher of this EventListenerManager
		 */
		public function EventListenerManager(eventDispatcher:ICoreEventDispatcher) 
		{
			this._target = eventDispatcher;
			this._events = new Vector.<EventData>();
			
			super();
			
			if (eventDispatcher == null) throwError(new TempleArgumentError(this, "dispatcher can not be null"));
			if (eventDispatcher.eventListenerManager) throwError(new TempleError(this, "dispatcher already has an EventListenerManager"));
			this.toStringProps.push('target');
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
			if (useWeakReference) return;
			
			var i:int = this._events.length;
			while (i--)
			{
				if (this._events[i].equals(type, listener, useCapture))
				{
					this._events[i].once = false;
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
			var i:int = this._events.length;
			while (i--)
			{
				if (this._events[i].equals(type, listener, useCapture)) return;
			}
			this._events.push(new EventData(type, listener, useCapture, true, priority));
			this._events.sort(this.sort);
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
			var i:int = this._events.length;
			while (i--)
			{
				if (this._events[i].equals(type, listener, useCapture))
				{
					EventData(this._events.splice(i, 1)[0]).destruct();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForType(type:String):void 
		{
			this._blockRequest = true;
			
			var i:int = this._events.length;
			var eventData:EventData;
			while (i--) 
			{
				eventData = this._events[i];
				if (eventData.type == type) 
				{
					eventData = this._events.splice(i, 1)[0];
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
			var i:int = this._events.length;
			var eventData:EventData;
			while (i--) 
			{
				eventData = this._events[i];
				if (eventData.type == type && eventData.once) 
				{
					eventData = this._events.splice(i, 1)[0];
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
			var i:int = this._events.length;
			var eventData:EventData;
			while (i--) 
			{
				eventData = this._events[i];
				
				if (eventData.listener == listener) 
				{
					eventData = this._events.splice(i, 1)[0];
					
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
				var i:int = this._events.length;
				var eventData:EventData;
				while (i--) 
				{
					eventData = this._events.splice(i, 1)[0];
					
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
		
		/**
		 * Returns a list of all listeners of the target (registered by the EventListenerManager)
		 */
		public function getInfo():Vector.<String>
		{
			var list:Vector.<String> = new Vector.<String>();
			if (this._events &&  this._events.length)
			{
				for each (var eventData:EventData in this._events)
				{
					list.push(eventData.type + ": " + this.functionToString(eventData.listener));
				}
			}
			return list;
		}

		/**
		 * Returns the total amount of (strong) event listeners on the target of the EventListenerManager
		 */
		public function get numListeners():uint 
		{
			return this._events ? this._events.length : 0;
		}
		
		private function handleOnceEvent(event:Event):void 
		{
			this._blockRequest = true;
			var i:int = this._events ? this._events.length : 0;
			var eventData:EventData;
			while (i--) 
			{
				if (this._events == null) break;
				eventData = this._events[i];
				if (eventData && eventData.type == event.type && eventData.once) 
				{
					eventData = this._events.splice(i, 1)[0];
					var listener:Function = eventData.listener;
					if (this._target) this._target.removeEventListener(eventData.type, eventData.listener, eventData.useCapture);
					eventData.destruct();
					listener(event);
				}
			}
			this._blockRequest = false;
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
			this.removeAllEventListeners();
			
			for each (var eventData:EventData in this._events) eventData.destruct();
			
			this._target = null;
			this._events = null;
			
			super.destruct();
		}
	}
}
import temple.core.CoreObject;

final class EventData extends CoreObject
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
		this.toStringProps.push('type');
	}

	public function equals(type:String, listener:Function, useCapture:Boolean):Boolean 
	{
		return this.type == type && this.listener == listener && this.useCapture == useCapture;
	}

	/**
	 * Destructs the object
	 */
	override public function destruct():void
	{
		this.type = null;
		this.listener = null;
	}
}
