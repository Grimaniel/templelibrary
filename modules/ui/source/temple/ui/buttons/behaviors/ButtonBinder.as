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

package temple.ui.buttons.behaviors 
{
	import temple.core.CoreObject;
	import temple.core.destruction.DestructEvent;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.utils.types.ArrayUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * The ButtonBinder binds two (or more) DisplayObjects together to pass their MouseEvents to eachother. 
	 * With the ButtonBinder you can set a TextField as a hitarea for a CheckBox or set a hitarea for a button which is not a child of the button.
	 * 
	 * @includeExample ButtonBinderExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ButtonBinder extends CoreObject 
	{
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns a list of all ButtonBinders of a DisplayObject if the DisplayObject has ButtonBinders. Otherwise null is returned.
		 */
		public static function getInstances(target:DisplayObject):Array
		{
			return ButtonBinder._dictionary[target] as Array;
		}
		
		// List of Events to bind
		private static const _EVENT_TYPES:Array = [	MouseEvent.CLICK,
												MouseEvent.DOUBLE_CLICK,
												MouseEvent.MOUSE_DOWN,
												MouseEvent.MOUSE_OUT,
												MouseEvent.MOUSE_OVER,
												MouseEvent.MOUSE_UP,
												MouseEvent.MOUSE_WHEEL,
												MouseEvent.ROLL_OUT,
												MouseEvent.ROLL_OVER];

		private var _buttons:Dictionary;
		private var _blockRequest:Boolean;
		private var _ignoreMouseEnabled:Boolean;
		
		/**
		 * Creates a new ButtonBinding
		 * @param button1 the first button to bind
		 * @param button2 the second button to bind
		 * @param weakReference indicates if weakReferences are used to bind the buttons
		 * @param ignoreMouseEnabled indicates if the mouseEnable must be ignored. If the set to true MouseEvents will be dispatched even if the mouseEnabled of the object is false.
		 */
		public function ButtonBinder(button1:DisplayObject, button2:DisplayObject, useWeakReference:Boolean = true, ignoreMouseEnabled:Boolean = false)
		{
			if (button1 == null) throwError(new TempleArgumentError(this, "button1 can not be null"));
			if (button2 == null) throwError(new TempleArgumentError(this, "button2 can not be null"));
			
			_buttons = new Dictionary(useWeakReference);
			
			add(button1);
			add(button2);
			
			this.ignoreMouseEnabled = ignoreMouseEnabled;
		}
		
		/**
		 * Adds a new button to the binder. The 2 buttons in the constructor are automatically added, so you do not need to call this method for those buttons
		 * @param button the button to add
		 * @param weakReference indicates if weakReference is used to bind the button
		 */
		public function add(button:DisplayObject, useWeakReference:Boolean = true):void
		{
			if (button == null) throwError(new TempleArgumentError(this, "Button can not be null"));
			
			if (ButtonBinder._dictionary[button] == null) ButtonBinder._dictionary[button] = new Array();
			(ButtonBinder._dictionary[button] as Array).push(this);
			
			_buttons[button] = this;
			
			for each (var type : String in ButtonBinder._EVENT_TYPES) 
			{
				button.addEventListener(type, handleEvent, false, 0, useWeakReference);
			}
			button.addEventListener(DestructEvent.DESTRUCT, handleButtonDestructed, false, 0, useWeakReference);
		}
		
		/**
		 * Removes a button from the ButtonBinder
		 * @param button the button to be removed
		 */
		public function remove(button:DisplayObject):void
		{
			if (button == null) throwError(new TempleArgumentError(this, "Button can not be null"));
			
			button.removeEventListener(DestructEvent.DESTRUCT, handleButtonDestructed);
			
			if (ButtonBinder._dictionary && ButtonBinder._dictionary[button])
			{
				ArrayUtils.removeValueFromArray(ButtonBinder._dictionary[button], this);
			}
			
			if (_buttons && _buttons[button])
			{
				for each (var type : String in ButtonBinder._EVENT_TYPES) 
				{
					button.removeEventListener(type, handleEvent);
				}
				delete _buttons[button];
			}
			else
			{
				logWarn("remove: ButtonBinder has no button '" + button + "'");
			}
		}
		
		/**
		 * Indicates if the mouseEnable must be ignored. If the set to true MouseEvents will be dispatched even if the mouseEnabled of the object is false.
		 */
		public function get ignoreMouseEnabled():Boolean
		{
			return _ignoreMouseEnabled;
		}
		
		/**
		 * @private
		 */
		public function set ignoreMouseEnabled(value:Boolean):void
		{
			_ignoreMouseEnabled = value;
		}

		private function handleEvent(event:Event):void
		{
			if (_blockRequest) return;
			_blockRequest = true;
			
			for (var button:Object in _buttons)
			{
				if (button != event.currentTarget)
				{
					var target:DisplayObject = event.currentTarget as DisplayObject;
					var isChild:Boolean = false;
					if (target is DisplayObjectContainer && DisplayObjectContainer(target).contains(button as DisplayObject)) isChild = true;
					
					if ((_ignoreMouseEnabled || (button is InteractiveObject && InteractiveObject(button).mouseEnabled)) && !isChild)
					{
						(button as DisplayObject).dispatchEvent(event.clone());
					}
				}
			}
			_blockRequest = false;
		}
		
		private function handleButtonDestructed(event:DestructEvent):void
		{
			remove(event.target as DisplayObject);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_buttons)
			{
				for (var button:Object in _buttons)
				{
					remove(button as DisplayObject);
				}
				_buttons = null;
			}
			super.destruct();
		}
	}
}
