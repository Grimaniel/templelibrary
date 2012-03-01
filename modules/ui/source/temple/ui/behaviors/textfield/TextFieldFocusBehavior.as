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
