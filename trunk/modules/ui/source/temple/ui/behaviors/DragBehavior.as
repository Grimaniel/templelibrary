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
	import temple.utils.keys.KeyCode;
	import flash.events.KeyboardEvent;
	import temple.common.interfaces.IEnableable;
	import temple.utils.propertyproxy.IPropertyProxy;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @eventType temple.ui.behaviors.DragBehaviorEvent.DRAGGING
	 */
	[Event(name = "DragBehaviorEvent.dragging", type = "temple.ui.behaviors.DragBehaviorEvent")]
	
	/**
	 * @eventType temple.ui.behaviors.DragBehaviorEvent.DRAG_START
	 */
	[Event(name = "DragBehaviorEvent.dragStart", type = "temple.ui.behaviors.DragBehaviorEvent")]
	
	/**
	 * @eventType temple.ui.behaviors.DragBehaviorEvent.DRAG_STOP
	 */
	[Event(name = "DragBehaviorEvent.dragStop", type = "temple.ui.behaviors.DragBehaviorEvent")]
	
	/**
	 * The DragBehavior makes a DisplayObject draggable. The DragBehavior uses the decorator pattern,
	 * so you won't have to change the code of the DisplayObject.
	 * 
	 * <p>It is not nessessary to store a reference to the DragBehavior since the DragBehavior is automatically destructed
	 * when the DisplayObject is destructed.</p>
	 * 
	 * @example
	 * <p>If you have a MovieClip called 'mcClip' add DragBehavior like:</p>
	 * <listing version="3.0">
	 * new DragBehavior(mcClip);
	 * </listing> 
	 * 
	 * <p>If you want to limit the dragging to a specific bounds, you can add a Rectangle. By adding the
	 * Reactangle you won't be able to drag the DisplayObject outside the Rectangle:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new DragBehavior(mcClip, new Rectangle(100, 100, 200, 200);
	 * </listing>
	 *
	 * <p>It's also possible to define a child object as a 'DragButton'. A DragButton is a DisplayObject
	 * that is used to drag the target.</p>
	 * 
	 * <p>If you have a MovieClip called 'mcClip' with a child called 'mcDragButton' add DragBehavior like:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new DragBehavior(mcClip, null, mcClip.mcDragButton);
	 * </listing> 
	 * 
	 * @includeExample DragBehaviorExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class DragBehavior extends BoundsBehavior implements IEnableable
	{
		/** @private */
		protected var _startDragOffset:Point;
		/** @private */
		protected  var _isDragging:Boolean;
		
		private var _dragButton:InteractiveObject;
		private var _enabled:Boolean;
		private var _dragVertical:Boolean;
		private var _dragHorizontal:Boolean;
		private var _positionProxy:IPropertyProxy;
		private var _useCursorKeys:Boolean;
		private var _cursorStepSize:Number = 1;
		private var _cursorBigStepSize:Number = 10;
		private var _threshold:Number = 0;

		/**
		 * Create the possibility to drag an object
		 * @param target The InteractiveObject to be dragged
		 * @param bounds limits the dragging
		 * @param dragButton an InteractiveObject that does the dragging, if there is no dragButton, the target does the dragging
		 */
		public function DragBehavior(target:InteractiveObject, bounds:Rectangle = null, dragButton:InteractiveObject = null, dragHorizontal:Boolean = true, dragVertical:Boolean = true, useCursorKeys:Boolean = false) 
		{
			super(target, bounds);
			
			construct::dragBehavior(target, bounds, dragButton, dragHorizontal, dragVertical, useCursorKeys);
		}

		construct function dragBehavior(target:InteractiveObject, bounds:Rectangle, dragButton:InteractiveObject, dragHorizontal:Boolean, dragVertical:Boolean, useCursorKeys:Boolean):void
		{
			_dragButton = dragButton || target;
			enabled = true;
			_dragHorizontal = dragHorizontal;
			_dragVertical = dragVertical;
			
			// dispath DragBehaviorEvent on target
			addEventListener(DragBehaviorEvent.DRAG_START, target.dispatchEvent);
			addEventListener(DragBehaviorEvent.DRAG_STOP, target.dispatchEvent);
			addEventListener(DragBehaviorEvent.DRAGGING, target.dispatchEvent);
			
			this.useCursorKeys = useCursorKeys;
			
			bounds;
		}

		/**
		 * An InteractiveObject that does the dragging, if there is no dragButton, the target does the dragging
		 */
		public function get dragButton():InteractiveObject
		{
			return _dragButton;
		}
		
		/**
		 * Start dragging the object. Will automatically be called on MouseDown.
		 */
		public function startDrag():void
		{
			// Can't drag objects with no parent
			if (!displayObject.parent) return;
			
			_startDragOffset = new Point(displayObject.x - displayObject.parent.mouseX, displayObject.y - displayObject.parent.mouseY);
			
			displayObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true);
			displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			displayObject.stage.addEventListener(Event.MOUSE_LEAVE, handleMouseLeave, false, 0, true);
		}
		
		/**
		 * Stop dragging the object. Will automatically be called on MouseUp.
		 */
		public function stopDrag():void
		{
			displayObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			displayObject.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			displayObject.stage.removeEventListener(Event.MOUSE_LEAVE, handleMouseLeave);
			
			if (_isDragging)
			{
				_isDragging = false;
				dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_STOP, this));
			}
		}

		/**
		 * Indicates if the DragBehavior is currently dragging
		 */
		public function get isDragging():Boolean
		{
			return _isDragging;
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
			if (value)
			{
				if (_dragButton) _dragButton.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			}
			else
			{
				if (isDragging) stopDrag();
				
				if (_dragButton) _dragButton.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			enabled = false;
		}

		/**
		 * Get or set horizontal dragging on (true) or off (false)
		 */
		public function get dragHorizontal():Boolean
		{
			return _dragHorizontal;
		}
		
		/**
		 * @private
		 */
		public function set dragHorizontal(value:Boolean):void
		{
			_dragHorizontal = value;
		}

		/**
		 * Get or set vertical dragging on (true) or off (false)
		 */
		public function get dragVertical():Boolean
		{
			return _dragVertical;
		}
		
		/**
		 * @private
		 */
		public function set dragVertical(value:Boolean):void
		{
			_dragVertical = value;
		}
		
		/**
		 * Optional IPropertyProxy for setting the position of the target. Useful if you want to animate the target to it's new position.
		 */
		public function get positionProxy():IPropertyProxy
		{
			return _positionProxy;
		}
		
		/**
		 * @private
		 */
		public function set positionProxy(value:IPropertyProxy):void
		{
			_positionProxy = value;
		}
		
		/**
		 * Update position of the target
		 * 
		 * @return true if the position has actually changed 
		 */
		public function update():Boolean
		{
			var newX:Number, newY:Number;
			
			if (_dragHorizontal) newX = _startDragOffset.x + displayObject.parent.mouseX;
			if (_dragVertical) newY = _startDragOffset.y + displayObject.parent.mouseY;
			
			if (_dragHorizontal && Math.abs(newX - displayObject.x) > _threshold || _dragVertical &&  Math.abs(newY - displayObject.y) > _threshold)
			{
				if (!_isDragging)
				{
					_isDragging = true;
					dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_START, this));
				}
				
				// Check again if enable, since it can be turned off by the DRAG_START handler
				if (!_enabled) return false;
				
				if (_dragHorizontal) 
				{
					if (_positionProxy)
					{
						_positionProxy.setValue(displayObject, "x", newX);
					}
					else
					{
						displayObject.x = newX;
					}
				}
				
				if (_dragVertical) 
				{
					if (_positionProxy)
					{
						_positionProxy.setValue(displayObject, "y", newY);
					}
					else
					{
						displayObject.y = newY;
					}
				}
				keepInBounds();
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Enables moving the object using the cursor keys.
		 */
		public function get useCursorKeys():Boolean 
		{
			return _useCursorKeys; 
		}
		
		/**
		 * @private
		 */
		public function set useCursorKeys(value:Boolean):void 
		{ 
			_useCursorKeys = value;
			
			if (_useCursorKeys)
			{
				_dragButton.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			}
			else
			{
				_dragButton.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			}
		}
		
		/**
		 * Default step size when using the cursor keys.
		 */
		public function get cursorStepSize():Number
		{
			return _cursorStepSize;
		}

		/**
		 * @private
		 */
		public function set cursorStepSize(value:Number):void
		{
			_cursorStepSize = value;
		}

		/**
		 * Step size when using the cursor keys while pressing the shift key.
		 */
		public function get cursorBigStepSize():Number
		{
			return _cursorBigStepSize;
		}

		/**
		 * @private
		 */
		public function set cursorBigStepSize(value:Number):void
		{
			_cursorBigStepSize = value;
		}
		
		/**
		 * The minimal amount of movement to trigger the scrolling
		 */
		public function get threshold():Number
		{
			return _threshold;
		}

		/**
		 * @private
		 */
		public function set threshold(value:Number):void
		{
			_threshold = value;
		}

		private function handleKeyDown(event:KeyboardEvent):void
		{
			var step:Number = event.shiftKey ? _cursorBigStepSize : _cursorStepSize;
			
			switch (event.keyCode)
			{
				case KeyCode.LEFT:
				{
					if (_dragHorizontal)
					{
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_START, this));
						if (_positionProxy)
						{
							_positionProxy.setValue(displayObject, "x", displayObject.x - step);
						}
						else
						{
							displayObject.x -= step;
						}
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAGGING, this));
						keepInBounds();
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_STOP, this));
					}
					break;
				}
				case KeyCode.RIGHT:
				{
					if (_dragHorizontal)
					{
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_START, this));
						if (_positionProxy)
						{
							_positionProxy.setValue(displayObject, "x", displayObject.x + step);
						}
						else
						{
							displayObject.x += step;
						}
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAGGING, this));
						keepInBounds();
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_STOP, this));
					}
					break;
				}
				case KeyCode.UP:
				{
					if (_dragVertical)
					{
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_START, this));
						if (_positionProxy)
						{
							_positionProxy.setValue(displayObject, "y", displayObject.x - step);
						}
						else
						{
							displayObject.y -= step;
						}
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAGGING, this));
						keepInBounds();
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_STOP, this));
					}
					break;
				}
				case KeyCode.DOWN:
				{
					if (_dragVertical)
					{
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_START, this));
						if (_positionProxy)
						{
							_positionProxy.setValue(displayObject, "y", displayObject.x + step);
						}
						else
						{
							displayObject.y += step;
						}
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAGGING, this));
						keepInBounds();
						dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_STOP, this));
					}
					break;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function handleMouseDown(event:MouseEvent):void 
		{
			startDrag();
		}

		/**
		 * @private
		 */
		protected function handleMouseMove(event:MouseEvent):void 
		{
			if (update())
			{
				dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAGGING, this));
			}
		}

		/**
		 * @private
		 */
		private function handleMouseUp(event:MouseEvent):void 
		{
			stopDrag();
		}

		private function handleMouseLeave(event:Event):void
		{
			// doesn't work in wmode opaque or transparent ?
			stopDrag();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (isDragging) stopDrag();
			if (_dragButton)
			{
				_dragButton.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				_dragButton.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				_dragButton = null;
			}
			_startDragOffset = null;
			_positionProxy = null;
			super.destruct();
		}
	}
}
