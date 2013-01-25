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
			_form = new Form();
			_form.addEventListener(FormEvent.VALIDATE_ERROR, handleFormEvent);
			_form.addEventListener(FormEvent.VALIDATE_SUCCESS, handleFormEvent);
			_form.addEventListener(FormEvent.SUBMIT_ERROR, handleFormEvent);
			_form.addEventListener(FormEvent.SUBMIT_SUCCESS, handleFormEvent);
			_form.addEventListener(FormEvent.RESET, handleFormEvent);
			
			// Wait a frame so all children are initialized
			new FrameDelay(findComponents);
		}
		
		/**
		 * Returns a reference to the Form
		 */
		public function get form():Form
		{
			return _form;
		}
		
		/**
		 * Add a component to the form
		 */
		public function addComponent(component:IFormElementComponent):void
		{
			_form.addElement(component, component.dataName, component.validationRule, component.errorMessage, component.tabIndex, component.submit);
		}
		
		/**
		 * Submit the form, after validation
		 * 
		 * Note, if the form is disabled (enabled = false) the form will not validate or submit
		 */
		public function submit():void
		{
			_form.submit();
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Debug", type="Boolean", defaultValue="false")]
		override public function set debug(value:Boolean):void
		{
			super.debug = _form.debug = value;
		}
		
		protected function findComponents():void
		{
			// find form elements components
			var item:DisplayObject;
			var leni:int = numChildren;
			for (var i:int = 0; i < leni ; i++)
			{
				item = getChildAt(i);
				if (item is IFormElementComponent) addComponent(IFormElementComponent(item));
				if (item is ISubmitButton) _form.addSubmitButton(item);
				if (item is IResetButton) _form.addResetButton(item);
			}
			_form.reset();
		}

		protected function handleFormEvent(event:FormEvent):void
		{
			if (_form.debug) logDebug("handleFormEvent: " + event.type);
			
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
					_form.validator.stopRealtimeValidating();
					StateHelper.hideError(this);
					break;
				}
			}
			dispatchEvent(event.clone());
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_urlName = null;
			
			if (_form)
			{
				_form.destruct();
				_form = null;
			}
			super.destruct();
		}
	}
}
