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

package temple.ui.behaviors 
{
	import temple.common.interfaces.IEnableable;
	import temple.utils.keys.KeyCode;
	import temple.utils.propertyproxy.IPropertyProxy;

	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;

	/**
	 * @eventType temple.ui.behaviors.MoveBehaviorEvent.MOVE
	 */
	[Event(name = "MoveBehaviorEvent.move", type = "temple.ui.behaviors.MoveBehaviorEvent")]
	
	/**
	 * The MoveBehavior makes a DisplayObject movable by the cursor keys. The MoveBehavior uses the decorator pattern,
	 * so you won't have to change the code of the DisplayObject. When the DispayObject has focus, use the cursor keys
	 * to move the object one pixel. If you also press the SHIFT key, the object will move 10 pixels.
	 * 
	 * <p>It is not nessessary to store a reference to the MoveBehavior since the MoveBehavior is automatically destructed
	 * when the DisplayObject is destructed.</p>
	 * 
	 * @example
	 * <p>If you have a MovieClip called 'mcClip' add MoveBehavior like:</p>
	 * <listing version="3.0">
	 * new MoveBehavior(mcClip);
	 * </listing> 
	 * 
	 * <p>If you want to limit the moving to a specific bounds, you can add a Rectangle. By adding the
	 * Reactangle you won't be able to move DisplayObject outside the Rectangle:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new MoveBehavior(mcClip, new Rectangle(100, 100, 200, 200);
	 * </listing>
	 *
	 * <p>It's also possible to define a child object as a 'MoveButton'. A MoveButton is a DisplayObject
	 * that is used to move the target.</p>
	 * 
	 * <p>If you have a MovieClip called 'mcClip' with a child called 'mcMoveButton' add MoveBehavior like:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new MoveBehavior(mcClip, null, mcClip.mcMoveButton);
	 * </listing> 
	 * 
	 * @author Thijs Broerse
	 */
	public class MoveBehavior extends BoundsBehavior implements IEnableable
	{
		private var _moveButton:InteractiveObject;
		private var _enabled:Boolean;
		private var _moveVertical:Boolean;
		private var _moveHorizontal:Boolean;
		private var _positionProxy:IPropertyProxy;

		/**
		 * Create the possibility to move an object
		 * @param target: The InteractiveObject to be moved
		 * @param bounds (optional): limits the moving
		 * @param moveButton (optional): an InteractiveObject that does the moving, if there is no moveButton, the target does the moving
		 */
		public function MoveBehavior(target:InteractiveObject, bounds:Rectangle = null, moveButton:InteractiveObject = null, moveHorizontal:Boolean = true, moveVertical:Boolean = true) 
		{
			super(target, bounds);
			
			this._moveButton = moveButton || target;
			
			this.enabled = true;
			this._moveHorizontal = moveHorizontal;
			this._moveVertical = moveVertical;
			
			// dispath MoveBehaviorEvent on target
			this.addEventListener(MoveBehaviorEvent.MOVE, target.dispatchEvent);
		}
		
		/**
		 * An InteractiveObject that does the moving, if there is no moveButton, the target does the moving
		 */
		public function get moveButton():InteractiveObject
		{
			return this._moveButton;
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
			if (value)
			{
				if (this._moveButton) this._moveButton.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
			}
			else
			{
				if (this._moveButton) this._moveButton.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			this.enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			this.enabled = false;
		}

		/**
		 * Get or set horizontal moving on (true) or off (false)
		 */
		public function get moveHorizontal():Boolean
		{
			return this._moveHorizontal;
		}
		
		/**
		 * @private
		 */
		public function set moveHorizontal(value:Boolean):void
		{
			this._moveHorizontal = value;
		}

		/**
		 * Get or set vertical moving on (true) or off (false)
		 */
		public function get moveVertical():Boolean
		{
			return this._moveVertical;
		}
		
		/**
		 * @private
		 */
		public function set moveVertical(value:Boolean):void
		{
			this._moveVertical = value;
		}
		
		/**
		 * Optional IPropertyProxy for setting the position of the target. Useful if you want to animate the target to it's new position.
		 */
		public function get positionProxy():IPropertyProxy
		{
			return this._positionProxy;
		}
		
		/**
		 * @private
		 */
		public function set positionProxy(value:IPropertyProxy):void
		{
			this._positionProxy = value;
		}
		
		private function handleKeyDown(event:KeyboardEvent):void
		{
			var x:Number, y:Number;
			
			switch (event.keyCode)
			{
				case KeyCode.LEFT:
					if (this._moveHorizontal)
					{
						x = this.displayObject.x -(event.shiftKey ? 10 : 1);
					}
					break;
				case KeyCode.RIGHT:
					if (this._moveHorizontal)
					{
						x = this.displayObject.x +(event.shiftKey ? 10 : 1);
					}
					break;
				case KeyCode.UP:
					if (this._moveHorizontal)
					{
						y = this.displayObject.y -(event.shiftKey ? 10 : 1);
					}
					break;
				case KeyCode.DOWN:
					if (this._moveHorizontal)
					{
						y = this.displayObject.y +(event.shiftKey ? 10 : 1);
					}
					break;
			}
			if (!isNaN(x))
			{
				if (this._positionProxy)
				{
					this._positionProxy.setValue(this.displayObject, "x", x);
				}
				else
				{
					this.displayObject.x = x;
				}
			}
			if (!isNaN(y))
			{
				if (this._positionProxy)
				{
					this._positionProxy.setValue(this.displayObject, "y", y);
				}
				else
				{
					this.displayObject.y = y;
				}
			}
			if (!isNaN(x) || !isNaN(y)) this.keepInBounds();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._moveButton)
			{
				this._moveButton.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
				this._moveButton = null;
			}
			this._positionProxy = null;
			super.destruct();
		}
	}
}
