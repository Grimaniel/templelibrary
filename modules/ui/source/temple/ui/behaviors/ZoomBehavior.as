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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
	 * The ZoomBehavior makes it possible to zoom in or out on a DisplayObject. The ZoomBehavior uses the decorator pattern,
	 * so you won't have to change the code of the DisplayObject. The DisplayObject can be zoomed by using code or the MouseWheel.
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
	 * <p>It is not nessessary to store a reference to the ZoomBehavior since the ZoomBehavior is automatically destructed
	 * if the DisplayObject is destructed.</p>
	 * 
	 * @author Arjan van Wijk
	 */
	public class ZoomBehavior extends BoundsBehavior 
	{
		private var _zoom:Number;
		private var _minZoom:Number;
		private var _maxZoom:Number;
		private var _newScale:Number;
		private var _newX:Number;
		private var _newY:Number;
		private var _running:Boolean;

		/**
		 * @param target The target to zoom
		 * @param minZoom Minimal zoom ratio (ie. 0.25)
		 * @param maxZoom Maximal zoom ratio (ie. 8)
		 */
		public function ZoomBehavior(target:DisplayObject, bounds:Rectangle = null, minZoom:Number = 1, maxZoom:Number = 4) 
		{
			super(target, bounds);
			
			this._minZoom = minZoom;
			this._maxZoom = maxZoom;
			
			this._zoom = 0;
			
			this._newScale = target.scaleX;
			this._newX = target.x;
			this._newY = target.y;
			
			target.addEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouseWheel);
			
			this._running = false;
			
			// dispath ZoomBehaviorEvent on target
			this.addEventListener(ZoomBehaviorEvent.ZOOM_START, target.dispatchEvent);
			this.addEventListener(ZoomBehaviorEvent.ZOOM_STOP, target.dispatchEvent);
			this.addEventListener(ZoomBehaviorEvent.ZOOMING, target.dispatchEvent);
		}

		/**
		 * Zooms to a specific zoom level
		 * @param zoom the level to zoom to
		 * @param useCenter indicates if the zooming should be calculated from the center of the object (true) or the current mouse position (false), default: false
		 */
		public function zoomTo(zoom:Number, useCenter:Boolean = false):void
		{
			this._zoom = Math.log(zoom) / Math.log(2);
			this.updateZoom(useCenter);
		}

		/**
		 * Stops the zooming
		 */
		public function stopZoom():void
		{
			if (this._running == true)
			{
				this._running = false;
				this.displayObject.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this.dispatchEvent(new ZoomBehaviorEvent(ZoomBehaviorEvent.ZOOM_STOP, this));
			}
		}

		/**
		 * The minimal zoom
		 */
		public function get minZoom():Number
		{
			return this._minZoom;
		}

		/**
		 * @private
		 */
		public function set minZoom(minZoom:Number):void
		{
			this._minZoom = minZoom;
		}

		/**
		 * The maximal zoom
		 */
		public function get maxZoom():Number
		{
			return this._maxZoom;
		}

		/**
		 * @private
		 */
		public function set maxZoom(maxZoom:Number):void
		{
			this._maxZoom = maxZoom;
		}

		/**
		 * The current zoom
		 */
		public function get zoom():Number
		{
			return Math.pow(2, this._zoom);
		}

		/**
		 * @private
		 */
		public function set zoom(zoom:Number):void
		{
			this._zoom = Math.log(zoom) / Math.log(2);
			this.updateZoom();
		}

		/**
		 * The current zoomLevel
		 */
		public function get zoomLevel():Number
		{
			return this._zoom;
		}

		/**
		 * @private
		 */
		protected function handleEnterFrame(event:Event):void
		{
			this.displayObject.scaleX = this.displayObject.scaleY += (this._newScale - this.displayObject.scaleY) / 5;
			this.displayObject.x += (this._newX - this.displayObject.x) / 5;
			this.displayObject.y += (this._newY - this.displayObject.y) / 5;
			
			this.dispatchEvent(new ZoomBehaviorEvent(ZoomBehaviorEvent.ZOOMING, this));
			
			if (Math.abs(this.displayObject.scaleX - this._newScale) < .01)
			{
				this.displayObject.scaleX = this.displayObject.scaleY = this._newScale;
				this.displayObject.x = this._newX;
				this.displayObject.y = this._newY;
				this.stopZoom();
			}
			this.keepInBounds();
		}

		/**
		 * @private
		 */
		protected function handleMouseWheel(event:MouseEvent):void
		{
			this._zoom += (event.delta / 3) / 4;
			this.updateZoom();
		}

		/**
		 * @private
		 */
		protected function updateZoom(useCenter:Boolean = false):void
		{
			var rect:Rectangle = this.displayObject.getRect(this.target as DisplayObject);
			var rX:Number = useCenter ? rect.x/rect.width + .5 : (this.displayObject.mouseX * this.displayObject.scaleX) / this.displayObject.width;
			var rY:Number = useCenter ? rect.y/rect.height + .5 : (this.displayObject.mouseY * this.displayObject.scaleY) / this.displayObject.height;
			
			var prevW:Number = this.displayObject.width;
			var prevH:Number = this.displayObject.height;
			
			this._newScale = Math.max(this._minZoom, Math.min(this._maxZoom, Math.pow(2, this._zoom)));
			
			this._zoom = Math.log(this._newScale) / Math.log(2);
			
			this._newX = this.displayObject.x + rX * (prevW - (this.displayObject.width / this.displayObject.scaleX * this._newScale));
			this._newY = this.displayObject.y + rY * (prevH - (this.displayObject.height / this.displayObject.scaleY * this._newScale));
			
			if (this._running == false)
			{
				this._running = true;
				this.displayObject.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame, false, 0, true);
				this.dispatchEvent(new ZoomBehaviorEvent(ZoomBehaviorEvent.ZOOM_START, this));
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.target) this.displayObject.removeEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouseWheel);
			if (this._running) this.stopZoom();
			super.destruct();
		}
	}
}
