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
			super(this.addChild(new TextField()) as TextField, this.addChild(new CodeList(width)) as IList);
			
			this.textField.type = TextFieldType.INPUT;
			this.textField.width = width;
			this.textField.height = height;
			this.textField.defaultTextFormat = CodeStyle.textFormat;
			this.multiline = multiline;
			
			this.hintTextColor = 0x888888;
			this.errorTextColor = 0xff0000;
			
			this.addChildAt(new CodeBackground(width, height), 0);
			
			// focus state
			var focus:FocusFadeState = new FocusFadeState(.2, .2);
			focus.graphics.beginFill(0xff0000, 1);
			focus.graphics.drawRect(-1, -1, width+2, height+2);
			focus.graphics.endFill();
			this.addChildAt(focus, 0);
			focus.filters = CodeStyle.focusFilters;
			
			this.list.y = height;
			
			// icon
			var icon:CoreShape = new CoreShape();
			this.addChild(icon);
			
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
			
			if (items) this.addItems(items);
			this.inSearch = inSearch;
		}
	}
}
