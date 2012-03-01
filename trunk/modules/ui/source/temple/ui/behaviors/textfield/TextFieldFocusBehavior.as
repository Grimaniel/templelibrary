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
	import temple.common.interfaces.IFocusable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;
	import temple.ui.focus.FocusManager;

	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * Handles the focus of a TextField, so the TextField can be used by the TabFocusManager.
	 * 
	 * @see temple.ui.focus.TabFocusManager
	 * 
	 * @author Thijs Broerse
	 */
	public class TextFieldFocusBehavior extends AbstractDisplayObjectBehavior implements IFocusable
	{
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the LiquidBehavior of a DisplayObject, if the DisplayObject has LiquidBehavior. Otherwise null is returned.
		 */
		public static function getInstance(target:TextField):TextFieldFocusBehavior
		{
			return TextFieldFocusBehavior._dictionary[target] as TextFieldFocusBehavior;
		}
		
		private var _focus:Boolean;

		public function TextFieldFocusBehavior(target:TextField)
		{
			super(target);
			this.toStringProps.push('name');
			if (TextFieldFocusBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has TextFieldFocusBehavior"));
			TextFieldFocusBehavior._dictionary[target] = this;
			
			target.tabEnabled = false;
			
			target.addEventListener(FocusEvent.FOCUS_IN, this.handleFocusIn);
			target.addEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
			target.addEventListener(KeyboardEvent.KEY_DOWN, this.dispatchEvent);
			target.addEventListener(KeyboardEvent.KEY_UP, this.dispatchEvent);
		}
		
		/**
		 * Returns a reference of the TextField of the TextFieldFocusBehavior
		 */
		public function get textField():TextField
		{
			return this.target as TextField;
		}

		/**
		 * Returns the name of the TextField
		 */
		public function get name():String
		{
			return this.textField.name;
		}

		
		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return this._focus;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			FocusManager.focus = this.textField;
		}
		
		private function handleFocusIn(event:FocusEvent):void 
		{
			this._focus = true;
		}

		private function handleFocusOut(event:FocusEvent):void 
		{
			this._focus = false;
		}

		override public function destruct():void 
		{
			if (this.textField)
			{
				target.addEventListener(FocusEvent.FOCUS_IN, this.handleFocusIn);
				target.addEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
			}
			
			super.destruct();
		}
	}
}
