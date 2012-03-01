/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
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
			
			this._textColor = textColor;
			this._selectionColor = selectionColor;
			this._selectedColor = selectedColor;
			this._colorMatrixFilter = new ColorMatrixFilter();
			this.updateFilter();
		}
		
		/**
		 * Returns a reference of the TextField of the TextFieldColor
		 */
		public function get textField():TextField
		{
			return this.target as TextField;
		}
		
		public function get textColor():uint
		{
			return this._textColor;
		}
		
		public function set textColor(value:uint):void
		{
			this._textColor = value;
			this.updateFilter();
		}
		
		public function get selectedColor():uint
		{
			return this._selectedColor;
		}
		
		public function set selectedColor(value:uint):void
		{
			this._selectedColor = value;
			this.updateFilter();
		}
		
		public function get selectionColor():uint
		{
			return this._selectionColor;
		}
		
		public function set selectionColor(value:uint):void
		{
			this._selectionColor = value;
			this.updateFilter();
		}
		
		private function updateFilter():void
		{
			
			this.textField.textColor = 0xff0000;
			
			ColorUtils.getARGB(this._selectionColor);

			var o:Object = ColorUtils.getRGB(this._selectionColor);
			var r:Object = ColorUtils.getRGB(this._textColor);
			var g:Object = ColorUtils.getRGB(this._selectedColor);
			
			const byteToPerc:Number = 1 / 0xff;
			
			var rr:Number = ((r.r - 0xff) - o.r) * byteToPerc + 1;
			var rg:Number = ((r.g - 0xff) - o.g) * byteToPerc + 1;
			var rb:Number = ((r.b - 0xff) - o.b) * byteToPerc + 1;

			var gr:Number = ((g.r - 0xff) - o.r) * byteToPerc + 1 - rr;
			var gg:Number = ((g.g - 0xff) - o.g) * byteToPerc + 1 - rg;
			var gb:Number = ((g.b - 0xff) - o.b) * byteToPerc + 1 - rb;
			
			this._colorMatrixFilter.matrix = [rr, gr, 0, 0, o.r, rg, gg, 0, 0, o.g, rb, gb, 0, 0, o.b, 0, 0, 0, 1, 0];
			
			this.textField.filters = [this._colorMatrixFilter];
		}
	}
}
