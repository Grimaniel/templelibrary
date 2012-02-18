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
	import temple.common.interfaces.IEnableable;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;
	import temple.utils.propertyproxy.IPropertyProxy;
	import temple.utils.types.NumberUtils;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	/**
	 * The ScrollBehavior makes a DisplayObject scrollable.
	 * <p>Scrolling is needed when the content of a DisplayObject is larger then the available visible area.
	 * The ScrollBehavior adds a scrollRect to the DisplayObject and is able to move the object under this
	 * this scrollRect to make all content available.</p>
	 * 
	 * @includeExample ScrollComponentExample.as
	 * @includeExample LiquidScrollComponentExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ScrollBehavior extends AbstractDisplayObjectBehavior implements IScrollPane, IEnableable
	{
		private static const _DEFAULT_STEP_SIZE:Number = 20;
		
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		private static var _scrollProxy:IPropertyProxy;
		
		/**
		 * Returns the ScrollablePaneBehavior of a DisplayObject if the DisplayObject has ScrollablePaneBehavior. Otherwise null is returned.
		 */
		public static function getInstance(target:DisplayObject):ScrollBehavior
		{
			return ScrollBehavior._dictionary[target] as ScrollBehavior;
		}
		
		/**
		 * Default IPropertyProxy that is used for scrolling for all ScrollBehaviors if the ScrollBehavior does not have an own scrollProxy
		 */
		public static function get scrollProxy():IPropertyProxy
		{
			return ScrollBehavior._scrollProxy;
		}
		
		/**
		 * @private
		 */
		public static function set scrollProxy(value:IPropertyProxy):void
		{
			ScrollBehavior._scrollProxy = value;
		}
		
		private var _scrollPane:IScrollPane;
		private var _scrollProxy:IPropertyProxy;
		private var _snapToPixel:Boolean;
		private var _mouseWheelScrollSpeed:Number;
		private var _stepSizeH:Number = ScrollBehavior._DEFAULT_STEP_SIZE;
		private var _stepSizeV:Number = ScrollBehavior._DEFAULT_STEP_SIZE;
		private var _marginTop:Number = 0;
		private var _marginBottom:Number = 0;
		private var _marginLeft:Number = 0;
		private var _marginRight:Number = 0;
		private var _mouseWheelEnabled:Boolean = true;
		private var _snapToStep:Boolean;
		private var _targetScrollH:Number;
		private var _targetScrollV:Number;
		private var _limit:Boolean = true;
		private var _enabled:Boolean = true;
		
		/**
		 * Creates a ScrollBehavior for a DisplayObject.
		 * @param target the DisplayObject that needs to be scrolled.
		 * @param scrollRect the size of the visible area.
		 * @param scrollPane if the target is part of a scrollPane, add it here, so the ScrollBehavior can handle through the scrollPane. Otherwise, set this property to null.
		 * @param snapToPixel a Boolean which indicates if all properties should be rounded.
		 */
		public function ScrollBehavior(target:DisplayObject, scrollRect:Rectangle, scrollPane:IScrollPane = null, snapToPixel:Boolean = true)
		{
			super(target);
			
			if (ScrollBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has ScrollablePaneBehavior"));
			
			ScrollBehavior._dictionary[target] = this;
			
			this._scrollPane = scrollPane || target as IScrollPane; 
			this._snapToPixel = snapToPixel;
			
			target.scrollRect = scrollRect;
			target.addEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouseWheel);
			target.addEventListener(ScrollEvent.SCROLL, this.handleScrollEvent);
			target.addEventListener(Event.RESIZE, this.handleTargetResize);
			target.addEventListener(Event.ADDED, this.handleTargetResize);
			target.addEventListener(Event.REMOVED, this.handleTargetResize);
		}
		
		/**
		 * Returns a reference to the ScrollPane
		 */
		public function get scrollPane():IScrollPane
		{
			return this._scrollPane;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollH():Number
		{
			return this.displayObject && this.displayObject.scrollRect ? this.displayObject.scrollRect.x + this._marginLeft : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set scrollH(value:Number):void
		{
			if (!this._enabled) return;
			if (isNaN(value)) throwError(new TempleArgumentError(this, "scrollH can not be set to NaN"));
			
			// limit value
			if (this._limit) value = Math.max(Math.min(value, this.maxScrollH), 0);
			
			// margin
			value -= this._marginLeft;
			
			var rect:Rectangle = this.displayObject.scrollRect;
			rect.x = this._snapToPixel ? Math.round(value) : value;;
			this.displayObject.scrollRect = rect;
			
			this.displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, value, NaN, this.maxScrollH, this.maxScrollV));
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollHTo(value:Number):void
		{
			if (!this._enabled) return;
			this._targetScrollH = value;
			
			if (this._snapToStep) this._targetScrollH = NumberUtils.roundToNearest(this._targetScrollH, this._stepSizeH);
			
			// limit value
			if (this._limit) this._targetScrollH = Math.max(Math.min(this._targetScrollH, this.maxScrollH), 0);
			
			if (this._scrollProxy)
			{
				this._scrollProxy.setValue(this, "scrollH", this._targetScrollH);
			}
			else if (ScrollBehavior._scrollProxy)
			{
				ScrollBehavior._scrollProxy.setValue(this, "scrollH", this._targetScrollH);
			}
			else
			{
				this.scrollH = this._targetScrollH;
			}
			this.displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, this._targetScrollH, NaN, this.maxScrollH, this.maxScrollV));
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
			return this.contentWidth - this.width;
		}

		/**
		 * @inheritDoc
		 */
		public function get scrollV():Number
		{
			return this.displayObject && this.displayObject.scrollRect ? this.displayObject.scrollRect.y + this._marginTop : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set scrollV(value:Number):void
		{
			if (!this._enabled) return;
			if (isNaN(value)) throwError(new TempleArgumentError(this, "scrollV can not be set to NaN"));
			
			// limit value
			if (this._limit) value = Math.max(Math.min(value, this.maxScrollV), 0);
			
			// margin
			value -= this._marginTop;
			
			var rect:Rectangle = this.displayObject.scrollRect;
			rect.y = this._snapToPixel ? Math.round(value) : value;
			this.displayObject.scrollRect = rect;
			
			this.displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, NaN, value, this.maxScrollH, this.maxScrollV));
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollVTo(value:Number):void
		{
			if (!this._enabled) return;
			this._targetScrollV = value;
			
			if (this._snapToStep) this._targetScrollV = NumberUtils.roundToNearest(this._targetScrollV, this._stepSizeV);
			
			// limit value
			if (this._limit) this._targetScrollV = Math.max(Math.min(this._targetScrollV, this.maxScrollV), 0);
			
			if (this._scrollProxy)
			{
				this._scrollProxy.setValue(this, "scrollV", this._targetScrollV);
			}
			else if (ScrollBehavior._scrollProxy)
			{
				ScrollBehavior._scrollProxy.setValue(this, "scrollV", this._targetScrollV);
			}
			else
			{
				this.scrollV = this._targetScrollV;
			}
			this.displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, NaN, this._targetScrollV, this.maxScrollH, this.maxScrollV));
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
			return this.contentHeight - this.height;
		}

		/**
		 * @inheritDoc
		 */
		public function get width():Number
		{
			return this.displayObject.scrollRect ? this.displayObject.scrollRect.width : this.displayObject.width;
		}

		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			var scroll:Number = this.scrollH;
			var rect:Rectangle = this.displayObject.scrollRect;
			rect.width = value;
			this.displayObject.scrollRect = rect;
			this.scrollH = scroll;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentWidth():Number
		{
			if (this._scrollPane)
			{
				return this._scrollPane.contentWidth + this._marginLeft + this._marginRight;
			}
			return this.displayObject.transform.pixelBounds.width / this.displayObject.transform.concatenatedMatrix.a + this._marginLeft + this._marginRight;
		}

		/**
		 * @inheritDoc
		 */
		public function get height():Number
		{
			return this.displayObject.scrollRect ? this.displayObject.scrollRect.height : this.displayObject.height;
		}
		
		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			var scroll:Number = this.scrollV;
			var rect:Rectangle = this.displayObject.scrollRect;
			rect.height = value;
			this.displayObject.scrollRect = rect;
			this.scrollV = scroll;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentHeight():Number
		{
			if (this._scrollPane && !isNaN(this._scrollPane.contentHeight))
			{
				return this._scrollPane.contentHeight + this._marginTop + this._marginBottom;
			}
			return this.displayObject.transform.pixelBounds.height / this.displayObject.transform.concatenatedMatrix.d + this._marginTop + this._marginBottom;
		}

		/**
		 * @inheritDoc
		 */
		public function scrollUp():void
		{
			this.scrollVTo(this.scrollV - this._stepSizeV);
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollDown():void
		{
			this.scrollVTo(this.scrollV + this._stepSizeV);
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollLeft():void
		{
			this.scrollHTo(this.scrollH - this._stepSizeH);
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollRight():void
		{
			this.scrollHTo(this.scrollH + this._stepSizeH);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get canScrollUp():Boolean
		{
			return (isNaN(this._targetScrollV) ? this.scrollV : this._targetScrollV) > 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollDown():Boolean
		{
			return (isNaN(this._targetScrollV) ? this.scrollV : this._targetScrollV) < this.maxScrollV;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollLeft():Boolean
		{
			return (isNaN(this._targetScrollH) ? this.scrollH : this._targetScrollH) > 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollRight():Boolean
		{
			return (isNaN(this._targetScrollH) ? this.scrollH : this._targetScrollH) < this.maxScrollH;
		}
		
		/**
		 * IPropertyProxy that is used for scrolling
		 */
		public function get scrollProxy():IPropertyProxy
		{
			return this._scrollProxy;
		}
		
		/**
		 * @private
		 */
		public function set scrollProxy(value:IPropertyProxy):void
		{
			this._scrollProxy = value;
		}

		/**
		 * Indicates if the scroll values should be rounded to pixels. Default: true
		 */
		public function get snapToPixel():Boolean
		{
			return this._snapToPixel;
		}
		
		/**
		 * @private
		 */
		public function set snapToPixel(value:Boolean):void
		{
			this._snapToPixel = value;
		}
		
		/**
		 * Get or set the speed of the scrolling by mouse wheel. If NaN the value of stepSizeV is used.
		 */
		public function get mouseWheelScrollSpeed():Number
		{
			return this._mouseWheelScrollSpeed;
		}
		
		/**
		 * @private
		 */
		public function set mouseWheelScrollSpeed(value:Number):void
		{
			this._mouseWheelScrollSpeed = value;
		}
		
		/**
		 * A Boolean value that indicates if the ScrollPane is automaticly scrolled when the user rolls the mouse wheel over the pane.
		 * By default, this value is true.
		 */
		public function get mouseWheelEnabled():Boolean
		{
			return this._mouseWheelEnabled;
		}
		
		/**
		 * @private
		 */
		public function set mouseWheelEnabled(value:Boolean):void
		{
			this._mouseWheelEnabled = value;
		}
		
		/**
		 * Get or set all margins (left, right, top, bottom) at once. If margins are not equal, NaN is returned
		 */
		public function get margin():Number
		{
			return this._marginTop == this._marginBottom && this._marginTop == this._marginLeft && this._marginTop == this._marginRight ? this._marginTop : NaN;
		}
		
		/**
		 * @private
		 */
		public function set margin(value:Number):void
		{
			this.marginTop = this.marginBottom = this.marginLeft = this.marginRight = value;
		}

		/**
		 * Margin at the top of the content
		 */
		public function get marginTop():Number
		{
			return this._marginTop;
		}
		
		/**
		 * @private
		 */
		public function set marginTop(value:Number):void
		{
			if (isNaN(value)) value = 0;
			var scrollV:Number = this.scrollV;
			this._marginTop = value;
			if (!isNaN(scrollV)) this.scrollV = scrollV;
			this.displayObject.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Margin at the bottom of the content
		 */
		public function get marginBottom():Number
		{
			return this._marginBottom;
		}
		
		/**
		 * @private
		 */
		public function set marginBottom(value:Number):void
		{
			if (isNaN(value)) value = 0;
			var scrollV:Number = this.scrollV;
			this._marginBottom = value;
			if (!isNaN(scrollV)) this.scrollV = scrollV;
			this.displayObject.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Margin at the left side of the content
		 */
		public function get marginLeft():Number
		{
			return this._marginLeft;
		}
		
		/**
		 * @private
		 */
		public function set marginLeft(value:Number):void
		{
			if (isNaN(value)) value = 0;
			var scrollH:Number = this.scrollH;
			this._marginLeft = value;
			if (!isNaN(scrollH)) this.scrollH = scrollH;
			this.displayObject.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Margin at the right side of the content
		 */
		public function get marginRight():Number
		{
			return this._marginRight;
		}
		
		/**
		 * @private
		 */
		public function set marginRight(value:Number):void
		{
			if (isNaN(value)) value = 0;
			var scrollH:Number = this.scrollH;
			this._marginRight = value;
			if (!isNaN(scrollH)) this.scrollH = scrollH;
			this.displayObject.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Size of one horizontal scroll step
		 */
		public function get stepSizeH():Number
		{
			return this._stepSizeH;
		}
		
		/**
		 * @private
		 */
		public function set stepSizeH(value:Number):void
		{
			this._stepSizeH = value;
		}
		
		/**
		 * Size of one vertical scroll step
		 */
		public function get stepSizeV():Number
		{
			return this._stepSizeV;
		}
		
		/**
		 * @private
		 */
		public function set stepSizeV(value:Number):void
		{
			this._stepSizeV = value;
		}
		
		/**
		 * Indicates if the scrollHTo and scrollVTo should be rounded by the 
		 */
		public function get snapToStep():Boolean
		{
			return this._snapToStep;
		}
		
		/**
		 * @private
		 */
		public function set snapToStep(value:Boolean):void
		{
			this._snapToStep = value;
		}
		
		/**
		 * A Boolean which indicates if the scrolling is limited to the size of the content.
		 * @default true
		 */
		public function get limit():Boolean
		{
			return this._limit;
		}

		/**
		 * @private
		 */
		public function set limit(value:Boolean):void
		{
			this._limit = value;
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
		}

		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			this._enabled = true;
		}

		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			this._enabled = false;
		}
		
		private function handleMouseWheel(event:MouseEvent):void
		{
			if (this._mouseWheelEnabled && this._enabled)
			{
				var scrollV:Number = this.scrollV - event.delta * (!isNaN(this._mouseWheelScrollSpeed) ? this._mouseWheelScrollSpeed : this._stepSizeV);
				this.scrollVTo(scrollV);
			}
		}
		
		private function handleScrollEvent(event:ScrollEvent):void
		{
			this.dispatchEvent(event.clone());
		}
		
		private function handleTargetResize(event:Event):void
		{
			this.dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			delete ScrollBehavior._dictionary[this.target];
			
			this._scrollProxy = null;
			
			if (this.displayObject)
			{
				this.displayObject.removeEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouseWheel);
				this.displayObject.removeEventListener(ScrollEvent.SCROLL, this.handleScrollEvent);
				this.displayObject.removeEventListener(Event.RESIZE, this.handleTargetResize);
			}
			this._scrollPane = null;
			
			super.destruct();
		}
	}
}
