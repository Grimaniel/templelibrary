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

package temple.ui.scroll 
{
	import temple.ui.layout.liquid.LiquidMovieClip;
	import temple.utils.FrameDelay;
	import temple.utils.propertyproxy.IPropertyProxy;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @eventType flash.events.Event.RESIZE
	 */
	[Event(name = "resize", type = "flash.events.Event")]

	/**
	 * Basic implementation of scrollable DisplayObject.
	 * 
	 * @author Thijs Broerse
	 */
	public class ScrollPane extends LiquidMovieClip implements IScrollPane, IScrollable
	{
		/**
		 * @private
		 */
		protected var _scrollBehavior:ScrollBehavior;
		
		private var _targetScrollH:Number;
		private var _targetScrollV : Number;
		
		public function ScrollPane(width:Number = NaN, height:Number = NaN) 
		{
			if (!isNaN(width) || !isNaN(height))
			{
				this.scrollRect = new Rectangle(0, 0, !isNaN(width) ? width : this.width, !isNaN(height) ? height : this.height);
			}
			
			this.init();
			
			this.addEventListener(Event.ADDED, this.handleDisplayObjectUpdate);
			this.addEventListener(Event.REMOVED, this.handleDisplayObjectUpdate);
		}
		
		/**
		 * @private
		 */
		protected function init():void
		{
			this._scrollBehavior = new ScrollBehavior(this, new Rectangle(0, 0, this.width, this.height));
		}

		private function handleDisplayObjectUpdate(event:Event):void 
		{
			new FrameDelay(this.dispatchEvent, 1, [new Event(Event.RESIZE)]);
		}
		
		/**
		 * Returns a reference to the ScrollBehavior
		 */
		public function get scrollBehavior():ScrollBehavior
		{
			return this._scrollBehavior;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return this.scrollRect ? this.scrollRect.width : super.width;
		}

		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if (this.scrollRect)
			{
				var scrollFactor:Number = this.maxScrollH ? this.scrollH / this.maxScrollH : 0;
				var rect:Rectangle = this.scrollRect;
				rect.width = value;
				this.scrollRect = rect;
				this.scrollH = scrollFactor * this.maxScrollH;
			}
			else
			{
				super.width = value;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get contentWidth():Number
		{
			return this.transform.pixelBounds.width + (!isNaN(this.marginLeft) ? this.marginLeft : 0) + (!isNaN(this.marginRight) ? this.marginRight : 0);;
		}

		/**
		 * @inheritDoc
		 * 
		 * Checks for a scrollRect and returns the height of the scrollRect.
		 */
		override public function get height():Number
		{
			return this.scrollRect ? this.scrollRect.height : super.height;
		}

		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if (this.scrollRect)
			{
				var scrollFactor:Number = this.maxScrollV ? this.scrollV / this.maxScrollV : 0;
				var rect:Rectangle = this.scrollRect;
				rect.height = value;
				this.scrollRect = rect;
				this.scrollV = scrollFactor * this.maxScrollV;
			}
			else
			{
				super.height = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentHeight():Number
		{
			return this.transform.pixelBounds.height + (!isNaN(this.marginTop) ? this.marginTop : 0) + (!isNaN(this.marginBottom) ? this.marginBottom : 0);
		}

		/**
		 * @inheritDoc
		 */
		public function get scrollH():Number
		{
			return this._scrollBehavior.scrollH;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="ScrollH", type="Number")]
		public function set scrollH(value:Number):void
		{
			this._scrollBehavior.scrollH = value;
		}

		/**
		 * @inheritDoc
		 */
		public function scrollHTo(value:Number):void
		{
			this._scrollBehavior.scrollHTo(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollH():Number
		{
			return this._targetScrollH;
		}

		/**
		 * @inheritDoc
		 */
		public function get maxScrollH():Number
		{
			return this._scrollBehavior ? this._scrollBehavior.maxScrollH : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get scrollV():Number
		{
			return this._scrollBehavior.scrollV;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="ScrollV", type="Number")]
		public function set scrollV(value:Number):void
		{
			this._scrollBehavior.scrollV = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollVTo(value:Number):void
		{
			this._scrollBehavior.scrollVTo(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollV():Number
		{
			return this._targetScrollV;
		}

		/**
		 * @inheritDoc
		 */
		public function get maxScrollV():Number
		{
			return this._scrollBehavior ? this._scrollBehavior.maxScrollV : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollUp():void
		{
			this.scrollBehavior.scrollUp();
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollDown():void
		{
			this.scrollBehavior.scrollDown();
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollLeft():void
		{
			this.scrollBehavior.scrollLeft();
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollRight():void
		{
			this.scrollBehavior.scrollRight();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get canScrollUp():Boolean
		{
			return this._scrollBehavior.canScrollUp;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollDown():Boolean
		{
			return this._scrollBehavior.canScrollDown;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollLeft():Boolean
		{
			return this._scrollBehavior.canScrollLeft;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollRight():Boolean
		{
			return this._scrollBehavior.canScrollRight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollProxy():IPropertyProxy
		{
			return this._scrollBehavior.scrollProxy;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scrollProxy(value:IPropertyProxy):void
		{
			this._scrollBehavior.scrollProxy = value;
		}
		
		/**
		 * Indicates if the scroll values should be rounded to pixels
		 */
		public function get snapToPixel():Boolean
		{
			return this._scrollBehavior.snapToPixel;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Snap to pixel", type="Boolean", defaultValue="true")]
		public function set snapToPixel(value:Boolean):void
		{
			this._scrollBehavior.snapToPixel = value;
		}
		
		/**
		 * Get or set the speed of the scrolling by mouse wheel. If NaN the value of stepSizeV is used.
		 */
		public function get mouseWheelScrollSpeed():Number
		{
			return this._scrollBehavior.mouseWheelScrollSpeed;
		}
		
		/**
		 * @private
		 */
		public function set mouseWheelScrollSpeed(value:Number):void
		{
			this._scrollBehavior.mouseWheelScrollSpeed = value;
		}
		
		/**
		 * A Boolean value that indicates if the ScrollPane is automaticly scrolled when the user rolls the mouse wheel over the pane.
		 * By default, this value is true.
		 */
		[Inspectable(name="MouseWheelEnabled", type="Boolean", defaultValue="true")]
		public function get mouseWheelEnabled():Boolean
		{
			return this._scrollBehavior.mouseWheelEnabled;
		}
		
		/**
		 * @private
		 */
		public function set mouseWheelEnabled(value:Boolean):void
		{
			this._scrollBehavior.mouseWheelEnabled = value;
		}
		
		/**
		 * Get or set all margins (left, right, top, bottom) at once. If margins are not equal, NaN is returned
		 */
		public function get margin():Number
		{
			return this.scrollBehavior ? this.scrollBehavior.margin : NaN;
		}
		
		/**
		 * @private
		 */
		public function set margin(value:Number):void
		{
			this.scrollBehavior.margin = value;
		}

		/**
		 * Margin at the top of the content
		 */
		public function get marginTop():Number
		{
			return this._scrollBehavior ? this._scrollBehavior.marginTop : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Margin top", type="Number", defaultValue="0")]
		public function set marginTop(value:Number):void
		{
			this._scrollBehavior.marginTop = value;
		}
		
		/**
		 * Margin at the bottom of the content
		 */
		public function get marginBottom():Number
		{
			return this._scrollBehavior ? this._scrollBehavior.marginBottom : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Margin bottom", type="Number", defaultValue="0")]
		public function set marginBottom(value:Number):void
		{
			this._scrollBehavior.marginBottom = value;
		}
		
		/**
		 * Margin at the left side of the content
		 */
		public function get marginLeft():Number
		{
			return this._scrollBehavior ? this._scrollBehavior.marginLeft : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Margin left", type="Number", defaultValue="0")]
		public function set marginLeft(value:Number):void
		{
			this._scrollBehavior.marginLeft = value;
		}
		
		/**
		 * Margin at the right side of the content
		 */
		public function get marginRight():Number
		{
			return this._scrollBehavior ? this._scrollBehavior.marginRight : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Margin right", type="Number", defaultValue="0")]
		public function set marginRight(value:Number):void
		{
			this._scrollBehavior.marginRight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._scrollBehavior = null;
			super.destruct();
		}
	}
}
