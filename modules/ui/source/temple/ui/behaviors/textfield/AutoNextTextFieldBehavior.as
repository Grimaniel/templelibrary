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

package temple.ui.behaviors.textfield 
{
	import temple.core.CoreObject;
	import temple.utils.FrameDelay;
	import temple.utils.keys.KeyCode;
	import temple.utils.types.ArrayUtils;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;

	/**
	 * Class for automatically jumping to the next <code>TextField</code> when the user filled the <code>maxChars</code>
	 * of the <code>TextField</code>.
	 * 
	 * @includeExample AutoNextTextFieldBehaviorExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class AutoNextTextFieldBehavior extends CoreObject 
	{
		private var _textFields:Array;

		public function AutoNextTextFieldBehavior()
		{
			this._textFields = new Array();
		}

		public function add(textField:TextField):void 
		{
			this._textFields.push(textField);
			textField.addEventListener(Event.CHANGE, this.handleTextChange);
			textField.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
		}

		public function remove(textField:TextField):void 
		{
			ArrayUtils.removeValueFromArray(this._textFields, textField);
			textField.removeEventListener(Event.CHANGE, this.handleTextChange);
			textField.removeEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
		}

		private function focusNext(textField:TextField):void 
		{
			var leni:int = this._textFields.length - 1;
			for (var i:int = 0; i < leni; i++)
			{
				if (this._textFields[i] == textField)
				{
					TextField(this._textFields[i]).stage.focus = TextField(this._textFields[i+1]);
					new FrameDelay(TextField(this._textFields[i+1]).setSelection, 1, [0, 0]);
				}
			}
		}

		private function focusPrevious(textField:TextField):void 
		{
			var leni:int = this._textFields.length;
			for (var i:int = 1; i < leni; i++)
			{
				if (this._textFields[i] == textField)
				{
					TextField(this._textFields[i]).stage.focus = TextField(this._textFields[i-1]);
					new FrameDelay(TextField(this._textFields[i-1]).setSelection, 1, [TextField(this._textFields[i-1]).text.length, TextField(this._textFields[i-1]).text.length]);
					return;
				}
			}
		}

		private function handleTextChange(event:Event):void 
		{
			var textField:TextField = TextField(event.target);
			
			if (textField.text.length >= textField.maxChars)
			{
				this.focusNext(textField);
			}
		}
		
		private function handleKeyDown(event:KeyboardEvent):void 
		{
			var textField:TextField = TextField(event.target);
			switch (event.keyCode)
			{
				case KeyCode.LEFT:
				case KeyCode.BACKSPACE:
					if (textField.caretIndex == 0) this.focusPrevious(textField);
					break;
				
				case KeyCode.RIGHT:
					if (textField.caretIndex == textField.text.length) this.focusNext(textField);
					event.stopImmediatePropagation();
					event.preventDefault();
					break;
			}
		}

		override public function destruct():void 
		{
			if (this._textFields)
			{
				while (this._textFields.length) this.remove(this._textFields[0]);
				this._textFields = null;
			}
			
			super.destruct();
		}
	}
}
