/*
include "../includes/License.as.inc";
 */

package temple.core.net 
{
	import temple.core.debug.IDebuggable;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.destruction.IDestructibleOnError;
	import temple.core.events.EventListenerManager;
	import temple.core.templelibrary;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

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
		 * Creates a CoreURLLoader.
		 * 
		 * @param request optional <code>URLRequest</code> to load
		 * @param dataFormat Controls whether the downloaded data is received as text
		 * 	(<code>URLLoaderDataFormat.TEXT</code>), raw binary data (<code>URLLoaderDataFormat.BINARY</code>), or
		 * 	URL-encoded variables (<code>URLLoaderDataFormat.VARIABLES</code>).
		 * @param destructOnError if set to true (default) this object wil automatically be destructed on an Error
		 * 	(<code>IOError</code> or <code>SecurityError</code>)
		 * @param logErrors if set to true an error message wil be logged on an Error (<code>IOError</code> or 
		 * 	<code>SecurityError</code>)
		 */
		public function CoreURLLoader(request:URLRequest = null, dataFormat:String = "text", destructOnError:Boolean = true, logErrors:Boolean = true)
		{
			construct::coreURLLoader(request, dataFormat, destructOnError, logErrors);
			
			super(request);
			
			this.dataFormat = dataFormat;
		}
		
		/**
		 * @private
		 */
		construct function coreURLLoader(request:URLRequest, dataFormat:String, destructOnError:Boolean, logErrors:Boolean):void
		{
			_destructOnError = destructOnError;
			_logErrors = logErrors;
			
			_registryId = Registry.add(this);
			
			// Add default listeners to Error events and preloader support
			super.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			super.addEventListener(Event.COMPLETE, handleComplete);
			super.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			super.addEventListener(IOErrorEvent.DISK_ERROR, handleIOError);
			super.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
			super.addEventListener(IOErrorEvent.VERIFY_ERROR, handleIOError);
			super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			
			request;
			dataFormat;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest):void
		{
			if (_isDestructed)
			{
				logWarn("load: This object is destructed (probably because 'desctructOnErrors' is set to true, so it cannot load anything");
				return;
			}
			if (_debug) logDebug("load: " + request.url);
			
			_url = request.url;
			_isLoading = true;
			_isLoaded = false;
			super.load(request);
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
		public function get destructOnError():Boolean
		{
			return _destructOnError;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set destructOnError(value:Boolean):void
		{
			_destructOnError = value;
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
			if (_debug) logDebug("handleProgress: " + Math.round(100 * (event.bytesLoaded / event.bytesTotal)) + "%, loaded: " + event.bytesLoaded + ", total: " + event.bytesTotal);
		}
		
		private function handleComplete(event:Event):void
		{
			if (_debug) logDebug("handleComplete");
			_isLoading = false;
			_isLoaded = true;
		}
		
		/**
		 * Default IOError handler
		 * 
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleIOError(event:IOErrorEvent):void
		{
			_isLoading = false;
			if (_logErrors) logError(event.type + ': ' + event.text);
			if (_destructOnError) destruct();
		}
		
		/**
		 * Default SecurityError handler
		 * 
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			_isLoading = false;
			if (_logErrors) logError(event.type + ': ' + event.text);
			if (_destructOnError) destruct();
		}
		
		include "../includes/IsDestructed.as.inc";

		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (_isDestructed) return;
			
			dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			super.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
			super.removeEventListener(Event.COMPLETE, handleComplete);
			super.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			super.removeEventListener(IOErrorEvent.DISK_ERROR, handleIOError);
			super.removeEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
			super.removeEventListener(IOErrorEvent.VERIFY_ERROR, handleIOError);
			super.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			
			if (_isLoading)
			{
				try
				{
					close();
				}
				catch (error:Error)
				{
					if (_debug) logWarn("destruct: " + error.message);
				}
			}
			if (_eventListenerManager)
			{
				_eventListenerManager.destruct();
				_eventListenerManager = null;
			}
			_isDestructed = true;
		}
	}
}
