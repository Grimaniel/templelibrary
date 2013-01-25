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
			
			_scaleButton = scaleButton;
			_registrationPoint = registrationPoint ||  new Point(0, 0);
			
			_keepAspectRatio = keepAspectRatio;
			_scaleButton.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			_scaleHorizontal = scaleHorizontal;
			_scaleVertical = scaleVertical;
			_useScale = useScale;
			
			// dispath ScaleBehaviorEvent on target
			addEventListener(ScaleBehaviorEvent.SCALE_START, target.dispatchEvent);
			addEventListener(ScaleBehaviorEvent.SCALE_STOP, target.dispatchEvent);
			addEventListener(ScaleBehaviorEvent.SCALING, target.dispatchEvent);
		}
		
		/**
		 * A Boolean which indicates if the scaleX and scaleY are adjusted (true) or the width and height (false). Default: true
		 */
		public function get useScale():Boolean
		{
			return _useScale;
		}

		/**
		 * @private
		 */
		public function set useScale(value:Boolean):void
		{
			_useScale = value;
		}
		
		/**
		 * Get or set horizontal scaling on (true) or off (false)
		 */
		public function get scaleHorizontal():Boolean
		{
			return _scaleHorizontal;
		}
		
		/**
		 * @private
		 */
		public function set scaleHorizontal(value:Boolean):void
		{
			_scaleHorizontal = value;
		}

		/**
		 * Get or set vertical scaling on (true) or off (false)
		 */
		public function get scaleVertical():Boolean
		{
			return _scaleVertical;
		}
		
		/**
		 * @private
		 */
		public function set scaleVertical(value:Boolean):void
		{
			_scaleVertical = value;
		}
		
		private function handleMouseDown(event:MouseEvent):void 
		{
			_startScaleMousePoint = new Point(displayObject.stage.mouseX, displayObject.stage.mouseY);
			_startScaleRegistrationPoint = displayObject.localToGlobal(_registrationPoint);
			_startScaleObjectPoint = new Point(displayObject.x, displayObject.y);
			
			displayObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true);
			displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			displayObject.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
			displayObject.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp, false, 0, true);
			_scaleButton.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true);
			
			_startScaleX = displayObject.scaleX;
			_startScaleY = displayObject.scaleY;
			
			event.stopPropagation();
			
			dispatchEvent(new ScaleBehaviorEvent(ScaleBehaviorEvent.SCALE_START, this));
		}

		private function handleMouseMove(event:MouseEvent):void 
		{
			// When shiftkey is pressed, keep aspect ratio
			scale(_keepAspectRatio || event.shiftKey);
		}

		private function handleKeyDown(e:KeyboardEvent):void 
		{
			switch (e.keyCode)
			{
				case Keyboard.SHIFT:
					scale(true);
					break;
			}
		}

		private function handleKeyUp(event:KeyboardEvent):void 
		{
			switch (event.keyCode)
			{
				case Keyboard.SHIFT:
					scale(_keepAspectRatio);
					break;
			}
		}

		private function scale(keepAspectRatio:Boolean):void 
		{
			if (_useScale)
			{
				var scaleX:Number = (_startScaleRegistrationPoint.x - displayObject.stage.mouseX) / (_startScaleRegistrationPoint.x - _startScaleMousePoint.x);
				var scaleY:Number = (_startScaleRegistrationPoint.y - displayObject.stage.mouseY) / (_startScaleRegistrationPoint.y - _startScaleMousePoint.y);
				
				scaleX *= _startScaleX;
				scaleY *= _startScaleY;
				
				if (keepAspectRatio)
				{
					scaleX = scaleY = Math.min(scaleX, scaleY);
				}
				if (_scaleHorizontal) displayObject.scaleX = scaleX;
				if (_scaleVertical) displayObject.scaleY = scaleY;
			}
			else
			{
				if (_scaleHorizontal) displayObject.width += displayObject.stage.mouseX - _startScaleMousePoint.x;
				if (_scaleVertical) displayObject.height += displayObject.stage.mouseY - _startScaleMousePoint.y;
				_startScaleMousePoint = new Point(displayObject.stage.mouseX, displayObject.stage.mouseY);
			}
			
			// move scale object to keep registration point in place
			displayObject.x -= (displayObject.localToGlobal(_registrationPoint).x - _startScaleRegistrationPoint.x);
			displayObject.y -= (displayObject.localToGlobal(_registrationPoint).y - _startScaleRegistrationPoint.y);
			
			dispatchEvent(new ScaleBehaviorEvent(ScaleBehaviorEvent.SCALING, this));
		}

		private function handleMouseUp(event:MouseEvent):void 
		{
			displayObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			displayObject.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			displayObject.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			displayObject.stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			_scaleButton.removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			dispatchEvent(new ScaleBehaviorEvent(ScaleBehaviorEvent.SCALE_STOP, this));
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
			if (_scaleButton)
			{
				_scaleButton.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				_scaleButton.removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
				_scaleButton = null;
			}
			
			if (displayObject && displayObject.stage)
			{
				displayObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				displayObject.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
				displayObject.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				displayObject.stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			}
			
			_startScaleMousePoint = null;
			_startScaleRegistrationPoint = null;
			_registrationPoint = null;
			_startScaleObjectPoint = null;
			
			super.destruct();
		}
	}
}
