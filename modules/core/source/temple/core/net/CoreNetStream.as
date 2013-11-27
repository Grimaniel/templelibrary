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
	import temple.core.events.EventListenerManager;
	import temple.core.templelibrary;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]
	
	/**
	 * Base class for all NetStreams in the Temple.
	 * <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * </ul>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @author Arjan van Wijk, Thijs Broerse
	 */
	public class CoreNetStream extends NetStream implements ICoreLoader, IDebuggable
	{
		include "../includes/ConstructNamespace.as.inc";
		
		private static var _framePulser:Shape;
		private const _toStringProps:Vector.<String> = new Vector.<String>();
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _isLoaded:Boolean;
		private var _registryId:uint;
		private var _isLoading:Boolean;
		private var _logErrors:Boolean;
		private var _url:String;
		private var _emptyPropsInToString:Boolean = true;
		private var _debug:Boolean;

		public function CoreNetStream(netConnection:NetConnection, logErrors:Boolean = true)
		{
			super(netConnection);
			
			construct::coreNetStream(netConnection, logErrors);
		}
		
		/**
		 * @private
		 */
		construct function coreNetStream(netConnection:NetConnection, logErrors:Boolean):void
		{
			_registryId = Registry.add(this);
			
			super.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
			super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			_logErrors = logErrors;
			
			netConnection;
			
			toStringProps.push('url');
		}
		
		/**
		 * @inheritDoc
		 */
		override public function play(...args:*):void
		{
			_isLoaded = false;
			_isLoading = true;
			_url = args[0];
			
			_framePulser ||= new Shape();
			_framePulser.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			super.play.apply(this, args);
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (bytesLoaded == bytesTotal && bytesLoaded > 0)
			{
				_framePulser.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				
				_isLoaded = true;
				_isLoading = false;
			}
		}
		
		include "../includes/CoreLoaderMethods.as.inc";
		
		include "../includes/CoreObjectMethods.as.inc";
		
		include "../includes/CoreEventDispatcherMethods.as.inc";
		
		include "../includes/LogMethods.as.inc";
		
		include "../includes/DebuggableMethods.as.inc";
		
		include "../includes/ToStringPropsMethods.as.inc";
		
		include "../includes/ToStringMethods.as.inc";
		
		include "../includes/IsDestructed.as.inc";
		
		private function handleNetStatusEvent(event:NetStatusEvent):void
		{
			if (_debug) logDebug(event.type + ": " + event.info.code);
		}

		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			if (_logErrors || _debug) logError(event.type + ': ' + event.text);
		}
		
		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (_isDestructed) return;
			
			dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			super.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);
			super.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			
			removeAllEventListeners();
			client = this;
			close();
			
			if (_framePulser)
			{
				_framePulser.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				if (!_framePulser.hasEventListener(Event.ENTER_FRAME)) _framePulser = null;
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
