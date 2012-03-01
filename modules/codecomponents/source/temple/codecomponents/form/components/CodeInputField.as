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
