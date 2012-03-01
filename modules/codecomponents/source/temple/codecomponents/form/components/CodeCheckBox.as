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
