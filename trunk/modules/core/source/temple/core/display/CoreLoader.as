/*
include "../includes/License.as.inc";
 */

package temple.core.display 
{
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
	import temple.core.debug.IDebuggable;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.events.EventListenerManager;
	import temple.core.net.ICoreLoader;
	import temple.core.templelibrary;


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
	 * loader.addEventListener(Event.COMPLETE, this.handleLoaderComplete);
	 * this.addChild(loader);
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
		include "../includes/Version.as.inc";
		
		private const _toStringProps:Vector.<String> = Vector.<String>(['name', 'url']);
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

		/**
		 * Creates a new CoreLoader
		 */
		public function CoreLoader(logErrors:Boolean = true)
		{
			super();
			
			this._logErrors = logErrors;
			
			if (this.loaderInfo) this.loaderInfo.addEventListener(Event.UNLOAD, this.handleUnload, false, 0, true);
			
			// Register object for destruction testing
			this._registryId = Registry.add(this);
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			super.addEventListener(Event.ADDED, this.handleAdded);
			super.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
			super.addEventListener(Event.REMOVED, this.handleRemoved);
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			
			// Add listeners on contentLoaderInfo
			this.contentLoaderInfo.addEventListener(Event.OPEN, this.handleOpen, false, 0, true);
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.handleProgress, false, 0, true);
			this.contentLoaderInfo.addEventListener(Event.INIT, this.handleInit, false, 0, true);
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, this.handleComplete, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.handleIOError, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, this.handleIOError, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, this.handleIOError, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, this.handleIOError, false, 0, true);
			this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError, false, 0, true);
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
		
		include "../includes/CoreLoaderMethods.as.inc";

		include "../includes/CoreObjectMethods.as.inc";
		
		include "../includes/CoreDisplayObjectMethods.as.inc";
		
		include "../includes/CoreEventDispatcherMethods.as.inc";
		
		include "../includes/DebuggableMethods.as.inc";

		include "../includes/LogMethods.as.inc";

		include "../includes/CoreDisplayObjectHandlers.as.inc";

		include "../includes/ToStringPropsMethods.as.inc";
		
		include "../includes/ToStringMethods.as.inc";
		
		private function handleOpen(event:Event):void
		{
			if (this.debug) this.logDebug("handleOpen");
			
			this.dispatchEvent(event.clone());
		}

		private function handleProgress(event:ProgressEvent):void
		{
			if (this.debug) this.logDebug("handleProgress: " + Math.round(100 * (event.bytesLoaded / event.bytesTotal)) + "%, loaded: " + event.bytesLoaded + ", total: " + event.bytesTotal);
			this.dispatchEvent(event.clone());
		}
		
		private function handleInit(event:Event):void
		{
			this.dispatchEvent(event.clone());
		}
		
		private function handleComplete(event:Event):void
		{
			if (this.debug) this.logDebug("handleComplete");
			
			this._isLoading = false;
			this._isLoaded = true;
			
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * Default IOError handler
		 */
		private function handleIOError(event:IOErrorEvent):void
		{
			this._isLoading = false;
			
			if (this._logErrors || this._debug) this.logError(event.type + ': ' + event.text);
			
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * Default SecurityError handler
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			this._isLoading = false;
			
			if (this._logErrors || this._debug) this.logError(event.type + ': ' + event.text);
			
			this.dispatchEvent(event.clone());
		}
		
		include "../includes/IsDestructed.as.inc";

		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (this._isDestructed) return;
			
			this.dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			if (this._eventListenerManager)
			{
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			super.removeEventListener(Event.ADDED, this.handleAdded);
			super.removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
			super.removeEventListener(Event.REMOVED, this.handleRemoved);
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			
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
					(this as Object)["unloadAndStop"](true);
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
				this.contentLoaderInfo.removeEventListener(Event.OPEN, this.handleOpen);
				this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.handleProgress);
				this.contentLoaderInfo.removeEventListener(Event.INIT, this.handleInit);
				this.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.handleComplete);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.handleIOError);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, this.handleIOError);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, this.handleIOError);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, this.handleIOError);
				this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError);
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
	}
}
