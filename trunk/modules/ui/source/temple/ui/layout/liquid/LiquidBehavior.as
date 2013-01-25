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
	import temple.common.enum.Align;
	import temple.common.enum.ScaleMode;
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
		private var _resetScale:Boolean;
		private var _adjustRelated:Boolean;
		private var _keepAspectRatio:Boolean;
		private var _reUpdatePossible:Boolean = true;
		private var _debug:Boolean;
		private var _debugColor:uint;
		private var _debugShape:CoreShape;
		private var _blockRequest:Boolean;
		private var _allowNegativePosition:Boolean;
		private var _useScale:Boolean;
		private var _scaleMode:String;
		private var _align:String;

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
			
			_enabled = true;
			
			target.addEventListener(Event.RESIZE, handleTargetResize, false, -1);
			
			if (relatedObject)
			{
				this.relatedObject = relatedObject;
			}
			else
			{
				this.relatedObject = findLiquidParent(target);
				
				if (this.relatedObject == null && target.stage && (!(target is ICoreDisplayObject) || ICoreDisplayObject(target).onStage))
				{
					// still no related object found, take the stage
					this.relatedObject = LiquidStage.getInstance(target.stage);
				}
			}
			target.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			_debugColor = ColorUtils.getRandomColor();
			
			if (initObject)
			{
				PropertyApplier.apply(this, initObject);
				init();
			}
		}
		
		/**
		 * Call this function after all liquid properties have been set to initialize the LiquidBehavior
		 */
		public function init():void
		{
			updateRelatedMinimalWidth();
			updateRelatedMinimalHeight();
			update();
			dispatchEvent(new Event(Event.INIT));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get left():Number
		{
			return _left;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set left(value:Number):void
		{
			_left = value;
			_horizontalCenter = NaN;
			_relativeX = NaN;
			if (!isNaN(_right)) _relativeWidth = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get right():Number
		{
			return _right;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set right(value:Number):void
		{
			_right = value;
			_horizontalCenter = NaN;
			_relativeX = NaN;
			if (!isNaN(_left)) _relativeWidth = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set horizontalCenter(value:Number):void
		{
			_horizontalCenter = value;
			_left = NaN;
			_right = NaN;
			_relativeX = NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeX():Number
		{
			return _relativeX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relativeX(value:Number):void
		{
			if (value < 0 || value > 1) throwError(new TempleArgumentError(this, 'relativeX must be between 0 and 1, (' + value + ')'));
			
			_relativeX = value;
			_left = NaN;
			_right = NaN;
			_horizontalCenter = NaN;
		}
		
		/**
		 * @private
		 */
		public function get x():Number
		{
			return displayObject.x;
		}

		/**
		 * @inheritDoc
		 */
		public function get width():Number
		{
			return isNaN(_absoluteWidth) ? displayObject.width : _absoluteWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function get relativeWidth():Number 
		{
			return _relativeWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function set relativeWidth(value:Number):void 
		{
			if (value < 0 || value > 1) throwError(new TempleArgumentError(this, 'relativeWidth must be between 0 and 1, (' + value + ')'));
			_relativeWidth = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get absoluteWidth():Number 
		{
			return _absoluteWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function set absoluteWidth(value:Number):void 
		{
			_absoluteWidth = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get minimalWidth():Number
		{
			return _minimalWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minimalWidth(value:Number):void
		{
			if (!isNaN(value) && value >= 0)
			{
				_minimalWidth = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scaleX():Number
		{
			return displayObject.scaleX;
		}

		/**
		 * @inheritDoc
		 */
		public function get top():Number
		{
			return _top;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set top(value:Number):void
		{
			_top = value;
			_verticalCenter = NaN;
			_relativeY = NaN;
			if (!isNaN(_bottom)) _relativeHeight = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get bottom():Number
		{
			return _bottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set bottom(value:Number):void
		{
			_bottom = value;
			_verticalCenter = NaN;
			_relativeY = NaN;
			if (!isNaN(_top)) _relativeHeight = NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set verticalCenter(value:Number):void
		{
			_verticalCenter = value;
			_top = NaN;
			_bottom = NaN;
			_relativeY = NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeY():Number
		{
			return _relativeY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relativeY(value:Number):void
		{
			if (value < 0 || value > 1) throwError(new TempleArgumentError(this, 'relativeY must be between 0 and 1, (' + value + ')'));
			
			_relativeY = value;
			_top = NaN;
			_bottom = NaN;
			_verticalCenter = NaN;
		}
		
		/**
		 * @private
		 */
		public function get y():Number
		{
			return displayObject.y;
		}

		/**
		 * @inheritDoc
		 */
		public function get height():Number
		{
			return isNaN(_absoluteHeight) ? displayObject.height : _absoluteHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relativeHeight():Number 
		{
			return _relativeHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function set relativeHeight(value:Number):void 
		{
			if (value < 0 || value > 1) throwError(new TempleArgumentError(this, 'relativehHeigth must be between 0 and 1, (' + value + ')'));
			_relativeHeight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get absoluteHeight():Number 
		{
			return _absoluteHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function set absoluteHeight(value:Number):void 
		{
			_absoluteHeight = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get minimalHeight():Number
		{
			return _minimalHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minimalHeight(value:Number):void
		{
			if (!isNaN(value) && value >= 0)
			{
				_minimalHeight = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scaleY():Number
		{
			return displayObject.scaleY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get relatedObject():ILiquidRelatedObject
		{
			return _relatedObject;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set relatedObject(value:ILiquidRelatedObject):void
		{
			if (value == this) throwError(new TempleArgumentError(this, "relatedObject can not be set to this"));
			
			// if we already had a related object, remove listeners
			if (_relatedObject)
			{
				_relatedObject.removeEventListener(Event.RESIZE, handleRelatedResize);
			}
			_relatedObject = value;
			
			if (_relatedObject)
			{
				_relatedObject.addEventListener(Event.RESIZE, handleRelatedResize, false, -1);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function update():void
		{
			var displayObject:DisplayObject = this.displayObject;
			
			// if behavior is disabled, or we do not have a relatedObject, or we do not have a parent, calculating position is useless 
			if (!_enabled || !_relatedObject || !displayObject.parent || !displayObject.stage || _blockRequest)
			{
				if (_debug)
				{
					if (!_enabled) logDebug("update: LiquidBehavior is disabled, won't update");
					else if (!_relatedObject) logDebug("update: LiquidBehavior has no relatedObject, won't update");
					else if (!displayObject.parent) logDebug("update: displayObject has no parent, won't update");
					else if (!displayObject.stage) logDebug("update: displayObject has no stage, won't update");
					else logDebug("update: can't update");
				}
				return;
			}
			
			if (_debug) logDebug("update: " +
				(!isNaN(_left) ? "left: " + _left + ", " : "") +
				(!isNaN(_right) ? "right: " + _right + ", " : "") +
				(!isNaN(_horizontalCenter) ? "horizontalCenter: " + _horizontalCenter + ", " : "") +
				(!isNaN(_relativeX) ? "relativeX: " + _relativeX + ", " : "") +
				(!isNaN(_relativeWidth) ? "relativeWidth: " + _relativeWidth + ", " : "") +
				(_minimalWidth ? "minimalWidth: " + _minimalWidth + ", " : "") +
				(!isNaN(_top) ? "top: " + _top + ", " : "") +
				(!isNaN(_bottom) ? "bottom: " + _bottom + ", " : "") +
				(!isNaN(_verticalCenter) ? "verticalCenter: " + _verticalCenter + ", " : "") +
				(!isNaN(_relativeY) ? "relativeY: " + _relativeY + ", " : "") +
				(!isNaN(_relativeHeight) ? "relativeHeight: " + _relativeHeight + ", " : "") +
				(_minimalHeight ? "minimalHeight: " + _minimalHeight + ", " : "") + 
				"relatedObject: " + _relatedObject + ", width: " + _relatedObject.width + ", height: " + _relatedObject.height);
			
			_blockRequest = true;

			var toX:Number;
			var toY:Number;
			var toWidth:Number;
			var toHeight:Number;
			
			if (!isNaN(_relativeWidth)) toWidth = _relativeWidth * _relatedObject.width;
			if (!isNaN(_relativeHeight)) toHeight = _relativeHeight * _relatedObject.height;
			
			var bounds:Rectangle = displayObject.getBounds(displayObject.parent);
			
			// horitontal
			if (!isNaN(_relativeX))
			{
				toX = (_relatedObject.width - (!isNaN(toWidth) ? toWidth : bounds.width)) * _relativeX;
			}
			else
			{
				if (!isNaN(_left))
				{
					toX = _left;
					if (_resetScale) toX /= getRelatedTotalScaleX();
				}
				else if (!isNaN(_horizontalCenter))
				{
					toX = (_relatedObject.width / _relatedObject.scaleX) * .5 + (_horizontalCenter / getRelatedTotalScaleX()) - (!isNaN(toWidth) ? toWidth : bounds.width) * .5;
				}
				
				if (!isNaN(_right))
				{
					if (isNaN(_left))
					{
						toX = _relatedObject.width / _relatedObject.scaleX - (_right / getRelatedTotalScaleX() + (!isNaN(toWidth) ? toWidth : bounds.width));
					}
					else
					{
						toWidth = (_relatedObject.width - _right) - _left;
					}
				}
			}
			if (isNaN(toWidth) && bounds.width < _minimalWidth)
			{
				toWidth = _minimalWidth;
			}
			else if (toWidth < _minimalWidth) toWidth = _minimalWidth;
			
			// vertical
			if (!isNaN(_relativeY))
			{
				toY = (_relatedObject.height - (!isNaN(toHeight) ? toHeight : bounds.height)) * _relativeY;
			}
			else
			{
				if (!isNaN(_top))
				{
					toY = _top;
					if (_resetScale) toY /= getRelatedTotalScaleY();
				}
				else if (!isNaN(_verticalCenter))
				{
					toY = (_relatedObject.height / _relatedObject.scaleY) * .5 + (_verticalCenter / getRelatedTotalScaleY()) - (!isNaN(toHeight) ? toHeight : bounds.height) * .5;
				}
				if (!isNaN(_bottom))
				{
					if (isNaN(_top))
					{
						if (_resetScale)
						{
							toY = _relatedObject.height / _relatedObject.scaleY - (_bottom / getRelatedTotalScaleY() + (!isNaN(toHeight) ? toHeight : bounds.height));
						}
						else
						{
							toY = _relatedObject.height - _bottom - (!isNaN(toHeight) ? toHeight : bounds.height);
							if (_resetScale) toY /= getRelatedTotalScaleY();
						}
					}
					else
					{
						toHeight = (_relatedObject.height - _bottom) - _top;
					}
				}
			}
			if (isNaN(toHeight) && bounds.height < _minimalHeight)
			{
				toHeight = _minimalHeight;
			}
			else if (toHeight < _minimalHeight) toHeight = _minimalHeight;
			
			if (toWidth || toHeight || !isNaN(toX) || !isNaN(toY))
			{
				if (_debug) logDebug("update to: width: " + toWidth + ", height: " + toHeight + ", x: " + toX + ", y: " + toY);
				
				var resized:Boolean;
				
				if (!_allowNegativePosition)
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
					if (displayObject.rotation == 0)
					{
						if (_resetScale) toWidth /= getRelatedTotalScaleX();
						if (_snapToPixels) toWidth = Math.round(toWidth);
						// do not set width to 0, this will cause weird behavior. So make it at least 1
						if (toWidth < 1) toWidth = 1;
						
						// do not set width if displayObject does not have a width
						if ((displayObject.width || displayObject is ILiquidObject) && displayObject.width != toWidth)
						{
							if (_useScale)
							{
								displayObject.scaleX *= toWidth / displayObject.width;
							}
							else
							{
								displayObject.width = toWidth;
							}
							resized = true;
						}
					}
					else
					{
						logWarn("You should not change dimensions on rotated objects! Width is not changed.");
					}
				}
				else if (_resetScale && displayObject.width)
				{
					var relatedScaleX:Number = getRelatedTotalScaleX();
					if (displayObject.scaleX != 1 / relatedScaleX)
					{
						displayObject.scaleX = 1 / relatedScaleX;
						resized = true;
					}
				}
				
				if (!isNaN(toHeight))
				{
					if (displayObject.rotation == 0)
					{
						if (_resetScale) toHeight /= getRelatedTotalScaleY();
						if (_snapToPixels) toHeight = Math.round(toHeight);
						// do not set height to 0, this will cause weird behavior. So make it at least 1
						if (toHeight < 1) toHeight = 1;
						
						// do not set height if displayObject does not have a height
						if ((displayObject.height || displayObject is ILiquidObject) && displayObject.height != toHeight)
						{
							if (_useScale)
							{
								displayObject.scaleY *= toHeight / displayObject.height;
							}
							else
							{
								displayObject.height = toHeight;
							}
							resized = true;
						}
					}
					else
					{
						logWarn("You should not change dimensions on rotated objects! Height is not changed");
					}
				}
				else if (_resetScale && displayObject.height)
				{
					var relatedScaleY:Number = getRelatedTotalScaleY();
					if (displayObject.scaleY != 1 / relatedScaleY)
					{
						displayObject.scaleY = 1 / relatedScaleY;
						resized = true;
					}
				}
				
				if (!isNaN(toX) || !isNaN(toY))
				{
					var offset:Point;
					var relatedOffset:Point = relatedObject.offset || new Point(0, 0);
					
					if (displayObject.rotation == 0)
					{
						offset = new Point(0,0);
					}
					else
					{
						offset = bounds.topLeft;
						offset.x -= displayObject.x;
						offset.y -= displayObject.y;
					}
					
					offset = relatedObject.displayObject.globalToLocal(displayObject.parent.localToGlobal(offset));
					
					if (!isNaN(toX))
					{
						displayObject.x = (_snapToPixels ? Math.round(toX - offset.x) : toX - offset.x) + relatedOffset.x;
					}
					
					if (!isNaN(toY))
					{
						displayObject.y = (_snapToPixels ? Math.round(toY - offset.y) : toY - offset.y) + relatedOffset.x;
					}
				}
				
				if (_keepAspectRatio && scaleX != scaleY && _reUpdatePossible)
				{
					_reUpdatePossible = false;
					
					if (!isNaN(_top) && !isNaN(_bottom))
					{
						displayObject.scaleX = scaleY;
						_reUpdatePossible = true;
					}
					else if (!isNaN(_left) && !isNaN(_right))
					{
						displayObject.scaleY = scaleX;
						_reUpdatePossible = true;
					}
					
					if (_reUpdatePossible)
					{
						_reUpdatePossible = false;
						update();
						resized = true;
					}
					_reUpdatePossible = true;
				}
				
				if (resized)
				{
					displayObject.dispatchEvent(new Event(Event.RESIZE));
				}
				
				if (_scaleMode && _scaleMode != ScaleMode.EXACT_FIT)
				{
					switch (_scaleMode)
					{
						case ScaleMode.NO_BORDER:
						{
							displayObject.scaleX = displayObject.scaleY = Math.max(displayObject.scaleX, displayObject.scaleY);
							break;
						}
						case ScaleMode.SHOW_ALL:
						{
							displayObject.scaleX = displayObject.scaleY = Math.min(displayObject.scaleX, displayObject.scaleY);
							break;
						}
						case ScaleMode.NO_SCALE:
						{
							displayObject.scaleX = displayObject.scaleY = 1;
							break;
						}
						default:
						{
							throwError(new TempleError(this, "Unhandled value for scaleMode: '" + _scaleMode + "'"));
							break;
						}
					}
					// Align horizontal
					switch (_align)
					{
						case Align.LEFT:
						case Align.BOTTOM_LEFT:
						case Align.TOP_LEFT:
						{
							// do nothing
							break;
						}
						case Align.BOTTOM:
						case Align.CENTER:
						case Align.MIDDLE:
						case Align.TOP:
						case null:
						{
							displayObject.x += .5 * (toWidth - displayObject.width);
							break;
						}
						case Align.RIGHT:
						case Align.BOTTOM_RIGHT:
						case Align.TOP_RIGHT:
						{
							displayObject.x += toWidth - displayObject.width;
							break;
						}
					}
					// Align vertizal
					switch (_align)
					{
						case Align.TOP:
						case Align.TOP_LEFT:
						case Align.TOP_RIGHT:
						{
							// do nothing
							break;
						}
						case Align.LEFT:
						case Align.CENTER:
						case Align.MIDDLE:
						case Align.RIGHT:
						case null:
						{
							displayObject.y += .5 * (toHeight - displayObject.height);
							break;
						}
						case Align.BOTTOM:
						case Align.BOTTOM_LEFT:
						case Align.BOTTOM_RIGHT:
						{
							displayObject.y += toHeight - displayObject.height;
							break;
						}
					}
				}
			}
			_blockRequest = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLiquid():Boolean
		{
			return 	!isNaN(_left) || 
					!isNaN(_right) || 
					!isNaN(_horizontalCenter) ||
					!isNaN(_relativeX) ||
					!isNaN(_relativeWidth) ||
					!isNaN(_minimalWidth) ||
					
					!isNaN(_top) || 
					!isNaN(_bottom) || 
					!isNaN(_verticalCenter) ||
					!isNaN(_relativeY) ||
					!isNaN(_relativeHeight) ||
					!isNaN(_minimalHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get resetRelatedScale():Boolean
		{
			return _resetScale;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set resetRelatedScale(value:Boolean):void
		{
			_resetScale = value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get offset():Point
		{
			return displayObject.getBounds(displayObject).topLeft;
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
			if (_enabled == value) return;
			
			_enabled = value;
			
			if (value)
			{
				if (_relatedObject)
				{
					// Set the scale handler
					_relatedObject.addEventListener(Event.RESIZE, handleRelatedResize, false, -1);
					
					// immediatly update the view.
					update();
				}
			}
			else
			{
				// remove the eventlisteners.
				if (_relatedObject) _relatedObject.removeEventListener(Event.RESIZE, handleRelatedResize);
				
				if (_debugShape)
				{
					_debugShape.destruct();
					_debugShape = null;
				}
			}
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
		 * @inheritDoc
		 */
		public function get keepAspectRatio():Boolean
		{
			return _keepAspectRatio;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set keepAspectRatio(value:Boolean):void
		{
			_keepAspectRatio = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get adjustRelated():Boolean
		{
			return _adjustRelated;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set adjustRelated(value:Boolean):void
		{
			_adjustRelated = value;
		}
		
		/**
		 * A Boolean which indicates if a negative value for x and y is allowed.
		 * @default false
		 */
		public function get allowNegativePosition():Boolean
		{
			return _allowNegativePosition;
		}
		
		/**
		 * @private
		 */
		public function set allowNegativePosition(value:Boolean):void
		{
			_allowNegativePosition = value;
		}
		
		/**
		 * If set to <code>true</code> <code>scaleX</code> and <code>scaleY</code> are adjusted instead of
		 * <code>width</code> and <code>height</code> when the dimensions of the object must be changed.
		 * 
		 * @default false
		 */
		public function get useScale():Boolean
		{
			return _useScale;
		}

		/**
		 * @private
		 */
		public function set useScale(value:Boolean):void
		{
			_useScale = value;
		}
		
		/**
		 * @see temple.common.enum.ScaleMode
		 */
		public function get scaleMode():String
		{
			return _scaleMode;
		}

		/**
		 * @private
		 */
		public function set scaleMode(value:String):void
		{
			switch (value)
			{
				case ScaleMode.NO_BORDER:
				case ScaleMode.NO_SCALE:
				case ScaleMode.SHOW_ALL:
				case ScaleMode.EXACT_FIT:
				case null:
				{
					_scaleMode = value;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "Invalid value for scaleMode: '" + value + "'"));
					break;
				}
			}
		}

		/**
		 * @see temple.common.enum.Align
		 */
		public function get align():String
		{
			return _align;
		}

		/**
		 * @private
		 */
		public function set align(value:String):void
		{
			switch (value)
			{
				case Align.BOTTOM:
				case Align.BOTTOM_LEFT:
				case Align.BOTTOM_RIGHT:
				case Align.CENTER:
				case Align.LEFT:
				case Align.RIGHT:
				case Align.TOP:
				case Align.TOP_LEFT:
				case Align.TOP_RIGHT:
				case Align.NONE:
				case null:
				{
					_align = value;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "Invalid value for scaleMode: '" + value + "'"));
					break;
				}
			}
			
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
			
			if (_debug)
			{
				displayObject.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, int.MIN_VALUE);
			}
			else
			{
				displayObject.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				if (_debugShape)
				{
					_debugShape.destruct();
					_debugShape = null;
				}
			}
			
		}
		
		/**
		 * Color of the debug squares
		 */
		public function get debugColor():uint
		{
			return _debugColor;
		}
		
		/**
		 * @private
		 */
		public function set debugColor(value:uint):void
		{
			_debugColor = value;
		}

		private function handleAddedToStage(event:Event):void
		{
			if (!relatedObject)
			{
				relatedObject = findLiquidParent(displayObject);
				
				if (!relatedObject)
				{
					relatedObject = LiquidStage.getInstance(displayObject.stage);
				}
			}
			update();
		}

		private function handleRelatedResize(event:Event):void
		{
			update();
		}
		
		private function handleTargetResize(event:Event):void
		{
			if (_blockRequest)
			{
				dispatchEvent(event.clone());
			}
			else
			{
				update();
			}
		}

		/**
		 * Calculates the minimal width and to set on the related object
		 */
		private function updateRelatedMinimalWidth():void
		{
			if (_relatedObject && _adjustRelated)
			{
				var minimalWidth:Number;
				if (!isNaN(_left) && !isNaN(_right))
				{
					minimalWidth = _left + _right + _minimalWidth;
				}
				else
				{
					minimalWidth = displayObject.width;
					
					if (!isNaN(_left)) minimalWidth += _left;
					if (!isNaN(_right)) minimalWidth += _right;
				}
				
				if (!isNaN(minimalWidth) && (isNaN(_relatedObject.minimalWidth) || _relatedObject.minimalWidth < minimalWidth))
				{
					_relatedObject.minimalWidth = minimalWidth;
				}
			}
		}

		/**
		 * Calculates the minimal height and to set on the related object
		 */
		private function updateRelatedMinimalHeight():void
		{
			if (_relatedObject && _adjustRelated)
			{
				var minimalHeight:Number;
				if (!isNaN(_top) && !isNaN(_bottom))
				{
					minimalHeight = _top + _bottom + _minimalHeight;
				}
				else
				{
					minimalHeight = displayObject.height;
					
					if (!isNaN(_top)) minimalHeight += _top;
					if (!isNaN(_bottom)) minimalHeight += _bottom;
				}
				if (!isNaN(minimalHeight) && (isNaN(_relatedObject.minimalHeight) || _relatedObject.minimalHeight < minimalHeight))
				{
					_relatedObject.minimalHeight = minimalHeight;
				}
			}
		}

		/**
		 * Calculates the total scaleX of all related objects
		 */
		private function getRelatedTotalScaleX():Number
		{
			var scale:Number = 1;
			var related:ILiquidRelatedObject = _relatedObject;
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
			var related:ILiquidRelatedObject = _relatedObject;
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
			return findLiquidParent(displayObject.parent);
		}
		
		private function handleEnterFrame(event:Event):void
		{
			drawBounce();
		}

		/**
		 * Draws on the stage a rectange on the same size and position of the bounce of the object
		 */
		private function drawBounce():void
		{
			if (!displayObject.stage || !displayObject.parent || displayObject is ICoreDisplayObject && !(displayObject as ICoreDisplayObject).onStage || !isDeepVisible(displayObject))
			{
				if (_debugShape)
				{
					_debugShape.destruct();
					_debugShape = null;
				}
				return;
			}
			
			if (!_debugShape)
			{
				_debugShape = new CoreShape("DebugShape: " + toString());
				displayObject.stage.addChild(_debugShape);
			}
			var offset:Point = displayObject.getRect(displayObject).topLeft;
			offset.x += displayObject.x;
			offset.y += displayObject.y;
			
			var point:Point = displayObject.parent.localToGlobal(offset);
			
			var bounds:Rectangle;
			
			if (displayObject.rotation == 0)
			{
				bounds = new Rectangle(point.x, point.y, displayObject.width, displayObject.height);
			}
			else
			{
				bounds = displayObject.getBounds(displayObject.stage);
			}
			
			// draw square for boundries
			_debugShape.graphics.clear();
			_debugShape.graphics.lineStyle(_DEBUG_LINE_THICKNESS, _debugColor, .3, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
			_debugShape.graphics.drawRect(bounds.topLeft.x + _DEBUG_LINE_THICKNESS * .5, bounds.topLeft.y + _DEBUG_LINE_THICKNESS * .5, bounds.width - _DEBUG_LINE_THICKNESS * .5, bounds.height - _DEBUG_LINE_THICKNESS * .5);
			
			// Draw cross on 0,0 point
			_debugShape.graphics.lineStyle(1, _debugColor, 1);
			_debugShape.graphics.moveTo(point.x - _DEBUG_CROSS_SIZE, point.y - _DEBUG_CROSS_SIZE);
			_debugShape.graphics.lineTo(point.x + _DEBUG_CROSS_SIZE, point.y + _DEBUG_CROSS_SIZE);
			_debugShape.graphics.moveTo(point.x + _DEBUG_CROSS_SIZE, point.y - _DEBUG_CROSS_SIZE);
			_debugShape.graphics.lineTo(point.x - _DEBUG_CROSS_SIZE, point.y + _DEBUG_CROSS_SIZE);
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
				return isDeepVisible(displayObject.parent);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_relatedObject)
			{
				_relatedObject.removeEventListener(Event.RESIZE, handleRelatedResize);
				_relatedObject = null;
			}
			if (target)
			{
				delete LiquidBehavior._dictionary[target];
				displayObject.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				displayObject.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}
			if (_debugShape)
			{
				_debugShape.destruct();
				_debugShape = null;
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