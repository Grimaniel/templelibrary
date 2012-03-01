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
			super(this.addChild(new TextField()) as TextField);
			
			this.textField.type = TextFieldType.INPUT;
			this.textField.width = width;
			this.textField.height = height;
			this.textField.defaultTextFormat = CodeStyle.textFormat;
			this.multiline = multiline;
			
			this.hintTextColor = 0x888888;
			this.errorTextColor = 0xff0000;
			
			this._background = this.addChildAt(new CodeBackground(width, height), 0) as CodeBackground;
			
			// focus state
			this._focus = new FocusFadeState(.2, .2);
			this._focus.graphics.beginFill(0xff0000, 1);
			this._focus.graphics.drawRect(-1, -1, width+2, height+2);
			this._focus.graphics.endFill();
			this.addChildAt(this._focus, 0);
			this._focus.filters = CodeStyle.focusFilters;
			
			// error state
			this._error = new ErrorFadeState(.2, .2);
			this._error.graphics.beginFill(0xff0000, 1);
			this._error.graphics.drawRect(-1, -1, width+2, height+2);
			this._error.graphics.endFill();
			this.addChildAt(this._error, 1);
			this._error.filters = CodeStyle.errorFilters;
		}
		
		override public function set width(value:Number):void
		{
			this.textField.width = value;
			this._focus.width = value;
			this._background.width = value;
			this._error.width = value + 2;
		}
		
		override public function set height(value:Number):void
		{
			this.textField.height = value;
			this._focus.height = value;
			this._background.height = value;
		}
	}
}
