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
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;
	import temple.utils.color.ColorUtils;

	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;

	/**
	 * Class for setting the coloring of the selection of a TextField.
	 * 
	 * @author Thijs Broerse
	 */
	public class TextFieldColorizer extends AbstractDisplayObjectBehavior 
	{
		private var _textColor:uint;
		private var _selectedColor:uint;
		private var _selectionColor:uint;
		private var _colorMatrixFilter:ColorMatrixFilter;
		
		public function TextFieldColorizer(target:TextField, textColor:Number = 0x000000, selectionColor:uint = 0x000000, selectedColor: uint = 0)
		{
			super(target);
			
			_textColor = textColor;
			_selectionColor = selectionColor;
			_selectedColor = selectedColor;
			_colorMatrixFilter = new ColorMatrixFilter();
			updateFilter();
		}
		
		/**
		 * Returns a reference of the TextField of the TextFieldColor
		 */
		public function get textField():TextField
		{
			return target as TextField;
		}
		
		public function get textColor():uint
		{
			return _textColor;
		}
		
		public function set textColor(value:uint):void
		{
			_textColor = value;
			updateFilter();
		}
		
		public function get selectedColor():uint
		{
			return _selectedColor;
		}
		
		public function set selectedColor(value:uint):void
		{
			_selectedColor = value;
			updateFilter();
		}
		
		public function get selectionColor():uint
		{
			return _selectionColor;
		}
		
		public function set selectionColor(value:uint):void
		{
			_selectionColor = value;
			updateFilter();
		}
		
		private function updateFilter():void
		{
			textField.textColor = 0xff0000;
			
			var o:Object = ColorUtils.getRGB(_selectionColor);
			var r:Object = ColorUtils.getRGB(_textColor);
			var g:Object = ColorUtils.getRGB(_selectedColor);
			
			const byteToPerc:Number = 1 / 0xff;
			
			var rr:Number = ((r.r - 0xff) - o.r) * byteToPerc + 1;
			var rg:Number = ((r.g - 0xff) - o.g) * byteToPerc + 1;
			var rb:Number = ((r.b - 0xff) - o.b) * byteToPerc + 1;

			var gr:Number = ((g.r - 0xff) - o.r) * byteToPerc + 1 - rr;
			var gg:Number = ((g.g - 0xff) - o.g) * byteToPerc + 1 - rg;
			var gb:Number = ((g.b - 0xff) - o.b) * byteToPerc + 1 - rb;
			
			_colorMatrixFilter.matrix = [rr, gr, 0, 0, o.r, rg, gg, 0, 0, o.g, rb, gb, 0, 0, o.b, 0, 0, 0, 1, 0];
			
			textField.filters = [_colorMatrixFilter];
		}
	}
}
