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
			this._focusManager = new TabFocusManager(false);
			super();
		}
		
		/**
		 * Returns a clone of the element list
		 */
		public function get elements():Array
		{
			return this._focusManager.items;
		}

		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void 
		{
			this._focusManager.focus = super.focus = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function showError(message:String = null):void
		{
			super.showError(message);
			
			var elements:Array = this.elements;
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
			var elements:Array = this.elements;
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
			var elements:Array = this.elements;
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
			return this._focusManager;
		}

		protected function addElement(element:IFocusable):void 
		{
			this._focusManager.add(element);
		}

		protected function removeElement(element:IFocusable):void 
		{
			this._focusManager.remove(element);
		}
	}
}
