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
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import temple.codecomponents.graphics.CodeBackground;
	import temple.codecomponents.style.CodeStyle;
	import temple.core.display.CoreShape;
	import temple.ui.form.components.AutoCompleteInputField;
	import temple.ui.form.components.IList;
	import temple.ui.states.focus.FocusFadeState;

	/**
	 * @includeExample CodeAutoCompleteInputFieldExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CodeAutoCompleteInputField extends AutoCompleteInputField 
	{
		public function CodeAutoCompleteInputField(width:Number = 160, height:Number = 18, items:Array = null, inSearch:Boolean = false)
		{
			super(addChild(new TextField()) as TextField, addChild(new CodeList(width)) as IList);
			
			textField.type = TextFieldType.INPUT;
			textField.width = width;
			textField.height = height;
			textField.defaultTextFormat = CodeStyle.textFormat;
			this.multiline = multiline;
			
			hintTextColor = 0x888888;
			errorTextColor = 0xff0000;
			
			addChildAt(new CodeBackground(width, height), 0);
			
			// focus state
			var focus:FocusFadeState = new FocusFadeState(.2, .2);
			focus.graphics.beginFill(0xff0000, 1);
			focus.graphics.drawRect(-1, -1, width+2, height+2);
			focus.graphics.endFill();
			addChildAt(focus, 0);
			focus.filters = CodeStyle.focusFilters;
			
			list.y = height;
			list.filters = CodeStyle.comboBoxListFilter;
			
			// icon
			var icon:CoreShape = new CoreShape();
			addChild(icon);
			
			icon.graphics.beginFill(CodeStyle.iconColor, CodeStyle.iconAlpha);
			icon.graphics.lineStyle(0, 0x000000, 0, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 3);
			icon.graphics.moveTo(0, 3);
			icon.graphics.lineTo(4, -2);
			icon.graphics.lineTo(-4, -2);
			icon.graphics.lineTo(0, 3);
			icon.graphics.endFill();
			icon.x = width - 7;
			icon.y = height * .5;
			icon.filters = CodeStyle.iconFilters;
			
			if (items) addItems(items);
			this.inSearch = inSearch;
		}
	}
}
