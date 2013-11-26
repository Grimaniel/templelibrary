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

package temple.ui.form.validation 
{
	import temple.ui.form.validation.rules.ValidationRuleData;
	import temple.common.interfaces.IEnableable;
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.IHasValue;
	import temple.core.CoreObject;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;
	import temple.ui.form.validation.rules.IValidationRule;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;


	/**
	 * Class for validation of user input values in UI components.
	 * UI components must implement IValidatable, and be added for validation through implementations of IValidationRule.
	 * 
	 * @example
	 * In a form, suppose two objects of type InputField are defined: mcName and mcEmail. The class InputField implements IValidatable.
	 * Add the following code to allow validation on those objects.
	 * <code>
	validator = new Validator();
	validator.addValidationRule(new EmptyStringValidationRule(mcName));
	validator.addValidationRule(new EmailValidationRule(mcEmail));
	</code>
	 * 	This code sets a validation rule on mcName to check for an empty string, and on mcEmail to check for a valid email address.
	 * 	To perform the actual validation, use this:
	 * 	<code>
	var errors:Vector.&lt;String&gt; = validator.validate();
	</code>
	 * If either of the validation rules returns false, it will be added to the list of <code>errors</code>. This list will have a length of 0 if no errors were found.
	 * Run through the list of errors to get the rule(s) that returned false. The UI component itself can then be accessed through the <code>getTarget()</code> function of IValidatable.
	 * 
	 * @author Thijs Broerse
	 */
	public class Validator extends CoreObject implements IDebuggable, IValidator
	{
		private var _rules:Vector.<ValidationRuleData>;
		private var _autoFocus:Boolean;
		private var _debug:Boolean;

		public function Validator(autoFocus:Boolean = true) 
		{
			_rules = new Vector.<ValidationRuleData>();
			_autoFocus = autoFocus;
			addToDebugManager(this);
		}

		/**
		 * Add a validation rule
		 * @param rule The rule
		 * @param message (optional) error message
		 */
		public function addValidationRule(rule:IValidationRule, message:String = null):IValidationRule 
		{
			if (rule) _rules.push(new ValidationRuleData(rule, message));
			return rule;
		}

		/**
		 * Removes all validation rules for an element 
		 */
		public function removeElement(element:IHasValue):void
		{
			for (var i:int = _rules.length - 1 ;i >= 0; i--) 
			{
				if (_rules[i].rule.target == element)
				{
					_rules.splice(i, 1);
				}
			}
			if (element is IEventDispatcher)
			{
				IEventDispatcher(element).removeEventListener(Event.CHANGE, handleErrorInputFieldChange);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function validate(showErrors:Boolean = true, keepValidating:Boolean = true):Vector.<ValidationRuleData> 
		{
			var errors:Vector.<ValidationRuleData> = new Vector.<ValidationRuleData>();
			
			var focussed:Boolean = !_autoFocus;
			
			// Create a dictionary for object validation, necessary when there are more then one validation rules on an object
			if (showErrors) var dictionary:Dictionary = new Dictionary(true);
			
			var leni:uint = _rules.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var data:ValidationRuleData = _rules[i];
				var rule:IValidationRule = data.rule;
				var target:IHasValue = rule.target;
				
				// check if target is enabled
				if (target is IEnableable && IEnableable(target).enabled == false)
				{
					if (debug) logDebug("Target is not enabled, skip: " + data);
					
					continue;
				}
				
				if (rule.isValid())
				{
					if (debug) logDebug("Valid: " + rule);
					
					if (showErrors && target is IHasError && !(target in dictionary))
					{
						IHasError(target).hideError();
					}
					
				}
				else
				{
					errors.push(data);
					
					if (debug) logDebug("Not valid: " + rule);
					
					if (showErrors && target is IHasError && !(target in dictionary))
					{
						IHasError(target).showError(_rules[i].message);
						dictionary[target] = true;
						
						if (target is IFocusable && !focussed)
						{
							IFocusable(target).focus = true;
							focussed = true;
						}
					}
				}
				
				if (keepValidating && target is IEventDispatcher)
				{
					// first remove, to prevent double listening
					IEventDispatcher(target).removeEventListener(Event.CHANGE, handleErrorInputFieldChange);
					IEventDispatcher(target).addEventListener(Event.CHANGE, handleErrorInputFieldChange);
				}
			}
			return errors;
		}
		
		/**
		 * Checks if the Validator is valid.
		 */
		public function isValid():Boolean 
		{
			return validate().length > 0;
		}

		/**
		 * Checks if a single element is valid and shows error if the element has an error and showError is set to true (default: false). Return true if element is valid.
		 * @param showError if set to true the element will show an ErrorState if the element is not valid.
		 */
		public function isElementValid(element:IHasValue, showError:Boolean = false):Boolean 
		{
			var valid:Boolean = true;
			var errorMessage:String;
			
			var leni:uint = _rules.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var data:ValidationRuleData = _rules[i];
				
				if (data.rule.target == element && !data.rule.isValid())
				{
					valid = false;
					if (errorMessage == null)
					{
						errorMessage = data.message;
					}
				}
			}
			if (showError && !valid && element is IHasError)
			{
				(element as IHasError).showError(errorMessage);
			}
			return valid;
		}

		/**
		 * @return all elements for validation, objects of type IValidatable
		 */
		public function getElements():Vector.<IHasValue>
		{
			var elements:Vector.<IHasValue> = new Vector.<IHasValue>();
			for (var i:uint = 0, leni:uint = _rules.length; i < leni; i++) 
			{
				elements.push(ValidationRuleData(_rules[i]).rule.target);
			}
			return elements;
		}

		/**
		 * Returns a list of all validation rules for an element
		 */
		public function getRulesForElement(element:IHasValue):Vector.<IValidationRule>
		{
			var rules:Vector.<IValidationRule> = new Vector.<IValidationRule>();
			var leni:uint = _rules.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var ruleData:ValidationRuleData = ValidationRuleData(_rules[i]);
				if (ruleData.rule.target == element) rules.push(ruleData.rule);
			}
			return rules;
		}

		/**
		 * Stop the realtime validating set by the isValid() function
		 */
		public function stopRealtimeValidating():void
		{
			if (_rules)
			{
				var leni:uint = _rules.length;
				for (var i:uint = 0;i < leni; i++) 
				{
					IEventDispatcher(ValidationRuleData(_rules[i]).rule.target).removeEventListener(Event.CHANGE, handleErrorInputFieldChange);
				}
			}
		}
		
		/**
		 * Indicates if the <code>Validator</code> should set the focus on the first element with an error when the
		 * <code>isValid()</code> method is called.
		 */
		public function get autoFocus():Boolean
		{
			return _autoFocus;
		}

		/**
		 * @private
		 */
		public function set autoFocus(value:Boolean):void
		{
			_autoFocus = value;
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
		}

		private function handleErrorInputFieldChange(event:Event):void 
		{
			if (event.currentTarget is IHasValue)
			{
				var leni:uint = _rules.length;
				var isValid:Boolean = true;
				var message:String;
				var data:ValidationRuleData;
				for (var i:Number = 0;i < leni; i++) 
				{
					data = _rules[i];
					
					if (data.rule.target != event.currentTarget) continue;

					if (data.rule.target is IHasError)
					{
						if (!data.rule.isValid())
						{
							isValid = false;
							message = data.message;
							break;
						}
					}
				}
				if (isValid)
				{
					IHasError(event.currentTarget).hideError();
				}
				else
				{
					IHasError(event.currentTarget).showError(message);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			stopRealtimeValidating();
			
			if (_rules)
			{
				while (_rules.length) _rules.shift().destruct();
				_rules = null;
			}
			
			super.destruct();
		}
	}
}