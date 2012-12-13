/*
include "../includes/License.as.inc";
 */

package temple.core.net 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
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
			this._destructOnError = destructOnError;
			this._logErrors = logErrors;
			
			this._registryId = Registry.add(this);
			
			// Add default listeners to Error events and preloader support
			super.addEventListener(Event.COMPLETE, this.handleLoadComplete);
			super.addEventListener(IOErrorEvent.IO_ERROR, this.handleIOError);
			super.addEventListener(IOErrorEvent.DISK_ERROR, this.handleIOError);
			super.addEventListener(IOErrorEvent.NETWORK_ERROR, this.handleIOError);
			super.addEventListener(IOErrorEvent.VERIFY_ERROR, this.handleIOError);
			super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError);
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
		
		include "../includes/LogMethods.as.inc";
		
		include "../includes/ToStringPropsMethods.as.inc";
		
		include "../includes/ToStringMethods.as.inc";
		
		private function handleLoadComplete(event:Event):void
		{
			this._isLoading = false;
			this._isLoaded = false;
		}
		
		/**
		 * Default IOError handler
		 * If logErrors is set to true, an error message is logged
		 */
		private function handleIOError(event:IOErrorEvent):void
		{
			this._isLoading = false;
			if (this._logErrors) this.logError(event.type + ': ' + event.text);
			if (this._destructOnError) this.destruct();
		}
		
		/**
		 * Default SecurityError handler
		 * If logErrors is set to true, an error message is logged
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
			
			super.removeEventListener(Event.COMPLETE, this.handleLoadComplete);
			super.removeEventListener(IOErrorEvent.IO_ERROR, this.handleIOError);
			super.removeEventListener(IOErrorEvent.DISK_ERROR, this.handleIOError);
			super.removeEventListener(IOErrorEvent.NETWORK_ERROR, this.handleIOError);
			super.removeEventListener(IOErrorEvent.VERIFY_ERROR, this.handleIOError);
			super.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError);
			
			if (this._isLoading) this.close();
			
			if (this._eventListenerManager)
			{
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			this._isDestructed = true;
		}
	}
}
