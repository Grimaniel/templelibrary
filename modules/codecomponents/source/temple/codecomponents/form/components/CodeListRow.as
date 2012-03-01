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
			this.addChild(new TextField());
			
			super();
			
			this.textField.width = width;
			this.textField.height = height;
			this.textField.defaultTextFormat = CodeStyle.textFormat;
			
			// background
			this._background = new CoreShape();
			this._background.graphics.beginFill(CodeStyle.backgroundColor, CodeStyle.backgroundAlpha);
			this._background.graphics.drawRect(0, 0, width, height);
			this._background.graphics.endFill();
			this.addChildAt(this._background, 0);
			
			// over state
			this._over = new OverFadeState();
			this._over.graphics.beginFill(CodeStyle.listItemOverstateColor, CodeStyle.listItemOverstateAlpha);
			this._over.graphics.drawRect(0, 0, width, height);
			this._over.graphics.endFill();
			this.addChildAt(this._over, 1);

			// select state
			this._select = new SelectFadeState(.25, .25);
			this._select.graphics.beginFill(CodeStyle.listItemSelectstateColor, CodeStyle.listItemSelectstateAlpha);
			this._select.graphics.drawRect(0, 0, width, height);
			this._select.graphics.endFill();
			this.addChildAt(this._select, 2);
			
			// focus state
			this._focus = new FocusFadeState(.25, .25);
			this._focus.graphics.lineStyle(CodeStyle.focusThickness, CodeStyle.focusColor, CodeStyle.focusAlpha, true, LineScaleMode.NONE);
			this._focus.graphics.drawRect(CodeStyle.focusThickness * .5, CodeStyle.focusThickness * .5, width - CodeStyle.focusThickness, height - CodeStyle.focusThickness);
			this.addChildAt(this._focus, 3);
		}

		override public function set index(value:uint):void 
		{
			super.index = value;
			
			this._background.alpha = value % 2 ? .2 : .4;
		}
		
		override public function set width(value:Number) : void
		{
			this._background.width = value;
			this._over.width = value;
			this._select.width = value;
			this._focus.width = value - CodeStyle.focusThickness;
			this.textField.width = value;
		}
	}
}
