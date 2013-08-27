/*
include "../includes/License.as.inc";
 */

package temple.core.net 
{
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
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;

	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]
	
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
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreURLStream extends URLStream implements ICoreLoader, IDestructibleOnError
	{
		include "../includes/Version.as.inc";
		
		include "../includes/ConstructNamespace.as.inc";
		
		private const _toStringProps:Vector.<String> = new Vector.<String>();
		private var _isLoading:Boolean;
		private var _isLoaded:Boolean;
		private var _destructOnError:Boolean;
		private var _logErrors:Boolean;
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _registryId:uint;
		private var _url:String;
		private var _emptyPropsInToString:Boolean = true;

		/**
		 * Creates a CoreURLStream
		 * @param destructOnError if set to true (default) this object will automatically be destructed on an Error (IOError or SecurityError)
		 * @param logErrors if set to true an error message wil be logged on an Error (IOError or SecurityError)
		 */
		public function CoreURLStream(destructOnError:Boolean = true, logErrors:Boolean = true)
		{
			construct::coreURLStream(destructOnError, logErrors);
		}
		
		/**
		 * @private
		 */
		construct function coreURLStream(destructOnError:Boolean, logErrors:Boolean):void
		{
			_destructOnError = destructOnError;
			_logErrors = logErrors;
			
			_registryId = Registry.add(this);
			
			// Add default listeners to Error events and preloader support
			super.addEventListener(Event.COMPLETE, handleLoadComplete);
			super.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			super.addEventListener(IOErrorEvent.DISK_ERROR, handleIOError);
			super.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
			super.addEventListener(IOErrorEvent.VERIFY_ERROR, handleIOError);
			super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function load(request:URLRequest):void
		{
			super.load(request);
			_url = request.url;
			_isLoading = true;
			_isLoaded = false;
		}

		/**
		 * @inheritDoc
		 */ 
		override public function close():void
		{
			super.close();
			_isLoading = false;
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
		
		include "../includes/LogMethods.as.inc";
		
		include "../includes/ToStringPropsMethods.as.inc";
		
		include "../includes/ToStringMethods.as.inc";
		
		private function handleLoadComplete(event:Event):void
		{
			_isLoading = false;
			_isLoaded = false;
		}
		
		/**
		 * Default IOError handler
		 * If logErrors is set to true, an error message is logged
		 */
		private function handleIOError(event:IOErrorEvent):void
		{
			_isLoading = false;
			if (_logErrors) logError(event.type + ': ' + event.text);
			if (_destructOnError) destruct();
		}
		
		/**
		 * Default SecurityError handler
		 * If logErrors is set to true, an error message is logged
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
			
			super.removeEventListener(Event.COMPLETE, handleLoadComplete);
			super.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			super.removeEventListener(IOErrorEvent.DISK_ERROR, handleIOError);
			super.removeEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
			super.removeEventListener(IOErrorEvent.VERIFY_ERROR, handleIOError);
			super.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			
			if (_isLoading) close();
			
			if (_eventListenerManager)
			{
				_eventListenerManager.destruct();
				_eventListenerManager = null;
			}
			_isDestructed = true;
		}
	}
}
