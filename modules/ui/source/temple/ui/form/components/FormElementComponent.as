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
	import temple.core.display.CoreSprite;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.focus.FocusManager;
	import temple.ui.form.validation.IHasError;
	import temple.ui.states.StateHelper;

	import flash.events.FocusEvent;

	/**
	 * Base component class for form elements.
	 * 
	 * @author Thijs Broerse
	 */
	public class FormElementComponent extends CoreSprite implements IFormElementComponent, IHasError 
	{
		protected var _validator:Class;
		private var _focus:Boolean;
		private var _dataName:String;
		private var _errorMessage:String;
		private var _tabIndex:int;
		private var _submit:Boolean = true;
		private var _hasError:Boolean;
		
		public function FormElementComponent()
		{
			super();
			
			FocusManager.init(this.stage);
			
			this.addEventListener(FocusEvent.FOCUS_IN, this.handleFocusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			throwError(new TempleError(this, "Override this method"));
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get dataName():String
		{
			return this._dataName;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Data name", type="String")]
		public function set dataName(value:String):void
		{
			this._dataName = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get validationRule():Class
		{
			return this._validator;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get errorMessage():String
		{
			return this._errorMessage;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Error message", type="String")]
		public function set errorMessage(value:String):void
		{
			this._errorMessage = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get tabIndex():int
		{
			return this._tabIndex;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Tab index", type="Number", defaultValue="-1")]
		override public function set tabIndex(value:int):void
		{
			this._tabIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get submit():Boolean
		{
			return this._submit;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Submit value", type="Boolean", defaultValue="true")]
		public function set submit(value:Boolean):void
		{
			this._submit = value;
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
			if (value == this._focus) return;
			
			if (value)
			{
				FocusManager.focus = this;
			}
			else if (this._focus)
			{
				FocusManager.focus = null;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get hasError():Boolean
		{
			return this._hasError;
		}

		/**
		 * @inheritDoc 
		 */
		public function set hasError(value:Boolean):void
		{
			if (value)
			{
				this.showError();
			}
			else
			{
				this.hideError();
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function showError(message:String = null):void 
		{
			this._hasError = true;
			this._errorMessage = message;
			StateHelper.showError(this, message);
		}
		
		/**
		 * @inheritDoc 
		 */
		public function hideError():void 
		{
			this._hasError = false;
			StateHelper.hideError(this);
		}
		
		/**
		 * @private
		 */
		protected function handleFocusIn(event:FocusEvent):void 
		{
			this._focus = true;
			StateHelper.showFocus(this);
		}

		/**
		 * @private
		 */
		protected function handleFocusOut(event:FocusEvent):void 
		{
			this._focus = false;
			StateHelper.hideFocus(this);
		}

		/**
		 * @inheritDoc 
		 */
		override public function destruct():void
		{
			this._dataName = null;
			this._errorMessage = null;
			this._validator = null;
			
			super.destruct();
		}
	}
}
