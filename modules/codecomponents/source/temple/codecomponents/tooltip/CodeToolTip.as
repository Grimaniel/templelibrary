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

package temple.codecomponents.tooltip 
{
	import com.greensock.TweenLite;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import temple.codecomponents.style.CodeStyle;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.ui.layout.liquid.LiquidSprite;
	import temple.ui.tooltip.ToolTip;



	/**
	 * @author Thijs Broerse
	 */
	public class CodeToolTip extends ToolTip 
	{
		private var _shown:Boolean;
		private var _showDuration:Number;
		private var _hideDuration:Number;

		public function CodeToolTip(showDuration:Number = .2, hideDuration:Number = .5)
		{
			this.showDuration = showDuration;
			this.hideDuration = hideDuration;
		}
		
		override protected function init(textField:TextField = null):void 
		{
			//background
			var background:LiquidSprite = new LiquidSprite({left:0, right:0, top:0, bottom:0}, this);
			background.graphics.beginFill(CodeStyle.toolTipBackgroundColor, CodeStyle.toolTipBackgroundAlpha);
			background.graphics.lineStyle(0, CodeStyle.toolTipBorderColor, CodeStyle.toolTipBackgroundAlpha, true, LineScaleMode.NONE);
			background.graphics.drawRect(0, 0, 10, 10);
			background.graphics.endFill();
			
			this.addChildAt(background, 0);
			textField = new TextField();
			this.addChild(textField);
			textField.defaultTextFormat = CodeStyle.toolTipTextFormat;
			textField.multiline = true;
			textField.wordWrap = true;
			textField.textColor = CodeStyle.toolTipTextColor;
			
			super.init();
			
			this.autoSize = TextFieldAutoSize.LEFT;
			this.padding = 0;
			this.paddingLeft = this.paddingRight = 2;
			
			this.filters = CodeStyle.toolTipFilters;
		}

		
		override public function set label(value:String):void 
		{
			this.textField.width = 400;
			super.label = value;
			
			var height:Number = this.textField.height;
			
			do
			{
				this.textField.width--;
			}
			while (this.textField.height == height);
			
			this.textField.width++;
			
			if (this.textField.width < 400)
			{
				this.textField.dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function show(instant:Boolean = false):void
		{
			if (this.enabled == false || this._shown) return;
			this._shown = true;
			if (instant)
			{
				this.autoAlpha = 1;
			}
			else
			{
				TweenLite.to(this, this._showDuration, {autoAlpha:1});
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function hide(instant:Boolean = false):void
		{
			if (this.enabled == false || !this._shown) return;
			this._shown = false;
			if (instant)
			{
				this.autoAlpha = 0;
			}
			else
			{
				TweenLite.to(this, this._hideDuration, {autoAlpha:0});
			}
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public function get showDuration():Number
		{
			return this._showDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Show duration", type="Number", defaultValue="0.5")]
		public function set showDuration(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "showDuration can not be NaN"));
			
			this._showDuration = value;
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public function get hideDuration():Number
		{
			return this._hideDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Hide duration", type="Number", defaultValue="0.5")]
		public function set hideDuration(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "hideDuration can not be NaN"));
			
			this._hideDuration = value;
		}
	}
}