/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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
 */

package temple.ui.buttons.behaviors 
{
	import temple.behaviors.AbstractBehavior;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;

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
	public class ScrubBehavior extends AbstractBehavior 
	{
		protected var _eventType:String;
		protected var _stage:Stage;
		
		/**
		 * Creates a new ScrubBehavior
		 * @param target the display object to apply to ScrubBehavior to
		 * @param eventType the MouseEvent type to dispatch while scrubbing. Value can either be MouseEvent.CLICK, MouseEvent.MOUSE_DOWN or MouseEvent.MOUSE_UP.
		 */
		public function ScrubBehavior(target:DisplayObject, eventType:String = MouseEvent.CLICK)
		{
			super(target);
			
			this._eventType = eventType;
			
			target.addEventListener(MouseEvent.MOUSE_DOWN, this.handleTargetMouseDown);

			if(target.stage)
			{
				this._stage = target.stage;
			}
			else
			{
				target.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
			}
		}
		
		/**
		 * Returns a reference to the DisplayObject
		 */
		public function get displayObject():DisplayObject
		{
			return this.target as DisplayObject;
		}
		
		/**
		 * The MouseEvent-type to dispatch while scrubbing. Value can either be MouseEvent.CLICK, MouseEvent.MOUSE_DOWN or MouseEvent.MOUSE_UP.
		 */
		public function get eventType():String
		{
			return this._eventType;
		}
		
		/**
		 * @private
		 */
		public function set eventType(value:String):void
		{
			switch(value)
			{
				case MouseEvent.CLICK:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_UP:
				{
					this._eventType = value;
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
			this.displayObject.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));
			
			if(!this._stage && this.displayObject.stage) this._stage = this.displayObject.stage;
			
			if(this._stage)
			{
				this._stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
				this._stage.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			}
		}
		
		private function handleMouseMove(event:MouseEvent):void
		{
			if(event.buttonDown) this.displayObject.dispatchEvent(new MouseEvent(this._eventType, true, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));
		}
		
		private function handleMouseUp(event:MouseEvent):void
		{
			this._stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
		}
		
		private function handleAddedToStage(event:Event):void
		{
			this._stage = (event.target as DisplayObject).stage;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.displayObject) this.displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleTargetMouseDown);
			
			if(this._stage)
			{
				this._stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
				this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			}
			super.destruct();
		}
	}
}
