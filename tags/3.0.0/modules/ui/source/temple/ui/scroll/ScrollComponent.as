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
		private var _scrollbar:ScrollBar;
		
		public function ScrollComponent()
		{
		}
		
		/**
		 * @private
		 */
		override protected function init():void 
		{
			if (!this._content) this.content = this.getChildByName(contentInstanceName) as DisplayObjectContainer;
			this.mask ||= this.getChildByName(maskInstanceName);
			this.scrollbar ||= this.getChildByName(scrollBarInstanceName) as ScrollBar;
			
			if (!this._scrollBehavior)
			{
				super.init();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return this.content.scrollRect ? this.content.scrollRect.width : super.width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if (this.content.scrollRect)
			{
				var scrollFactor:Number = this.maxScrollH ? this.scrollH / this.maxScrollH : 0;
				var rect:Rectangle = this.content.scrollRect;
				rect.width = value;
				this.content.scrollRect = rect;
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
		override public function get contentWidth():Number 
		{
			return this.content.transform.pixelBounds.width / this.content.transform.concatenatedMatrix.a + (!isNaN(this.marginLeft) ? this.marginLeft : 0) + (!isNaN(this.marginRight) ? this.marginRight : 0);
		}

		/**
		 * @inheritDoc
		 * 
		 * Checks for a scrollRect and returns the height of the scrollRect.
		 */
		override public function get height():Number
		{
			return this.content.scrollRect ? this.content.scrollRect.height : super.height;
		}

		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if (this.content.scrollRect && !isNaN(this.maxScrollV))
			{
				var scrollFactor:Number = this.maxScrollV ? this.scrollV / this.maxScrollV : 0;
				var rect:Rectangle = this.content.scrollRect;
				rect.height = value;
				this.content.scrollRect = rect;
				this.scrollV = scrollFactor * this.maxScrollV;
			}
			else
			{
				super.height = value;
			}
		}

		override public function get contentHeight():Number 
		{
			return this.content.transform.pixelBounds.height / this.content.transform.concatenatedMatrix.d + (!isNaN(this.marginTop) ? this.marginTop : 0) + (!isNaN(this.marginBottom) ? this.marginBottom : 0);
		}

		/**
		 * The content that is scrolled. If set to null, the whole ScrollComponent is scrolled.
		 */
		public function get content():DisplayObjectContainer
		{
			return this._content ? this._content : this;
		}
		
		/**
		 * @private
		 */
		public function set content(value:DisplayObjectContainer):void
		{
			if (this._scrollBehavior) this._scrollBehavior.destruct();
			this._content = value;
			if (this._content)
			{
				if (this.mask)
				{
					this._scrollBehavior = new ScrollBehavior(this._content, this.mask.getRect(this), this);
					this._content.mask = this.mask;
				}
				else
				{
					this._scrollBehavior = new ScrollBehavior(this._content, this.content.scrollRect ? this.content.scrollRect : new Rectangle(0, 0, this.width, this.height), this);
				}
			}
			
			if (this._content != this)
			{
				this.scrollRect = null;
				
				if (this._content) this._content.addEventListener(ScrollEvent.SCROLL, this.dispatchEvent);
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
				this.content.scrollRect = new Rectangle(value.x, value.y, value.width, value.height);
				value.visible = false;
			} 
		}
		
		/**
		 * Add a ScrollBar 
		 */
		public function get scrollbar():ScrollBar
		{
			return this._scrollbar;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scrollbar(value:ScrollBar):void
		{
			this._scrollbar = value;
			if (this._scrollbar)
			{
				this._scrollbar.autoHide = true;
				this._scrollbar.scrollPane = this;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			this._content = null;
			this._scrollbar = null;
			super.destruct();
		}
	}
}
