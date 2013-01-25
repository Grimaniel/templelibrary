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
			
			this.scrollBar = new CodeScrollBar();
			this.addChild(this.scrollBar);
			this.scrollBar.top = 0;
			this.scrollBar.bottom = 0;
			this.scrollBar.right = 0;

			new LiquidBehavior(this.addChildAt(new CodeBackground(100, 100), 0), {top: 0, left: 0, right: 0, bottom: 0}, this);
			
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
