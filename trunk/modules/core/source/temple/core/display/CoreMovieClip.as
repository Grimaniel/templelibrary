/*
include "../includes/License.as.inc";
 */

package temple.core.display 
{
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.destruction.Destructor;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.EventListenerManager;
	import temple.core.templelibrary;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;


	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]
	
	/**
	 * Base class for all MovieClips in the Temple. The CoreMovieClip handles some core features of the Temple:
	 * <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Global reference to the stage trough the StageProvider.</li>
	 * 	<li>Corrects a timeline bug in Flash (see <a href="http://www.tyz.nl/2009/06/23/weird-parent-thing-bug-in-flash/" target="_blank">http://www.tyz.nl/2009/06/23/weird-parent-thing-bug-in-flash/</a>).</li>
	 * 	<li>Event dispatch optimization.</li>
	 * 	<li>Easy remove of all EventListeners.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Automatic removes and destruct children, grandchildren etc. on destruction.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * 	<li>Some useful extra properties like autoAlpha, position and scale.</li>
	 * </ul>
	 * 
	 * <p>You should always use and/or extend the CoreMovieClip instead of MovieClip if you want to make use of the Temple features.</p>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @includeExample CoreDisplayObjectsExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreMovieClip extends MovieClip implements ICoreMovieClip
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
		private var _frameScripts:Vector.<Function>;
		private var _debug:Boolean;

		public function CoreMovieClip()
		{
			construct::coreMovieClip();
		}
		
		/**
		 * @private
		 */
		construct function coreMovieClip():void
		{
			if (this.loaderInfo) this.loaderInfo.addEventListener(Event.UNLOAD, this.handleUnload, false, 0, true);
			
			this._registryId = Registry.add(this);
			if (super.stage) StageProvider.stage ||= super.stage;
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			super.addEventListener(Event.ADDED, this.handleAdded);
			super.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			super.addEventListener(Event.REMOVED, this.handleRemoved);
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function addFrameScript(...args):void
		{
			super.addFrameScript.apply(null, args);
			
			this._frameScripts ||= new Vector.<Function>(this.totalFrames, true);
			
			for (var i:int = 0, leni:int = args.length; i < leni; i += 2)
			{
				this._frameScripts[args[i]] = args[i+1];
				
				if (this.debug) this.logDebug("FrameScript " + (args[i+1] == null ? "cleared" : "set") + " on frame " + (args[i] + 1));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasFrameScript(frame:uint):Boolean
		{
			if (frame == 0)
			{
				return throwError(new TempleArgumentError(this, "frame cannot be 0"));
			}
			else if (frame > this.totalFrames)
			{
				return throwError(new TempleArgumentError(this, "frame " + frame + " doesn't exists, totalFrame is " + this.totalFrames));
			}
			return this._frameScripts &&  this._frameScripts[frame - 1] != null;
		}

		/**
		 * @inheritDoc
		 */
		public function get hasFrameScripts():Boolean
		{
			return this._frameScripts != null;
		}

		/**
		 * @inheritDoc
		 */
		public function getFrameScript(frame:uint):Function
		{
			if (frame == 0)
			{
				return throwError(new TempleArgumentError(this, "frame cannot be 0"));
			}
			else if (frame > this.totalFrames)
			{
				return throwError(new TempleArgumentError(this, "frame " + frame + " doesn't exists, totalFrame is " + this.totalFrames));
			}
			return this._frameScripts[frame - 1];
		}

		/**
		 * @inheritDoc
		 */
		public function setFrameScript(frame:uint, script:Function):void
		{
			if (frame == 0)
			{
				throwError(new TempleArgumentError(this, "frame cannot be 0"));
				return;
			}
			else if (frame > this.totalFrames)
			{
				throwError(new TempleArgumentError(this, "frame " + frame + " doesn't exists, totalFrame is " + this.totalFrames));
				return;
			}
			this.addFrameScript(frame - 1, script);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clearFrameScript(frame:uint):void
		{
			this.addFrameScript(frame - 1, null);
		}

		/**
		 * @inheritDoc
		 */
		public function clearFrameScripts():void
		{
			if (this._frameScripts)
			{
				for (var i:int = 0, leni:int = this._frameScripts.length; i < leni; i++)
				{
					if (this._frameScripts[i] != null) this.addFrameScript(i, null);
				}
			}
		}

		/**
		 * Returns a list of all Frame Scripts. Modifying this list does not have effect on the actual scripts on the
		 * frames.
		 */
		templelibrary function get frameScripts():Vector.<Function>
		{
			return this._frameScripts;
		}

		include "../includes/CoreObjectMethods.as.inc";

		include "../includes/CoreDisplayObjectMethods.as.inc";

		include "../includes/CoreDisplayObjectContainerMethods.as.inc";
		
		include "../includes/CoreEventDispatcherMethods.as.inc";
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Debug", type="Boolean", defaultValue="false")]
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}
		
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
			
			// clear mask, so it won't keep a reference to an other object
			this.mask = null;
			this.stop();
			this.clearFrameScripts();
			this._frameScripts = null;
			
			if (this.stage && this.stage.focus == this) this.stage.focus = null;
			
			if (this.loaderInfo) this.loaderInfo.removeEventListener(Event.UNLOAD, this.handleUnload);
			
			if (this._eventListenerManager)
			{
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			
			super.removeEventListener(Event.ENTER_FRAME, this.handleDestructedFrameDelay);
			super.removeEventListener(Event.ADDED, this.handleAdded);
			super.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			super.removeEventListener(Event.REMOVED, this.handleRemoved);
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			
			Destructor.destructChildren(this);
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
						if (this.name && this.parent.hasOwnProperty(this.name)) this.parent[this.name] = null;
						this.parent.removeChild(this);
					}
					else
					{
						// something weird happened, since we have a parent but didn't receive an ADDED event. So do the try-catch thing
						try
						{
							if (this.name && this.parent.hasOwnProperty(this.name)) this.parent[this.name] = null;
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