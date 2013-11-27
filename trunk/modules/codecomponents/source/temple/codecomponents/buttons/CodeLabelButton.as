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

package temple.codecomponents.buttons 
{
	import temple.codecomponents.style.CodeStyle;
	import temple.ui.buttons.LiquidLabelButton;
	import temple.ui.buttons.behaviors.ButtonTweenBehavior;
	import temple.ui.layout.liquid.LiquidBehavior;

	import flash.text.TextField;


	/**
	 * @includeExample CodeLabelButtonExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CodeLabelButton extends LiquidLabelButton 
	{
		public function CodeLabelButton(text:String = "", multiline:Boolean = false, autoSize:Boolean = true)
		{
			super(new TextField());
			
			padding = 2;
			
			this.text = text;
			textField.multiline = multiline;
			this.autoSize = autoSize;
			
			if (!autoSize)
			{
				textField.width = 100;
				textField.height = 20;
			}
		}

		override protected function init(textField:TextField = null):void 
		{
			addChild(textField);
			textField.defaultTextFormat = CodeStyle.textFormat;
			textField.width = textField.height = 1;
			
			new LiquidBehavior(addChildAt(new CodeButton(width, height), 0), {left:0, right:0, top:0, bottom:0}, this);
			var tweenBehavior:ButtonTweenBehavior = new ButtonTweenBehavior(this, .5, {alpha: 1});
			tweenBehavior.disabledDuration = .5;
			tweenBehavior.disabledVars = {alpha: .5};
			
			super.init();
		}
	}
}
