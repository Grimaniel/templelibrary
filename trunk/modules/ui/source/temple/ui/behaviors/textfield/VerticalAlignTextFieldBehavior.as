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
	import temple.common.enum.Align;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	/**
	 * Dispatched when the TextField is aligned
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * The VerticalAlignTextFieldBehavior adds vertical alignment to a TextField.
	 * <p>When the text of the TextField is changed, the position of the TextField will be changed to give it the correct vertical alignment</p> 
	 * 
	 * @author Thijs Broerse
	 */
	public class VerticalAlignTextFieldBehavior extends AbstractDisplayObjectBehavior 
	{
		private var _align:String;
		private var _top:Number;
		private var _middle:Number;
		private var _bottom:Number;
		
		public function VerticalAlignTextFieldBehavior(target:TextField, align:String, autoSize:String = 'left')
		{
			super(target);
			
			this._top = target.y;
			this._bottom = target.y + target.height;
			this._middle = target.y + target.height * .5;
			
			switch (autoSize)
			{
				case TextFieldAutoSize.CENTER:
				case TextFieldAutoSize.LEFT:
				case TextFieldAutoSize.RIGHT:
					target.autoSize = autoSize;
					break;
				
				default:
					throwError(new TempleError(this, "Invalid value for autoSize: '" + autoSize + "', autoSize must be 'left', 'right' or 'center'"));
					break;
			}
			
			this.align = align;
			target.addEventListener(Event.CHANGE, this.handleTextFieldChange);
		}
		
		/**
		 * The vertical alignement. Possible values: Align.TOP, Align.MIDDLE, Align.BOTTOM
		 */
		public function get align():String
		{
			return this._align;
		}
		
		/**
		 * @private
		 */
		public function set align(value:String):void
		{
			switch (value)
			{
				case Align.TOP:
				case Align.MIDDLE:
				case Align.BOTTOM:
					this._align = value;
					this.doAlign();
					break;
				default:
					throwError(new TempleError(this, "Invalid value for align: '" + value + "'"));
					break;
			}
		}
		
		/**
		 * The initial top of the TextField
		 */
		public function get top():Number
		{
			return this._top;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set top(value:Number):void
		{
			this._top = value;
		}
		
		/**
		 * The initial middle of the TextField
		 */
		public function get middle():Number
		{
			return this._middle;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set middle(value:Number):void
		{
			this._middle = value;
		}
		
		/**
		 * The initial bottom of the TextField
		 */
		public function get bottom():Number
		{
			return this._bottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set bottom(value:Number):void
		{
			this._bottom = value;
		}
		
		private function handleTextFieldChange(event:Event):void
		{
			this.doAlign();
		}

		private function doAlign():void
		{
			switch (this._align)
			{
				case Align.TOP:
					this.displayObject.y = this._top;
					break;
				case Align.BOTTOM:
					this.displayObject.y = this._bottom - this.displayObject.height;
					break;
				case Align.MIDDLE:
					this.displayObject.y = this._middle - .5 * this.displayObject.height;
					break;
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.displayObject) this.displayObject.removeEventListener(Event.CHANGE, this.handleTextFieldChange);
			
			super.destruct();
		}
	}
}
