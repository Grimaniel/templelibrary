/*
include "../includes/License.as.inc";
 */

package temple.core.net 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.destruction.IDestructibleOnError;
	import temple.core.events.EventListenerManager;
	import temple.core.templelibrary;

	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]
	
	/**
	 * Base class for all URLLoaders in the Temple. The CoreURLLoader handles some core features of the Temple:
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
	 * <p>You should always use and/or extend the CoreURLLoader instead of URLLoader if you want to make use of the Temple features.</p>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreURLLoader extends URLLoader implements ICoreLoader, IDestructibleOnError, IDebuggable
	{
		include "../includes/Version.as.inc";
		
		include "../includes/ConstructNamespace.as.inc";
		
		private const _toStringProps:Vector.<String> = Vector.<String>(['url']);
		private var _registryId:uint;
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _destructOnError:Boolean;
		private var _isLoading:Boolean;
		private var _isLoaded:Boolean;
		private var _logErrors:Boolean;
		private var _url:String;
		private var _emptyPropsInToString:Boolean = true;
		private var _debug:Boolean;

		/**
		 * Creates a CoreURLLoader
		 * @param request optional URLRequest to load
		 * @param destructOnError if set to true (default) this object wil automatically be destructed on an Error (IOError or SecurityError)
		 * @param logErrors if set to true an error message wil be logged on an Error (IOError or SecurityError)
		 */
		public function CoreURLLoader(request:URLRequest = null, destructOnError:Boolean = true, logErrors:Boolean = true)
		{
			construct::coreURLLoader(request, destructOnError, logErrors);
			
			super(request);
		}
		
		/**
		 * @private
		 */
		construct function coreURLLoader(request:URLRequest, destructOnError:Boolean, logErrors:Boolean):void
		{
			this._destructOnError = destructOnError;
			this._logErrors = logErrors;
			
			this._registryId = Registry.add(this);
			
			// Add default listeners to Error events and preloader support
			super.addEventListener(ProgressEvent.PROGRESS, this.handleProgress);
			super.addEventListener(Event.COMPLETE, this.handleComplete);
			super.addEventListener(IOErrorEvent.IO_ERROR, this.handleIOError);
			super.addEventListener(IOErrorEvent.DISK_ERROR, this.handleIOError);
			super.addEventListener(IOErrorEvent.NETWORK_ERROR, this.handleIOError);
			super.addEventListener(IOErrorEvent.VERIFY_ERROR, this.handleIOError);
			super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError);
			
			request;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest):void
		{
			if (this._isDestructed)
			{
				this.logWarn("load: This object is destructed (probably because 'desctructOnErrors' is set to true, so it cannot load anything");
				return;
			}
			if (this.debug) this.logDebug("load: " + request.url);
			
			this._url = request.url;
			this._isLoading = true;
			this._isLoaded = false;
			super.load(request);
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
		
		include "../includes/CoreLoaderMethods.as.inc";
		
		include "../includes/CoreObjectMethods.as.inc";
		
		include "../includes/CoreEventDispatcherMethods.as.inc";

		include "../includes/DebuggableMethods.as.inc";

		include "../includes/LogMethods.as.inc";
		
		include "../includes/ToStringPropsMethods.as.inc";
		
		include "../includes/ToStringMethods.as.inc";
		
		private function handleProgress(event:ProgressEvent):void
		{
			if (this.debug) this.logDebug("handleProgress: " + Math.round(100 * (event.bytesLoaded / event.bytesTotal)) + "%, loaded: " + event.bytesLoaded + ", total: " + event.bytesTotal);
		}
		
		private function handleComplete(event:Event):void
		{
			if (this._debug) this.logDebug("handleComplete");
			this._isLoading = false;
			this._isLoaded = true;
		}
		
		/**
		 * Default IOError handler
		 * 
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleIOError(event:IOErrorEvent):void
		{
			this._isLoading = false;
			if (this._logErrors) this.logError(event.type + ': ' + event.text);
			if (this._destructOnError) this.destruct();
		}
		
		/**
		 * Default SecurityError handler
		 * 
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			this._isLoading = false;
			if (this._logErrors) this.logError(event.type + ': ' + event.text);
			if (this._destructOnError) this.destruct();
		}
		
		include "../includes/IsDestructed.as.inc";

		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (this._isDestructed) return;
			
			this.dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			super.removeEventListener(ProgressEvent.PROGRESS, this.handleProgress);
			super.removeEventListener(Event.COMPLETE, this.handleComplete);
			super.removeEventListener(IOErrorEvent.IO_ERROR, this.handleIOError);
			super.removeEventListener(IOErrorEvent.DISK_ERROR, this.handleIOError);
			super.removeEventListener(IOErrorEvent.NETWORK_ERROR, this.handleIOError);
			super.removeEventListener(IOErrorEvent.VERIFY_ERROR, this.handleIOError);
			super.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError);
			
			if (this._isLoading)
			{
				try
				{
					this.close();
				}
				catch(error:Error)
				{
					if (this.debug) this.logWarn("destruct: " + error.message);
				}
			}
			if (this._eventListenerManager)
			{
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			this._isDestructed = true;
		}
	}
}
