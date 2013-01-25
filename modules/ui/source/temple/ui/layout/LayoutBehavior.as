/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.ui.layout 
{
	import temple.common.enum.Direction;
	import temple.common.enum.Orientation;
	import temple.common.interfaces.IEnableable;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;
	import temple.ui.layout.liquid.LiquidBehavior;
	import temple.utils.FrameDelay;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * Behavior for automatically positioning of children in a <code>DisplayObjectContainer</code>.
	 * 
	 * @author Thijs Broerse
	 */
	public class LayoutBehavior extends AbstractDisplayObjectBehavior implements IEnableable, IDebuggable
	{
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the LayoutBehavior of a DisplayObjectContainer, if the DisplayObjectContainer has LayoutBehavior. Otherwise null is returned.
		 */
		public static function getInstance(target:DisplayObjectContainer):LiquidBehavior
		{
			return LayoutBehavior._dictionary[target] as LiquidBehavior;
		}
		
		private var _orientation:String = Orientation.HORIZONTAL;
		private var _direction:String = Direction.ASCENDING;

		private var _spacing:Number;
		private var _liquidBehavior:LiquidBehavior;
		private var _block:Boolean;
		private var _overwriteDimensions:Boolean;
		private var _enabled:Boolean = true;
		private var _snapToPixels:Boolean = true;
		private var _ignoreInvisibleChildren:Boolean;
		private var _debug:Boolean;

		public function LayoutBehavior(target:DisplayObjectContainer, orientation:String = "horizontal", direction:String = "ascending", spacing:Number = 0, overwriteDimensions:Boolean = true, enabled:Boolean = true)
		{
			_block = true;
			
			super(target);
			
			if (LayoutBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has LayoutBehavior"));
			LayoutBehavior._dictionary[target] = this;

			_liquidBehavior = LiquidBehavior.getInstance(target) || new LiquidBehavior(target);
			
			this.orientation = orientation;
			this.direction = direction;
			this.spacing = spacing;
			_overwriteDimensions = overwriteDimensions;
			_enabled = enabled;
			
			var leni:int = target.numChildren;
			for (var i:int = 0; i < leni; i++)
			{
				target.getChildAt(i).addEventListener(Event.RESIZE, handleChildResize, false, 0, true);
			}
			
			target.addEventListener(Event.ADDED, handleAdded);
			target.addEventListener(Event.REMOVED, handleRemoved);
			
			addToDebugManager(this);
			
			_block = false;
			layoutChildren();
		}

		/**
		 * Returns a reference to the DisplayObjectContainer. Same value as target, but typed as DisplayObjectContainer.
		 */
		public function get displayObjectContainer():DisplayObjectContainer 
		{
			return target as DisplayObjectContainer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get orientation():String
		{
			return _orientation;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set orientation(value:String):void
		{
			switch (value)
			{
				case Orientation.HORIZONTAL:
				case Orientation.VERTICAL:
				{
					if (_orientation != value)
					{
						_orientation = value;
						layoutChildren();
					}
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "invalid value for orientation: '" + value + "'"));
					return;
					break;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get direction():String
		{
			return _direction;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set direction(value:String):void
		{
			switch (value)
			{
				case Direction.ASCENDING:
				case Direction.DESCENDING:
				{
					if (_direction != value)
					{
						_direction = value;
						layoutChildren();
					}
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "invalid value for orientation: '" + value + "'"));
					return;
				}
					break;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get spacing():Number
		{
			return _spacing;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set spacing(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "spacing can not be set to NaN"));
			_spacing = value;
			layoutChildren();
		}
		
		/**
		 * If set to true (default) the LayoutBehaviors controls the dimension of the target.
		 */
		public function get overwriteDimensions():Boolean
		{
			return _overwriteDimensions;
		}
		
		/**
		 * @private
		 */
		public function set overwriteDimensions(value:Boolean):void
		{
			_overwriteDimensions = value;
		}
		
		/**
		 * Distributes all children of the target corresponding to the orientation, direction and spacing.
		 */
		public function layoutChildren():void
		{
			if (_block || !_enabled || isDestructed) return;
			
			if (debug) logDebug("layoutChildren: orientation=" + orientation + ", direction=" + direction + ", numChildren=" + displayObjectContainer.numChildren);
			
			var liquid:LiquidBehavior;
			var child:DisplayObject;
			var offset:Number = 0;
			var leni:int = displayObjectContainer.numChildren;
			for (var i:int = 0; i < leni; i++)
			{
				child = displayObjectContainer.getChildAt(i);
				
				if (_ignoreInvisibleChildren && !child.visible) continue;
				
				liquid = LiquidBehavior.getInstance(child) || new LiquidBehavior(child, _liquidBehavior);
				
				liquid.relatedObject = _liquidBehavior;
				
				if (i) offset += _spacing;
				
				if (_snapToPixels) offset = Math.round(offset);
				
				if (debug) logDebug("layout: offset=" + offset + ", Child=" + child);
				
				switch (_orientation)
				{
					case Orientation.HORIZONTAL:
					{
						switch (_direction)
						{
							case Direction.ASCENDING:
							{
								liquid.left = offset;
								liquid.right = NaN;
								break;
							}
							case Direction.DESCENDING:
							{
								liquid.left = NaN;
								liquid.right = offset;
								break;
							}
						}
						offset += liquid.displayObject.width;
						break;
					}
					case Orientation.VERTICAL:
					{
						switch (_direction)
						{
							case Direction.ASCENDING:
							{
								liquid.bottom = NaN;
								liquid.top = offset;
								break;
							}
							case Direction.DESCENDING:
							{
								liquid.top = NaN;
								liquid.bottom = offset;
								break;
							}
						}
						offset += liquid.displayObject.height;
						break;
					}
				}
				liquid.update();
			}
			if (_overwriteDimensions)// && _direction == Direction.DESCENDING)
			{
				if (_snapToPixels) offset = Math.round(offset);
				switch (_orientation)
				{
					case Orientation.HORIZONTAL:
					{
						_liquidBehavior.absoluteWidth = offset;
						if (displayObject.width != offset && target is ILayoutContainer) displayObject.width = offset;
						break;
					}
					case Orientation.VERTICAL:
					{
						_liquidBehavior.absoluteHeight = offset;
						if (displayObject.height != offset && target is ILayoutContainer) displayObject.height = offset;
						break;
					}
				}
			}
			_liquidBehavior.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if (_enabled) layoutChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			enabled = false;
		}
		
		/**
		 * If set to true al values will be rounded
		 */
		public function get snapToPixels():Boolean
		{
			return _snapToPixels;
		}

		/**
		 * @private
		 */
		public function set snapToPixels(value:Boolean):void
		{
			_snapToPixels = value;
		}
		
		/**
		 * 
		 */
		public function get ignoreInvisibleChildren():Boolean
		{
			return _ignoreInvisibleChildren;
		}

		/**
		 * @private
		 */
		public function set ignoreInvisibleChildren(value:Boolean):void
		{
			_ignoreInvisibleChildren = value;
		}
		
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
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}

		private function handleChildResize(event:Event):void
		{
			if (debug) logDebug("handleChildResize: " + event.target);
			_liquidBehavior.update();
			layoutChildren();
		}
		
		private function handleAdded(event:Event):void 
		{
			if (DisplayObject(event.target).parent == target)
			{
				DisplayObject(event.target).addEventListener(Event.RESIZE, handleChildResize, false, 0, true);
				layoutChildren();
			}
		}

		private function handleRemoved(event:Event):void 
		{
			if (DisplayObject(event.target).parent == target)
			{
				DisplayObject(event.target).removeEventListener(Event.RESIZE, handleChildResize);
				new FrameDelay(layoutChildren);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (displayObject)
			{
				displayObject.addEventListener(Event.REMOVED, handleRemoved);
				displayObject.addEventListener(Event.ADDED, handleAdded);
			}
			_liquidBehavior = null;
			
			super.destruct();
		}
	}
}
