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
	import temple.common.interfaces.IEnableable;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * The ScrubBehavior makes a DisplayObject Scrubbable. That means that MouseEvent.CLICK events will be dispatched on the DisplayObject when you are Scrubbing over the Object.
	 * Scrubbing means: moving the mouse while pressing.
	 * 
	 * @author Thijs Broerse
	 */
	public class ScrubBehavior extends AbstractDisplayObjectBehavior implements IEnableable
	{
		private var _eventType:String;
		private var _stage:Stage;
		private var _enabled:Boolean = true;
		
		/**
		 * Creates a new ScrubBehavior
		 * @param target the display object to apply to ScrubBehavior to
		 * @param eventType the MouseEvent type to dispatch while scrubbing. Value can either be MouseEvent.CLICK, MouseEvent.MOUSE_DOWN or MouseEvent.MOUSE_UP.
		 */
		public function ScrubBehavior(target:DisplayObject, eventType:String = MouseEvent.CLICK)
		{
			super(target);
			
			this.eventType = eventType;
			
			target.addEventListener(MouseEvent.MOUSE_DOWN, handleTargetMouseDown);

			if (target.stage)
			{
				_stage = target.stage;
			}
			else
			{
				target.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}
		}
		
		/**
		 * The MouseEvent-type to dispatch while scrubbing. Value can either be MouseEvent.CLICK, MouseEvent.MOUSE_DOWN or MouseEvent.MOUSE_UP.
		 */
		public function get eventType():String
		{
			return _eventType;
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
		 * @private
		 */
		public function set eventType(value:String):void
		{
			switch (value)
			{
				case MouseEvent.CLICK:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_UP:
				{
					_eventType = value;
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "invalid value for eventType: '" + value + "'"));
					break;
				}
			}
		}
		
		private function handleTargetMouseDown(event:MouseEvent):void
		{
			if (_enabled) displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));
			
			if (!_stage && displayObject.stage) _stage = displayObject.stage;
			
			if (_stage)
			{
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				_stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			}
			if (_enabled) displayObject.dispatchEvent(new MouseEvent(_eventType, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));
		}
		
		private function handleMouseMove(event:MouseEvent):void
		{
			if (event.buttonDown && _enabled) displayObject.dispatchEvent(new MouseEvent(_eventType, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));
		}
		
		private function handleMouseUp(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			displayObject.addEventListener(MouseEvent.CLICK, handleClick, false, int.MAX_VALUE);
		}

		private function handleClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			displayObject.removeEventListener(MouseEvent.CLICK, handleClick);
		}
		
		private function handleAddedToStage(event:Event):void
		{
			_stage = (event.target as DisplayObject).stage;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (displayObject)
			{
				displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, handleTargetMouseDown);
				displayObject.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}
			
			if (_stage)
			{
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
				_stage = null;
			}
			_eventType = null;
			
			super.destruct();
		}
	}
}
