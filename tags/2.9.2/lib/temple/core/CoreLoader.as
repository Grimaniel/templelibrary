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
	import temple.debug.IDebuggable;
	import temple.debug.Registry;
	import temple.debug.log.Log;
	import temple.debug.log.LogLevel;
	import temple.debug.objectToString;
	import temple.destruction.DestructEvent;
	import temple.destruction.EventListenerManager;
	import temple.utils.StageProvider;

	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * @eventType temple.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.destruction.DestructEvent")]
	
	/**
	 * @eventType flash.events.Event.OPEN
	 */
	[Event(name = "open", type = "flash.events.Event")]
	
	/**
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name = "progress", type = "flash.events.Event")]
	
	/**
	 * @eventType flash.events.Event.INIT
	 */
	[Event(name = "init", type = "flash.events.Event")]
	
	/**
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name = "ioError", type = "flash.events.Event")]
	
	/**
	 * @eventType flash.events.IOErrorEvent.DISK_ERROR
	 */
	[Event(name = "diskError", type = "flash.events.Event")]
	
	/**
	 * @eventType flash.events.IOErrorEvent.NETWORK_ERROR
	 */
	[Event(name = "networkError", type = "flash.events.Event")]
	
	/**
	 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
	 */
	[Event(name = "verifyError", type = "flash.events.Event")]
	
	/**
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name = "securityError", type = "flash.events.Event")]
	
	/**
	 * Base class for all Loaders in the Temple. The CoreLoader handles some core features of the Temple:
	* <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Global reference to the stage trough the StageProvider.</li>
	 * 	<li>Corrects a timeline bug in Flash (see <a href="http://www.tyz.nl/2009/06/23/weird-parent-thing-bug-in-flash/" target="_blank">http://www.tyz.nl/2009/06/23/weird-parent-thing-bug-in-flash/</a>).</li>
	 * 	<li>Event dispatch optimization.</li>
	 * 	<li>Easy remove of all EventListeners.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * 	<li>Handles and logs error events.</li>
	 * 	<li>Passes all contentLoaderInfo events.</li>
	 * 	<li>Some useful extra properties like autoAlpha, position and scale.</li>
	 * </ul>
	 * 
	 * <p>The CoreLoader passes all events of the contentLoaderInfo. You should always set the EventListeners on the 
	 * CoreLoader since these will automatic be removed on destruction.</p>
	 * 
	 * <p>You should always use and/or extend the CoreLoader instead of Loader if you want to make use of the Temple features.</p>
	 * 
	 * Usage:
	 * @example
	 * <listing version="3.0">
	 * var loader:CoreLoader = new CoreLoader();
	 * loader.addEventListener(Event.COMPLETE, this.handleLoaderComplete);
	 * this.addChild(loader);
	 * loader.load(new URLRequest('http://code.google.com/p/templelibrary/logo?logo_id=1259568715'));
	 * 
	 * function handleLoaderComplete(event:Event):void
	 * {
	 * 	trace("image loaded");
	 * 
	 * }
	 * </listing>
	 * 
	 * @see temple.Temple#registerObjectsInMemory()
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreLoader extends Loader implements ICoreDisplayObject, ICoreLoader, IDebuggable
	{
		private static const _DEFAULT_HANDLER : int = 0;
		
		private var _preloadableBehavior:PreloadableBehavior;
		private var _isLoading:Boolean;
		private var _isLoaded:Boolean;
		private var _logErrors:Boolean;
		private var _url:String;
		private var _debug:Boolean;
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _onStage:Boolean;
		private var _onParent:Boolean;
		private var _registryId:uint;
		private var _destructOnUnload:Boolean = true;
		private var _toStringProps:Array = ['name', 'url'];
		private var _emptyPropsInToString:Boolean = true;

		/**
		 * Creates a new CoreLoader
		 */
		public function CoreLoader(logErrors:Boolean = true)
		{
			this._eventListenerManager = new EventListenerManager(this);
			super();
			
			this._logErrors = logErrors;
			
			if (this.loaderInfo) this.loaderInfo.addEventListener(Event.UNLOAD, templelibrary::handleUnload, false, 0, true);
			
			// Register object for destruction testing
			this._registryId = Registry.add(this);
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			this.addEventListener(Event.ADDED, templelibrary::handleAdded);
			this.addEventListener(Event.ADDED_TO_STAGE,templelibrary::handleAddedToStage);
			this.addEventListener(Event.REMOVED, templelibrary::handleRemoved);
			this.addEventListener(Event.REMOVED_FROM_STAGE, templelibrary::handleRemovedFromStage);
			
			// Add default listeners to Error events
			this.contentLoaderInfo.addEventListener(Event.OPEN, templelibrary::handleOpen, false, 0, true);
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, templelibrary::handleProgress, false, 0, true);
			this.contentLoaderInfo.addEventListener(Event.INIT, templelibrary::handleInit, false, 0, true);
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, templelibrary::handleComplete, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, templelibrary::handleIOError, false, CoreLoader._DEFAULT_HANDLER, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, templelibrary::handleIOError, false, CoreLoader._DEFAULT_HANDLER, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, templelibrary::handleIOError, false, CoreLoader._DEFAULT_HANDLER, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, templelibrary::handleIOError, false, CoreLoader._DEFAULT_HANDLER, true);
			this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, templelibrary::handleSecurityError, false, CoreLoader._DEFAULT_HANDLER, true);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Checks for a scrollRect and returns the width of the scrollRect.
		 */
		override public function get width():Number
		{
			return this.scrollRect ? this.scrollRect.width : super.width;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * If the object does not have a width and is not scaled to 0 the object is empty, 
		 * setting the width is useless and can only cause weird errors, so we don't.
		 */
		override public function set width(value:Number):void
		{
			if (super.width || !this.scaleX) super.width = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Checks for a scrollRect and returns the height of the scrollRect.
		 */
		override public function get height():Number
		{
			return this.scrollRect ? this.scrollRect.height : super.height;
		}

		/**
		 * @inheritDoc
		 * 
		 * If the object does not have a height and is not scaled to 0 the object is empty, 
		 * setting the height is useless and can only cause weird errors, so we don't. 
		 */
		override public function set height(value:Number):void
		{
			if (super.height || !this.scaleY) super.height = value;
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
		override public function load(request:URLRequest, context:LoaderContext = null):void
		{
			if (this._isDestructed)
			{
				this.logWarn("load: This object is destructed (probably because 'desctructOnErrors' is set to true, so it cannot load anything");
				return;
			}
			
			if (this._debug) this.logDebug("load");
			
			this._isLoading = true;
			this._isLoaded = false;
			this._url = request.url;
			if (this._preloadableBehavior) this._preloadableBehavior.onLoadStart(this, this._url);
			super.load(request, context);
		}

		/**
		 * @inheritDoc
		 */ 
		override public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			if (this._isDestructed)
			{
				this.logWarn("load: This object is destructed (probably because 'destructOnErrors' is set to true, so it cannot load anything");
				return;
			}
			if (this._debug) this.logDebug("loadBytes, context:" + context);
			
			this._isLoading = true;
			super.loadBytes(bytes, context);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Checks if the object has loaded something before call super.unload();
		 */
		override public function unload():void
		{
			if (this._isLoaded)
			{
				super.unload();
				
				this._isLoaded = false;
				this._url = null;
			}
			else if (this._debug) this.logInfo('Nothing is loaded, so unloading is useless');
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Checks if the object is actually loading before call super.unload();
		 */ 
		override public function close():void
		{
			if (this._isLoading)
			{
				super.close();
				
				this._isLoading = false;
				this._url = null;
			}
			else if (this._debug) this.logInfo('Nothing is loading, so closing is useless');
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
		 * 
		 * When object is not on the stage it gets is stage reference from the StageProvider
		 */
		override public function get stage():Stage
		{
			if (!super.stage) return StageProvider.stage;
			
			return super.stage;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get onStage():Boolean
		{
			return this._onStage;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasParent():Boolean
		{
			return this._onParent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoAlpha():Number
		{
			return this.visible ? this.alpha : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set autoAlpha(value:Number):void
		{
			this.alpha = value;
			this.visible = this.alpha > 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get position():Point
		{
			return new Point(this.x, this.y);
		}
		
		/**
		 * @inheritDoc
		 */
		public function set position(value:Point):void
		{
			this.x = value.x;
			this.y = value.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scale():Number
		{
			if (this.scaleX == this.scaleY) return this.scaleX;
			return NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scale(value:Number):void
		{
			this.scaleX = this.scaleY = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get destructOnUnload():Boolean
		{
			return this._destructOnUnload;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set destructOnUnload(value:Boolean):void
		{
			this._destructOnUnload = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
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
			if (this._eventListenerManager) this._eventListenerManager.removeEventListener(type, listener, useCapture);
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
			return this._preloadableBehavior ? this._preloadableBehavior.preloader : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set preloader(value:IPreloader):void
		{
			if (value && !this._preloadableBehavior) this._preloadableBehavior = new PreloadableBehavior(this);
			if (this._preloadableBehavior) this._preloadableBehavior.preloader = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint
		{
			return this.contentLoaderInfo ? this.contentLoaderInfo.bytesLoaded : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint
		{
			return this.contentLoaderInfo ? this.contentLoaderInfo.bytesTotal : 0;
		}
		
		/**
		 * Does a Log.debug, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logDebug(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.DEBUG, this._registryId);
		}
		
		/**
		 * Does a Log.error, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logError(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.ERROR, this._registryId);
		}
		
		/**
		 * Does a Log.fatal, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logFatal(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.FATAL, this._registryId);
		}
		
		/**
		 * Does a Log.info, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logInfo(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.INFO, this._registryId);
		}
		
		/**
		 * Does a Log.status, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logStatus(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.STATUS, this._registryId);
		}
		
		/**
		 * Does a Log.warn, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logWarn(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.WARN, this._registryId);
		}
		
		templelibrary final function handleUnload(event:Event):void
		{
			if (this._destructOnUnload) this.destruct();
		}
		
		templelibrary final function handleAdded(event:Event):void
		{
			if (event.currentTarget == this) this._onParent = true;
		}

		templelibrary final function handleAddedToStage(event:Event):void
		{
			this._onStage = true;
		}

		templelibrary final function handleRemoved(event:Event):void
		{
			if (event.currentTarget == this) this._onParent = false;
		}
		
		templelibrary final function handleRemovedFromStage(event:Event):void
		{
			this._onStage = false;
		}

		templelibrary final function handleOpen(event:Event):void
		{
			if (this.debug) this.logDebug("handleOpen");
			
			this.dispatchEvent(event.clone());
		}

		templelibrary final function handleProgress(event:ProgressEvent):void
		{
			if (this.debug) this.logDebug("handleProgress: " + Math.round(100 * (event.bytesLoaded / event.bytesTotal)) + "%, loaded: " + event.bytesLoaded + ", total: " + event.bytesTotal);
			if (this._preloadableBehavior) this._preloadableBehavior.onLoadProgress();
			this.dispatchEvent(event.clone());
		}
		
		templelibrary final function handleInit(event:Event):void
		{
			this.dispatchEvent(event.clone());
		}
		
		templelibrary final function handleComplete(event:Event):void
		{
			if (this.debug) this.logDebug("handleComplete");
			
			this._isLoading = false;
			this._isLoaded = true;
			if (this._preloadableBehavior) this._preloadableBehavior.onLoadComplete(this);
			
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * Default IOError handler
		 */
		templelibrary final function handleIOError(event:IOErrorEvent):void
		{
			this._isLoading = false;
			if (this._preloadableBehavior) this._preloadableBehavior.onLoadComplete(this);
			
			if (this._logErrors || this._debug) this.logError(event.type + ': ' + event.text);
			
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * Default SecurityError handler
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		templelibrary final function handleSecurityError(event:SecurityErrorEvent):void
		{
			this._isLoading = false;
			if (this._preloadableBehavior) this._preloadableBehavior.onLoadComplete(this);
			
			if (this._logErrors || this._debug) this.logError(event.type + ': ' + event.text);
			
			this.dispatchEvent(event.clone());
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
			
			this.dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			if (this._preloadableBehavior)
			{
				this._preloadableBehavior.destruct();
				this._preloadableBehavior = null;
			}
			
			if (this._eventListenerManager)
			{
				this.removeAllEventListeners();
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			
			if (this._isLoading)
			{
				try
				{
					this.close();
				}
				catch (e:Error){}
			}
			
			try
			{
				if (this.hasOwnProperty("unloadAndStop"))
				{
					//Flash Player 10 and later only
					(this as Object)['unloadAndStop'](true);
				}
				else
				{
					this.unload();
				}
			}
			catch (e:ArgumentError)
			{
				//the loader.content is addChilded somewhere else, so it cannot be unloaded
			}
			
			if (this.contentLoaderInfo)
			{
				this.contentLoaderInfo.removeEventListener(Event.OPEN, templelibrary::handleOpen);
				this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, templelibrary::handleProgress);
				this.contentLoaderInfo.removeEventListener(Event.INIT, templelibrary::handleInit);
				this.contentLoaderInfo.removeEventListener(Event.COMPLETE, templelibrary::handleComplete);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, templelibrary::handleIOError);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, templelibrary::handleIOError);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, templelibrary::handleIOError);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, templelibrary::handleIOError);
				this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, templelibrary::handleSecurityError);
			}
			
			if (this.parent)
			{
				if (this.parent is Loader)
				{
					Loader(this.parent).unload();
				}
				else
				{
					if (this._onParent)
					{
						this.parent.removeChild(this);
					}
					else
					{
						// something weird happened, since we have a parent but didn't receive an ADDED event. So do the try-catch thing
						try
						{
							this.parent.removeChild(this);
						}
						catch (e:Error){}
					}
				}
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
