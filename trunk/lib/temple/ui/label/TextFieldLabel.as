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
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.ui.label 
{
	import temple.behaviors.AbstractBehavior;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;

	import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * Dispatched after the text in the TextField is changed
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name = "change", type = "flash.events.Event")]

	/**
	 * Dispatched after the text in the TextField is resized
	 * @eventType flash.events.Event.RESIZE
	 */
	[Event(name = "resize", type = "flash.events.Event")]

	/**
	 * @author Thijs Broerse
	 */
	public class TextFieldLabel extends AbstractBehavior implements ITextFieldLabel
	{
		protected var _html:Boolean;
		
		public function TextFieldLabel(target:TextField)
		{
			super(target);
			
			target.addEventListener(Event.CHANGE, this.handleTextFieldChange);
			target.addEventListener(Event.RESIZE, this.handleTextFieldResize);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get label():String
		{
			return this._html ? this.textField.htmlText : this.textField.text;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set label(value:String):void
		{
			if(value == null) value = "";
			
			if(this._html)
			{
				// Add an empty StyleSheet to the TextField if there is no StyleSheet. This prevents the HTML text to get parsed by Flash
				if(this.textField.styleSheet == null) this.textField.styleSheet = new StyleSheet();
				this.textField.htmlText = value;
			}
			else
			{
				this.textField.text = value;
			}
			this.textField.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoSize():String
		{
			return this.textField.autoSize;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set autoSize(value:String):void
		{
			switch(value)
			{
				case TextFieldAutoSize.LEFT:
				case TextFieldAutoSize.RIGHT:
				case TextFieldAutoSize.CENTER:
					this.textField.mouseWheelEnabled = false;
					this.textField.autoSize = value;
					this.textField.dispatchEvent(new Event(Event.RESIZE));
					break;
				case TextFieldAutoSize.NONE:
					this.textField.autoSize = value;
					break;
					
				default:
					throwError(new TempleArgumentError(this, "invalid value for autoSize: '" + value + "'"));
					break;
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get html():Boolean
		{
			return this._html;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set html(value:Boolean):void
		{
			if(this._html != value)
			{
				this._html = value;
				if(this._html)
				{
					this.textField.htmlText = this.textField.text;
				}
				else
				{
					this.textField.text = this.textField.htmlText;
				}
				this.textField.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get textField():TextField
		{
			return this.target as TextField;
		}
		
		private function handleTextFieldChange(event:Event):void
		{
			this.dispatchEvent(event.clone());
			
			if(this.textField.autoSize != TextFieldAutoSize.NONE)
			{
				this.textField.dispatchEvent(new Event(Event.RESIZE));
			}
		}

		private function handleTextFieldResize(event:Event):void
		{
			this.dispatchEvent(event.clone());
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return super.toString() + (this.textField ?  ": \"" + this.textField.name + "\" (text:\"" + this.textField.text + "\")" : "");
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.textField)
			{
				this.textField.removeEventListener(Event.CHANGE, this.handleTextFieldChange);
				this.textField.removeEventListener(Event.RESIZE, this.handleTextFieldResize);
			}
			
			super.destruct();
		}
	}
}
