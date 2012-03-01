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
	import temple.codecomponents.graphics.CodeBackground;
	import temple.codecomponents.scroll.CodeScrollBar;
	import temple.ui.form.components.List;
	import temple.ui.layout.liquid.LiquidBehavior;

	/**
	 * @includeExample CodeListExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CodeList extends List 
	{
		public function CodeList(width:Number = 160, rowCount:uint = 10, items:Array = null)
		{
			super(CodeListRow, rowCount);
			
			this.width = width;
			this.height = 60;
			
			this.scrollbar = new CodeScrollBar();
			this.addChild(this.scrollbar);
			this.scrollbar.top = 0;
			this.scrollbar.bottom = 0;
			this.scrollbar.right = 0;

			new LiquidBehavior(this.addChildAt(new CodeBackground(100, 100), 0), this, {top: 0, left: 0, right: 0, bottom: 0});
			
			if (items) this.addItems(items);
		}

		override public function set width(value:Number) : void
		{
			super.width = value;

			for (var i:int = 0, len:uint = this.rows.length; i < len; i++)
			{
				if (this.rows[i] is CodeListRow)
				{
					(this.rows[i] as CodeListRow).width = value;
				}
			}
		}

		override protected function createRow() : void
		{
			super.createRow();
			this.width = this.width;
		}

	}
}
