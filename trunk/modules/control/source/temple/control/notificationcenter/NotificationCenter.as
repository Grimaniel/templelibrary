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

package temple.control.notificationcenter 
{
	import temple.core.CoreObject;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;
	import temple.core.debug.log.Log;
	import temple.core.events.CoreEventDispatcher;

	/**
	 * The NotificationCenter is used for Objects to communicate with eachother without having a reference to eachother.
	 * 
	 * <p>An object (Observer) that wants to receive Notifications from the NotificationCenter adds itself to the
	 * NotificationCenter by using 'addObserver' and pass the type (String) of the Notification and a handler (function).
	 * This handler should accept one (and only one) argument of type Notification. The handler is called evertyime a 
	 * Notification of the specified type is posted.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * NotificationCenter.getInstance().addObserver("myNotification", handleNotification);
	 * 
	 * function handleNotification(notification:Notification):void
	 * {
	 * 		trace("Notification received: " + notification.type);
	 * }
	 * </listing>
	 * 
	 * <p>To post a Notification to the NotificationCenter use 'post'.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * NotificationCenter.getInstance().post("myNotification");
	 * </listing>
	 * 
	 * <p>It's possible to send a data object with a Notification. The Observer receives this data object in the Notification: notification.data.
	 * This data object is untyped, so you can send all types of objects.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * NotificationCenter.getInstance().addObserver("myNotification", handleNotification);
	 * 
	 * function handleNotification(notification:Notification):void
	 * {
	 * 		trace("Notification received: " + notification.type + ", data:" + notification.data);
	 * }
	 * 
	 * NotificationCenter.getInstance().post("myNotification", "some data as String");
	 * </listing>
	 * 
	 * <p>All Observers are by default registered using weakReference. Therefor the objects can be removed by the Garbage Collector if there is no more
	 * (strong) reference to the object</p>
	 * 
	 * <p>The NotificationCenter is a multiton, so there can be multiple instances each with there own name:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * NotificationCenter.getInstance(); // returns the default NotificationCenter
	 * 
	 * NotificationCenter.getInstance("myNotificationCenter"); // returns a NotificationCenter with name "myNotificationCenter"
	 * </listing>
	 * 
	 * @see temple.control.notificationcenter.Notification
	 * 
	 * @includeExample NotificationCenterExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public final class NotificationCenter extends CoreObject implements IDebuggable
	{
		private static var _instances:CoreObject;

		/**
		 * Static function to get instances by name. Multiton implementation
		 * @param name the name of the NotificationCenter
		 * @param createIfNull if set to true automatically creates a new NotificationCenter if no NotificationCenter is found
		 * 
		 * @return a NotificationCenter instance
		 */
		public static function getInstance(name:String = 'default', createIfNull:Boolean = true):NotificationCenter
		{
			if (NotificationCenter._instances == null || NotificationCenter._instances[name] == null)
			{
				if (createIfNull)
				{
					if (NotificationCenter._instances == null)
					{
						NotificationCenter._instances = new CoreObject();
					}
					NotificationCenter._instances[name] = new NotificationCenter(name);
				}
				else
				{
					Log.error("getInstance: no instance with name '" + name + "' found", 'temple.data.notificationcenter.NotificationCenter');
					return null;
				}
			}
			return NotificationCenter._instances[name] as NotificationCenter;
		}

		private var _eventDispatcher:CoreEventDispatcher; 
		private var _name:String;
		private var _debug:Boolean;

		/**
		 * Creates a new NotificationCenter. Call this constructor only if you explicitely don't want to use the getInstance() method
		 */
		public function NotificationCenter(name:String = null) 
		{
			_name = name;
			super();
			_eventDispatcher = new CoreEventDispatcher();
			addToDebugManager(this);
			toStringProps.push('name');
		}

		/**
		 * Get the name of the NotificationCenter
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * Wrapper for NotificationCenter.getInstance().addObserver(type, listener, useWeakReference);
		 */
		public static function addObserver(type:String, listener:Function, useWeakReference:Boolean = true):void
		{
			NotificationCenter.getInstance().addObserver(type, listener, useWeakReference);
		}

		/**
		 * Registers observer to receive notifications of a specific type
		 * When a notification of the type is posted, method is called with a Notification as the argument.
		 * @param type notification identifier name
		 * @param listener The observer's method that will be called when notification is posted. This method should only have one argument (of type Notification).
		 * @param useWeakReference Determines whether the reference to the listener is strong or weak. A strong reference (the default) prevents your listener from being garbage-collected. A weak reference does not. 
		 */
		public function addObserver(type:String, listener:Function, useWeakReference:Boolean = true):void
		{
			if (_debug) logDebug("addObserver: '" + type + "' ");
			
			_eventDispatcher.addEventListener(type, listener, false, 0, useWeakReference);
		}
		
		/**
		 * Wrapper for NotificationCenter.getInstance().removeObserver(type, listener);
		 */
		public static function removeObserver(type:String, listener:Function):void
		{
			NotificationCenter.getInstance().removeObserver(type, listener);
		}
		
		/**
		 * Removes the observer(s) for a specific type and/or listeners.
		 * @param type notification identifier name
		 * @param listener The observer's method that will be called when notification is posted.
		 */
		public function removeObserver(type:String, listener:Function):void
		{
			_eventDispatcher.removeEventListener(type, listener);
		}
		
		/**
		 * Wrapper for NotificationCenter.getInstance().post(type, data);
		 */
		public static function post(type:String, data:* = null):void
		{
			NotificationCenter.getInstance().post(type, data);
		}

		/**
		 * Creates a Notification instance and passes this to the observers associated through the type
		 * @param type notification identifier
		 * @param data (optional) object to pass - this will be packed in the Notification
		 */
		public function post(type:String, data:* = null):void
		{
			if (_debug)
			{
				logDebug("post: '" + type + "', data: " + data);
				
				if (!_eventDispatcher.hasEventListener(type))
				{
					logWarn("NotificationCenter has no observers for '" + type + "'");
				}
			}
			_eventDispatcher.dispatchEvent(new Notification(this, type, data));
		}

		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_eventDispatcher)
			{
				_eventDispatcher.destruct();
				_eventDispatcher = null;
			}
			
			if (NotificationCenter._instances)
			{
				delete NotificationCenter._instances[_name];
				
				// check if there are some NotificationCenters left
				for (var key:String in NotificationCenter._instances);
				if (key == null) NotificationCenter._instances = null;
			}
			super.destruct();
		}
	}
}