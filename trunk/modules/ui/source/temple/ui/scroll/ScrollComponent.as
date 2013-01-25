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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * A scrollable object for usage in the Flash IDE.
	 * <p>Set this class a base class in the IDE for the object. Add an object called 'content' of 'mcContent' on the stage
	 * which contains the content that must be scrolled. Add an ScrollBar on the stage called 'scrollbar' or 'mcScrollBar' which
	 * act as ScrollBar for this component. Add an object called 'mask' or 'mcMask' which size will be used a scrollRect (visible
	 * area) for the ScrollComponent.</p>
	 * 
	 * @see temple.ui.scroll.ScrollBar
	 * 
	 * @includeExample ScrollComponentExample.as
	 * @includeExample LiquidScrollComponentExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ScrollComponent extends ScrollPane implements IScrollable 
	{
		/**
		 * Instance name of a child which acts as content for the ScrollComponent.
		 */
		public static var contentInstanceName:String = "mcContent";

		/**
		 * Instance name of a child which acts as mask for the ScrollComponent.
		 */
		public static var maskInstanceName:String = "mcMask";

		/**
		 * Instance name of a child which acts as ScrollBar for the ScrollComponent.
		 */
		public static var scrollBarInstanceName:String = "mcScrollBar";
		
		private var _content:DisplayObjectContainer;
		private var _scrollBar:ScrollBar;
		
		public function ScrollComponent()
		{
		}
		
		/**
		 * @private
		 */
		override protected function init():void 
		{
			if (!_content) content = getChildByName(contentInstanceName) as DisplayObjectContainer;
			mask ||= getChildByName(maskInstanceName);
			scrollBar ||= getChildByName(scrollBarInstanceName) as ScrollBar;
			
			if (!_scrollBehavior)
			{
				super.init();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return content.scrollRect ? content.scrollRect.width : super.width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if (content.scrollRect)
			{
				var scrollFactor:Number = maxScrollH ? scrollH / maxScrollH : 0;
				var rect:Rectangle = content.scrollRect;
				rect.width = value;
				content.scrollRect = rect;
				scrollH = scrollFactor * maxScrollH;
			}
			else
			{
				super.width = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function get contentWidth():Number 
		{
			return content.transform.pixelBounds.width / content.transform.concatenatedMatrix.a + (!isNaN(marginLeft) ? marginLeft : 0) + (!isNaN(marginRight) ? marginRight : 0);
		}

		/**
		 * @inheritDoc
		 * 
		 * Checks for a scrollRect and returns the height of the scrollRect.
		 */
		override public function get height():Number
		{
			return content.scrollRect ? content.scrollRect.height : super.height;
		}

		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if (content.scrollRect && !isNaN(maxScrollV))
			{
				var scrollFactor:Number = maxScrollV ? scrollV / maxScrollV : 0;
				var rect:Rectangle = content.scrollRect;
				rect.height = value;
				content.scrollRect = rect;
				scrollV = scrollFactor * maxScrollV;
			}
			else
			{
				super.height = value;
			}
		}

		override public function get contentHeight():Number 
		{
			return content.transform.pixelBounds.height / content.transform.concatenatedMatrix.d + (!isNaN(marginTop) ? marginTop : 0) + (!isNaN(marginBottom) ? marginBottom : 0);
		}

		/**
		 * The content that is scrolled. If set to null, the whole ScrollComponent is scrolled.
		 */
		public function get content():DisplayObjectContainer
		{
			return _content ? _content : this;
		}
		
		/**
		 * @private
		 */
		public function set content(value:DisplayObjectContainer):void
		{
			if (_scrollBehavior) _scrollBehavior.destruct();
			_content = value;
			if (_content)
			{
				if (mask)
				{
					_scrollBehavior = new ScrollBehavior(_content, mask.getRect(this), this);
					_content.mask = mask;
				}
				else
				{
					_scrollBehavior = new ScrollBehavior(_content, content.scrollRect ? content.scrollRect : new Rectangle(0, 0, width, height), this);
				}
			}
			
			if (_content != this)
			{
				scrollRect = null;
				
				if (_content) _content.addEventListener(ScrollEvent.SCROLL, dispatchEvent);
			}
		}

		/**
		 * @inheritDoc
		 * 
		 * The size of the mask is used as scrollRect
		 */
		override public function set mask(value:DisplayObject):void 
		{
			if (value)
			{
				content.scrollRect = new Rectangle(value.x, value.y, value.width, value.height);
				value.visible = false;
			} 
		}
		
		/**
		 * Add a ScrollBar 
		 */
		public function get scrollBar():ScrollBar
		{
			return _scrollBar;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scrollBar(value:ScrollBar):void
		{
			_scrollBar = value;
			if (_scrollBar)
			{
				_scrollBar.autoHide = true;
				_scrollBar.scrollPane = this;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			_content = null;
			_scrollBar = null;
			super.destruct();
		}
	}
}
