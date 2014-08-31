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

package temple.ui.form
{
	import temple.utils.PropertyApplier;
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
	import temple.ui.form.result.FormFieldError;
	import temple.ui.form.result.FormResult;
	import temple.ui.form.result.IFormFieldError;
	import temple.ui.form.result.IFormResult;
	import temple.ui.form.services.FormServiceEvent;
	import temple.ui.form.services.IFormService;
	import temple.ui.form.validation.IHasError;
	import temple.ui.form.validation.IValidator;
	import temple.ui.form.validation.Validator;
	import temple.ui.form.validation.rules.ValidationRuleData;
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
	public class Form extends CoreEventDispatcher implements IDebuggable, IEnableable, IResettable, IFocusable, IValidator
	{
		private var _validator:Validator;
		private var _service:IFormService;
		private var _data:Object;
		private var _elements:HashMap;
		private var _names:Dictionary;
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
			
			_validator = new Validator();
			_tabFocusManager = new TabFocusManager();
			
			_data = new Object();
			_elements = new HashMap();
			_names = new Dictionary(true);
			
			_submitButtons = new Dictionary(true);
			_resetButtons = new Dictionary(true);
			
			this.debug = debug;
			
			addToDebugManager(this);
			
			if (service) this.service = service;
		}

		/**
		 * The service is the object that handles the submit of the form (like store the data or send to a server etc.)
		 */
		public function get service():IFormService
		{
			return _service;
		}

		/**
		 * @private
		 */
		public function set service(value:IFormService):void
		{
			if (_service)
			{
				_service.removeEventListener(FormServiceEvent.SUCCESS, handleFormServiceEvent);
				_service.removeEventListener(FormServiceEvent.RESULT, handleFormServiceEvent);
				_service.removeEventListener(FormServiceEvent.ERROR, handleFormServiceEvent);
			}
			_service = value;
			
			if (_debug) logDebug("service: " + _service);
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
		public function add(element:IHasValue, name:String = null, validationRule:Class = null, errorMessage:String = null, tabIndex:int = -1, submit:Boolean = true):IHasValue 
		{
			if (_debug)
			{
				if (submit && name != null)
				{
					logDebug("add: " + element + (name ? " '" + name + "'" : ""));
				}
				else
				{
					logWarn("add: " + element + " '" + name + "', value will not be submit to service");
				}
			}
			
			if (name == null)
			{
				name = _elementIndex.toString();
				_elementIndex++;
			}
			
			if (element == null)
			{
				throwError(new TempleArgumentError(this, "element can not be null"));
			}
			
			if (name in _elements)
			{
				throwError(new TempleArgumentError(this, "element with name '" + name + "' already exists"));
			}
			if (element in _names)
			{
				throwError(new TempleArgumentError(this, "element already exists in form"));
			}
			
			_names[element] = name;
			_elements[name] = new FormElementData(name, element, tabIndex == -1 ? ObjectUtils.length(_elements) : tabIndex, submit);
			
			if (validationRule)
			{
				_validator.addValidationRule(new validationRule(element), errorMessage);
			}
			
			if (element is IFocusable) _tabFocusManager.add(element as IFocusable);
			
			if (_prefillData && _prefillData.hasOwnProperty(name))
			{
				element.value = _prefillData[name];
			}
			
			if (_debug && element is IDebuggable)
			{
				IDebuggable(element).debug = _debug;
			}

			if (element is IEventDispatcher) (element as IEventDispatcher).addEventListener(FormElementEvent.SUBMIT, handleFormElementSubmit);
			
			return element;
		}

		/**
		 * Remove an input, checkbox or radiogroup from the form
		 * @element the element to remove
		 */
		public function remove(element:IHasValue):void 
		{
			if (_debug) logDebug("remove: " + element);
			
			// remove from _componentsList
			for each (var fed:FormElementData in _elements)
			{
				if (fed.element == element)
				{
					delete _elements[fed.name];
					break;
				}
			}
			
			delete _names[element];
			
			// remove from validator
			if (_validator) _validator.removeElement(element);
			
			// remove from focusManager
			if (_tabFocusManager && element is IFocusable) _tabFocusManager.remove(element as IFocusable);
			
			if (element is IEventDispatcher) (element as IEventDispatcher).removeEventListener(FormElementEvent.SUBMIT, handleFormElementSubmit);
		}

		/**
		 * Checks if the Form has an element with a specific name
		 */
		public function has(name:String):Boolean
		{
			return (_elements[name]) ? true : false;
		}

		/**
		 * Returns the element with the specific name
		 */
		public function get(name:String):IHasValue
		{
			return _elements[name] ? FormElementData(_elements[name]).element : null;
		}
		
		/**
		 * Returns the name of element in this form
		 */
		public function getNameFor(element:IHasValue):String
		{
			return _names[element];
		}
		
		/**
		 * Set if an element with a specific name should be send on submit
		 */
		public function update(name:String, submit:Boolean):void 
		{
			if (has(name))
			{
				FormElementData(_elements[name]).submit = submit;
			}
			else
			{
				throwError(new TempleArgumentError(this, "No element found with name '" + name + "'"));
			}
		}

		/**
		 * Removes all elements of the form
		 */
		public function removeAll():void 
		{
			if (_debug) logDebug("removeAll");
			
			var elements:Array = [];
			for each (var fed:FormElementData in _elements) elements.push(fed.element);
			while (elements.length) remove(elements.shift());

		}

		/**
		 * add a button for submitting the form 
		 */
		public function addSubmitButton(button:DisplayObject, tabIndex:int = -1, tabEnabled:Boolean = true):void 
		{
			if (_debug) logDebug("addSubmitButton: " + button);
			
			_submitButtons[button] = 'submitbutton';
			button.addEventListener(MouseEvent.CLICK, handleSubmitButtonClicked, false, 0, true);
			if (tabEnabled && button is IFocusable) _tabFocusManager.add(button as IFocusable, tabIndex);
		}

		/**
		 * Remove a button for submitting the form 
		 */
		public function removeSubmitButton(button:DisplayObject):void 
		{
			if (_debug) logDebug("removeSubmitButton: " + button);
			
			delete _submitButtons[button];
			button.removeEventListener(MouseEvent.CLICK, handleSubmitButtonClicked);
			if (button is IFocusable) _tabFocusManager.remove(button as IFocusable);
		}

		/**
		 * add a button for resetting the form 
		 */
		public function addResetButton(button:DisplayObject, tabIndex:int = -1, tabEnabled:Boolean = true):void 
		{
			if (_debug) logDebug("addResetButton: " + button);
			
			_resetButtons[button] = 'cancelbutton';
			button.addEventListener(MouseEvent.CLICK, handleResetButtonClicked, false, 0, true);
			if (tabEnabled && button is IFocusable) _tabFocusManager.add(button as IFocusable, tabIndex);
		}
		
		/**
		 * Remove a button for resetting the form 
		 */
		public function removeResetButton(button:DisplayObject):void 
		{
			if (_debug) logDebug("removeResetButton: " + button);
			
			delete _resetButtons[button];
			button.removeEventListener(MouseEvent.CLICK, handleResetButtonClicked);
			if (button is IFocusable) _tabFocusManager.remove(button as IFocusable);
		}

		/**
		 * Submit the form, after validation
		 * 
		 * Note, if the form is disabled (enabled = false) the form will not validate or submit
		 */
		public function submit():void 
		{
			if (_debug) logDebug("submit:");
			
			if (enabled)
			{
				if (validate().length == 0)
				{
					if (_debug) logDebug(dump(getData()));
					send();
				}
			}
			else
			{
				if (_debug) logDebug("submit: Form is disabled!");
			}
		}

		/**
		 * Insert data in the send object, for hidden form fields
		 */
		public function insertData(name:String, data:*):void 
		{
			if (_debug) logDebug("insertData: " + name + "=" + data);
			
			_data[name] = data;
		}

		/**
		 * @inheritDoc
		 * 
		 * Clears all fields and hides the errors
		 * Does not removes the elements, just empties their values
		 */
		public function reset():void 
		{
			if (_debug) logDebug("clear: ");
			
			// temporary disable submitByElement
			var submitByElement:Boolean = _submitByElement;
			_submitByElement = false;
			
			_validator.stopRealtimeValidating();
			for each (var fed:FormElementData in _elements)
			{
				if (fed.element is IHasError) IHasError(fed.element).hideError();
				if (fed.element is IResettable) IResettable(fed.element).reset();
			}
			_submitByElement = submitByElement;
			dispatchEvent(new FormEvent(FormEvent.RESET));
		}
		
		/**
		 * @inheritDoc
		 */
		public function isValid():Boolean
		{
			return _validator.isValid();
		}

		/**
		 * @inheritDoc
		 */
		public function validate(showErrors:Boolean = true, keepValidating:Boolean = true):Vector.<ValidationRuleData>
		{
			if (_debug) logDebug("validate");
			
			var errors:Vector.<ValidationRuleData> = _validator.validate(showErrors, keepValidating);
			
			if (!errors.length)
			{
				if (_debug) logInfo("Form is valid");
				dispatchEvent(new FormEvent(FormEvent.VALIDATE_SUCCESS));
				return errors;
			}
			if (_debug)
			{
				logError("Form is invalid: " + errors);
			}
			
			var fields:Vector.<IFormFieldError> = new Vector.<IFormFieldError>();
			
			for (var i:int = 0, leni:int = errors.length; i < leni; i++)
			{
				var element:IHasValue = errors[i].rule.target;
				
				fields.push(new FormFieldError(getNameFor(element), element, errors[i].message));
			}
			
			dispatchEvent(new FormEvent(FormEvent.VALIDATE_ERROR, new FormResult(false, "Form is not valid", null, null, fields)));
			return errors;
		}

		/**
		 * Gets the data of the Form
		 * NOTE: This function does not validate the Form. For validation for call validate()
		 */
		public function getData():Object
		{
			for each (var fed:FormElementData in _elements)
			{
				if (fed.submit) _data[fed.name] = fed.element.value;
			}
			
			if (_debug)
			{
				for (var key : String in _data) 
				{
					logDebug("ModelData: [" + key + "] : " + _data[key]);
				}
			}
			return _data;
		}

		/**
		 * Prefill the form with a data object. Object can be any kind of object.
		 * Form searches for elements with the same name (2nd argument of addElement method) as a property of the prefill object
		 * Form can only prefill elements who implements IPrefillable
		 * @param data The data object (name - value pair) with the prefill data
		 */
		public function prefill(data:Object):void
		{
			_prefillData = data;
			
			// temporary disable submitByElement
			var submitByElement:Boolean = _submitByElement;
			_submitByElement = false;
			
			if (_debug) logDebug("prefillData: " + dump(_prefillData, 0));
			
			if (_prefillData != null)
			{
				for each (var fed:FormElementData in _elements)
				{
					if (PropertyApplier.hasProperty(_prefillData, fed.name))
					{
						fed.element.value = PropertyApplier.getProperty(_prefillData, fed.name);
						if (_debug) logDebug("prefillData: " + fed.name + " is set to " + fed.element.value);
					}
					else if (_debug) logDebug("prefillData: " + fed.name + " not found"); 
				}
			}
			_submitByElement = submitByElement;
		}

		/**
		 * Returns the validator, for adding more ValidationRules
		 */
		public function get validator():Validator
		{
			return _validator;
		}
		
		/**
		 * Returns a reference to the TabFocusManager
		 */
		public function get tabFocusManager():TabFocusManager
		{
			return _tabFocusManager;
		}

		/**
		 * Indicates if the form is enabled
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}

		/**
		 * Enable or disable the form
		 * If the form is disabled it cannot post the data
		 */
		public function set enabled(value:Boolean):void
		{
			if (_debug) logDebug("enabled: " + value);
			
			_enabled = value;
			
			for (var submitbutton:* in _submitButtons)
			{
				if (submitbutton is MovieClip) MovieClip(submitbutton).enabled = value;
				if (submitbutton is IEnableable) IEnableable(submitbutton).enabled = value;
			}
			
			for (var cancelbutton:* in _resetButtons)
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
			enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			enabled = false;
		}

		/**
		 * If set to true, the form can be submitted by an Element if the Element dispatches a FormElementEvent.SUBMIT event
		 */
		public function get submitByElement():Boolean
		{
			return _submitByElement;
		}
		
		/**
		 * @private
		 */
		public function set submitByElement(value:Boolean):void
		{
			_submitByElement = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return _tabFocusManager.focus;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			_tabFocusManager.focus = value;
		}
		
		/**
		 * A Boolean which indicates if the Form should be disabled when the data is submitted. This prevent multiple submits.
		 * The Form will be enabled again if a result from the service is received.
		 * @default true
		 */
		public function get disableOnSubmit():Boolean
		{
			return _disableOnSubmit;
		}

		/**
		 * @private
		 */
		public function set disableOnSubmit(value:Boolean):void
		{
			_disableOnSubmit = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
			if (_debug) logWarn("Form is running in debug mode!");
			
			DebugManager.setDebugForChildren(this, value);
		}

		/**
		 * @private
		 */
		protected function send():void
		{
			if (_debug) logDebug("send: ");
			
			if (_service != null)
			{
				if (_disableOnSubmit) enabled = false;
				
				// add listeners (remove first to prevend double listening)
				_service.removeEventListener(FormServiceEvent.SUCCESS, handleFormServiceEvent);
				_service.removeEventListener(FormServiceEvent.RESULT, handleFormServiceEvent);
				_service.removeEventListener(FormServiceEvent.ERROR, handleFormServiceEvent);
				_service.addEventListener(FormServiceEvent.SUCCESS, handleFormServiceEvent);
				_service.addEventListener(FormServiceEvent.RESULT, handleFormServiceEvent);
				_service.addEventListener(FormServiceEvent.ERROR, handleFormServiceEvent);

				var result:IFormResult = _service.submit(getData());
				
				if (result && !enabled)
				{
					onResult(result);
					
					// remove listeners
					_service.removeEventListener(FormServiceEvent.SUCCESS, handleFormServiceEvent);
					_service.removeEventListener(FormServiceEvent.RESULT, handleFormServiceEvent);
					_service.removeEventListener(FormServiceEvent.ERROR, handleFormServiceEvent);
				}
			}
			else
			{
				logWarn("send: service is not set, form can not be submitted!");
			}
		}

		/**
		 * @private
		 */
		protected function handleSubmitButtonClicked(event:MouseEvent):void 
		{
			submit();
		}

		/**
		 * @private
		 */
		protected function handleResetButtonClicked(event:MouseEvent):void 
		{
			reset();
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
					enabled = true;
					if (_debug) logDebug("handleFormServiceEvent: " + event.type);
					dispatchEvent(new FormEvent(FormEvent.SUBMIT_SUCCESS, event.result));
					break;
				}
				case FormServiceEvent.RESULT:
				{
					onResult(event.result);
					break;
				}
				case FormServiceEvent.ERROR:
				{
					enabled = true;
					
					if (_debug) logError("handleFormServiceEvent: " + event.type);
					
					dispatchEvent(new FormEvent(FormEvent.SUBMIT_ERROR, event.result));
					break;
				}
				default:
				{
					if (_debug) logDebug("handleFormServiceEvent: " + event.type);
					break;
				}
			}
		}

		private function onResult(result:IFormResult):void 
		{
			if (result == null) return;
			
			enabled = true; 
					
			if (result.success)
			{
				if (_debug) logDebug("Success " + (result.message ? "\"" + result.message + "\"" : ""));
			}
			else
			{
				if (_debug) logError("Error " + (result.message ? "\"" + result.message + "\"" : ""));
				
				var data:FormElementData;
				var focussed:Boolean;
				for each (var error:IFormFieldError in result.errors)
				{
					data = _elements[error.field];
					if (data)
					{
						if (!error.field && error is FormFieldError) FormFieldError(error).field = data.element;
						
						if (data.element is IHasError)
						{
							IHasError(data.element).showError(error.message);
							if (!focussed && data.element is IFocusable)
							{
								IFocusable(data.element).focus = true;
								focussed = true;
							}
						}
					}
					else if (_debug) logWarn("No field with name '" + error.field + "' found");
					
					if (_debug) logError("Error: " + error.field + " '" + error.message + "' (" + error.code + ")");
				}
			}
			dispatchEvent(new FormEvent(result.success ? FormEvent.SUBMIT_SUCCESS : FormEvent.SUBMIT_ERROR, result));
					
		}

		
		/**
		 * @private
		 */
		protected function handleFormElementSubmit(event:FormElementEvent):void
		{
			if (_submitByElement) submit();
		}

		/**
		 * @inheritDoc
		 * 
		 * Distroys the form and his elements
		 */
		override public function destruct():void
		{
			if (_debug) logDebug("destruct: ");
			
			if (_submitButtons)
			{
				for (var submitButton:Object in _submitButtons)
				{
					removeSubmitButton(submitButton as DisplayObject);
				}
				_submitButtons = null;
			}
			if (_resetButtons)
			{
				for (var resetButton:Object in _resetButtons)
				{
					removeSubmitButton(resetButton as DisplayObject);
				}
				_resetButtons = null;
			}
			
			_service = null;
			
			// Destruct validator
			if (_validator)
			{
				_validator.destruct();
				_validator = null;
			}
			
			// Destruct focusmanager
			if (_tabFocusManager)
			{
				_tabFocusManager.destruct();
				_tabFocusManager = null;
			}
			
			// Destruct elements
			if (_elements)
			{
				removeAll();
				_elements = null;
			}
			_prefillData = null;
			
			super.destruct();
		}
	}
}
import temple.common.interfaces.IHasValue;

final class FormElementData
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
