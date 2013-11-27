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

package temple.core.display 
{
	import flash.events.IEventDispatcher;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.events.EventListenerManager;
	import temple.core.net.CoreURLLoader;
	import temple.core.net.ICoreLoader;
	import temple.core.templelibrary;

	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;



	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]
	
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
	 * loader.addEventListener(Event.COMPLETE, handleLoaderComplete);
	 * addChild(loader);
	 * loader.load(new URLRequest('http://code.google.com/p/templelibrary/logo'));
	 * 
	 * function handleLoaderComplete(event:Event):void
	 * {
	 * 	trace("image loaded");
	 * 
	 * }
	 * </listing>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @includeExample CoreLoaderExample.as
	 * @includeExample CoreDisplayObjectsExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreLoader extends Loader implements ICoreDisplayObject, ICoreLoader, IDebuggable
	{
		/**
		 * Hashmap of CoreURLLoaders which loads policy files (crossdomain.xml files)
		 */
		templelibrary static const POLICYFILE_LOADERS:Object = {};
		
		/**
		 * @private
		 * 
		 * Protected namespace for construct method. This makes overriding of constructor possible.
		 */
		protected namespace construct;
		
		private const _toStringProps:Vector.<String> = Vector.<String>(['name', 'url', 'content']);
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
		private var _emptyPropsInToString:Boolean = true;
		private var _context:LoaderContext;
		private var _policyFileLoader:CoreURLLoader;

		/**
		 * Creates a new CoreLoader
		 */
		public function CoreLoader(request:URLRequest = null, context:LoaderContext = null, logErrors:Boolean = true)
		{
			construct::coreLoader(request, context, logErrors);
		}
		
		/**
		 * @private
		 */
		construct function coreLoader(request:URLRequest, context:LoaderContext, logErrors:Boolean):void
		{
			_logErrors = logErrors;
			
			if (loaderInfo) loaderInfo.addEventListener(Event.UNLOAD, handleUnload, false, 0, true);
			
			_registryId = Registry.add(this);
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			super.addEventListener(Event.ADDED, handleAdded);
			super.addEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
			super.addEventListener(Event.REMOVED, handleRemoved);
			super.addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
			
			// Add listeners on contentLoaderInfo
			contentLoaderInfo.addEventListener(Event.OPEN, handleOpen, false, 0, true);
			contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleProgress, false, 0, true);
			contentLoaderInfo.addEventListener(Event.INIT, handleInit, false, 0, true);
			contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete, false, 0, true);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);
			contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, handleIOError, false, 0, true);
			contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError, false, 0, true);
			contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, handleIOError, false, 0, true);
			contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError, false, 0, true);
			contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus, false, 0, true);
			
			if (request) load(request, context);
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function load(request:URLRequest, context:LoaderContext = null):void
		{
			if (_isDestructed)
			{
				logWarn("load: This object is destructed (probably because 'desctructOnErrors' is set to true, so it cannot load anything");
				return;
			}
			
			if (_debug) logDebug("load");
			
			_isLoading = true;
			_isLoaded = false;
			_url = request.url;
			_context = context;
			super.load(request, context);
		}

		/**
		 * @inheritDoc
		 */ 
		override public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			if (_isDestructed)
			{
				logWarn("load: This object is destructed (probably because 'destructOnErrors' is set to true, so it cannot load anything");
				return;
			}
			if (_debug) logDebug("loadBytes, context:" + context);
			
			_isLoading = true;
			super.loadBytes(bytes, context);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Checks if the object has loaded something before call super.unload();
		 */
		override public function unload():void
		{
			if (_isLoaded)
			{
				super.unload();
				
				_isLoaded = false;
				_url = null;
			}
			else if (_debug) logInfo('Nothing is loaded, so unloading is useless');
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Checks if the object is actually loading before call super.unload();
		 */ 
		override public function close():void
		{
			if (_isLoading)
			{
				super.close();
				
				_isLoading = false;
				_url = null;
			}
			else if (_debug) logInfo('Nothing is loading, so closing is useless');
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded():uint
		{
			return contentLoaderInfo ? contentLoaderInfo.bytesLoaded : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesTotal():uint
		{
			return contentLoaderInfo ? contentLoaderInfo.bytesTotal : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get logErrors():Boolean
		{
			return _logErrors;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set logErrors(value:Boolean):void
		{
			_logErrors = value;
		}

		[Temple]
		/**
		 * @inheritDoc
		 */
		public final function get registryId():uint
		{
			return _registryId;
		}
		
		/**
		 * Checks for a <code>scrollRect</code> and returns the width of the <code>scrollRect</code>.
		 * Otherwise the <code>super.width</code> is returned. This fixes a FlashPlayer bug; Flash doesn't immediatly
		 * update the objects width when a scrollRect is set on a DisplayObject.
		 */
		override public function get width():Number
		{
			return scrollRect ? scrollRect.width : super.width;
		}
		
		/**
		 * If the object does not have a width and is not scaled to 0 the object is empty, 
		 * setting the width is useless and can only cause weird errors, so we don't.
		 */
		override public function set width(value:Number):void
		{
			if (super.width || !scaleX) super.width = value;
		}
		
		/**
		 * Checks for a <code>scrollRect</code> and returns the height of the <code>scrollRect</code>.
		 * Otherwise the <code>super.height</code> is returned. This fixes a FlashPlayer bug; Flash doesn't immediatly
		 * update the objects height when a scrollRect is set on a DisplayObject.
		 */
		override public function get height():Number
		{
			return scrollRect ? scrollRect.height : super.height;
		}

		/**
		 * If the object does not have a height and is not scaled to 0 the object is empty, 
		 * setting the height is useless and can only cause weird errors, so we don't. 
		 */
		override public function set height(value:Number):void
		{
			if (super.height || !scaleY) super.height = value;
		}
		
		/**
		 * When object is not on the stage it gets the stage reference from the StageProvider. So therefore this object
		 * will always has a reference to the stage.
		 */
		override public function get stage():Stage
		{
			return super.stage || StageProvider.stage;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get onStage():Boolean
		{
			return _onStage;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasParent():Boolean
		{
			return _onParent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeFromParent():void
		{
			if (parent && _onParent) parent.removeChild(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoAlpha():Number
		{
			return visible ? alpha : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoAlpha(value:Number):void
		{
			alpha = value;
			visible = alpha > 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get position():Point
		{
			return new Point(x, y);
		}
		
		/**
		 * @inheritDoc
		 */
		public function set position(value:Point):void
		{
			x = value.x;
			y = value.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scale():Number
		{
			return scaleX == scaleY ? scaleX : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scale(value:Number):void
		{
			scaleX = scaleY = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get destructOnUnload():Boolean
		{
			return _destructOnUnload;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set destructOnUnload(value:Boolean):void
		{
			_destructOnUnload = value;
		}
		
		/**
		 * A <code>Boolean</code> which indicates of the <code>CoreLoader</code> is redirected to an other url
		 */
		public function get isRedirected():Boolean
		{
			return _url && contentLoaderInfo.url && _url != contentLoaderInfo.url;
		}
		
		/**
		 * Indicates if the <code>checkPolicyFile</code> property of the <code>LoaderContext</code> of the last load
		 * was set to <code>true</code>.
		 */
		public function get checkPolicyFile():Boolean
		{
			return _context && _context.checkPolicyFile;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Checks if this object has event listeners of this event before dispatching the event. Should speed up the
		 * application.
		 */
		override public function dispatchEvent(event:Event):Boolean 
		{
			if (hasEventListener(event.type) || event.bubbles) 
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
			if (getEventListenerManager()) _eventListenerManager.templelibrary::addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			if (getEventListenerManager()) _eventListenerManager.addEventListenerOnce(type, listener, useCapture, priority);
		}

		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			super.removeEventListener(type, listener, useCapture);
			if (_eventListenerManager) _eventListenerManager.templelibrary::removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForType(type:String):void 
		{
			if (_eventListenerManager) _eventListenerManager.removeAllStrongEventListenersForType(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllOnceEventListenersForType(type:String):void
		{
			if (_eventListenerManager) _eventListenerManager.removeAllOnceEventListenersForType(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForListener(listener:Function):void 
		{
			if (_eventListenerManager) _eventListenerManager.removeAllStrongEventListenersForListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void 
		{
			if (_eventListenerManager) _eventListenerManager.removeAllEventListeners();
		}
		
		/**
		 * @inheritDoc
		 */
		public function listenTo(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			if (getEventListenerManager()) _eventListenerManager.listenTo(dispatcher, type, listener, useCapture, priority);
		}
		
		/**
		 * @inheritDoc
		 */
		public function listenOnceTo(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			if (getEventListenerManager()) _eventListenerManager.listenOnceTo(dispatcher, type, listener, useCapture, priority);
		}
		
		[Temple]
		/**
		 * @inheritDoc
		 */
		public function get eventListenerManager():EventListenerManager
		{
			return _eventListenerManager;
		}
		
		private function getEventListenerManager():EventListenerManager
		{
			if (_isDestructed)
			{
				logError("Object is destructed, don't add event listeners");
				return null;
			}
			return _eventListenerManager ||= EventListenerManager.getInstance(this) || new EventListenerManager(this);
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
		 * Does a Log.debug, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#debug()
		 * @see temple.core.debug.log.LogLevel#DEBUG
		 */
		protected final function logDebug(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.DEBUG, _registryId);
		}
		
		/**
		 * Does a Log.error, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#error()
		 * @see temple.core.debug.log.LogLevel#ERROR
		 */
		protected final function logError(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.ERROR, _registryId);
		}
		
		/**
		 * Does a Log.fatal, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#fatal()
		 * @see temple.core.debug.log.LogLevel#FATAL
		 */
		protected final function logFatal(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.FATAL, _registryId);
		}
		
		/**
		 * Does a Log.info, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#info()
		 * @see temple.core.debug.log.LogLevel#INFO
		 */
		protected final function logInfo(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.INFO, _registryId);
		}
		
		/**
		 * Does a Log.status, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#status()
		 * @see temple.core.debug.log.LogLevel#STATUS
		 */
		protected final function logStatus(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.STATUS, _registryId);
		}
		
		/**
		 * Does a Log.warn, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#warn()
		 * @see temple.core.debug.log.LogLevel#WARN
		 */
		protected final function logWarn(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.WARN, _registryId);
		}

		private function handleUnload(event:Event):void
		{
			if (_destructOnUnload) destruct();
		}
		
		private function handleAdded(event:Event):void
		{
			if (event.currentTarget == this) _onParent = true;
		}

		private function handleAddedToStage(event:Event):void
		{
			_onStage = true;
			StageProvider.stage ||= super.stage;
		}

		private function handleRemoved(event:Event):void
		{
			if (event.target == this)
			{
				_onParent = false;
				if (!_isDestructed) super.addEventListener(Event.ENTER_FRAME, handleDestructedFrameDelay);
			}
		}
		
		private function handleDestructedFrameDelay(event:Event):void
		{
			super.removeEventListener(Event.ENTER_FRAME, handleDestructedFrameDelay);
			checkParent();
		}

		/**
		 * Check objects parent, after being removed. If the object still has a parent, the object has been removed by a timeline animation.
		 * If an object is removed by a timeline animation, the object is not used anymore and can be destructed
		 */
		private function checkParent():void
		{
			if (parent && !_onParent) destruct();
		}

		private function handleRemovedFromStage(event:Event):void
		{
			_onStage = false;
		}		

		/**
		 * List of property names which are output in the toString() method.
		 */
		protected final function get toStringProps():Vector.<String>
		{
			return _toStringProps;
		}
		
		/**
		 * @private
		 *
		 * Possibility to modify the toStringProps array from outside, using the templelibrary namespace.
		 */
		templelibrary final function get toStringProps():Vector.<String>
		{
			return _toStringProps;
		}
		
		/**
		 * A Boolean which indicates if empty properties are output in the toString() method.
		 */
		protected final function get emptyPropsInToString():Boolean
		{
			return _emptyPropsInToString;
		}

		/**
		 * @private
		 */
		protected final function set emptyPropsInToString(value:Boolean):void
		{
			_emptyPropsInToString = value;
		}

		/**
		 * @private
		 * 
		 * Possibility to modify the emptyPropsInToString value from outside, using the templelibrary namespace.
		 */
		templelibrary final function get emptyPropsInToString():Boolean
		{
			return _emptyPropsInToString;
		}
		
		/**
		 * @private
		 */
		templelibrary final function set emptyPropsInToString(value:Boolean):void
		{
			_emptyPropsInToString = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return objectToString(this, toStringProps, !emptyPropsInToString);
		}
		
		private function handleOpen(event:Event):void
		{
			if (_debug) logDebug(event.type);
			dispatchEvent(event);
		}

		private function handleProgress(event:ProgressEvent):void
		{
			if (_debug) logDebug(event.type + ": " + Math.round(100 * (event.bytesLoaded / event.bytesTotal)) + "%, loaded: " + event.bytesLoaded + ", total: " + event.bytesTotal);
			dispatchEvent(event);
		}
		
		private function handleInit(event:Event):void
		{
			if (_debug) logDebug(event.type);
			if (isRedirected && checkPolicyFile)
			{
				var url:String = contentLoaderInfo.url;
				
				// Redirected, load correct policy file
				var policyFile:String = url.substring(0, url.indexOf("/", url.indexOf("//") + 2)) + "/crossdomain.xml";
				
				if (_debug) logDebug("Redirected to '" + url + "', we need to check the policy file: '" + policyFile + "'");

				_policyFileLoader = CoreLoader.templelibrary::POLICYFILE_LOADERS[policyFile] ||= new CoreURLLoader();
				
				if (_policyFileLoader.isLoaded)
				{
					// Policy file is already loaded, continue
					if (_debug) logDebug("Policy file is already loaded");
					_policyFileLoader = null;
				}
				else if (_policyFileLoader.isDestructed)
				{
					// Policy file can not be loaded, continue
					if (_debug) logDebug("Policy file cannot be loaded");
					_policyFileLoader = null;
				}
				else
				{
					_policyFileLoader.addEventListener(Event.COMPLETE, handlePolicyFileEvent);
					_policyFileLoader.addEventListener(IOErrorEvent.IO_ERROR, handlePolicyFileEvent);
					_policyFileLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handlePolicyFileEvent);
					
					if (!_policyFileLoader.isLoading) _policyFileLoader.load(new URLRequest(policyFile));
				}
			}
			else
			{
				dispatchEvent(event);
			}
		}
		
		private function handlePolicyFileEvent(event:Event):void
		{
			_policyFileLoader.removeEventListener(Event.COMPLETE, handlePolicyFileEvent);
			_policyFileLoader.removeEventListener(IOErrorEvent.IO_ERROR, handlePolicyFileEvent);
			_policyFileLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlePolicyFileEvent);
			
			if (_debug) logDebug("policyFile: " + event.type);
			
			_policyFileLoader = null;
			_isLoading = false;
			_isLoaded = true;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function handleComplete(event:Event):void
		{
			if (_debug) logDebug(event.type);
			
			if (!_policyFileLoader)
			{
				_isLoading = false;
				_isLoaded = true;
				
				dispatchEvent(event);
			}
			else if (_debug) logDebug("Policy file not loaded yet");
		}
		
		/**
		 * Default IOError handler
		 */
		private function handleIOError(event:IOErrorEvent):void
		{
			_isLoading = false;
			
			if (_logErrors || _debug) logError(event.type + ': ' + event.text);
			
			dispatchEvent(event);
		}
		
		/**
		 * Default SecurityError handler
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			_isLoading = false;
			
			if (_logErrors || _debug) logError(event.type + ': ' + event.text);
			
			dispatchEvent(event);
		}
		
		private function handleHTTPStatus(event:HTTPStatusEvent):void
		{
			if (_debug) logDebug(event.type);
			dispatchEvent(event);
		}
		
		[Temple]
		/**
		 * @inheritDoc
		 */
		public final function get isDestructed():Boolean
		{
			return _isDestructed;
		}

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
			
			_context = null;
			
			if (_policyFileLoader)
			{
				_policyFileLoader.removeEventListener(Event.COMPLETE, handlePolicyFileEvent);
				_policyFileLoader.removeEventListener(IOErrorEvent.IO_ERROR, handlePolicyFileEvent);
				_policyFileLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handlePolicyFileEvent);
				_policyFileLoader = null;
			}
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			super.removeEventListener(Event.ADDED, handleAdded);
			super.removeEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
			super.removeEventListener(Event.REMOVED, handleRemoved);
			super.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
			
			if (_isLoading)
			{
				try
				{
					close();
				}
				catch (e:Error){}
			}
			
			try
			{
				if (hasOwnProperty("unloadAndStop"))
				{
					//Flash Player 10 and later only
					(this as Object)["unloadAndStop"](true);
				}
				else
				{
					unload();
				}
			}
			catch (e:ArgumentError)
			{
				//the loader.content is addChilded somewhere else, so it cannot be unloaded
			}
			
			if (contentLoaderInfo)
			{
				contentLoaderInfo.removeEventListener(Event.OPEN, handleOpen);
				contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
				contentLoaderInfo.removeEventListener(Event.INIT, handleInit);
				contentLoaderInfo.removeEventListener(Event.COMPLETE, handleComplete);
				contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, handleIOError);
				contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
				contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, handleIOError);
				contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
				contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
			}
			
			if (parent)
			{
				if (parent is Loader)
				{
					Loader(parent).unload();
				}
				else
				{
					if (_onParent)
					{
						parent.removeChild(this);
					}
					else
					{
						// something weird happened, since we have a parent but didn't receive an ADDED event. So do the try-catch thing
						try
						{
							parent.removeChild(this);
						}
						catch (e:Error){}
					}
				}
			}
			_isDestructed = true;
		}
	}
}
