/*
include "../includes/License.as.inc";
 */

package temple.core.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.events.EventListenerManager;
	import temple.core.templelibrary;


	/**
	 * @eventType temple.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]

	/**
	 * Base class for all Bitmaps in the Temple. The CoreBitmap handles some core features of the Temple:
	 * <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Global reference to the stage trough the StageProvider.</li>
	 * 	<li>Event dispatch optimization.</li>
	 * 	<li>Easy remove of all EventListeners.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * 	<li>Automatic disposes BitmapData on destruction (can be disabled).</li>
	 * 	<li>Some useful extra properties like autoAlpha, position and scale.</li>
	 * </ul>
	 * 
	 * <p>Note: The CoreBitmap will automatic dispose the BitmapData on destruction. If you do not want that you should set disposeBitmapDataOnDestruct to false.</p>
	 * 
	 * <p>You should always use and/or extend the CoreBitmap instead of MovieClip if you want to make use of the Temple features.</p>
	 *
	 * @see temple.core.Temple#registerObjectsInMemory
	 *
	 * @includeExample CoreDisplayObjectsExample.as	
	 *
	 * @author Thijs Broerse
	 */
	public class CoreBitmap extends Bitmap implements ICoreDisplayObject
	{
		include "../includes/Version.as.inc";
		
		include "../includes/ConstructNamespace.as.inc";
		
		private const _toStringProps:Vector.<String> = Vector.<String>(['name']);
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _onStage:Boolean;
		private var _onParent:Boolean;
		private var _destructOnUnload:Boolean = true;
		private var _registryId:uint;
		private var _disposeBitmapDataOnDestruct:Boolean;
		private var _emptyPropsInToString:Boolean = true;

		public function CoreBitmap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false, disposeBitmapDataOnDestruct:Boolean = false)
		{
			super(bitmapData, pixelSnapping, smoothing);

			construct::coreBitmap(bitmapData, pixelSnapping, smoothing, disposeBitmapDataOnDestruct);
		}
		
		/**
		 * @private
		 */
		construct function coreBitmap(bitmapData:BitmapData, pixelSnapping:String, smoothing:Boolean, disposeBitmapDataOnDestruct:Boolean):void
		{
			this._disposeBitmapDataOnDestruct = disposeBitmapDataOnDestruct;

			if (this.loaderInfo) this.loaderInfo.addEventListener(Event.UNLOAD, this.handleUnload, false, 0, true);
			
			this._registryId = Registry.add(this);
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			super.addEventListener(Event.ADDED, this.handleAdded);
			super.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			super.addEventListener(Event.REMOVED, this.handleRemoved);
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			
			bitmapData;
			pixelSnapping;
			smoothing;
		}
		
		/**
		 * Indicates if the BitmapData should be disposed when the CoreBitmap is destructed. Default: true
		 */
		public function get disposeBitmapDataOnDestruct():Boolean
		{
			return this._disposeBitmapDataOnDestruct;
		}
		
		/**
		 * @private
		 */
		public function set disposeBitmapDataOnDestruct(value:Boolean):void
		{
			this._disposeBitmapDataOnDestruct = value;
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
			if (this._isDestructed) return;
			
			this.dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			if (this.bitmapData && this._disposeBitmapDataOnDestruct)
			{
				this.bitmapData.dispose();
			}
			this.bitmapData = null;
			
			// clear mask, so it won't keep a reference to an other object
			this.mask = null;
			
			if (this.loaderInfo) this.loaderInfo.removeEventListener(Event.UNLOAD, this.handleUnload);
			
			this.removeEventListener(Event.ENTER_FRAME, this.handleDestructedFrameDelay);
			
			if (this._eventListenerManager)
			{
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			
			super.removeEventListener(Event.ADDED, this.handleAdded);
			super.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			super.removeEventListener(Event.REMOVED, this.handleRemoved);
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			
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
