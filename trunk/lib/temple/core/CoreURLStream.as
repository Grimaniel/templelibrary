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

package temple.core 
{
	import temple.data.loader.preload.IPreloader;
	import temple.data.loader.preload.PreloadableBehavior;
	import temple.debug.Registry;
	import temple.debug.log.Log;
	import temple.debug.log.LogLevel;
	import temple.debug.objectToString;
	import temple.destruction.DestructEvent;
	import temple.destruction.EventListenerManager;
	import temple.destruction.IDestructibleOnError;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;

	/**
	 * @eventType temple.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.destruction.DestructEvent")]
	
	/**
	 * Base class for all URLStreams in the Temple. The CoreURLStream handles some core features of the Temple:
	 * <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Event dispatch optimization.</li>
	 * 	<li>Easy remove of all EventListeners.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * 	<li>Logs IOErrorEvents and SecurityErrorEvents.</li>
	 * </ul>
	 * 
	 * <p>You should always use and/or extend the CoreURLStream instead of URLStream if you want to make use of the Temple features.</p>
	 * 
	 * @see temple.Temple#registerObjectsInMemory()
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreURLStream extends URLStream implements ICoreLoader, IDestructibleOnError
	{
		private static const _DEFAULT_HANDLER : int = -50;
		
		/** @private */
		protected var _isLoading:Boolean;
		/** @private */
		protected var _isLoaded:Boolean;
		/** @private */
		protected var _destructOnError:Boolean;
		/** @private */
		protected var _logErrors:Boolean;
		/** @private */
		protected var _preloadableBehavior:PreloadableBehavior;
		
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _registryId:uint;
		private var _url:String;
		private var _toStringProps:Array = [];
		private var _emptyPropsInToString:Boolean = true;

		/**
		 * Creates a CoreURLStream
		 * @param destructOnError if set to true (default) this object will automatically be destructed on an Error (IOError or SecurityError)
		 * @param logErrors if set to true an error message wil be logged on an Error (IOError or SecurityError)
		 */
		public function CoreURLStream(destructOnError:Boolean = true, logErrors:Boolean = true)
		{
			super();
			
			this._eventListenerManager = new EventListenerManager(this);
			
			this._destructOnError = destructOnError;
			this._logErrors = logErrors;
			
			// Register object for destruction testing
			this._registryId = Registry.add(this);
			
			// Add default listeners to Error events and preloader support
			this.addEventListener(Event.OPEN, templelibrary::handleOpen);
			this.addEventListener(ProgressEvent.PROGRESS, templelibrary::handleProgress);
			this.addEventListener(Event.COMPLETE, templelibrary::handleLoadComplete);
			this.addEventListener(IOErrorEvent.IO_ERROR, templelibrary::handleIOError, false, CoreURLStream._DEFAULT_HANDLER);
			this.addEventListener(IOErrorEvent.DISK_ERROR, templelibrary::handleIOError, false, CoreURLStream._DEFAULT_HANDLER);
			this.addEventListener(IOErrorEvent.NETWORK_ERROR, templelibrary::handleIOError, false, CoreURLStream._DEFAULT_HANDLER);
			this.addEventListener(IOErrorEvent.VERIFY_ERROR, templelibrary::handleIOError, false, CoreURLStream._DEFAULT_HANDLER);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, templelibrary::handleSecurityError, false, CoreURLStream._DEFAULT_HANDLER);
			
			// preloader support
			this._preloadableBehavior = new PreloadableBehavior(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public final function get registryId():uint
		{
			return this._registryId;
		}

		/**
		 * @inheritDoc
		 */ 
		override public function load(request:URLRequest):void
		{
			super.load(request);
			this._url = request.url;
			this._isLoading = true;
			this._isLoaded = false;
		}

		/**
		 * @inheritDoc
		 */ 
		override public function close():void
		{
			super.close();
			this._isLoading = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return this._isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return this._url;
		}
			
		/**
		 * @inheritDoc
		 */
		public function get logErrors():Boolean
		{
			return this._logErrors;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set logErrors(value:Boolean):void
		{
			this._logErrors = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get destructOnError():Boolean
		{
			return this._destructOnError;
		}

		/**
		 * @inheritDoc
		 */
		public function set destructOnError(value:Boolean):void
		{
			this._destructOnError = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Check implemented if object hasEventListener, must speed up the application
		 * http://www.gskinner.com/blog/archives/2008/12/making_dispatch.html
		 */
		override public function dispatchEvent(event:Event):Boolean 
		{
			if (this.hasEventListener(event.type) || event.bubbles) 
			{
				return super.dispatchEvent(event);
		  	}
		 	return true;
		}

		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			this._eventListenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			this._eventListenerManager.addEventListenerOnce(type, listener, useCapture, priority);
		}

		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			super.removeEventListener(type, listener, useCapture);
			this._eventListenerManager.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForType(type:String):void 
		{
			this._eventListenerManager.removeAllStrongEventListenersForType(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllOnceEventListenersForType(type:String):void
		{
			this._eventListenerManager.removeAllOnceEventListenersForType(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForListener(listener:Function):void 
		{
			this._eventListenerManager.removeAllStrongEventListenersForListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void 
		{
			this._eventListenerManager.removeAllEventListeners();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get eventListenerManager():EventListenerManager
		{
			return this._eventListenerManager;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preloader():IPreloader
		{
			return this._preloadableBehavior.preloader;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set preloader(value:IPreloader):void
		{
			this._preloadableBehavior.preloader = value;
		}
		
		templelibrary final function handleOpen(event:Event):void
		{
			this._preloadableBehavior.onLoadStart(this);
		}

		templelibrary final function handleProgress(event:ProgressEvent):void
		{
			this._preloadableBehavior.onLoadProgress();
		}
		
		templelibrary final function handleLoadComplete(event:Event):void
		{
			this._preloadableBehavior.onLoadComplete(this);
			this._isLoading = false;
			this._isLoaded = false;
		}
		
		/**
		 * Default IOError handler
		 * If logErrors is set to true, an error message is logged
		 */
		templelibrary final function handleIOError(event:IOErrorEvent):void
		{
			this._isLoading = false;
			this._preloadableBehavior.onLoadComplete(this);
			if (this._logErrors) this.logError(event.type + ': ' + event.text);
			if (this._destructOnError) this.destruct();
		}
		
		/**
		 * Default SecurityError handler
		 * If logErrors is set to true, an error message is logged
		 */
		templelibrary final function handleSecurityError(event:SecurityErrorEvent):void
		{
			this._isLoading = false;
			this._preloadableBehavior.onLoadComplete(this);
			if (this._logErrors) this.logError(event.type + ': ' + event.text);
			if (this._destructOnError) this.destruct();
		}
		
		/**
		 * Log wrapper functions
		 */
		protected final function logDebug(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.DEBUG, this._registryId);
		}
		protected final function logError(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.ERROR, this._registryId);
		}
		protected final function logFatal(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.FATAL, this._registryId);
		}
		protected final function logInfo(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.INFO, this._registryId);
		}
		protected final function logStatus(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.STATUS, this._registryId);
		}
		protected final function logWarn(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.WARN, this._registryId);
		}
		
		/**
		 * A Boolean which indicates if empty properties are outputted in the toString() method.
		 */
		protected final function get toStringProps():Array
		{
			return this._toStringProps;
		}
		
		/**
		 * @private
		 */
		templelibrary final function get toStringProps():Array
		{
			return this._toStringProps;
		}
		
		/**
		 * List of property names which are outputted in the toString() method.
		 */
		protected final function get emptyPropsInToString():Boolean
		{
			return this._emptyPropsInToString;
		}

		/**
		 * @private
		 */
		protected final function set emptyPropsInToString(value:Boolean):void
		{
			this._emptyPropsInToString = value;
		}

		/**
		 * @private
		 */
		templelibrary final function get emptyPropsInToString():Boolean
		{
			return this._emptyPropsInToString;
		}
		
		/**
		 * @private
		 */
		templelibrary final function set emptyPropsInToString(value:Boolean):void
		{
			this._emptyPropsInToString = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function get isDestructed():Boolean
		{
			return this._isDestructed;
		}

		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (this._isDestructed) return;
			
			this._preloadableBehavior.destruct();
			
			this.dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			if (this._isLoading) this.close();
			
			if (this._eventListenerManager)
			{
				this.removeAllEventListeners();
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			this._isDestructed = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return objectToString(this, this.toStringProps, !this.emptyPropsInToString);
		}
	}
}
