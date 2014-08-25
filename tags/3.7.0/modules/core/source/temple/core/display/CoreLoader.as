/*
include "../includes/License.as.inc";
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
		
		include "../includes/ConstructNamespace.as.inc";
		
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
		
		include "../includes/CoreLoaderMethods.as.inc";

		include "../includes/CoreObjectMethods.as.inc";
		
		include "../includes/CoreDisplayObjectMethods.as.inc";
		
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
		
		include "../includes/CoreEventDispatcherMethods.as.inc";
		
		include "../includes/DebuggableMethods.as.inc";

		include "../includes/LogMethods.as.inc";

		include "../includes/CoreDisplayObjectHandlers.as.inc";

		include "../includes/ToStringPropsMethods.as.inc";
		
		include "../includes/ToStringMethods.as.inc";
		
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
