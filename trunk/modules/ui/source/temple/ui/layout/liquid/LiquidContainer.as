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
	 * @includeExample LiquidExample.as
	 * 
	 * @see temple.ui.layout.liquid.LiquidBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class LiquidContainer extends LiquidMovieClip implements IHasBackground
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

		public function LiquidContainer(width:Number = NaN, height:Number = NaN, scaleMode:String = 'noScale', align:String = null, clipping:Boolean = false)
		{
			construct::liquidContainer(width, height, scaleMode, align, clipping);
		}

		/**
		 * @private
		 */
		construct function liquidContainer(width:Number, height:Number, scaleMode:String, align:String, clipping:Boolean):void
		{
			this._width = width;
			this._height = height;
			
			this._contentWidth = this._width;
			this._contentHeight	= this._height;
			
			this.scaleMode = scaleMode;
			this.clipping = clipping;
			this.align = align;
			
			this._originalScale = new Point(this.scaleX, this.scaleY);
		}

		/**
		 * Reset the scale of the object, so that both scaleX and scaleY will be 1, but the width and height stays the same.
		 */
		public function resetScale():void 
		{
			if (this.scaleX != 1 || this.scaleY != 1)
			{
				this._width = this.width;
				this._height = this.height;
				
				var leni:int = this.numChildren;
				for (var i:int = 0; i < leni; i++)
				{
					this.getChildAt(i).width *= this.scaleX;
					this.getChildAt(i).height *= this.scaleY;
				}
				
				this.scale = 1;
				this.layout();
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return !isNaN(this._width) ? this._width : super.width;
		}

		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if (this._width != value)
			{
				this._width = value;
				this.layout();
				this.dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return !isNaN(this._height) ? this._height : super.height;
		}

		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if (this._height != value)
			{
				this._height = value;
				this.layout();
				this.dispatchEvent(new Event(Event.RESIZE));
			}
		}
		
		public function get contentWidth():Number
		{
			return this._contentWidth;
		}
		
		public function set contentWidth(value:Number):void
		{
			this._contentWidth = value;
		}
		
		public function get contentHeight():Number
		{
			return this._contentHeight;
		}
		
		public function set contentHeight(value:Number):void
		{
			this._contentHeight = value;
		}
		
		/**
		 * TODO:
		 */
		[Inspectable(name="ScaleMode", type="String", defaultValue="noScale", enumeration="exactFit,noBorder,noScale,showAll")]
		public function get scaleMode():String
		{
			return this._scaleMode;
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
					this._scaleMode = value;
					this.layout();
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "Invalid value for scaleMode: '" + value + "'"));
					break;
				}
			}
		}
		
		public function get align():String
		{
			switch (this._horizontalAlign)
			{
				case 0:
				{
					switch (this._verticalAlign)
					{
						case 0: return Align.TOP_LEFT; 
						case 1: return Align.BOTTOM_LEFT;
						default: return Align.LEFT;
					}
				}
				case 1:
				{
					switch (this._verticalAlign)
					{
						case 0: return Align.TOP_RIGHT; 
						case 1: return Align.BOTTOM_RIGHT;
						default: return Align.RIGHT;
					}
				}
				default:
				{
					switch (this._verticalAlign)
					{
						case 0: return Align.TOP; 
						case 1: return Align.BOTTOM;
						default: return Align.NONE;
					}
				}
			}
			return null;
		}
		
		public function set align(value:String):void
		{
			switch (value)
			{
				case Align.LEFT:
				{
					this._horizontalAlign = 0;
					break;
				}
				case Align.CENTER:
				{
					this._horizontalAlign = .5;
					break;
				}
				case Align.RIGHT:
				{
					this._horizontalAlign = 1;
					break;
				}
				case Align.TOP:
				{
					this._verticalAlign = 0;
					break;
				}
				case Align.MIDDLE:
				{
					this._verticalAlign = .5;
					break;
				}
				case Align.BOTTOM:
				{
					this._verticalAlign = 1;
					break;
				}
				case Align.TOP_LEFT:
				{
					this._horizontalAlign = 0;
					this._verticalAlign = 0;
					break;
				}
				case Align.TOP_RIGHT:
				{
					this._horizontalAlign = 1;
					this._verticalAlign = 0;
					break;
				}
				case Align.BOTTOM_LEFT:
				{
					this._horizontalAlign = 0;
					this._verticalAlign = 1;
					break;
				}
				case Align.BOTTOM_RIGHT:
				{
					this._horizontalAlign = 1;
					this._verticalAlign = 1;
					break;
				}
				case Align.NONE:
				case null:
				{
					this._horizontalAlign = .5;
					this._verticalAlign = .5;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "Invalid value for align: '" + value + "'"));
					break;
				}
			}
		}
		
		public function get horizontalAlign():Number
		{
			return this._horizontalAlign;
		}
		
		public function set horizontalAlign(value:Number):void
		{
			if (isNaN(value)) value = .5;
			this._horizontalAlign = value;
			this.layout();
		}
		
		public function get verticalAlign():Number
		{
			return this._verticalAlign;
		}
		
		public function set verticalAlign(value:Number):void
		{
			if (isNaN(value)) value = .5;
			this._verticalAlign = value;
			this.layout();
		}
		
		/**
		 * TODO:
		 */
		[Inspectable(name="Clippping", type="Boolean", defaultValue="false")]
		public function get clipping():Boolean
		{
			return this._clipping;
		}
		
		/**
		 * @private
		 */
		public function set clipping(value:Boolean):void
		{
			this._clipping = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get background():Boolean
		{
			return this._background;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set background(value:Boolean):void
		{
			this._background = value;
			this.setBackground();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get backgroundColor():uint
		{
			return this._backgroundColor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set backgroundColor(value:uint):void
		{
			this._backgroundColor = value;
			this.setBackground();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get backgroundAlpha():Number
		{
			return this._backgroundAlpha;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set backgroundAlpha(value:Number):void
		{
			this._backgroundAlpha = value;
			this.setBackground();
		}

		override public function get offset():Point 
		{
			return new Point(0,0);
		}

		override public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle 
		{
			if (targetCoordinateSpace == this.parent)
			{
				return new Rectangle(this.x, this.y, this.width, this.height);
			}
			return super.getBounds(targetCoordinateSpace);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set keepAspectRatio(value:Boolean):void
		{
			super.keepAspectRatio = value;
			
			this._aspectRatio = value ? this._width / this._height : NaN;
		}
		
		public function get aspectRatio():Number
		{
			return this._aspectRatio;
		}

		public function set aspectRatio(value:Number):void
		{
			this._aspectRatio = value;
		}
		
		public function layout():void 
		{
			switch (this._scaleMode)
			{
				case ScaleMode.NO_SCALE:
				{
					if (this._clipping) this.scrollRect = new Rectangle(-this._horizontalAlign * (this._width - this._contentWidth), -this._verticalAlign * (this._height - this._contentHeight), this._width, this._height);
					
					if (!isNaN(this._aspectRatio))
					{
						var ratio:Number = this.width / this.height;
						
						if (ratio != this._aspectRatio)
						{
							this.width = this.height * this._aspectRatio;
						}
					}
					else
					{
						this.scale = 1;
					}
					
					break;
				}
				case ScaleMode.SHOW_ALL:
				{
					this.scale = Math.min(this._width / this._contentWidth, this._height / this._contentHeight);
					this.scrollRect = new Rectangle(  -this._horizontalAlign * (this._width - this._contentWidth * this.scaleX) / this.scaleX
													, -this._verticalAlign * (this._height - this._contentHeight * this.scaleY) / this.scaleY
													, this._width / this.scaleX, this._height / this.scaleY);
					break;
				}
				case ScaleMode.NO_BORDER:
				{
					this.scale = Math.max(this._width / this._contentWidth, this._height / this._contentHeight);
					this.scrollRect = new Rectangle(  -this._horizontalAlign * (this._width - this._contentWidth * this.scaleX) / this.scaleX
													, -this._verticalAlign * (this._height - this._contentHeight * this.scaleY) / this.scaleY
													, this._width / this.scaleX, this._height / this.scaleY);
					break;
				}
				case ScaleMode.EXACT_FIT:
				{
					this.scaleX = this.width / this._contentWidth;
					this.scaleY = this._height / this._contentHeight;
					
					if (this._clipping)
					{
						this.scrollRect = new Rectangle(0, 0, this._contentWidth, this._contentHeight);
					}
				}
			}
			this.setBackground();
		}
		
		override public function set scrollRect(value:Rectangle):void
		{
			super.scrollRect = value;
			this.setBackground();
		}
		
		private function setBackground():void 
		{
			this.graphics.clear();
			if (this._background)
			{
				this.graphics.beginFill(this._backgroundColor, this._backgroundAlpha);
				this.graphics.drawRect(this.scrollRect ? this.scrollRect.x : 0, this.scrollRect ? this.scrollRect.y : 0, this.width, this.height);
				this.graphics.endFill();
			}
		}
	}
}