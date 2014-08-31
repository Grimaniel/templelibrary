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
	import temple.common.interfaces.IHasBackground;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * This class is used as a wrapper around other liquid objects to set special liquid properties.
	 * When a LiquidContainer is resized, it will not be scaled. Therefor all liquid children woun't be scaled,
	 * but sized and positioned based on their liquid properties.
	 * 
	 * @includeExample LiquidContainerExample.as
	 * @includeExample LiquidExample.as
	 * 
	 * @see temple.ui.layout.liquid.LiquidBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class LiquidContainer extends LiquidSprite implements IHasBackground
	{
		protected var _originalScale:Point;
		
		private var _contentWidth:Number;
		private var _contentHeight:Number;
		private var _width:Number;
		private var _height:Number;
		private var _scaleMode:String;
		private var _clipping:Boolean;
		
		private var _horizontalAlign:Number;
		private var _verticalAlign:Number;
		private var _background:Boolean;
		private var _backgroundColor:uint;
		private var _backgroundAlpha:Number = 1;
		private var _aspectRatio:Number;

		public function LiquidContainer(width:Number = NaN, height:Number = NaN, scaleMode:String = 'noScale', align:String = 'topLeft', clipping:Boolean = false)
		{
			construct::liquidContainer(width, height, scaleMode, align, clipping);
		}

		/**
		 * @private
		 */
		construct function liquidContainer(width:Number, height:Number, scaleMode:String, align:String, clipping:Boolean):void
		{
			_width = width;
			_height = height;
			
			_contentWidth = _width;
			_contentHeight	= _height;
			
			_scaleMode = scaleMode;
			_clipping = clipping;
			this.align = align;
			
			_originalScale = new Point(scaleX, scaleY);
		}

		/**
		 * Reset the scale of the object, so that both scaleX and scaleY will be 1, but the width and height stays the same.
		 */
		public function resetScale():void 
		{
			if (scaleX != 1 || scaleY != 1)
			{
				_width = width;
				_height = height;
				
				var leni:int = numChildren;
				for (var i:int = 0; i < leni; i++)
				{
					getChildAt(i).width *= scaleX;
					getChildAt(i).height *= scaleY;
				}
				
				scale = 1;
				layout();
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return !isNaN(_width) ? _width : super.width;
		}

		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width = value;
				layout();
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return !isNaN(_height) ? _height : super.height;
		}

		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height = value;
				layout();
				dispatchEvent(new Event(Event.RESIZE));
			}
		}
		
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		
		public function set contentWidth(value:Number):void
		{
			_contentWidth = value;
		}
		
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		
		public function set contentHeight(value:Number):void
		{
			_contentHeight = value;
		}
		
		/**
		 * TODO:
		 */
		[Inspectable(name="ScaleMode", type="String", defaultValue="noScale", enumeration="exactFit,noBorder,noScale,showAll")]
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
				case ScaleMode.EXACT_FIT:
				case ScaleMode.NO_BORDER:
				case ScaleMode.NO_SCALE:
				case ScaleMode.SHOW_ALL:
				{
					_scaleMode = value;
					layout();
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
		 * 
		 */
		public function get align():String
		{
			switch (_horizontalAlign)
			{
				case 0:
				{
					switch (_verticalAlign)
					{
						case 0: return Align.TOP_LEFT; 
						case 1: return Align.BOTTOM_LEFT;
						default: return Align.LEFT;
					}
				}
				case 1:
				{
					switch (_verticalAlign)
					{
						case 0: return Align.TOP_RIGHT; 
						case 1: return Align.BOTTOM_RIGHT;
						default: return Align.RIGHT;
					}
				}
				default:
				{
					switch (_verticalAlign)
					{
						case 0: return Align.TOP; 
						case 1: return Align.BOTTOM;
						default: return Align.NONE;
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		public function set align(value:String):void
		{
			switch (value)
			{
				case Align.LEFT:
				{
					_horizontalAlign = 0;
					break;
				}
				case Align.CENTER:
				{
					_horizontalAlign = .5;
					break;
				}
				case Align.RIGHT:
				{
					_horizontalAlign = 1;
					break;
				}
				case Align.TOP:
				{
					_verticalAlign = 0;
					break;
				}
				case Align.MIDDLE:
				{
					_verticalAlign = .5;
					break;
				}
				case Align.BOTTOM:
				{
					_verticalAlign = 1;
					break;
				}
				case Align.TOP_LEFT:
				case null:
				{
					_horizontalAlign = 0;
					_verticalAlign = 0;
					break;
				}
				case Align.TOP_RIGHT:
				{
					_horizontalAlign = 1;
					_verticalAlign = 0;
					break;
				}
				case Align.BOTTOM_LEFT:
				{
					_horizontalAlign = 0;
					_verticalAlign = 1;
					break;
				}
				case Align.BOTTOM_RIGHT:
				{
					_horizontalAlign = 1;
					_verticalAlign = 1;
					break;
				}
				case Align.NONE:
				{
					_horizontalAlign = .5;
					_verticalAlign = .5;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "Invalid value for align: '" + value + "'"));
					return;
				}
			}
			layout();
		}
		
		/**
		 * 
		 */
		public function get horizontalAlign():Number
		{
			return _horizontalAlign;
		}
		
		/**
		 * @private
		 */
		public function set horizontalAlign(value:Number):void
		{
			if (isNaN(value)) value = .5;
			_horizontalAlign = value;
			layout();
		}
		
		/**
		 * 
		 */
		public function get verticalAlign():Number
		{
			return _verticalAlign;
		}
		
		/**
		 * @private
		 */
		public function set verticalAlign(value:Number):void
		{
			if (isNaN(value)) value = .5;
			_verticalAlign = value;
			layout();
		}
		
		/**
		 * TODO:
		 */
		[Inspectable(name="Clippping", type="Boolean", defaultValue="false")]
		public function get clipping():Boolean
		{
			return _clipping;
		}
		
		/**
		 * @private
		 */
		public function set clipping(value:Boolean):void
		{
			_clipping = value;
			layout();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get background():Boolean
		{
			return _background;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set background(value:Boolean):void
		{
			_background = value;
			setBackground();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			setBackground();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
			setBackground();
		}

		/**
		 * @inheritDoc
		 */
		override public function get offset():Point 
		{
			return new Point(0,0);
		}

		/**
		 * @inheritDoc
		 */
		override public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle 
		{
			if (targetCoordinateSpace == parent)
			{
				return new Rectangle(x, y, width, height);
			}
			return super.getBounds(targetCoordinateSpace);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set keepAspectRatio(value:Boolean):void
		{
			super.keepAspectRatio = value;
			_aspectRatio = value ? _width / _height : NaN;
			layout();
		}
		
		/**
		 * 
		 */
		public function get aspectRatio():Number
		{
			return _aspectRatio;
		}

		/**
		 * @private
		 */
		public function set aspectRatio(value:Number):void
		{
			_aspectRatio = value;
		}
		
		/**
		 * 
		 */
		public function layout():void 
		{
			switch (_scaleMode)
			{
				case ScaleMode.NO_SCALE:
				{
					if (_clipping) super.scrollRect = new Rectangle(-_horizontalAlign * (_width - _contentWidth) || 0, -_verticalAlign * (_height - _contentHeight) || 0, _width || 0, _height || 0);
					
					if (!isNaN(_aspectRatio))
					{
						var ratio:Number = width / height;
						
						if (ratio != _aspectRatio)
						{
							width = height * _aspectRatio;
						}
					}
					else
					{
						scale = 1;
					}
					
					break;
				}
				case ScaleMode.SHOW_ALL:
				{
					scale = Math.min(_width / _contentWidth, _height / _contentHeight);
					super.scrollRect = new Rectangle(  -_horizontalAlign * (_width - _contentWidth * scaleX) / scaleX
													, -_verticalAlign * (_height - _contentHeight * scaleY) / scaleY
													, _width / scaleX, _height / scaleY);
					break;
				}
				case ScaleMode.NO_BORDER:
				{
					scale = Math.max(_width / _contentWidth, _height / _contentHeight);
					super.scrollRect = new Rectangle(  -_horizontalAlign * (_width - _contentWidth * scaleX) / scaleX
													, -_verticalAlign * (_height - _contentHeight * scaleY) / scaleY
													, _width / scaleX, _height / scaleY);
					break;
				}
				case ScaleMode.EXACT_FIT:
				{
					scaleX = width / _contentWidth;
					scaleY = _height / _contentHeight;
					
					if (_clipping)
					{
						super.scrollRect = new Rectangle(0, 0, _contentWidth, _contentHeight);
					}
				}
			}
			setBackground();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scrollRect(value:Rectangle):void
		{
			super.scrollRect = value;
			setBackground();
		}
		
		private function setBackground():void 
		{
			graphics.clear();
			if (_background)
			{
				graphics.beginFill(_backgroundColor, _backgroundAlpha);
				graphics.drawRect(scrollRect ? scrollRect.x : 0, scrollRect ? scrollRect.y : 0, width, height);
				graphics.endFill();
			}
		}
	}
}