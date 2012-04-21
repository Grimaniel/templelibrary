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

package temple.ui.scroll
{
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;

	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * Makes a <code>TextField</code> act like a <code>ScrollPange</code> and can be managed by a
	 * <code>ScrollBehavior</code> or <code>ScrollBar</code>.
	 * 
	 * @see temple.ui.scroll.IScrollPane
	 * @see temple.ui.scroll.ScrollPane
	 * @see temple.ui.scroll.ScrollBehavior
	 * @see temple.ui.scroll.ScrollBar
	 * 
	 * @author Thijs Broerse
	 */
	public class TextFieldScrollBehavior extends AbstractDisplayObjectBehavior implements IScrollPane
	{
		private var _stepSize:Number;
		
		public function TextFieldScrollBehavior(target:TextField, stepSize:Number = 3)
		{
			super(target);
			
			this._stepSize = stepSize;
			
			target.addEventListener(Event.SCROLL, this.handleTextFieldScroll);
			target.addEventListener(Event.CHANGE, this.handleTextChange);
			target.addEventListener(Event.RESIZE, this.handleResize);
		}

		/**
		 * Returns a reference of the TextField of the TextFieldScrollBehavior
		 */
		public function get textField():TextField
		{
			return this.target as TextField;
		}
		
		public function get stepSize():Number
		{
			return this._stepSize;
		}

		public function set stepSize(value:Number):void
		{
			this._stepSize = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get width():Number
		{
			return this.textField.width;
		}

		/**
		 * @inheritDoc
		 */
		public function get height():Number
		{
			return this.textField.height;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scrollH():Number
		{
			return this.textField.scrollH;
		}

		/**
		 * @inheritDoc
		 */
		public function set scrollH(value:Number):void
		{
			this.textField.scrollH = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get maxScrollH():Number
		{
			return this.textField.maxScrollH;
		}

		/**
		 * @inheritDoc
		 */
		public function scrollHTo(value:Number):void
		{
			this.scrollH = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get targetScrollH():Number
		{
			return this.scrollH;
		}

		/**
		 * @inheritDoc
		 */
		public function get scrollV():Number
		{
			return this.textField.scrollV;
		}

		/**
		 * @inheritDoc
		 */
		public function set scrollV(value:Number):void
		{
			this.textField.scrollV = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get maxScrollV():Number
		{
			return this.textField.maxScrollV;
		}

		/**
		 * @inheritDoc
		 */
		public function scrollVTo(value:Number):void
		{
			this.scrollV = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get targetScrollV():Number
		{
			return this.scrollV;
		}

		/**
		 * @inheritDoc
		 */
		public function get contentWidth():Number
		{
			return this.textField.textWidth;
		}

		/**
		 * @inheritDoc
		 */
		public function get contentHeight():Number
		{
			return this.textField.textHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function scrollUp():void
		{
			this.scrollVTo(this.scrollV - this._stepSize);
		}

		/**
		 * @inheritDoc
		 */
		public function scrollDown():void
		{
			this.scrollVTo(this.scrollV + this._stepSize);
		}

		/**
		 * @inheritDoc
		 */
		public function scrollLeft():void
		{
			this.scrollHTo(this.scrollV - this._stepSize);
		}

		/**
		 * @inheritDoc
		 */
		public function scrollRight():void
		{
			this.scrollHTo(this.scrollV + this._stepSize);
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollUp():Boolean
		{
			return this.scrollV > 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollDown():Boolean
		{
			return this.scrollV < this.maxScrollV;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollLeft():Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function get canScrollRight():Boolean
		{
			return false;
		}
		
		private function handleTextFieldScroll(event:Event):void
		{
			this.dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, this.scrollH, this.scrollV, this.maxScrollH, this.maxScrollV));
		}

		private function handleTextChange(event:Event):void
		{
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function handleResize(event:Event):void
		{
			this.dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.textField)
			{
				this.textField.removeEventListener(Event.SCROLL, this.handleTextFieldScroll);
				this.textField.removeEventListener(Event.CHANGE, this.handleTextChange);
				this.textField.removeEventListener(Event.RESIZE, this.handleResize);
			}
			
			super.destruct();
		}

	}
}
