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

package temple.ui.form
{
	import temple.common.interfaces.IEnableable;
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.IResettable;
	import temple.core.debug.DebugManager;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.data.collections.HashMap;
	import temple.ui.focus.TabFocusManager;
	import temple.ui.form.components.FormElementEvent;
	import temple.ui.form.components.ISetValue;
	import temple.ui.form.result.FormResult;
	import temple.ui.form.result.IFormFieldError;
	import temple.ui.form.result.IFormResult;
	import temple.ui.form.services.FormServiceEvent;
	import temple.ui.form.services.IFormService;
	import temple.ui.form.validation.IHasError;
	import temple.ui.form.validation.Validator;
	import temple.utils.types.ObjectUtils;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;


	/**
	 * @eventType temple.ui.form.FormEvent.VALIDATE_SUCCESS
	 */
	[Event(name = "FormEvent.validateSuccess", type = "temple.ui.form.FormEvent")]

	/**
	 * @eventType temple.ui.form.FormEvent.VALIDATE_ERROR
	 */
	[Event(name = "FormEvent.validateError", type = "temple.ui.form.FormEvent")]

	/**
	 * @eventType temple.ui.form.FormEvent.SUBMIT_SUCCESS
	 */
	[Event(name = "FormEvent.submitSuccess", type = "temple.ui.form.FormEvent")]

	/**
	 * @eventType temple.ui.form.FormEvent.SUBMIT_ERROR
	 */
	[Event(name = "FormEvent.submitError", type = "temple.ui.form.FormEvent")]

	/**
	 * @eventType temple.ui.form.FormEvent.RESET
	 */
	[Event(name = "FormEvent.reset", type = "temple.ui.form.FormEvent")]

	/**
	 * A Form is used to get information from the user. The form uses form elements, like <code>InputField</code>,
	 * <code>CheckBoxes</code> or <code>RadioButtons</code>, to let the user fill in the data.
	 * By adding the elements to the Form, the Form can handle the validation, tabbing, clearing, prefilling and submit
	 * of the elements and the data.
	 * 
	 * <p>A Temple Form consists of:</p>
	 * <ul>
	 *  <li>Elements</li>
	 *  <li>Validator</li>
	 *  <li>TabFocusManager</li>
	 *  <li>FormService</li>
	 * </ul>
	 * 
	 * <p><strong>Elements</strong></p>
	 * <p>The elements are the visible objects of the Form. Add elements to a Form with '<code>addElement()</code>'
	 * like:</p>
	 * <listing version="3.0">
	 * _form.addElement(mcNameField, "name", EmptyStringValidationRule, "you must fill in a name");</listing>
	 * 
	 * <p><strong>Validator</strong></p>
	 * <p>A <code>Validator</code> checks if the form is valid (the user has filled in all mandatory fields, and filled 
	 * them correctly) before the Form is submitted. A <code>Validator</code> is built-in in the Form and is called
	 * automatically.
	 * The <code>Validator</code> will call <code>showError()</code> with the corresponding error message if the elemt
	 * isn't valid.</p>
	 * 
	 * <p><strong>TabFocusManager</strong></p>
	 * <p>A <code>TabFocusManager</code> handles the focus between the elements of the Form. When the user presses the 
	 * tab-ket it will automatically set the focus to the next element of the Form. Or the previous when the user 
	 * also presses the Shift-key. The <code>TabFocusManager</code> is built-in in the Form.</p>
	 * 
	 * <p><strong>FormService</strong></p>
	 * <p>A <code>FormService</code> handles the data of the Form after the Form is validated and submitted.
	 * For instance a FormService can send this data to a backend server or store the data is an object. When the
	 * submission of the data by the FormService is complete is returns an <code>IFormResult</code>. This can be
	 * done synchronously by returning the <code>IFormResult</code> with the <code>submit</code> call. Or asynchronously
	 * by dispatching an <code>FormServiceEvent</code> and send the <code>IFormResult</code> with this
	 * <code>FormServiceEvent</code>. Therefor the <code>submit</code> method must return <code>null</code>, so the 
	 * Form knows it must listen for a <code>FormServiceEvent</code>.</p>
	 * 
	 * <p>The <code>IFormResult</code> contains information about the handling of the submission. The 
	 * <code>IFormResult</code> has a <code>success</code> which is <code>true</code> when the submission was
	 * successful. It also has an optional <code>errors</code> which can contain more information about a possible
	 * failure. The <code>IFormResult</code> has a <code>data</code> property which contains the data from the 
	 * <code>FormService</code>.</p>
	 * 
	 * <p>The <code>IFormService</code> must be set manually. If the <code>Form</code> doesn't have an
	 * <code>IFormService</code>, the <code>Form</code> can't be submitted.</p>
	 * 
	 * <p><strong>Adding hidden values to a Form</strong></p>
	 * <p>It's possible to add values to the <code>Form</code> which are send with the submit. This is done with the
	 * <code>insertModelData()</code> method.</p>
	 * 
	 * @see temple.ui.form.components.InputField
	 * @see temple.ui.form.components.CheckBox
	 * @see temple.ui.form.components.RadioButton
	 * @see temple.ui.form.components.RadioGroup
	 * @see temple.ui.form.components.List
	 * @see temple.ui.form.components.ComboBox
	 * 
	 * @see temple.ui.form.validation.Validator
	 * @see temple.ui.focus.TabFocusManager
	 * 
	 * @see temple.ui.form.services.IFormService
	 * @see temple.ui.form.services.FormServiceEvent
	 * @see temple.ui.form.result.IFormResult
	 * @see temple.ui.form.result.FormResult
	 * 
	 * @includeExample FormExample.as
	 * 
	 * @includeExample services/XMLFormServiceExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class Form extends CoreEventDispatcher implements IDebuggable, IEnableable, IResettable, IFocusable
	{
		private var _validator:Validator;
		private var _service:IFormService;
		private var _dataModel:Object;
		private var _elements:HashMap;
		private var _tabFocusManager:TabFocusManager;
		private var _debug:Boolean;
		private var _enabled:Boolean = true;
		private var _prefillData:Object;
		private var _submitByElement:Boolean = true;
		private var _submitButtons:Dictionary;
		private var _resetButtons:Dictionary;
		private var _elementIndex:uint;
		private var _disableOnSubmit:Boolean = true;

		/**
		 * Form
		 * @param service The IFormService that handles the submit.
		 * @param debug indicates if the form is in debugging mode. If debug is true, debug information is traced via Log
		 */
		public function Form(service:IFormService = null, debug:Boolean = false) 
		{
			super();
			
			this._validator = new Validator();
			this._tabFocusManager = new TabFocusManager();
			
			this._dataModel = new Object();
			this._elements = new HashMap("Form Elements");
			
			this._submitButtons = new Dictionary(true);
			this._resetButtons = new Dictionary(true);
			
			this.debug = debug;
			
			addToDebugManager(this);
			
			if (service) this.service = service;
		}

		/**
		 * The service is the object that handles the submit of the form (like store the data or send to a server etc.)
		 */
		public function get service():IFormService
		{
			return this._service;
		}

		/**
		 * @private
		 */
		public function set service(value:IFormService):void
		{
			if (this._service)
			{
				this._service.removeEventListener(FormServiceEvent.SUCCESS, this.handleFormServiceEvent);
				this._service.removeEventListener(FormServiceEvent.RESULT, this.handleFormServiceEvent);
				this._service.removeEventListener(FormServiceEvent.ERROR, this.handleFormServiceEvent);
			}
			this._service = value;
			
			if (this._service)
			{
				if (this._service is IDebuggable) addToDebugManager(value as IDebuggable, this);
			}
			if (this._debug) this.logDebug("service: " + this._service);
		}

		/**
		 * For adding an input, checkbox, radiogroup etc. to the Form.
		 * @param element the element to add (input/checkbox/radiogroup etc)
		 * @param name the name in the submit object to the IFormService of this element. If null an auto incremented value will be used as name.
		 * @param validationRule (optional) a class that validates the result, NOTE: validationRule must implement IValidationRule.
		 * @param errorMessage (optional) an error message which is returned by the validator.
		 * @param tabIndex (optional). The order for tabbing for this element.
		 * @param submit (optional) indicates if this value should be submitted to the service (true) or should be ignored (false), default: true
		 * @return the element
		 */
		public function addElement(element:IHasValue, name:String = null, validationRule:Class = null, errorMessage:String = null, tabIndex:int = -1, submit:Boolean = true):IHasValue 
		{
			if (this._debug)
			{
				if (submit && name != null)
				{
					this.logDebug("addFormElement: " + element + (name ? " '" + name + "'" : ""));
				}
				else
				{
					this.logWarn("addFormElement: " + element + " '" + name + "', value will not be submit to service");
				}
			}
			
			if (name == null)
			{
				name = this._elementIndex.toString();
				this._elementIndex++;
			}
			
			if (element == null)
			{
				throwError(new TempleArgumentError(this, "element can not be null"));
			}
			
			if (this._elements[name])
			{
				throwError(new TempleArgumentError(this, "element with name '" + name + "' already exists"));
			}
			
			this._elements[name] = new FormElementData(name, element, tabIndex == -1 ? ObjectUtils.length(this._elements) : tabIndex, submit);
			if (element is IDebuggable) addToDebugManager(element as IDebuggable, this);
			
			if (validationRule)
			{
				this._validator.addValidationRule(new validationRule(element), errorMessage);
			}
			
			if (element is IFocusable) this._tabFocusManager.add(element as IFocusable);
			
			if (element is ISetValue && this._prefillData && this._prefillData.hasOwnProperty(name))
			{
				ISetValue(element).value = this._prefillData[name];
			}
			
			if (this._debug && element is IDebuggable)
			{
				IDebuggable(element).debug = this._debug;
			}

			if (element is IEventDispatcher) (element as IEventDispatcher).addEventListener(FormElementEvent.SUBMIT, this.handleFormElementSubmit);
			
			return element;
		}

		/**
		 * Remove an input, checkbox or radiogroup from the form
		 * @element the element to remove
		 */
		public function removeElement(element:IHasValue):void 
		{
			if (this._debug) this.logDebug("removeFormElement: " + element);
			
			// remove from _componentsList
			for each (var fed:FormElementData in this._elements)
			{
				if (fed.element == element)
				{
					delete this._elements[fed.name];
					break;
				}
			}
			
			// remove from validator
			if (this._validator) this._validator.removeElement(element);
			
			// remove from focusManager
			if (this._tabFocusManager && element is IFocusable) this._tabFocusManager.remove(element as IFocusable);
			
			if (element is IEventDispatcher) (element as IEventDispatcher).removeEventListener(FormElementEvent.SUBMIT, this.handleFormElementSubmit);
		}

		/**
		 * Checks if the Form has an element with a specific name
		 */
		public function hasElement(name:String):Boolean
		{
			return (this._elements[name]) ? true : false;
		}

		/**
		 * Returns the element with the specific name
		 */
		public function getElement(name:String):IHasValue
		{
			return this._elements[name] ? FormElementData(this._elements[name]).element : null;
		}
		
		/**
		 * Set if an element with a specific name should be send on submit
		 */
		public function updateElement(name:String, submit:Boolean):void 
		{
			if (this.hasElement(name))
			{
				FormElementData(this._elements[name]).submit = submit;
			}
			else
			{
				throwError(new TempleArgumentError(this, "No element found with name '" + name + "'"));
			}
		}

		/**
		 * Removes all elements of the form
		 */
		public function removeAllElements():void 
		{
			if (this._debug) this.logDebug("removeAllFormElements: ");
			
			var elements:Array = [];
			for each (var fed:FormElementData in this._elements) elements.push(fed.element);
			while (elements.length) this.removeElement(elements.shift());

		}

		/**
		 * add a button for submitting the form 
		 */
		public function addSubmitButton(button:DisplayObject, tabIndex:int = -1, tabEnabled:Boolean = true):void 
		{
			if (this._debug) this.logDebug("addSubmitButton: " + button);
			
			this._submitButtons[button] = 'submitbutton';
			button.addEventListener(MouseEvent.CLICK, handleSubmitButtonClicked, false, 0, true);
			if (tabEnabled && button is IFocusable) this._tabFocusManager.add(button as IFocusable, tabIndex);
		}

		/**
		 * Remove a button for submitting the form 
		 */
		public function removeSubmitButton(button:DisplayObject):void 
		{
			if (this._debug) this.logDebug("removeSubmitButton: " + button);
			
			delete this._submitButtons[button];
			button.removeEventListener(MouseEvent.CLICK, handleSubmitButtonClicked);
			if (button is IFocusable) this._tabFocusManager.remove(button as IFocusable);
		}

		/**
		 * add a button for resetting the form 
		 */
		public function addResetButton(button:DisplayObject, tabIndex:int = -1, tabEnabled:Boolean = true):void 
		{
			if (this._debug) this.logDebug("addCancelButton: " + button);
			
			this._resetButtons[button] = 'cancelbutton';
			button.addEventListener(MouseEvent.CLICK, handleResetButtonClicked, false, 0, true);
			if (tabEnabled && button is IFocusable) this._tabFocusManager.add(button as IFocusable, tabIndex);
		}
		
		/**
		 * Remove a button for submitting the form 
		 */
		public function removeCancelButton(button:DisplayObject):void 
		{
			if (this._debug) this.logDebug("removeCancelButton: " + button);
			
			delete this._resetButtons[button];
			button.removeEventListener(MouseEvent.CLICK, handleResetButtonClicked);
			if (button is IFocusable) this._tabFocusManager.remove(button as IFocusable);
		}

		/**
		 * Submit the form, after validation
		 * 
		 * Note, if the form is disabled (enabled = false) the form will not validate or submit
		 */
		public function submit():void 
		{
			if (this._debug) this.logDebug("submit:");
			
			if (this.enabled)
			{
				// validate
				if (this.validate())
				{
					if (this._debug) this.logDebug(ObjectUtils.traceObject(this.getModelData(), 1, false));
					this.send();
				}
			}
			else
			{
				if (this._debug) this.logDebug("submit: Form is disabled!");
			}
		}

		/**
		 * Insert data in the send object, for hidden form fields
		 */
		public function insertModelData(name:String, data:*):void 
		{
			if (this._debug) this.logDebug("insertModelData: " + name + "=" + data);
			
			this._dataModel[name] = data;
		}

		/**
		 * @inheritDoc
		 * 
		 * Clears all fields and hides the errors
		 * Does not removes the elements, just empties their values
		 */
		public function reset():void 
		{
			if (this._debug) this.logDebug("clear: ");
			
			this._validator.stopRealtimeValidating();
			for each (var fed:FormElementData in this._elements)
			{
				if (fed.element is IHasError) IHasError(fed.element).hideError();
				if (fed.element is IResettable) IResettable(fed.element).reset();
			}
			
			this.dispatchEvent(new FormEvent(FormEvent.RESET));
		}

		/**
		 * Validates the form
		 * @param keepValidating if set to true the form will keep validation after each change
		 * @param showError if set to true wrong elements will show their ErrorState
		 * @return a Boolean which indicates if the form is valid
		 */
		public function validate(keepValidating:Boolean = true, showErrors:Boolean = true):Boolean
		{
			if (this._debug) this.logDebug("validate");
			
			if (!this._enabled)
			{
				if (this._debug) this.logWarn("Form is disabled");
				return false;
			}
			
			if (this._validator.isValid(keepValidating, showErrors))
			{
				if (this._debug) this.logInfo("Form is valid");
				// reset errors states on all elements
				for each (var fed:FormElementData in this._elements)
				{
					if (fed.element is IHasError && IHasError(fed.element).hasError)
					{
						IHasError(fed.element).hideError();
					}
				}
				this.dispatchEvent(new FormEvent(FormEvent.VALIDATE_SUCCESS));
				return true;
			}
			if (this._debug)
			{
				this.logError("Form is invalid: " + this._validator.validate());
				if (this._validator.getErrorMessages().length) this.logError("Error messages: " + this._validator.getErrorMessages());
			}
			
			this.dispatchEvent(new FormEvent(FormEvent.VALIDATE_ERROR, new FormResult(false, this._validator.getErrorMessage())));
			return false;
		}

		/**
		 * Gets the ModelData of the Form
		 * NOTE: This function does not validate the Form. For validation for call validate()
		 */
		public function getModelData():Object
		{
			for each (var fed:FormElementData in this._elements)
			{
				if (fed.submit) this._dataModel[fed.name] = fed.element.value;
			}
			
			if (this._debug)
			{
				for (var key : String in this._dataModel) 
				{
					this.logDebug("ModelData: [" + key + "] : " + this._dataModel[key]);
				}
			}
			return this._dataModel;
		}

		/**
		 * Prefill the form with a data object. Object can be any kind of object.
		 * Form searches for elements with the same name (2nd argument of addElement method) as a property of the prefill object
		 * Form can only prefill elements who implements IPrefillable
		 * @param data The data object (name - value pair) with the prefill data
		 */
		public function prefillData(data:Object):void
		{
			this._prefillData = data;
			
			if (this._debug) this.logDebug("prefillData: " + ObjectUtils.traceObject(data, 0, false));
			
			if (this._prefillData != null)
			{
				for each (var fed:FormElementData in this._elements)
				{
					if (this._prefillData.hasOwnProperty(fed.name) && fed.element is ISetValue)
					{
						ISetValue(fed.element).value = data[fed.name];
						if (this._debug) this.logDebug("prefillData: " + fed.name + " is set to " + data[fed.name]);
					}
					else if (this._debug) this.logDebug("prefillData: " + fed.name + " not found"); 
				}
			}
		}

		/**
		 * Returns the validator, for adding more ValidationRules
		 */
		public function get validator():Validator
		{
			return this._validator;
		}
		
		/**
		 * Returns a reference to the TabFocusManager
		 */
		public function get tabFocusManager():TabFocusManager
		{
			return this._tabFocusManager;
		}

		/**
		 * Indicates if the form is enabled
		 */
		public function get enabled():Boolean
		{
			return this._enabled;
		}

		/**
		 * Enable or disable the form
		 * If the form is disabled it cannot post the data
		 */
		public function set enabled(value:Boolean):void
		{
			if (this._debug) this.logDebug("enabled: " + value);
			
			this._enabled = value;
			
			for (var submitbutton:* in this._submitButtons)
			{
				if (submitbutton is MovieClip) MovieClip(submitbutton).enabled = value;
				if (submitbutton is IEnableable) IEnableable(submitbutton).enabled = value;
			}
			
			for (var cancelbutton:* in this._resetButtons)
			{
				if (cancelbutton is MovieClip) MovieClip(cancelbutton).enabled = value;
				if (cancelbutton is IEnableable) IEnableable(cancelbutton).enabled = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			this.enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			this.enabled = false;
		}

		/**
		 * If set to true, the form can be submitted by an Element if the Element dispatches a FormElementEvent.SUBMIT event
		 */
		public function get submitByElement():Boolean
		{
			return this._submitByElement;
		}
		
		/**
		 * @private
		 */
		public function set submitByElement(value:Boolean):void
		{
			this._submitByElement = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return this._tabFocusManager.focus;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			this._tabFocusManager.focus = value;
		}
		
		/**
		 * A Boolean which indicates if the Form should be disabled when the data is submitted. This prevent multiple submits.
		 * The Form will be enabled again if a result from the service is received.
		 * @default true
		 */
		public function get disableOnSubmit():Boolean
		{
			return this._disableOnSubmit;
		}

		/**
		 * @private
		 */
		public function set disableOnSubmit(value:Boolean):void
		{
			this._disableOnSubmit = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
			if (this._debug) this.logWarn("Form is running in debug mode!");
			
			DebugManager.setDebugForChildren(this, value);
		}

		/**
		 * @private
		 */
		protected function send():void
		{
			if (this._debug) this.logDebug("send: ");
			
			if (this._service != null)
			{
				if (this._disableOnSubmit) this.enabled = false;
				
				// add listeners (remove first to prevend double listening)
				this._service.removeEventListener(FormServiceEvent.SUCCESS, this.handleFormServiceEvent);
				this._service.removeEventListener(FormServiceEvent.RESULT, this.handleFormServiceEvent);
				this._service.removeEventListener(FormServiceEvent.ERROR, this.handleFormServiceEvent);
				this._service.addEventListener(FormServiceEvent.SUCCESS, this.handleFormServiceEvent);
				this._service.addEventListener(FormServiceEvent.RESULT, this.handleFormServiceEvent);
				this._service.addEventListener(FormServiceEvent.ERROR, this.handleFormServiceEvent);

				var result:IFormResult = this._service.submit(this.getModelData());
				
				if (result && !this.enabled)
				{
					this.onResult(result);
					
					// remove listeners
					this._service.removeEventListener(FormServiceEvent.SUCCESS, this.handleFormServiceEvent);
					this._service.removeEventListener(FormServiceEvent.RESULT, this.handleFormServiceEvent);
					this._service.removeEventListener(FormServiceEvent.ERROR, this.handleFormServiceEvent);
				}
			}
			else
			{
				this.logWarn("send: service is not set, form can not be submitted!");
			}
		}

		/**
		 * @private
		 */
		protected function handleSubmitButtonClicked(event:MouseEvent):void 
		{
			this.submit();
		}

		/**
		 * @private
		 */
		protected function handleResetButtonClicked(event:MouseEvent):void 
		{
			this.reset();
		}

		/**
		 * @private
		 */
		protected function handleFormServiceEvent(event:FormServiceEvent):void 
		{
			switch (event.type)
			{
				case FormServiceEvent.SUCCESS:
				{
					this.enabled = true;
					if (this._debug) this.logDebug("handleFormServiceEvent: " + event.type);
					this.dispatchEvent(new FormEvent(FormEvent.SUBMIT_SUCCESS, event.result));
					break;
				}
				case FormServiceEvent.RESULT:
				{
					this.onResult(event.result);
					break;
				}
				case FormServiceEvent.ERROR:
				{
					this.enabled = true;
					
					if (this._debug) this.logError("handleFormServiceEvent: " + event.type);
					
					this.dispatchEvent(new FormEvent(FormEvent.SUBMIT_ERROR, event.result));
					break;
				}
				default:
				{
					if (this._debug) this.logDebug("handleFormServiceEvent: " + event.type);
					break;
				}
			}
		}

		private function onResult(result:IFormResult):void 
		{
			if (result == null) return;
			
			this.enabled = true; 
					
			if (result.success)
			{
				if (this._debug) this.logDebug("onResult: success " + result.message);
			}
			else
			{
				if (this._debug) this.logError("onResult: error " + result.message);
				
				var element:FormElementData;
				var focussed:Boolean;
				for each (var error:IFormFieldError in result.errors)
				{
					element = this._elements[error.field];
					if (element)
					{
						if (element.element is IHasError)
						{
							IHasError(element.element).showError(error.message);
							if (!focussed && element.element is IFocusable)
							{
								IFocusable(element.element).focus = true;
								focussed = true;
							}
						}
					}
					else if (this._debug) this.logWarn("handleFormServiceEvent: no field with name '" + error.field + "' found");
					
					if (this._debug) this.logError("handleFormServiceEvent: Error: " + error.field + " '" + error.message + "' (" + error.code + ")");
				}
			}
			this.dispatchEvent(new FormEvent(result.success ? FormEvent.SUBMIT_SUCCESS : FormEvent.SUBMIT_ERROR, result));
					
		}

		
		/**
		 * @private
		 */
		protected function handleFormElementSubmit(event:FormElementEvent):void
		{
			if (this._submitByElement) this.submit();
		}

		/**
		 * @inheritDoc
		 * 
		 * Distroys the form and his elements
		 */
		override public function destruct():void
		{
			if (this._debug) this.logDebug("destruct: ");
			
			this._submitButtons = null;
			this._resetButtons = null;
			this._service = null;
			
			// Destruct validator
			if (this._validator)
			{
				this._validator.destruct();
				this._validator = null;
			}
			
			// Destruct focusmanager
			if (this._tabFocusManager)
			{
				this._tabFocusManager.destruct();
				this._tabFocusManager = null;
			}
			
			// Destruct elements
			if (this._elements)
			{
				this.removeAllElements();
				this._elements = null;
			}
			this._prefillData = null;
			
			super.destruct();
		}
	}
}
import temple.common.interfaces.IHasValue;

class FormElementData
{
	public var name:String;
	public var element:IHasValue;
	public var tabindex:int;
	public var submit:Boolean;
	
	public function FormElementData(name:String, element:IHasValue, tabIndex:int, submit:Boolean) 
	{
		this.name = name;
		this.element = element;
		this.tabindex = tabIndex;
		this.submit = submit;
	}
}
