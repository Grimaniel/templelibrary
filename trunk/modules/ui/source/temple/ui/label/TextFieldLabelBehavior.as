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

package temple.ui.label 
{
	import temple.core.behaviors.AbstractBehavior;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

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
	public class TextFieldLabelBehavior extends AbstractBehavior implements ITextFieldLabel
	{
		protected var _html:Boolean;
		
		public function TextFieldLabelBehavior(target:TextField)
		{
			super(target);
			toStringProps.push('name', 'label');
			target.addEventListener(Event.CHANGE, handleTextFieldChange);
			target.addEventListener(Event.RESIZE, handleTextFieldResize);
		}

		/**
		 * Return the name of the TextField
		 */
		public function get name():String
		{
			return textField ? textField.name : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get label():String
		{
			return textField ? (_html ? textField.htmlText : textField.text) : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set label(value:String):void
		{
			if (value == null) value = "";
			
			if (_html)
			{
				// Add an empty StyleSheet to the TextField if there is no StyleSheet. This prevents the HTML text to get parsed by Flash
				if (textField.styleSheet == null) textField.styleSheet = new StyleSheet();
				textField.htmlText = value;
			}
			else
			{
				textField.text = value;
			}
			textField.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoSize():String
		{
			return textField.autoSize;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set autoSize(value:String):void
		{
			switch (value)
			{
				case TextFieldAutoSize.LEFT:
				case TextFieldAutoSize.RIGHT:
				case TextFieldAutoSize.CENTER:
					textField.mouseWheelEnabled = false;
					textField.autoSize = value;
					textField.dispatchEvent(new Event(Event.RESIZE));
					break;
				case TextFieldAutoSize.NONE:
					textField.autoSize = value;
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
			return _html;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set html(value:Boolean):void
		{
			if (_html != value)
			{
				_html = value;
				if (_html)
				{
					textField.htmlText = textField.text;
				}
				else
				{
					textField.text = textField.htmlText;
				}
				textField.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get textField():TextField
		{
			return target as TextField;
		}
		
		private function handleTextFieldChange(event:Event):void
		{
			dispatchEvent(event.clone());
			
			if (textField.autoSize != TextFieldAutoSize.NONE)
			{
				textField.dispatchEvent(new Event(Event.RESIZE));
			}
		}

		private function handleTextFieldResize(event:Event):void
		{
			dispatchEvent(event.clone());
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (textField)
			{
				textField.removeEventListener(Event.CHANGE, handleTextFieldChange);
				textField.removeEventListener(Event.RESIZE, handleTextFieldResize);
			}
			
			super.destruct();
		}
	}
}
