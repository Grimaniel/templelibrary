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

package temple.codecomponents.form.components 
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import temple.codecomponents.graphics.CodeBackground;
	import temple.codecomponents.style.CodeStyle;
	import temple.ui.form.components.InputField;
	import temple.ui.states.error.ErrorFadeState;
	import temple.ui.states.focus.FocusFadeState;


	/**
	 * @author Thijs Broerse
	 */
	public class CodeInputField extends InputField 
	{
		private var _focus:FocusFadeState;
		private var _background:CodeBackground;
		private var _error:ErrorFadeState;
		
		public function CodeInputField(width:Number = 160, height:Number = 18, multiline:Boolean = false)
		{
			super(addChild(new TextField()) as TextField);
			
			textField.type = TextFieldType.INPUT;
			textField.width = width;
			textField.height = height;
			textField.defaultTextFormat = CodeStyle.textFormat;
			this.multiline = multiline;
			
			hintTextColor = 0x888888;
			errorTextColor = 0xff0000;
			
			_background = addChildAt(new CodeBackground(width, height), 0) as CodeBackground;
			
			// focus state
			_focus = new FocusFadeState(.2, .2);
			_focus.graphics.beginFill(0xff0000, 1);
			_focus.graphics.drawRect(0, 0, width+2, height+2);
			_focus.x = -1;
			_focus.y = -1;
			_focus.graphics.endFill();
			addChildAt(_focus, 0);
			_focus.filters = CodeStyle.focusFilters;
			
			// error state
			_error = new ErrorFadeState(.2, .2);
			_error.graphics.beginFill(0xff0000, 1);
			_error.graphics.drawRect(0, 0, width+2, height+2);
			_error.x = -1;
			_error.y = -1;
			_error.graphics.endFill();
			addChildAt(_error, 1);
			_error.filters = CodeStyle.errorFilters;
		}
		
		override public function set width(value:Number):void
		{
			textField.width = value;
			_background.width = value;
			_focus.width = value + 2;
			_error.width = value + 2;
		}
		
		override public function set height(value:Number):void
		{
			textField.height = value;
			_background.height = value;
			_focus.height = value + 2;
			_error.height = value + 2;
		}
	}
}
