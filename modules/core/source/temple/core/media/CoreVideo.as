/*
include "../includes/License.as.inc";
 */

package temple.core.media 
{
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.display.ICoreDisplayObject;
	import temple.core.display.StageProvider;
	import temple.core.events.EventListenerManager;
	import temple.core.templelibrary;

	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;

	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]
	
	/**
	 * Base class for all Videos in the Temple. The CoreVideo handles some core features of the Temple:
	 * <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Global reference to the stage trough the StageProvider.</li>
	 * 	<li>Corrects a timeline bug in Flash (see <a href="http://www.tyz.nl/2009/06/23/weird-parent-thing-bug-in-flash/" target="_blank">http://www.tyz.nl/2009/06/23/weird-parent-thing-bug-in-flash/</a>).</li>
	 * 	<li>Event dispatch optimization.</li>
	 * 	<li>Easy remove of all EventListeners.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * 	<li>Some useful extra properties like autoAlpha, position and scale.</li>
	 * </ul>
	 * 
	 * <p>You should always use and/or extend the CoreVideo instead of Shape if you want to make use of the Temple features.</p>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @includeExample CoreDisplayObjectsExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreVideo extends Video implements ICoreDisplayObject 
	{
		include "../includes/Version.as.inc";
		
		include "../includes/ConstructNamespace.as.inc";
		
		private const _toStringProps:Vector.<String> = Vector.<String>(['name']);
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _onStage:Boolean;
		private var _onParent:Boolean;
		private var _registryId:uint;
		private var _destructOnUnload:Boolean = true;
		private var _emptyPropsInToString:Boolean = true;
		private var _camera:Camera;
		private var _netStream:NetStream;

		public function CoreVideo(width:int = 320, height:int = 240)
		{
			super(width, height);
			
			construct::coreVideo(width, height);
		}
		
		/**
		 * @private
		 */
		construct function coreVideo(width:int, height:int):void
		{
			if (loaderInfo) loaderInfo.addEventListener(Event.UNLOAD, handleUnload, false, 0, true);
			
			_registryId = Registry.add(this);
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			super.addEventListener(Event.ADDED, handleAdded);
			super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			super.addEventListener(Event.REMOVED, handleRemoved);
			super.addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
			
			width;
			height;
		}
		
		/**
		 * Returns a reference to the attached <code>Camera</code>.
		 * 
		 * @see #attachCamera()
		 */
		public function get camera():Camera 
		{
			return _camera; 
		}
		
		/**
		 * @private
		 */
		public function set camera(value:Camera):void 
		{ 
			attachCamera(value); 
		}
		
		/**
		 * Returns a reference to the attached <code>NetStream</code>.
		 * 
		 * @see #attachNetStream()
		 */
		public function get netStream():NetStream 
		{
			return _netStream; 
		}
		
		/**
		 * @private
		 */
		public function set netStream(value:NetStream):void 
		{ 
			attachNetStream(value); 
		}
		
		/**
		 * @inheritDoc
		 */
		override public function attachCamera(camera:Camera):void
		{
			super.attachCamera(camera);
			_camera = camera;
		}
		
		/**
		 * Detaches the attached <code>Camera</code>.
		 * 
		 * @see #attachCamera()
		 */
		public function detachCamera():void
		{
			if (_camera) attachCamera(null);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function attachNetStream(netStream:NetStream):void
		{
			super.attachNetStream(netStream);
			_netStream = netStream;
		}
		
		/**
		 * Detaches the attached <code>NetStream</code>.
		 * 
		 * @see #attachNetStream()
		 */
		public function detachNetStream():void
		{
			if (_netStream) attachNetStream(null);
		}
		
		include "../includes/CoreObjectMethods.as.inc";
		
		include "../includes/CoreDisplayObjectMethods.as.inc";
		
		include "../includes/CoreEventDispatcherMethods.as.inc";
		
		include "../includes/LogMethods.as.inc";

		include "../includes/CoreDisplayObjectHandlers.as.inc";
		
		include "../includes/ToStringPropsMethods.as.inc";

		include "../includes/ToStringMethods.as.inc";
		
		include "../includes/IsDestructed.as.inc";

		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (_isDestructed) return;
			
			dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			// clear mask, so it won't keep a reference to an other object
			mask = null;
			
			detachCamera();
			detachNetStream();
			
			if (loaderInfo) loaderInfo.removeEventListener(Event.UNLOAD, handleUnload);
			
			removeEventListener(Event.ENTER_FRAME, handleDestructedFrameDelay);
			
			if (_eventListenerManager)
			{
				_eventListenerManager.destruct();
				_eventListenerManager = null;
			}
			
			super.removeEventListener(Event.ENTER_FRAME, handleDestructedFrameDelay);
			super.removeEventListener(Event.ADDED, handleAdded);
			super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			super.removeEventListener(Event.REMOVED, handleRemoved);
			super.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
			
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
						if (name && parent.hasOwnProperty(name)) parent[name] = null;
						parent.removeChild(this);
					}
					else
					{
						// something weird happened, since we have a parent but didn't receive an ADDED event. So do the try-catch thing
						try
						{
							if (name && parent.hasOwnProperty(name)) parent[name] = null;
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
