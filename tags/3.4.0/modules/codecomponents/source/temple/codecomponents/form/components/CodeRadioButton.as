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
	import flash.text.TextFieldAutoSize;
	import temple.codecomponents.style.CodeStyle;
	import temple.core.display.CoreSprite;
	import temple.ui.form.components.RadioButton;
	import temple.ui.states.focus.FocusFadeState;
	import temple.ui.states.select.SelectFadeState;

	/**
	 * @includeExample CodeRadioButtonExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CodeRadioButton extends RadioButton 
	{
		public function CodeRadioButton(label:String = null, value:* = null, selected:Boolean = false) 
		{
			addChild(new TextField());
			
			super();
			
			createUI();
			
			if (label) this.label = label;
			selectedValue = value == null ? (label ? label : true) : value;
			this.selected = selected;
		}

		private function createUI():void 
		{
			// background
			var background:CoreSprite = new CoreSprite();
			background.graphics.beginFill(CodeStyle.backgroundColor, CodeStyle.backgroundAlpha);
			background.graphics.drawCircle(7, 7, 7);
			background.graphics.endFill();
			addChildAt(background, 0);
			background.filters = CodeStyle.backgroundFilters;
			background.y = 1;
			
			// select state
			var selectState:SelectFadeState = new SelectFadeState(.3, .3);
			selectState.graphics.beginFill(CodeStyle.iconColor, CodeStyle.iconAlpha);
			selectState.graphics.drawCircle(7, 8.5, 4);
			selectState.graphics.endFill();
			selectState.filters = CodeStyle.iconFilters;
			addChild(selectState);
			
			// focus state
			var focus:FocusFadeState = new FocusFadeState(.2, .2);
			focus.graphics.beginFill(0xff0000, 1);
			focus.graphics.drawCircle(7, 6.5, 8);
			focus.graphics.endFill();
			addChildAt(focus, 0);
			focus.filters = CodeStyle.focusFilters;
			focus.y = 2;
			
			// Label
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.x = 12;
			textField.defaultTextFormat = CodeStyle.textFormat;
			textField.textColor = CodeStyle.textColor;
		}
	}
}
