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

package temple.ui.layout.liquid 
{
	import temple.common.interfaces.IEnableable;
	import temple.core.behaviors.IBehavior;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.display.CoreShape;
	import temple.core.display.ICoreDisplayObject;
	import temple.core.display.StageProvider;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;
	import temple.utils.PropertyApplier;
	import temple.utils.color.ColorUtils;

	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;



	/**
	 * Dispatched when the init() is called, after initialization.
	 * @eventType flash.events.Event.INIT
	 */
	[Event(name = "init", type = "flash.events.Event")]

	/**
	 * Dispatched when the target is resized
	 * @eventType flash.events.Event.RESIZE
	 */
	[Event(name = "resize", type = "flash.events.Event")]

	/**
	 * Class add liquid behavior on a DisplayObject.
	 * LiquidBehavior allows you to align or scale a DisplayObject to an other Object or to the Stage.
	 * 
	 * <p>Set left, right and / or horizontalCenter to align horizontal.</p>
	 * <p>Set top, bottom and / or verticalCenter to align vertizal.</p>
	 * 
	 * <p>Call init() method after setting these values to initialize the behavior.</p>
	 * 
	 * <p>LiquidBehavior extends the AbstractBehavior and is auto-destructed.</p>
	 * 
	 * @includeExample LiquidExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class LiquidBehavior extends AbstractDisplayObjectBehavior implements IEnableable, ILiquidObject, IBehavior, IDebuggable
	{
		private static const _DEBUG_LINE_THICKNESS:Number = 2;
		private static const _DEBUG_CROSS_SIZE:Number = 2 * _DEBUG_LINE_THICKNESS;
		
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the LiquidBehavior of a DisplayObject, if the DisplayObject has LiquidBehavior. Otherwise null is returned.
		 */
		public static function getInstance(target:DisplayObject):LiquidBehavior
		{
			return LiquidBehavior._dictionary[target] as LiquidBehavior;
		}
		
		/**
		 * Updates all LiquidBehaviors
		 */
		public static function updateAll():void
		{
			if (StageProvider.stage)
			{
				StageProvider.stage.dispatchEvent(new Event(Event.RESIZE));
			}
			else
			{
				Log.warn("There is no reference to the Stage, can't do 'updateAll'", LiquidBehavior);
			}
		}
		
		/**
		 * Enable or disable debug on all LiquidBehaviors
		 */
		public static function debugAll(debug:Boolean = true):void
		{
			for each (var liquidBehavior:LiquidBehavior in LiquidBehavior._dictionary) liquidBehavior.debug = debug;
		}

		private var _relatedObject:ILiquidRelatedObject;
		
		private var _left:Number;
		private var _right:Number;
		private var _horizontalCenter:Number;
		private var _relativeX:Number;
		private var _relativeWidth:Number;
		private var _absoluteWidth:Number;
		private var _minimalWidth:Number = 0;
		
		private var _top:Number;
		private var _bottom:Number;
		private var _verticalCenter:Number;
		private var _relativeY:Number;
		private var _relativeHeight:Number;
		private var _absoluteHeight:Number;
		private var _minimalHeight:Number = 0;

		private var _enabled:Boolean;
		private var _snapToPixels:Boolean = true;
		private var _resetScale:Boolean = true;
		private var _adjustRelated:Boolean = false;
		private var _keepAspectRatio:Boolean;
		private var _reUpdatePossible:Boolean = true;
		private var _debug:Boolean;
		private var _debugColor:uint;
		private var _debugShape:CoreShape;
		private var _blockRequest:Boolean;
		private var _allowNegativePosition:Boolean;

		/**
		 * Create the possibility to align or scale an object related to an other object (or stage)
		 * @param target The DisplayObject to be aligned
		 * @param initObject a dynamic object that contains the properties of the behavior
		 * @param relatedObject the (parent) object to align the target to
		 */
		public function LiquidBehavior(target:DisplayObject, initObject:Object = null, relatedObject:ILiquidRelatedObject = null)
		{
			super(target);
			
			if (LiquidBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has LiquidBehavior"));
			LiquidBehavior._dictionary[target] = this;
			
			this._enabled = true;
			
			target.addEventListener(Event.RESIZE, this.handleTargetResize, false, -1);
			
			if (relatedObject)
			{
				this.relatedObject = relatedObject;
			}
			else
			{
				this.relatedObject = this.findLiquidParent(target);
				
				if (this.relatedObject == null && target.stage && (!(target is ICoreDisplayObject) || ICoreDisplayObject(target).onStage))
				{
					// still no related object found, take the stage
					if (LiquidStage.getInstance())
					{
						this.relatedObject = LiquidStage.getInstance();
					}
					else
					{
						// target has a stage, convert it to be liquid and use it.
						new LiquidStage(target.stage);
						this.relatedObject = LiquidStage.getInstance();
					}
				}
			}
			target.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			
			this._debugColor = ColorUtils.getRandomColor();
			
			if (initObject)
			{
				PropertyApplier.apply(this, initObject);
				this.init();
			}
		}
		
		/**
		 * Call this function after all liquid properties have been set to initialize the LiquidBehavior
		 */
		public function init():void
		{
			this.updateRelatedMinimalWidth();
			this.updateRelatedMinimalHeight();
			this.update();
			this.dispatchEvent(new Event(Event.INIT));
		}

		/**
		 * @inheritDoc
		 */
		public function get left():Number
		{
			return this._left;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set left(value:Number):void
		{
			this._left = value;
			this._horizontalCenter = NaN;
			this._relativeX = NaN;
			if (!isNaN(this._right)) this._relativeWidth = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get right():Number
		{
			return this._right;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set right(value:Number):void
		{
			this._right = value;
			this._horizontalCenter = NaN;
			this._relativeX = NaN;
			if (!isNaN(this._left)) this._relativeWidth = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get horizontalCenter():Number
		{
			return this._horizontalCenter;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set horizontalCenter(value:Number):void
		{
			this._horizontalCenter = value;
			this._left = NaN;
			this._right = NaN;
			this._relativeX = NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeX():Number
		{
			return this._relativeX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relativeX(value:Number):void
		{
			if (value < 0 || value > 1) throwError(new TempleArgumentError(this, 'relativeX must be between 0 and 1, (' + value + ')'));
			
			this._relativeX = value;
			this._left = NaN;
			this._right = NaN;
			this._horizontalCenter = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get width():Number
		{
			return isNaN(this._absoluteWidth) ? this.displayObject.width : this._absoluteWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function get relativeWidth():Number 
		{
			return this._relativeWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function set relativeWidth(value:Number):void 
		{
			if (value < 0 || value > 1) throwError(new TempleArgumentError(this, 'relativeWidth must be between 0 and 1, (' + value + ')'));
			this._relativeWidth = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get absoluteWidth():Number 
		{
			return this._absoluteWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function set absoluteWidth(value:Number):void 
		{
			this._absoluteWidth = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get minimalWidth():Number
		{
			return this._minimalWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minimalWidth(value:Number):void
		{
			if (!isNaN(value) && value >= 0)
			{
				this._minimalWidth = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scaleX():Number
		{
			return this.displayObject.scaleX;
		}

		/**
		 * @inheritDoc
		 */
		public function get top():Number
		{
			return this._top;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set top(value:Number):void
		{
			this._top = value;
			this._verticalCenter = NaN;
			this._relativeY = NaN;
			if (!isNaN(this._bottom)) this._relativeHeight = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get bottom():Number
		{
			return this._bottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set bottom(value:Number):void
		{
			this._bottom = value;
			this._verticalCenter = NaN;
			this._relativeY = NaN;
			if (!isNaN(this._top)) this._relativeHeight = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get verticalCenter():Number
		{
			return this._verticalCenter;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set verticalCenter(value:Number):void
		{
			this._verticalCenter = value;
			this._top = NaN;
			this._bottom = NaN;
			this._relativeY = NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeY():Number
		{
			return this._relativeY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relativeY(value:Number):void
		{
			if (value < 0 || value > 1) throwError(new TempleArgumentError(this, 'relativeY must be between 0 and 1, (' + value + ')'));
			
			this._relativeY = value;
			this._top = NaN;
			this._bottom = NaN;
			this._verticalCenter = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get height():Number
		{
			return isNaN(this._absoluteHeight) ? this.displayObject.height : this._absoluteHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeHeight():Number 
		{
			return this._relativeHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function set relativeHeight(value:Number):void 
		{
			if (value < 0 || value > 1) throwError(new TempleArgumentError(this, 'relativehHeigth must be between 0 and 1, (' + value + ')'));
			this._relativeHeight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get absoluteHeight():Number 
		{
			return this._absoluteHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function set absoluteHeight(value:Number):void 
		{
			this._absoluteHeight = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get minimalHeight():Number
		{
			return this._minimalHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minimalHeight(value:Number):void
		{
			if (!isNaN(value) && value >= 0)
			{
				this._minimalHeight = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scaleY():Number
		{
			return this.displayObject.scaleY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relatedObject():ILiquidRelatedObject
		{
			return this._relatedObject;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relatedObject(value:ILiquidRelatedObject):void
		{
			if (value == this) throwError(new TempleArgumentError(this, "relatedObject can not be set to this"));
			
			// if we already had a related object, remove listeners
			if (this._relatedObject)
			{
				this._relatedObject.removeEventListener(Event.RESIZE, this.handleRelatedResize);
			}
			this._relatedObject = value;
			
			if (this._relatedObject)
			{
				this._relatedObject.addEventListener(Event.RESIZE, this.handleRelatedResize, false, -1);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function update():void
		{
			// if behavior is disabled, or we do not have a relatedObject, or we do not have a parent, calculating position is useless 
			if (!this._enabled || !this._relatedObject || !this.displayObject.parent || !this.displayObject.stage || this._blockRequest)
			{
				if (this._debug)
				{
					if (!this._enabled) this.logDebug("update: LiquidBehavior is disabled, won't update");
					else if (!this._relatedObject) this.logDebug("update: LiquidBehavior has no relatedObject, won't update");
					else if (!this.displayObject.parent) this.logDebug("update: displayObject has no parent, won't update");
					else if (!this.displayObject.stage) this.logDebug("update: displayObject has no stage, won't update");
					else this.logDebug("update: can't update");
				}
				return;
			}
			
			if (this._debug) this.logDebug("update: " +
				(!isNaN(this._left) ? "left: " + this._left + ", " : "") +
				(!isNaN(this._right) ? "right: " + this._right + ", " : "") +
				(!isNaN(this._horizontalCenter) ? "horizontalCenter: " + this._horizontalCenter + ", " : "") +
				(!isNaN(this._relativeX) ? "relativeX: " + this._relativeX + ", " : "") +
				(!isNaN(this._relativeWidth) ? "relativeWidth: " + this._relativeWidth + ", " : "") +
				(this._minimalWidth ? "minimalWidth: " + this._minimalWidth + ", " : "") +
				(!isNaN(this._top) ? "top: " + this._top + ", " : "") +
				(!isNaN(this._bottom) ? "bottom: " + this._bottom + ", " : "") +
				(!isNaN(this._verticalCenter) ? "verticalCenter: " + this._verticalCenter + ", " : "") +
				(!isNaN(this._relativeY) ? "relativeY: " + this._relativeY + ", " : "") +
				(!isNaN(this._relativeHeight) ? "relativeHeight: " + this._relativeHeight + ", " : "") +
				(this._minimalHeight ? "minimalHeight: " + this._minimalHeight + ", " : "") + 
				"relatedObject: " + this._relatedObject + ", width: " + this._relatedObject.width + ", height: " + this._relatedObject.height);
			
			this._blockRequest = true;

			var toX:Number;
			var toY:Number;
			var toWidth:Number;
			var toHeight:Number;
			
			if (!isNaN(this._relativeWidth)) toWidth = this._relativeWidth * this._relatedObject.width;
			if (!isNaN(this._relativeHeight)) toHeight = this._relativeHeight * this._relatedObject.height;
			
			var bounds:Rectangle = this.displayObject.getBounds(this.displayObject.parent);
			
			// horitontal
			if (!isNaN(this._relativeX))
			{
				toX = (this._relatedObject.width - (!isNaN(toWidth) ? toWidth : bounds.width)) * this._relativeX;
			}
			else
			{
				if (!isNaN(this._left))
				{
					toX = this._left;
					if (this._resetScale) toX /= this.getRelatedTotalScaleX();
				}
				else if (!isNaN(this._horizontalCenter))
				{
					toX = (this._relatedObject.width / this._relatedObject.scaleX) * .5 + (this._horizontalCenter / this.getRelatedTotalScaleX()) - (!isNaN(toWidth) ? toWidth : bounds.width) * .5;
				}
				
				if (!isNaN(this._right))
				{
					if (isNaN(this._left))
					{
						toX = this._relatedObject.width / this._relatedObject.scaleX - (this._right / this.getRelatedTotalScaleX() + (!isNaN(toWidth) ? toWidth : bounds.width));
					}
					else
					{
						toWidth = (this._relatedObject.width - this._right) - this._left;
					}
				}
			}
			if (isNaN(toWidth) && bounds.width < this._minimalWidth)
			{
				toWidth = this._minimalWidth;
			}
			else if (toWidth < this._minimalWidth) toWidth = this._minimalWidth;
			
			// vertical
			if (!isNaN(this._relativeY))
			{
				toY = (this._relatedObject.height - (!isNaN(toHeight) ? toHeight : bounds.height)) * this._relativeY;
			}
			else
			{
				if (!isNaN(this._top))
				{
					toY = this._top;
					if (this._resetScale) toY /= this.getRelatedTotalScaleY();
				}
				else if (!isNaN(this._verticalCenter))
				{
					toY = (this._relatedObject.height / this._relatedObject.scaleY) * .5 + (this._verticalCenter / this.getRelatedTotalScaleY()) - (!isNaN(toHeight) ? toHeight : bounds.height) * .5;
				}
				if (!isNaN(this._bottom))
				{
					if (isNaN(this._top))
					{
						if (this._resetScale)
						{
							toY = this._relatedObject.height / this._relatedObject.scaleY - (this._bottom / this.getRelatedTotalScaleY() + (!isNaN(toHeight) ? toHeight : bounds.height));
						}
						else
						{
							toY = this._relatedObject.height - this._bottom - (!isNaN(toHeight) ? toHeight : bounds.height);
							if (this._resetScale) toY /= this.getRelatedTotalScaleY();
						}
					}
					else
					{
						toHeight = (this._relatedObject.height - this._bottom) - this._top;
					}
				}
			}
			if (isNaN(toHeight) && bounds.height < this._minimalHeight)
			{
				toHeight = this._minimalHeight;
			}
			else if (toHeight < this._minimalHeight) toHeight = this._minimalHeight;
			
			if (toWidth || toHeight || !isNaN(toX) || !isNaN(toY))
			{
				if (this._debug) this.logDebug("update to: width: " + toWidth + ", height: " + toHeight + ", x: " + toX + ", y: " + toY);
				
				var resized:Boolean;
				
				if (!this._allowNegativePosition)
				{
					if (!isNaN(toX) && toX < 0)
					{
						toX = 0;
					}
					if (!isNaN(toY) && toY < 0)
					{
						toY = 0;
					}
				}
				
				if (!isNaN(toWidth))
				{
					if (this.displayObject.rotation == 0)
					{
						if (this._resetScale) toWidth /= this.getRelatedTotalScaleX();
						if (this._snapToPixels) toWidth = Math.round(toWidth);
						// do not set width to 0, this will cause weird behavior. So make it at least 1
						if (toWidth < 1) toWidth = 1;
						
						// do not set width if displayObject does not have a width
						if ((this.displayObject.width || this.displayObject is ILiquidObject) && this.displayObject.width != toWidth)
						{
							this.displayObject.width = toWidth;
							resized = true;
						}
					}
					else
					{
						this.logWarn("You should not change dimensions on rotated objects! Width is not changed.");
					}
				}
				else if (this._resetScale && this.displayObject.width)
				{
					var relatedScaleX:Number = this.getRelatedTotalScaleX();
					if (this.displayObject.scaleX != 1 / relatedScaleX)
					{
						this.displayObject.scaleX = 1 / relatedScaleX;
						resized = true;
					}
				}
				
				if (!isNaN(toHeight))
				{
					if (this.displayObject.rotation == 0)
					{
						if (this._resetScale) toHeight /= this.getRelatedTotalScaleY();
						if (this._snapToPixels) toHeight = Math.round(toHeight);
						// do not set height to 0, this will cause weird behavior. So make it at least 1
						if (toHeight < 1) toHeight = 1;
						
						// do not set height if displayObject does not have a height
						if ((this.displayObject.height || this.displayObject is ILiquidObject) && this.displayObject.height != toHeight)
						{
							this.displayObject.height = toHeight;
							resized = true;
						}
					}
					else
					{
						this.logWarn("You should not change dimensions on rotated objects! Height is not changed");
					}
				}
				else if (this._resetScale && this.displayObject.height)
				{
					var relatedScaleY:Number = this.getRelatedTotalScaleY();
					if (this.displayObject.scaleY != 1 / relatedScaleY)
					{
						this.displayObject.scaleY = 1 / relatedScaleY;
						resized = true;
					}
				}
				
				if (!isNaN(toX) || !isNaN(toY))
				{
					var offset:Point;
					var relatedOffset:Point = this.relatedObject.offset || new Point(0, 0);
					
					if (this.displayObject.rotation == 0)
					{
						offset = new Point(0,0);
					}
					else
					{
						offset = bounds.topLeft;
						offset.x -= this.displayObject.x;
						offset.y -= this.displayObject.y;
					}
					
					offset = this.relatedObject.displayObject.globalToLocal(this.displayObject.parent.localToGlobal(offset));
					
					if (!isNaN(toX))
					{
						this.displayObject.x = (this._snapToPixels ? Math.round(toX - offset.x) : toX - offset.x) + relatedOffset.x;
					}
					
					if (!isNaN(toY))
					{
						this.displayObject.y = (this._snapToPixels ? Math.round(toY - offset.y) : toY - offset.y) + relatedOffset.x;
					}
				}
				
				if (this._keepAspectRatio && this.scaleX != this.scaleY && this._reUpdatePossible)
				{
					this._reUpdatePossible = false;
					
					if (!isNaN(this._top) && !isNaN(this._bottom))
					{
						this.displayObject.scaleX = this.scaleY;
						this._reUpdatePossible = true;
					}
					else if (!isNaN(this._left) && !isNaN(this._right))
					{
						this.displayObject.scaleY = this.scaleX;
						this._reUpdatePossible = true;
					}
					
					if (this._reUpdatePossible)
					{
						this._reUpdatePossible = false;
						this.update();
					}
					this._reUpdatePossible = true;
				}
				
				if (resized)
				{
					this.displayObject.dispatchEvent(new Event(Event.RESIZE));
				}
			}
			this._blockRequest = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLiquid():Boolean
		{
			return 	!isNaN(this._left) || 
					!isNaN(this._right) || 
					!isNaN(this._horizontalCenter) ||
					!isNaN(this._relativeX) ||
					!isNaN(this._relativeWidth) ||
					!isNaN(this._minimalWidth) ||
					
					!isNaN(this._top) || 
					!isNaN(this._bottom) || 
					!isNaN(this._verticalCenter);
					!isNaN(this._relativeY);
					!isNaN(this._relativeHeight);
					!isNaN(this._minimalHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get resetRelatedScale():Boolean
		{
			return this._resetScale;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set resetRelatedScale(value:Boolean):void
		{
			this._resetScale = value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get offset():Point
		{
			return this.displayObject.getBounds(this.displayObject).topLeft;
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
			if (this._enabled == value) return;
			
			this._enabled = value;
			
			if (value)
			{
				if (this._relatedObject)
				{
					// Set the scale handler
					this._relatedObject.addEventListener(Event.RESIZE, this.handleRelatedResize, false, -1);
					
					// immediatly update the view.
					this.update();
				}
			}
			else
			{
				// remove the eventlisteners.
				if (this._relatedObject) this._relatedObject.removeEventListener(Event.RESIZE, this.handleRelatedResize);
				
				if (this._debugShape)
				{
					this._debugShape.destruct();
					this._debugShape = null;
				}
			}
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
		 * @inheritDoc
		 */
		public function get keepAspectRatio():Boolean
		{
			return this._keepAspectRatio;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set keepAspectRatio(value:Boolean):void
		{
			this._keepAspectRatio = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get adjustRelated():Boolean
		{
			return this._adjustRelated;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set adjustRelated(value:Boolean):void
		{
			this._adjustRelated = value;
		}
		
		/**
		 * A Boolean which indicates if a negative value for x and y is allowed.
		 * @default false
		 */
		public function get allowNegativePosition():Boolean
		{
			return this._allowNegativePosition;
		}
		
		/**
		 * @private
		 */
		public function set allowNegativePosition(value:Boolean):void
		{
			this._allowNegativePosition = value;
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
			
			if (this._debug)
			{
				this.displayObject.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame, false, int.MIN_VALUE);
			}
			else
			{
				this.displayObject.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				if (this._debugShape)
				{
					this._debugShape.destruct();
					this._debugShape = null;
				}
			}
			
		}
		
		/**
		 * Color of the debug squares
		 */
		public function get debugColor():uint
		{
			return this._debugColor;
		}
		
		/**
		 * @private
		 */
		public function set debugColor(value:uint):void
		{
			this._debugColor = value;
		}

		private function handleAddedToStage(event:Event):void
		{
			if (!this.relatedObject)
			{
				this.relatedObject = this.findLiquidParent(this.displayObject);
				
				if (!this.relatedObject)
				{
					if (LiquidStage.getInstance())
					{
						this.relatedObject = LiquidStage.getInstance();
					}
					else
					{
						this.relatedObject = new LiquidStage(this.displayObject.stage);
					}
				}
			}
			this.update();
		}

		private function handleRelatedResize(event:Event):void
		{
			this.update();
		}
		
		private function handleTargetResize(event:Event):void
		{
			if (this._blockRequest)
			{
				this.dispatchEvent(event.clone());
			}
			else
			{
				this.update();
			}
		}

		/**
		 * Calculates the minimal width and to set on the related object
		 */
		private function updateRelatedMinimalWidth():void
		{
			if (this._relatedObject && this._adjustRelated)
			{
				var minimalWidth:Number;
				if (!isNaN(this._left) && !isNaN(this._right))
				{
					minimalWidth = this._left + this._right + this._minimalWidth;
				}
				else
				{
					minimalWidth = this.displayObject.width;
					
					if (!isNaN(this._left)) minimalWidth += this._left;
					if (!isNaN(this._right)) minimalWidth += this._right;
				}
				
				if (!isNaN(minimalWidth) && (isNaN(this._relatedObject.minimalWidth) || this._relatedObject.minimalWidth < minimalWidth))
				{
					this._relatedObject.minimalWidth = minimalWidth;
				}
			}
		}

		/**
		 * Calculates the minimal height and to set on the related object
		 */
		private function updateRelatedMinimalHeight():void
		{
			if (this._relatedObject && this._adjustRelated)
			{
				var minimalHeight:Number;
				if (!isNaN(this._top) && !isNaN(this._bottom))
				{
					minimalHeight = this._top + this._bottom + this._minimalHeight;
				}
				else
				{
					minimalHeight = this.displayObject.height;
					
					if (!isNaN(this._top)) minimalHeight += this._top;
					if (!isNaN(this._bottom)) minimalHeight += this._bottom;
				}
				if (!isNaN(minimalHeight) && (isNaN(this._relatedObject.minimalHeight) || this._relatedObject.minimalHeight < minimalHeight))
				{
					this._relatedObject.minimalHeight = minimalHeight;
				}
			}
		}

		/**
		 * Calculates the total scaleX of all related objects
		 */
		private function getRelatedTotalScaleX():Number
		{
			var scale:Number = 1;
			var related:ILiquidRelatedObject = this._relatedObject;
			while (related != null)
			{
				scale *= related.scaleX;
				related = related.relatedObject && related.resetRelatedScale ? related.relatedObject : null;
			}
			return scale;
		}

		/**
		 * Calculates the total scaley of all related objects
		 */
		private function getRelatedTotalScaleY():Number
		{
			var scale:Number = 1;
			var related:ILiquidRelatedObject = this._relatedObject;
			while (related != null)
			{
				scale *= related.scaleY;
				related = related.relatedObject && related.resetRelatedScale ? related.relatedObject : null;
			}
			return scale;
		}
		
		/**
		 * Searches in the display list for a parent with LiquidBehavior
		 */
		private function findLiquidParent(displayObject:DisplayObject):ILiquidRelatedObject
		{
			if (!displayObject || !displayObject.parent) return null;
			if (displayObject.parent is ILiquidRelatedObject) return displayObject.parent as ILiquidRelatedObject;
			var liquid:LiquidBehavior = LiquidBehavior.getInstance(displayObject.parent);
			if (liquid) return liquid;
			return this.findLiquidParent(displayObject.parent);
		}
		
		private function handleEnterFrame(event:Event):void
		{
			this.drawBounce();
		}

		/**
		 * Draws on the stage a rectange on the same size and position of the bounce of the object
		 */
		private function drawBounce():void
		{
			if (!this.displayObject.stage || !this.displayObject.parent || this.displayObject is ICoreDisplayObject && !(this.displayObject as ICoreDisplayObject).onStage || !this.isDeepVisible(this.displayObject))
			{
				if (this._debugShape)
				{
					this._debugShape.destruct();
					this._debugShape = null;
				}
				return;
			}
			
			if (!this._debugShape)
			{
				this._debugShape = new CoreShape("DebugShape: " + this.toString());
				this.displayObject.stage.addChild(this._debugShape);
			}
			var offset:Point = this.displayObject.getRect(this.displayObject).topLeft;
			offset.x += this.displayObject.x;
			offset.y += this.displayObject.y;
			
			var point:Point = this.displayObject.parent.localToGlobal(offset);
			
			var bounds:Rectangle;
			
			if (this.displayObject.rotation == 0)
			{
				bounds = new Rectangle(point.x, point.y, this.displayObject.width, this.displayObject.height);
			}
			else
			{
				bounds = this.displayObject.getBounds(this.displayObject.stage);
			}
			
			// draw square for boundries
			this._debugShape.graphics.clear();
			this._debugShape.graphics.lineStyle(_DEBUG_LINE_THICKNESS, this._debugColor, .3, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
			this._debugShape.graphics.drawRect(bounds.topLeft.x + _DEBUG_LINE_THICKNESS * .5, bounds.topLeft.y + _DEBUG_LINE_THICKNESS * .5, bounds.width - _DEBUG_LINE_THICKNESS * .5, bounds.height - _DEBUG_LINE_THICKNESS * .5);
			
			// Draw cross on 0,0 point
			this._debugShape.graphics.lineStyle(1, this._debugColor, 1);
			this._debugShape.graphics.moveTo(point.x - _DEBUG_CROSS_SIZE, point.y - _DEBUG_CROSS_SIZE);
			this._debugShape.graphics.lineTo(point.x + _DEBUG_CROSS_SIZE, point.y + _DEBUG_CROSS_SIZE);
			this._debugShape.graphics.moveTo(point.x + _DEBUG_CROSS_SIZE, point.y - _DEBUG_CROSS_SIZE);
			this._debugShape.graphics.lineTo(point.x - _DEBUG_CROSS_SIZE, point.y + _DEBUG_CROSS_SIZE);
		}

		private function isDeepVisible(displayObject:DisplayObject):Boolean 
		{
			if (!displayObject.visible)
			{
				return false;
			}
			else if (!displayObject.parent)
			{
				return true;
			}
			else
			{
				return this.isDeepVisible(displayObject.parent);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._relatedObject)
			{
				this._relatedObject.removeEventListener(Event.RESIZE, this.handleRelatedResize);
				this._relatedObject = null;
			}
			if (this.target)
			{
				delete LiquidBehavior._dictionary[this.target];
				this.displayObject.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this.displayObject.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			}
			if (this._debugShape)
			{
				this._debugShape.destruct();
				this._debugShape = null;
			}
			super.destruct();
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(LiquidBehavior);
		}
	}
}