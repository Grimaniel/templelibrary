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
				scrollRect = new Rectangle(0, 0, !isNaN(width) ? width : this.width, !isNaN(height) ? height : this.height);
			}
			
			init();
			
			addEventListener(Event.ADDED, handleDisplayObjectUpdate);
			addEventListener(Event.REMOVED, handleDisplayObjectUpdate);
		}
		
		/**
		 * @private
		 */
		protected function init():void
		{
			_scrollBehavior = new ScrollBehavior(this, new Rectangle(0, 0, width, height));
		}

		private function handleDisplayObjectUpdate(event:Event):void 
		{
			new FrameDelay(dispatchEvent, 1, [new Event(Event.RESIZE)]);
		}
		
		/**
		 * Returns a reference to the ScrollBehavior
		 */
		public function get scrollBehavior():ScrollBehavior
		{
			return _scrollBehavior;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return scrollRect ? scrollRect.width : super.width;
		}

		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if (scrollRect)
			{
				var scrollFactor:Number = maxScrollH ? scrollH / maxScrollH : 0;
				var rect:Rectangle = scrollRect;
				rect.width = value;
				scrollRect = rect;
				scrollH = scrollFactor * maxScrollH;
				dispatchEvent(new Event(Event.RESIZE));
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
			return transform.pixelBounds.width + (!isNaN(marginLeft) ? marginLeft : 0) + (!isNaN(marginRight) ? marginRight : 0);;
		}

		/**
		 * @inheritDoc
		 * 
		 * Checks for a scrollRect and returns the height of the scrollRect.
		 */
		override public function get height():Number
		{
			return scrollRect ? scrollRect.height : super.height;
		}

		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if (scrollRect)
			{
				var scrollFactor:Number = maxScrollV ? scrollV / maxScrollV : 0;
				var rect:Rectangle = scrollRect;
				rect.height = value;
				scrollRect = rect;
				scrollV = scrollFactor * maxScrollV;
				dispatchEvent(new Event(Event.RESIZE));
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
			return transform.pixelBounds.height + (!isNaN(marginTop) ? marginTop : 0) + (!isNaN(marginBottom) ? marginBottom : 0);
		}

		/**
		 * @inheritDoc
		 */
		public function get scrollH():Number
		{
			return _scrollBehavior.scrollH;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="ScrollH", type="Number")]
		public function set scrollH(value:Number):void
		{
			_scrollBehavior.scrollH = value;
		}

		/**
		 * @inheritDoc
		 */
		public function scrollHTo(value:Number):void
		{
			_scrollBehavior.scrollHTo(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollH():Number
		{
			return _targetScrollH;
		}

		/**
		 * @inheritDoc
		 */
		public function get maxScrollH():Number
		{
			return _scrollBehavior ? _scrollBehavior.maxScrollH : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get scrollV():Number
		{
			return _scrollBehavior.scrollV;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="ScrollV", type="Number")]
		public function set scrollV(value:Number):void
		{
			_scrollBehavior.scrollV = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollVTo(value:Number):void
		{
			_scrollBehavior.scrollVTo(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targetScrollV():Number
		{
			return _targetScrollV;
		}

		/**
		 * @inheritDoc
		 */
		public function get maxScrollV():Number
		{
			return _scrollBehavior ? _scrollBehavior.maxScrollV : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollUp():void
		{
			scrollBehavior.scrollUp();
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollDown():void
		{
			scrollBehavior.scrollDown();
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollLeft():void
		{
			scrollBehavior.scrollLeft();
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollRight():void
		{
			scrollBehavior.scrollRight();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get canScrollUp():Boolean
		{
			return _scrollBehavior.canScrollUp;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollDown():Boolean
		{
			return _scrollBehavior.canScrollDown;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollLeft():Boolean
		{
			return _scrollBehavior.canScrollLeft;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollRight():Boolean
		{
			return _scrollBehavior.canScrollRight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollProxy():IPropertyProxy
		{
			return _scrollBehavior.scrollProxy;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scrollProxy(value:IPropertyProxy):void
		{
			_scrollBehavior.scrollProxy = value;
		}
		
		/**
		 * Indicates if the scroll values should be rounded to pixels
		 */
		public function get snapToPixel():Boolean
		{
			return _scrollBehavior.snapToPixel;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Snap to pixel", type="Boolean", defaultValue="true")]
		public function set snapToPixel(value:Boolean):void
		{
			_scrollBehavior.snapToPixel = value;
		}
		
		/**
		 * Get or set the speed of the scrolling by mouse wheel. If NaN the value of stepSizeV is used.
		 */
		public function get mouseWheelScrollSpeed():Number
		{
			return _scrollBehavior.mouseWheelScrollSpeed;
		}
		
		/**
		 * @private
		 */
		public function set mouseWheelScrollSpeed(value:Number):void
		{
			_scrollBehavior.mouseWheelScrollSpeed = value;
		}
		
		/**
		 * A Boolean value that indicates if the ScrollPane is automaticly scrolled when the user rolls the mouse wheel over the pane.
		 * By default, this value is true.
		 */
		[Inspectable(name="MouseWheelEnabled", type="Boolean", defaultValue="true")]
		public function get mouseWheelEnabled():Boolean
		{
			return _scrollBehavior.mouseWheelEnabled;
		}
		
		/**
		 * @private
		 */
		public function set mouseWheelEnabled(value:Boolean):void
		{
			_scrollBehavior.mouseWheelEnabled = value;
		}
		
		/**
		 * Get or set all margins (left, right, top, bottom) at once. If margins are not equal, NaN is returned
		 */
		public function get margin():Number
		{
			return scrollBehavior ? scrollBehavior.margin : NaN;
		}
		
		/**
		 * @private
		 */
		public function set margin(value:Number):void
		{
			scrollBehavior.margin = value;
		}

		/**
		 * Margin at the top of the content
		 */
		public function get marginTop():Number
		{
			return _scrollBehavior ? _scrollBehavior.marginTop : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Margin top", type="Number", defaultValue="0")]
		public function set marginTop(value:Number):void
		{
			_scrollBehavior.marginTop = value;
		}
		
		/**
		 * Margin at the bottom of the content
		 */
		public function get marginBottom():Number
		{
			return _scrollBehavior ? _scrollBehavior.marginBottom : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Margin bottom", type="Number", defaultValue="0")]
		public function set marginBottom(value:Number):void
		{
			_scrollBehavior.marginBottom = value;
		}
		
		/**
		 * Margin at the left side of the content
		 */
		public function get marginLeft():Number
		{
			return _scrollBehavior ? _scrollBehavior.marginLeft : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Margin left", type="Number", defaultValue="0")]
		public function set marginLeft(value:Number):void
		{
			_scrollBehavior.marginLeft = value;
		}
		
		/**
		 * Margin at the right side of the content
		 */
		public function get marginRight():Number
		{
			return _scrollBehavior ? _scrollBehavior.marginRight : NaN;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Margin right", type="Number", defaultValue="0")]
		public function set marginRight(value:Number):void
		{
			_scrollBehavior.marginRight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_scrollBehavior = null;
			super.destruct();
		}
	}
}
