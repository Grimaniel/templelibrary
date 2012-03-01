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
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	/**
	 * Makes a DisplayObject scalable by mouse.
	 * 
	 * @includeExample ScaleBehaviorExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ScaleBehavior extends AbstractDisplayObjectBehavior
	{
		private var _scaleButton:DisplayObject;
		private var _startScaleMousePoint:Point;
		private var _startScaleRegistrationPoint:Point;
		private var _registrationPoint:Point;
		private var _startScaleObjectPoint:Point;
		private var _startScaleX:Number;
		private var _startScaleY:Number;
		private var _keepAspectRatio:Boolean;
		private var _scaleVertical:Boolean;
		private var _scaleHorizontal:Boolean;
		private var _useScale:Boolean;

		/**
		 * @param target the object that must be scaled
		 * @param scaleButton: dragbutton for scaling 
		 */
		public function ScaleBehavior(target:InteractiveObject, scaleButton:InteractiveObject, registrationPoint:Point = null, keepAspectRatio:Boolean = false, scaleHorizontal:Boolean = true, scaleVertical:Boolean = true, useScale:Boolean = true) 
		{
			super(target);
			
			this._scaleButton = scaleButton;
			this._registrationPoint = registrationPoint ||  new Point(0, 0);
			
			this._keepAspectRatio = keepAspectRatio;
			this._scaleButton.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown, false, 0, true);
			this._scaleHorizontal = scaleHorizontal;
			this._scaleVertical = scaleVertical;
			this._useScale = useScale;
			
			// dispath ScaleBehaviorEvent on target
			this.addEventListener(ScaleBehaviorEvent.SCALE_START, target.dispatchEvent);
			this.addEventListener(ScaleBehaviorEvent.SCALE_STOP, target.dispatchEvent);
			this.addEventListener(ScaleBehaviorEvent.SCALING, target.dispatchEvent);
		}
		
		/**
		 * A Boolean which indicates if the scaleX and scaleY are adjusted (true) or the width and height (false). Default: true
		 */
		public function get useScale():Boolean
		{
			return this._useScale;
		}

		/**
		 * @private
		 */
		public function set useScale(value:Boolean):void
		{
			this._useScale = value;
		}
		
		/**
		 * Get or set horizontal scaling on (true) or off (false)
		 */
		public function get scaleHorizontal():Boolean
		{
			return this._scaleHorizontal;
		}
		
		/**
		 * @private
		 */
		public function set scaleHorizontal(value:Boolean):void
		{
			this._scaleHorizontal = value;
		}

		/**
		 * Get or set vertical scaling on (true) or off (false)
		 */
		public function get scaleVertical():Boolean
		{
			return this._scaleVertical;
		}
		
		/**
		 * @private
		 */
		public function set scaleVertical(value:Boolean):void
		{
			this._scaleVertical = value;
		}
		
		private function handleMouseDown(event:MouseEvent):void 
		{
			this._startScaleMousePoint = new Point(this.displayObject.stage.mouseX, this.displayObject.stage.mouseY);
			this._startScaleRegistrationPoint = this.displayObject.localToGlobal(this._registrationPoint);
			this._startScaleObjectPoint = new Point(this.displayObject.x, this.displayObject.y);
			
			this.displayObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove, false, 0, true);
			this.displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp, false, 0, true);
			this.displayObject.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown, false, 0, true);
			this.displayObject.stage.addEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp, false, 0, true);
			this._scaleButton.addEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut, false, 0, true);
			
			this._startScaleX = this.displayObject.scaleX;
			this._startScaleY = this.displayObject.scaleY;
			
			event.stopPropagation();
			
			this.dispatchEvent(new ScaleBehaviorEvent(ScaleBehaviorEvent.SCALE_START, this));
		}

		private function handleMouseMove(event:MouseEvent):void 
		{
			// When shiftkey is pressed, keep aspect ratio
			this.scale(this._keepAspectRatio || event.shiftKey);
		}

		private function handleKeyDown(e:KeyboardEvent):void 
		{
			switch (e.keyCode)
			{
				case Keyboard.SHIFT:
					this.scale(true);
					break;
			}
		}

		private function handleKeyUp(event:KeyboardEvent):void 
		{
			switch (event.keyCode)
			{
				case Keyboard.SHIFT:
					scale(this._keepAspectRatio);
					break;
			}
		}

		private function scale(keepAspectRatio:Boolean):void 
		{
			if (this._useScale)
			{
				var scaleX:Number = (this._startScaleRegistrationPoint.x - this.displayObject.stage.mouseX) / (this._startScaleRegistrationPoint.x - this._startScaleMousePoint.x);
				var scaleY:Number = (this._startScaleRegistrationPoint.y - this.displayObject.stage.mouseY) / (this._startScaleRegistrationPoint.y - this._startScaleMousePoint.y);
				
				scaleX *= this._startScaleX;
				scaleY *= this._startScaleY;
				
				if (keepAspectRatio)
				{
					scaleX = scaleY = Math.min(scaleX, scaleY);
				}
				if (this._scaleHorizontal) this.displayObject.scaleX = scaleX;
				if (this._scaleVertical) this.displayObject.scaleY = scaleY;
			}
			else
			{
				if (this._scaleHorizontal) this.displayObject.width += this.displayObject.stage.mouseX - this._startScaleMousePoint.x;
				if (this._scaleVertical) this.displayObject.height += this.displayObject.stage.mouseY - this._startScaleMousePoint.y;
				this._startScaleMousePoint = new Point(this.displayObject.stage.mouseX, this.displayObject.stage.mouseY);
			}
			
			// move scale object to keep registration point in place
			this.displayObject.x -= (this.displayObject.localToGlobal(this._registrationPoint).x - this._startScaleRegistrationPoint.x);
			this.displayObject.y -= (this.displayObject.localToGlobal(this._registrationPoint).y - this._startScaleRegistrationPoint.y);
			
			this.dispatchEvent(new ScaleBehaviorEvent(ScaleBehaviorEvent.SCALING, this));
		}

		private function handleMouseUp(event:MouseEvent):void 
		{
			this.displayObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
			this.displayObject.stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			this.displayObject.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
			this.displayObject.stage.removeEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp);
			this._scaleButton.removeEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut);
			this.dispatchEvent(new ScaleBehaviorEvent(ScaleBehaviorEvent.SCALE_STOP, this));
		}

		/**
		 * Stop rollout event to prevent the object getting a rollout animation
		 */
		private function handleMouseOut(event:MouseEvent):void 
		{
			event.stopPropagation();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._scaleButton)
			{
				this._scaleButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
				this._scaleButton.removeEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut);
				this._scaleButton = null;
			}
			
			if (this.displayObject && this.displayObject.stage)
			{
				this.displayObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
				this.displayObject.stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
				this.displayObject.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
				this.displayObject.stage.removeEventListener(KeyboardEvent.KEY_UP, this.handleKeyUp);
			}
			
			this._startScaleMousePoint = null;
			this._startScaleRegistrationPoint = null;
			this._registrationPoint = null;
			this._startScaleObjectPoint = null;
			
			super.destruct();
		}
	}
}
