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
	import temple.codecomponents.graphics.CodeBackground;
	import temple.codecomponents.icons.CodeCheck;
	import temple.codecomponents.style.CodeStyle;
	import temple.ui.form.components.CheckBox;
	import temple.ui.states.focus.FocusFadeState;
	import temple.ui.states.select.SelectFadeState;


	/**
	 * @includeExample CodeCheckBoxExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CodeCheckBox extends CheckBox 
	{
		public function CodeCheckBox(label:String = null, value:* = null, selected:Boolean = false, unselectedValue:* = false) 
		{
			this.addChild(new TextField());
			
			super();
			
			this.createUI();
			
			if (label) this.label = label;
			this.selectedValue = value == null ? (label ? label : true) : value;
			this.unselectedValue = unselectedValue;
			this.selected = selected;
		}

		private function createUI():void 
		{
			this.addChildAt(new CodeBackground(), 0).y = 1;
			
			// select state
			var selectState:SelectFadeState = new SelectFadeState(.3, .3);
			selectState.addChild(new CodeCheck(CodeStyle.iconColor, CodeStyle.iconAlpha));
			selectState.y = 1;
			selectState.filters = CodeStyle.iconFilters;
			this.addChild(selectState);
			
			// focus state
			var focus:FocusFadeState = new FocusFadeState(.2, .2);
			focus.graphics.beginFill(0xff0000, 1);
			focus.graphics.drawRect(0, 0, 15, 15);
			focus.graphics.endFill();
			this.addChildAt(focus, 0);
			focus.filters = CodeStyle.focusFilters;
			focus.y = 1;
			
			// Label
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this.textField.x = 12;
			this.textField.defaultTextFormat = CodeStyle.textFormat;
			this.textField.textColor = CodeStyle.textColor;
		}
	}
}
