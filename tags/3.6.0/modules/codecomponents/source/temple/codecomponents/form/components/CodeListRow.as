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
	import flash.display.LineScaleMode;
	import flash.text.TextField;
	import temple.codecomponents.style.CodeStyle;
	import temple.core.display.CoreShape;
	import temple.ui.form.components.ListRow;
	import temple.ui.states.focus.FocusFadeState;
	import temple.ui.states.over.OverFadeState;
	import temple.ui.states.select.SelectFadeState;


	/**
	 * @includeExample CodeListExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CodeListRow extends ListRow 
	{
		private var _background:CoreShape;
		private var _over:OverFadeState;
		private var _select:SelectFadeState;
		private var _focus:FocusFadeState;

		public function CodeListRow(width:Number = 160, height:Number = 18)
		{
			addChild(new TextField());
			
			super();
			
			textField.width = width;
			textField.height = height;
			textField.defaultTextFormat = CodeStyle.textFormat;
			
			// background
			_background = new CoreShape();
			_background.graphics.beginFill(CodeStyle.backgroundColor, CodeStyle.backgroundAlpha);
			_background.graphics.drawRect(0, 0, width, height);
			_background.graphics.endFill();
			addChildAt(_background, 0);
			
			// over state
			_over = new OverFadeState();
			_over.graphics.beginFill(CodeStyle.listItemOverstateColor, CodeStyle.listItemOverstateAlpha);
			_over.graphics.drawRect(0, 0, width, height);
			_over.graphics.endFill();
			addChildAt(_over, 1);

			// select state
			_select = new SelectFadeState(.25, .25);
			_select.graphics.beginFill(CodeStyle.listItemSelectstateColor, CodeStyle.listItemSelectstateAlpha);
			_select.graphics.drawRect(0, 0, width, height);
			_select.graphics.endFill();
			addChildAt(_select, 2);
			
			// focus state
			_focus = new FocusFadeState(.25, .25);
			_focus.graphics.lineStyle(CodeStyle.focusThickness, CodeStyle.focusColor, CodeStyle.focusAlpha, true, LineScaleMode.NONE);
			_focus.graphics.drawRect(CodeStyle.focusThickness * .5, CodeStyle.focusThickness * .5, width - CodeStyle.focusThickness, height - CodeStyle.focusThickness);
			addChildAt(_focus, 3);
		}

		override public function set index(value:uint):void 
		{
			super.index = value;
			
			_background.alpha = value % 2 ? .2 : .4;
		}
		
		override public function set width(value:Number) : void
		{
			_background.width = value;
			_over.width = value;
			_select.width = value;
			_focus.width = value - CodeStyle.focusThickness;
			textField.width = value;
		}
	}
}
