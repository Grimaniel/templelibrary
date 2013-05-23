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

package temple.ui.behaviors 
{
	import temple.core.debug.IDebuggable;
	import temple.ui.Dot;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @eventType temple.ui.behaviors.ZoomBehaviorEvent.ZOOMING
	 */
	[Event(name = "ZoomBehaviorEvent.zooming", type = "temple.ui.behaviors.ZoomBehaviorEvent")]
	
	/**
	 * @eventType temple.ui.behaviors.ZoomBehaviorEvent.ZOOM_START
	 */
	[Event(name = "ZoomBehaviorEvent.zoomStart", type = "temple.ui.behaviors.ZoomBehaviorEvent")]
	
	/**
	 * @eventType temple.ui.behaviors.ZoomBehaviorEvent.ZOOM_STOP
	 */
	[Event(name = "ZoomBehaviorEvent.zoomStop", type = "temple.ui.behaviors.ZoomBehaviorEvent")]
	
	/**
	 * The ZoomBehavior makes it possible to zoom in or out on a DisplayObject. The ZoomBehavior uses the decorator
	 * pattern, so you won't have to change the code of the DisplayObject. The DisplayObject can be zoomed by using code
	 * or the MouseWheel.
	 * 
	 * <p>If you have a MovieClip called 'mcClip' add ZoomBehavior like:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new ZoomBehavior(mcClip);
	 * </listing> 
	 * 
	 * <p>If you want to limit the zooming to a specific bounds, you can add a Rectangle. By adding the
	 * Reactangle you won't be able to zoom the DisplayObject outside the Rectangle:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new ZoomBehavior(mcClip, new Reactangle(100, 100, 200, 200);
	 * </listing>
	 *
	 * <p>It is not nessessary to store a reference to the ZoomBehavior since the ZoomBehavior is automatically
	 * destructed if the DisplayObject is destructed.</p>
	 * 
	 * @author Arjan van Wijk, Thijs Broerse
	 */
	public class ZoomBehavior extends BoundsBehavior implements IDebuggable
	{
		private var _zoomLevel:Number;
		private var _minZoom:Number;
		private var _maxZoom:Number;
		private var _newScale:Number;
		private var _newX:Number;
		private var _newY:Number;
		private var _running:Boolean;
		private var _debug:Boolean;
		private var _dot:Dot;

		/**
		 * @param target The target to zoom
		 * @param minZoom Minimal zoom ratio (ie. 0.25)
		 * @param maxZoom Maximal zoom ratio (ie. 8)
		 */
		public function ZoomBehavior(target:DisplayObject, bounds:Rectangle = null, minZoom:Number = 1, maxZoom:Number = 4) 
		{
			super(target, bounds);
			
			_minZoom = minZoom;
			_maxZoom = maxZoom;
			
			_zoomLevel = 0;
			
			_newScale = target.scaleX;
			_newX = target.x;
			_newY = target.y;
			
			target.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			
			_running = false;
			
			// dispath ZoomBehaviorEvent on target
			addEventListener(ZoomBehaviorEvent.ZOOM_START, target.dispatchEvent);
			addEventListener(ZoomBehaviorEvent.ZOOM_STOP, target.dispatchEvent);
			addEventListener(ZoomBehaviorEvent.ZOOMING, target.dispatchEvent);
		}

		/**
		 * Zooms to a specific zoom level
		 * @param zoom the level to zoom to
		 * @param center a point which is used as the center of the zooming, if null the center of the object is used.
		 */
		public function zoomTo(zoom:Number, point:Point = null):void
		{
			_zoomLevel = Math.log(zoom) / Math.log(2);
			updateZoom(point || getCenter());
		}

		/**
		 * Stops the zooming
		 */
		public function stopZoom():void
		{
			if (_running)
			{
				_running = false;
				displayObject.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				dispatchEvent(new ZoomBehaviorEvent(ZoomBehaviorEvent.ZOOM_STOP, this));
			}
		}

		/**
		 * The minimal zoom
		 */
		public function get minZoom():Number
		{
			return _minZoom;
		}

		/**
		 * @private
		 */
		public function set minZoom(minZoom:Number):void
		{
			_minZoom = minZoom;
		}

		/**
		 * The maximal zoom
		 */
		public function get maxZoom():Number
		{
			return _maxZoom;
		}

		/**
		 * @private
		 */
		public function set maxZoom(maxZoom:Number):void
		{
			_maxZoom = maxZoom;
		}

		/**
		 * The current zoom
		 */
		public function get zoom():Number
		{
			return Math.pow(2, _zoomLevel);
		}

		/**
		 * @private
		 */
		public function set zoom(value:Number):void
		{
			_zoomLevel = Math.log(value) / Math.log(2);
			updateZoom(getCenter());
		}

		/**
		 * The current zoomLevel
		 */
		public function get zoomLevel():Number
		{
			return _zoomLevel;
		}

		/**
		 * Recalculates the zoom based on the targets current scale.
		 */
		public function recalculateZoom():void
		{
			_zoomLevel = Math.log(displayObject.scaleX) / Math.log(2);
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
		}

		/**
		 * @private
		 */
		protected function handleEnterFrame(event:Event):void
		{
			displayObject.scaleX = displayObject.scaleY += (_newScale - displayObject.scaleY) / 5;
			displayObject.x += (_newX - displayObject.x) / 5;
			displayObject.y += (_newY - displayObject.y) / 5;
			
			dispatchEvent(new ZoomBehaviorEvent(ZoomBehaviorEvent.ZOOMING, this));
			
			if (Math.abs(displayObject.scaleX - _newScale) < .01)
			{
				displayObject.scaleX = displayObject.scaleY = _newScale;
				displayObject.x = _newX;
				displayObject.y = _newY;
				stopZoom();
			}
			keepInBounds();
		}

		/**
		 * @private
		 */
		protected function handleMouseWheel(event:MouseEvent):void
		{
			_zoomLevel += (event.delta / 3) / 4;
			updateZoom(new Point((displayObject.mouseX * displayObject.scaleX) / displayObject.width, (displayObject.mouseY * displayObject.scaleY) / displayObject.height));
		}

		/**
		 * @private
		 */
		protected function updateZoom(point:Point):void
		{
			var prevW:Number = displayObject.width;
			var prevH:Number = displayObject.height;
			
			_newScale = Math.max(_minZoom, Math.min(_maxZoom, Math.pow(2, _zoomLevel)));
			
			_zoomLevel = Math.log(_newScale) / Math.log(2);
			
			_newX = displayObject.x + point.x * (prevW - (displayObject.width / displayObject.scaleX * _newScale));
			_newY = displayObject.y + point.y * (prevH - (displayObject.height / displayObject.scaleY * _newScale));
			
			if (_running == false)
			{
				_running = true;
				displayObject.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
				dispatchEvent(new ZoomBehaviorEvent(ZoomBehaviorEvent.ZOOM_START, this));
			}
			dispatchEvent(new Event(Event.CHANGE));
			
			if (_debug)
			{
				_dot ||= new Dot();
				
				DisplayObjectContainer(displayObject).addChild(_dot);
				_dot.x = point.x * (displayObject.width / displayObject.scaleX);
				_dot.y = point.y * (displayObject.height / displayObject.scaleY);
				_dot.scaleX = 1 / displayObject.scaleX;
				_dot.scaleY = 1 / displayObject.scaleY;
				
				logDebug("Zoom: " + point.x + ", " + point.y);
			}
			else if (_dot && _dot.parent)
			{
				 _dot.parent.removeChild(_dot);
			}
		}

		private function getCenter():Point
		{
			var rect:Rectangle = displayObject.getRect(displayObject);
			return new Point(rect.x/rect.width + .5, rect.y/rect.height + .5);
		}


		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (target) displayObject.removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			if (_running) stopZoom();
			super.destruct();
		}
	}
}
