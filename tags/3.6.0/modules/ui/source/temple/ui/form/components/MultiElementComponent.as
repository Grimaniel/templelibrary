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

package temple.ui.form.components 
{
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.IResettable;
	import temple.ui.focus.TabFocusManager;
	import temple.ui.form.validation.IHasError;

	/**
	 * Base class for form element which consists of multiple element.
	 * 
	 * @author Thijs Broerse
	 */
	public class MultiElementComponent extends FormElementComponent implements IHasError, IResettable 
	{
		private var _focusManager:TabFocusManager;
		
		public function MultiElementComponent()
		{
			_focusManager = new TabFocusManager(false);
			super();
		}
		
		/**
		 * Returns a clone of the element list
		 */
		public function get elements():Array
		{
			return _focusManager.items;
		}

		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void 
		{
			_focusManager.focus = super.focus = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function showError(message:String = null):void
		{
			super.showError(message);
			
			var elements:Array = elements;
			var leni:int = elements.length;
			for (var i:int = 0; i < leni; i++)
			{
				if (elements[i] is IHasError)
				{
					IHasError(elements[i]).showError(message);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function hideError():void
		{
			super.hideError();
			var elements:Array = elements;
			var leni:int = elements.length;
			for (var i:int = 0; i < leni; i++)
			{
				if (elements[i] is IHasError)
				{
					IHasError(elements[i]).hideError();
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			var elements:Array = elements;
			var leni:int = elements.length;
			for (var i:int = 0; i < leni; i++)
			{
				if (elements[i] is IResettable)
				{
					IResettable(elements[i]).reset();
				}
			}
		}
		
		/**
		 * Returns a reference to the TabFocusManager
		 */
		public function get focusManager():TabFocusManager
		{
			return _focusManager;
		}

		protected function addElement(element:IFocusable):void 
		{
			_focusManager.add(element);
		}

		protected function removeElement(element:IFocusable):void 
		{
			_focusManager.remove(element);
		}
	}
}
