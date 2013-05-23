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
			
			_scrollPane = scrollPane || target as IScrollPane; 
			_snapToPixel = snapToPixel;
			
			target.scrollRect = scrollRect;
			target.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			target.addEventListener(ScrollEvent.SCROLL, handleScrollEvent);
			target.addEventListener(Event.RESIZE, handleTargetResize);
			target.addEventListener(Event.ADDED, handleTargetResize);
			target.addEventListener(Event.REMOVED, handleTargetResize);
		}
		
		/**
		 * Returns a reference to the ScrollPane
		 */
		public function get scrollPane():IScrollPane
		{
			return _scrollPane;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollH():Number
		{
			return displayObject && displayObject.scrollRect ? displayObject.scrollRect.x + _marginLeft : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set scrollH(value:Number):void
		{
			if (!_enabled) return;
			if (isNaN(value)) throwError(new TempleArgumentError(this, "scrollH can not be set to NaN"));
			
			// limit value
			if (_limit) value = Math.max(Math.min(value, maxScrollH), 0);
			
			// margin
			value -= _marginLeft;
			
			var rect:Rectangle = displayObject.scrollRect;
			rect.x = _snapToPixel ? Math.round(value) : value;;
			displayObject.scrollRect = rect;
			
			displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, value, NaN, maxScrollH, maxScrollV));
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollHTo(value:Number):void
		{
			if (!_enabled) return;
			_targetScrollH = value;
			
			if (_snapToStep) _targetScrollH = NumberUtils.roundToNearest(_targetScrollH, _stepSizeH);
			
			// limit value
			if (_limit) _targetScrollH = Math.max(Math.min(_targetScrollH, maxScrollH), 0);
			
			if (_scrollProxy)
			{
				_scrollProxy.setValue(this, "scrollH", _targetScrollH);
			}
			else if (ScrollBehavior._scrollProxy)
			{
				ScrollBehavior._scrollProxy.setValue(this, "scrollH", _targetScrollH);
			}
			else
			{
				scrollH = _targetScrollH;
			}
			displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, _targetScrollH, NaN, maxScrollH, maxScrollV));
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
			return Math.max(contentWidth - width, 0);
		}

		/**
		 * @inheritDoc
		 */
		public function get scrollV():Number
		{
			return displayObject && displayObject.scrollRect ? displayObject.scrollRect.y + _marginTop : NaN;
		}

		/**
		 * @inheritDoc
		 */
		public function set scrollV(value:Number):void
		{
			if (!_enabled) return;
			if (isNaN(value)) throwError(new TempleArgumentError(this, "scrollV can not be set to NaN"));
			
			// limit value
			if (_limit) value = Math.max(Math.min(value, maxScrollV), 0);
			
			// margin
			value -= _marginTop;
			
			var rect:Rectangle = displayObject.scrollRect;
			rect.y = _snapToPixel ? Math.round(value) : value;
			displayObject.scrollRect = rect;
			
			displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, NaN, value, maxScrollH, maxScrollV));
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollVTo(value:Number):void
		{
			if (!_enabled) return;
			_targetScrollV = value;
			
			if (_snapToStep) _targetScrollV = NumberUtils.roundToNearest(_targetScrollV, _stepSizeV);
			
			// limit value
			if (_limit) _targetScrollV = Math.max(Math.min(_targetScrollV, maxScrollV), 0);
			
			if (_scrollProxy)
			{
				_scrollProxy.setValue(this, "scrollV", _targetScrollV);
			}
			else if (ScrollBehavior._scrollProxy)
			{
				ScrollBehavior._scrollProxy.setValue(this, "scrollV", _targetScrollV);
			}
			else
			{
				scrollV = _targetScrollV;
			}
			displayObject.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, NaN, _targetScrollV, maxScrollH, maxScrollV));
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
			return Math.max(contentHeight - height, 0);
		}

		/**
		 * @inheritDoc
		 */
		public function get width():Number
		{
			return displayObject.scrollRect ? displayObject.scrollRect.width : displayObject.width;
		}

		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			var scroll:Number = scrollH;
			var rect:Rectangle = displayObject.scrollRect;
			rect.width = value;
			displayObject.scrollRect = rect;
			scrollH = scroll;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentWidth():Number
		{
			if (_scrollPane)
			{
				return _scrollPane.contentWidth + _marginLeft + _marginRight;
			}
			return displayObject.transform.pixelBounds.width / displayObject.transform.concatenatedMatrix.a + _marginLeft + _marginRight;
		}

		/**
		 * @inheritDoc
		 */
		public function get height():Number
		{
			return displayObject.scrollRect ? displayObject.scrollRect.height : displayObject.height;
		}
		
		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			var scroll:Number = scrollV;
			var rect:Rectangle = displayObject.scrollRect;
			rect.height = value;
			displayObject.scrollRect = rect;
			scrollV = scroll;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentHeight():Number
		{
			if (_scrollPane && !isNaN(_scrollPane.contentHeight))
			{
				return _scrollPane.contentHeight + _marginTop + _marginBottom;
			}
			return displayObject.transform.pixelBounds.height / displayObject.transform.concatenatedMatrix.d + _marginTop + _marginBottom;
		}

		/**
		 * @inheritDoc
		 */
		public function scrollUp():void
		{
			scrollVTo(scrollV - _stepSizeV);
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollDown():void
		{
			scrollVTo(scrollV + _stepSizeV);
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollLeft():void
		{
			scrollHTo(scrollH - _stepSizeH);
		}
		
		/**
		 * @inheritDoc
		 */
		public function scrollRight():void
		{
			scrollHTo(scrollH + _stepSizeH);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get canScrollUp():Boolean
		{
			return (isNaN(_targetScrollV) ? scrollV : _targetScrollV) > 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollDown():Boolean
		{
			return (isNaN(_targetScrollV) ? scrollV : _targetScrollV) < maxScrollV;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollLeft():Boolean
		{
			return (isNaN(_targetScrollH) ? scrollH : _targetScrollH) > 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollRight():Boolean
		{
			return (isNaN(_targetScrollH) ? scrollH : _targetScrollH) < maxScrollH;
		}
		
		/**
		 * IPropertyProxy that is used for scrolling
		 */
		public function get scrollProxy():IPropertyProxy
		{
			return _scrollProxy;
		}
		
		/**
		 * @private
		 */
		public function set scrollProxy(value:IPropertyProxy):void
		{
			_scrollProxy = value;
		}

		/**
		 * Indicates if the scroll values should be rounded to pixels. Default: true
		 */
		public function get snapToPixel():Boolean
		{
			return _snapToPixel;
		}
		
		/**
		 * @private
		 */
		public function set snapToPixel(value:Boolean):void
		{
			_snapToPixel = value;
		}
		
		/**
		 * Get or set the speed of the scrolling by mouse wheel. If NaN the value of stepSizeV is used.
		 */
		public function get mouseWheelScrollSpeed():Number
		{
			return _mouseWheelScrollSpeed;
		}
		
		/**
		 * @private
		 */
		public function set mouseWheelScrollSpeed(value:Number):void
		{
			_mouseWheelScrollSpeed = value;
		}
		
		/**
		 * A Boolean value that indicates if the ScrollPane is automaticly scrolled when the user rolls the mouse wheel over the pane.
		 * By default, this value is true.
		 */
		public function get mouseWheelEnabled():Boolean
		{
			return _mouseWheelEnabled;
		}
		
		/**
		 * @private
		 */
		public function set mouseWheelEnabled(value:Boolean):void
		{
			_mouseWheelEnabled = value;
		}
		
		/**
		 * Get or set all margins (left, right, top, bottom) at once. If margins are not equal, NaN is returned
		 */
		public function get margin():Number
		{
			return _marginTop == _marginBottom && _marginTop == _marginLeft && _marginTop == _marginRight ? _marginTop : NaN;
		}
		
		/**
		 * @private
		 */
		public function set margin(value:Number):void
		{
			marginTop = marginBottom = marginLeft = marginRight = value;
		}

		/**
		 * Margin at the top of the content
		 */
		public function get marginTop():Number
		{
			return _marginTop;
		}
		
		/**
		 * @private
		 */
		public function set marginTop(value:Number):void
		{
			if (isNaN(value)) value = 0;
			var scrollV:Number = scrollV;
			_marginTop = value;
			if (!isNaN(scrollV)) this.scrollV = scrollV;
			displayObject.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Margin at the bottom of the content
		 */
		public function get marginBottom():Number
		{
			return _marginBottom;
		}
		
		/**
		 * @private
		 */
		public function set marginBottom(value:Number):void
		{
			if (isNaN(value)) value = 0;
			var scrollV:Number = scrollV;
			_marginBottom = value;
			if (!isNaN(scrollV)) this.scrollV = scrollV;
			displayObject.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Margin at the left side of the content
		 */
		public function get marginLeft():Number
		{
			return _marginLeft;
		}
		
		/**
		 * @private
		 */
		public function set marginLeft(value:Number):void
		{
			if (isNaN(value)) value = 0;
			var scrollH:Number = scrollH;
			_marginLeft = value;
			if (!isNaN(scrollH)) this.scrollH = scrollH;
			displayObject.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Margin at the right side of the content
		 */
		public function get marginRight():Number
		{
			return _marginRight;
		}
		
		/**
		 * @private
		 */
		public function set marginRight(value:Number):void
		{
			if (isNaN(value)) value = 0;
			var scrollH:Number = scrollH;
			_marginRight = value;
			if (!isNaN(scrollH)) this.scrollH = scrollH;
			displayObject.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * Size of one horizontal scroll step
		 */
		public function get stepSizeH():Number
		{
			return _stepSizeH;
		}
		
		/**
		 * @private
		 */
		public function set stepSizeH(value:Number):void
		{
			_stepSizeH = value;
		}
		
		/**
		 * Size of one vertical scroll step
		 */
		public function get stepSizeV():Number
		{
			return _stepSizeV;
		}
		
		/**
		 * @private
		 */
		public function set stepSizeV(value:Number):void
		{
			_stepSizeV = value;
		}
		
		/**
		 * Indicates if the scrollHTo and scrollVTo should be rounded by the 
		 */
		public function get snapToStep():Boolean
		{
			return _snapToStep;
		}
		
		/**
		 * @private
		 */
		public function set snapToStep(value:Boolean):void
		{
			_snapToStep = value;
		}
		
		/**
		 * A Boolean which indicates if the scrolling is limited to the size of the content.
		 * @default true
		 */
		public function get limit():Boolean
		{
			return _limit;
		}

		/**
		 * @private
		 */
		public function set limit(value:Boolean):void
		{
			_limit = value;
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
			_enabled = value;
		}

		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			_enabled = true;
		}

		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			_enabled = false;
		}
		
		private function handleMouseWheel(event:MouseEvent):void
		{
			if (_mouseWheelEnabled && _enabled)
			{
				var scrollV:Number = scrollV - event.delta * (!isNaN(_mouseWheelScrollSpeed) ? _mouseWheelScrollSpeed : _stepSizeV);
				scrollVTo(scrollV);
			}
		}
		
		private function handleScrollEvent(event:ScrollEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function handleTargetResize(event:Event):void
		{
			dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			delete ScrollBehavior._dictionary[target];
			
			_scrollProxy = null;
			
			if (displayObject)
			{
				displayObject.removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
				displayObject.removeEventListener(ScrollEvent.SCROLL, handleScrollEvent);
				displayObject.removeEventListener(Event.RESIZE, handleTargetResize);
			}
			_scrollPane = null;
			
			super.destruct();
		}
	}
}
