/*
include "../includes/License.as.inc";
 */

package temple.core.net 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.events.EventListenerManager;
	import temple.core.templelibrary;

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
	 * @author Arjan van Wijk
	 */
	public class CoreNetStream extends NetStream implements ICoreLoader
	{
		include "../includes/Version.as.inc";
		
		private const _toStringProps:Vector.<String> = new Vector.<String>();
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _isLoaded:Boolean;
		private var _framePulseSprite:Sprite;
		private var _registryId:uint;
		private var _isLoading:Boolean;
		private var _logErrors:Boolean;
		private var _url:String;
		private var _emptyPropsInToString:Boolean = true;

		public function CoreNetStream(netConnection:NetConnection) 
		{
			super(netConnection);
			
			// Register object for destruction testing
			this._registryId = Registry.add(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function play(...args:*):void
		{
			this._isLoaded = false;
			this._isLoading = true;
			this._url = args[0];
			
			this._framePulseSprite ||= new Sprite();
			this._framePulseSprite.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			
			super.play.apply(this, args);
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (this.bytesLoaded == this.bytesTotal && this.bytesLoaded > 0)
			{
				this._framePulseSprite.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				
				this._isLoaded = true;
				this._isLoading = false;
			}
		}
		
		include "../includes/CoreLoaderMethods.as.inc";
		
		include "../includes/CoreObjectMethods.as.inc";
		
		include "../includes/CoreEventDispatcherMethods.as.inc";
		
		include "../includes/LogMethods.as.inc";
		
		include "../includes/ToStringPropsMethods.as.inc";
		
		include "../includes/ToStringMethods.as.inc";
		
		include "../includes/IsDestructed.as.inc";
		
		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (this._isDestructed) return;
			
			this.dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			this.removeAllEventListeners();
			this.client = this;
			this.close();
			
			if (this._framePulseSprite)
			{
				this._framePulseSprite.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this._framePulseSprite = null;
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
