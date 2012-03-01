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
	import temple.core.debug.IDebuggable;
	import temple.core.display.CoreMovieClip;
	import temple.ui.form.Form;
	import temple.ui.form.FormEvent;
	import temple.ui.states.StateHelper;
	import temple.utils.FrameDelay;

	import flash.display.DisplayObject;

	/**
	 * Component for easy generating Forms without any code in the Flash IDE.
	 * 
	 * <p>The <code>FormComponent</code> searches the display list for objects which implements
	 * <code>IFormElementComponent</code> and add them automatically as element of a Form. If
	 * a <code>DisplayObject</code> implements <code>ISubmitButton</code> it will automatically be set a SubmitButton
	 * for the <code>Form</code>. If a <code>DisplayObject</code> implements <code>IResetButton</code> it will
	 * be set a ResetButton for the <code>Form</code>.</p>
	 * 
	 * @see temple.ui.form.components.IFormElementComponent
	 * @see temple.ui.form.components.ISubmitButton
	 * @see temple.ui.form.components.IResetButton
	 * @see temple.ui.form.Form
	 * 
	 * @author Thijs Broerse
	 */
	public class FormComponent extends CoreMovieClip implements IDebuggable
	{
		private var _form:Form;
		private var _urlName:String;

		public function FormComponent()
		{
			this._form = new Form();
			this._form.addEventListener(FormEvent.VALIDATE_ERROR, this.handleFormEvent);
			this._form.addEventListener(FormEvent.VALIDATE_SUCCESS, this.handleFormEvent);
			this._form.addEventListener(FormEvent.SUBMIT_ERROR, this.handleFormEvent);
			this._form.addEventListener(FormEvent.SUBMIT_SUCCESS, this.handleFormEvent);
			this._form.addEventListener(FormEvent.RESET, this.handleFormEvent);
			
			// Wait a frame so all children are initialized
			new FrameDelay(this.findComponents);
		}
		
		/**
		 * Returns a reference to the Form
		 */
		public function get form():Form
		{
			return this._form;
		}
		
		/**
		 * Add a component to the form
		 */
		public function addComponent(component:IFormElementComponent):void
		{
			this._form.addElement(component, component.dataName, component.validationRule, component.errorMessage, component.tabIndex, component.submit);
		}
		
		/**
		 * Submit the form, after validation
		 * 
		 * Note, if the form is disabled (enabled = false) the form will not validate or submit
		 */
		public function submit():void
		{
			this._form.submit();
		}

		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._form.debug;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Debug mode", type="Boolean")]
		public function set debug(value:Boolean):void
		{
			this._form.debug = value;
		}
		
		protected function findComponents():void
		{
			// find form elements components
			var item:DisplayObject;
			var leni:int = this.numChildren;
			for (var i:int = 0; i < leni ; i++)
			{
				item = this.getChildAt(i);
				if (item is IFormElementComponent) this.addComponent(IFormElementComponent(item));
				if (item is ISubmitButton) this._form.addSubmitButton(item);
				if (item is IResetButton) this._form.addResetButton(item);
			}
			this._form.reset();
		}

		protected function handleFormEvent(event:FormEvent):void
		{
			if (this._form.debug) this.logDebug("handleFormEvent: " + event.type);
			
			switch (event.type)
			{
				case FormEvent.VALIDATE_ERROR:
				case FormEvent.SUBMIT_ERROR:
				{
					StateHelper.showError(this, event.result ? event.result.message : null);
					break;
				}
				case FormEvent.VALIDATE_SUCCESS:
				case FormEvent.SUBMIT_SUCCESS:
				case FormEvent.RESET:
				{
					this._form.validator.stopRealtimeValidating();
					StateHelper.hideError(this);
					break;
				}
			}
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._urlName = null;
			
			if (this._form)
			{
				this._form.destruct();
				this._form = null;
			}
			super.destruct();
		}
	}
}
