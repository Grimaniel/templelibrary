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
			if (loaderInfo) loaderInfo.addEventListener(Event.UNLOAD, handleUnload, false, 0, true);
			
			_registryId = Registry.add(this);
			if (super.stage) StageProvider.stage ||= super.stage;
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			super.addEventListener(Event.ADDED, handleAdded);
			super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			super.addEventListener(Event.REMOVED, handleRemoved);
			super.addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addFrameScript(...args):void
		{
			super.addFrameScript.apply(null, args);
			
			_frameScripts ||= new Vector.<Function>(totalFrames, true);
			
			for (var i:int = 0, leni:int = args.length; i < leni; i += 2)
			{
				_frameScripts[args[i]] = args[i+1];
				
				if (_debug) logDebug("FrameScript " + (args[i+1] == null ? "cleared" : "set") + " on frame " + (args[i] + 1));
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
			else if (frame > totalFrames)
			{
				return throwError(new TempleArgumentError(this, "frame " + frame + " doesn't exists, totalFrame is " + totalFrames));
			}
			return _frameScripts &&  _frameScripts[frame - 1] != null;
		}

		/**
		 * @inheritDoc
		 */
		public function get hasFrameScripts():Boolean
		{
			return _frameScripts != null;
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
			else if (frame > totalFrames)
			{
				return throwError(new TempleArgumentError(this, "frame " + frame + " doesn't exists, totalFrame is " + totalFrames));
			}
			return _frameScripts[frame - 1];
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
			else if (frame > totalFrames)
			{
				throwError(new TempleArgumentError(this, "frame " + frame + " doesn't exists, totalFrame is " + totalFrames));
				return;
			}
			addFrameScript(frame - 1, script);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clearFrameScript(frame:uint):void
		{
			addFrameScript(frame - 1, null);
		}

		/**
		 * @inheritDoc
		 */
		public function clearFrameScripts():void
		{
			if (_frameScripts)
			{
				for (var i:int = 0, leni:int = _frameScripts.length; i < leni; i++)
				{
					if (_frameScripts[i] != null) addFrameScript(i, null);
				}
			}
		}

		/**
		 * Returns a list of all Frame Scripts. Modifying this list does not have effect on the actual scripts on the
		 * frames.
		 */
		templelibrary function get frameScripts():Vector.<Function>
		{
			return _frameScripts;
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
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Debug", type="Boolean", defaultValue="false")]
		public function set debug(value:Boolean):void
		{
			_debug = value;
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
			if (_isDestructed) return;
			
			dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			// clear mask, so it won't keep a reference to an other object
			mask = null;
			stop();
			clearFrameScripts();
			_frameScripts = null;
			
			if (stage && stage.focus == this) stage.focus = null;
			
			if (loaderInfo) loaderInfo.removeEventListener(Event.UNLOAD, handleUnload);
			
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
			
			Destructor.destructChildren(this);
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