/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
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
			this._block = true;
			
			super(target);
			
			if (LayoutBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has LayoutBehavior"));
			LayoutBehavior._dictionary[target] = this;

			this._liquidBehavior = LiquidBehavior.getInstance(target) || new LiquidBehavior(target);
			
			this.orientation = orientation;
			this.direction = direction;
			this.spacing = spacing;
			this._overwriteDimensions = overwriteDimensions;
			this._enabled = enabled;
			
			var leni:int = target.numChildren;
			for (var i:int = 0; i < leni; i++)
			{
				target.getChildAt(i).addEventListener(Event.RESIZE, this.handleChildResize, false, 0, true);
			}
			
			target.addEventListener(Event.ADDED, this.handleAdded);
			target.addEventListener(Event.REMOVED, this.handleRemoved);
			
			addToDebugManager(this);
			
			this._block = false;
			this.layoutChildren();
		}

		/**
		 * Returns a reference to the DisplayObjectContainer. Same value as target, but typed as DisplayObjectContainer.
		 */
		public function get displayObjectContainer():DisplayObjectContainer 
		{
			return this.target as DisplayObjectContainer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get orientation():String
		{
			return this._orientation;
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
					if (this._orientation != value)
					{
						this._orientation = value;
						this.layoutChildren();
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
			return this._direction;
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
					if (this._direction != value)
					{
						this._direction = value;
						this.layoutChildren();
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
			return this._spacing;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set spacing(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "spacing can not be set to NaN"));
			this._spacing = value;
			this.layoutChildren();
		}
		
		/**
		 * If set to true (default) the LayoutBehaviors controls the dimension of the target.
		 */
		public function get overwriteDimensions():Boolean
		{
			return this._overwriteDimensions;
		}
		
		/**
		 * @private
		 */
		public function set overwriteDimensions(value:Boolean):void
		{
			this._overwriteDimensions = value;
		}
		
		/**
		 * Distributes all children of the target corresponding to the orientation, direction and spacing.
		 */
		public function layoutChildren():void
		{
			if (this._block || !this._enabled || this.isDestructed) return;
			
			if (this.debug) this.logDebug("layoutChildren: orientation=" + this.orientation + ", direction=" + this.direction + ", numChildren=" + this.displayObjectContainer.numChildren);
			
			var liquid:LiquidBehavior;
			var child:DisplayObject;
			var offset:Number = 0;
			var leni:int = this.displayObjectContainer.numChildren;
			for (var i:int = 0; i < leni; i++)
			{
				child = this.displayObjectContainer.getChildAt(i);
				
				if (this._ignoreInvisibleChildren && !child.visible) continue;
				
				liquid = LiquidBehavior.getInstance(child) || new LiquidBehavior(child, this._liquidBehavior);
				
				liquid.relatedObject = this._liquidBehavior;
				
				if (i) offset += this._spacing;
				
				if (this._snapToPixels) offset = Math.round(offset);
				
				if (this.debug) this.logDebug("layout: offset=" + offset + ", Child=" + child);
				
				switch (this._orientation)
				{
					case Orientation.HORIZONTAL:
					{
						switch (this._direction)
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
						switch (this._direction)
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
			if (this._overwriteDimensions)// && this._direction == Direction.DESCENDING)
			{
				if (this._snapToPixels) offset = Math.round(offset);
				switch (this._orientation)
				{
					case Orientation.HORIZONTAL:
					{
						this._liquidBehavior.absoluteWidth = offset;
						if (this.displayObject.width != offset && this.target is ILayoutContainer) this.displayObject.width = offset;
						break;
					}
					case Orientation.VERTICAL:
					{
						this._liquidBehavior.absoluteHeight = offset;
						if (this.displayObject.height != offset && this.target is ILayoutContainer) this.displayObject.height = offset;
						break;
					}
				}
			}
			this._liquidBehavior.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean
		{
			return this._enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			this._enabled = value;
			if (this._enabled) this.layoutChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			this.enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			this.enabled = false;
		}
		
		/**
		 * If set to true al values will be rounded
		 */
		public function get snapToPixels():Boolean
		{
			return this._snapToPixels;
		}

		/**
		 * @private
		 */
		public function set snapToPixels(value:Boolean):void
		{
			this._snapToPixels = value;
		}
		
		/**
		 * 
		 */
		public function get ignoreInvisibleChildren():Boolean
		{
			return this._ignoreInvisibleChildren;
		}

		/**
		 * @private
		 */
		public function set ignoreInvisibleChildren(value:Boolean):void
		{
			this._ignoreInvisibleChildren = value;
		}
		
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
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		private function handleChildResize(event:Event):void
		{
			if (this.debug) this.logDebug("handleChildResize: " + event.target);
			this._liquidBehavior.update();
			this.layoutChildren();
		}
		
		private function handleAdded(event:Event):void 
		{
			if (DisplayObject(event.target).parent == this.target)
			{
				DisplayObject(event.target).addEventListener(Event.RESIZE, this.handleChildResize, false, 0, true);
				this.layoutChildren();
			}
		}

		private function handleRemoved(event:Event):void 
		{
			if (DisplayObject(event.target).parent == this.target)
			{
				DisplayObject(event.target).removeEventListener(Event.RESIZE, this.handleChildResize);
				new FrameDelay(this.layoutChildren);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if (this.displayObject)
			{
				this.displayObject.addEventListener(Event.REMOVED, this.handleRemoved);
				this.displayObject.addEventListener(Event.ADDED, this.handleAdded);
			}
			this._liquidBehavior = null;
			
			super.destruct();
		}
	}
}
