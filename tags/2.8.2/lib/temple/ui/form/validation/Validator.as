/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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

package temple.ui.form.validation 
{
	import temple.core.CoreObject;
	import temple.debug.DebugManager;
	import temple.debug.IDebuggable;
	import temple.ui.IEnableable;
	import temple.ui.focus.IFocusable;
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
	var errors:Array = validator.validate();
	</code>
	 * If either of the validation rules returns false, it will be added to the list of <code>errors</code>. This list will have a length of 0 if no errors were found.
	 * Run through the list of errors to get the rule(s) that returned false. The UI component itself can then be accessed through the <code>getTarget()</code> function of IValidatable.
	 * 
	 * @author Thijs Broerse
	 */
	public class Validator extends CoreObject implements IDebuggable
	{
		/** Objects of type RuleData */
		private var _rules:Array = new Array();
		private var _errorMessage:String;
		private var _errorMessages:Array;
		private var _debug:Boolean;

		public function Validator() 
		{
			DebugManager.add(this);
		}

		/**
		 * Add a validation rule
		 * @param rule The rule
		 * @param message (optional) error message
		 */
		public function addValidationRule(rule:IValidationRule, message:String = null):IValidationRule 
		{
			if (rule) this._rules.push(new RuleData(rule, message));
			return rule;
		}

		/**
		 * Removes all validation rules for an element 
		 */
		public function removeElement(element:IHasValue):void
		{
			for (var i:int = this._rules.length - 1 ;i >= 0; i--) 
			{
				if (RuleData(this._rules[i]).rule.target == element)
				{
					this._rules.splice(i, 1);
				}
			}
			if (element is IEventDispatcher)
			{
				// first remove, to prevent double listening
				IEventDispatcher(element).removeEventListener(Event.CHANGE, this.handleErrorInputFieldChange);
			}
		}

		/**
		 * Check validity of all added validation rules
		 * @return a list of all validation rules that did not validate; objects of type IValidationRule
		 */
		public function validate():Array 
		{
			var errors:Array = new Array();
			
			var leni:uint = this._rules.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var rule:IValidationRule = RuleData(this._rules[i]).rule;
				
				// check if target is enabled
				if (rule.target is IEnableable && IEnableable(rule.target).enabled == false) continue;
				
				if (!rule.isValid())
				{
					errors.push(rule);
					
					if (this.debug) this.logDebug("Not valid: " + rule);
				}
				else if (this.debug) this.logDebug("Valid: " + rule);
				
			}
			return errors;
		}

		/**
		 * Checks if the Validator is valid and shows errors for the validator which has errors if showErrors is set to true. Return true if form is valid.
		 * Sets focus on the first elements which is IFocusable.
		 * @param keepValidating if set to true the form will keep validation after each change
		 * @param showError if set to true wrong elements will show their ErrorState
		 */
		public function isValid(keepValidating:Boolean = true, showErrors:Boolean = true):Boolean 
		{
			var valid:Boolean = true;
			var focussed:Boolean = false;
			this._errorMessage = null;
			this._errorMessages = new Array();
			
			// Create a dictionary for object validation, necessary when there are more then one validation rules on an object
			var dictionary:Dictionary = new Dictionary(true);
			
			var leni:uint = this._rules.length;
			
			if (this.debug) this.logDebug("isValid: validator has " + leni + " rules");
			
			for (var i:uint = 0;i < leni; i++) 
			{
				var ruleData:RuleData = RuleData(this._rules[i]);
				
				// check if target is enabled
				if (ruleData.rule.target is IEnableable && IEnableable(ruleData.rule.target).enabled == false)
				{
					if (this.debug) this.logDebug("Target is not enabled, skip: " + ruleData);
					
					continue;
				}
				
				if (!ruleData.rule.isValid())
				{
					if (this._errorMessage == null) this._errorMessage = ruleData.message;
					if (ruleData.message != null) this._errorMessages.push(ruleData.message);
					valid = false;
					
					if (this.debug) this.logDebug("Not valid: " + ruleData);
				}
				else if (this.debug) this.logDebug("Valid: " + ruleData);
				
				var target:IHasValue = ruleData.rule.target;
				if (target is IHasError)
				{
					if (ruleData.rule.isValid())
					{
						if (dictionary[target] == null)
						{
							IHasError(target).hideError();
						}
					}
					else
					{
						if (showErrors)
						{
							IHasError(target).showError(ruleData.message);
							if (target is IFocusable && !focussed)
							{
								IFocusable(target).focus = true;
								focussed = true;
							}
						}
						dictionary[target] = false;
					}
					if (target is IEventDispatcher && keepValidating)
					{
						// first remove, to prevent double listening
						IEventDispatcher(target).removeEventListener(Event.CHANGE, this.handleErrorInputFieldChange);
						IEventDispatcher(target).addEventListener(Event.CHANGE, this.handleErrorInputFieldChange);
					}
				}
			}
			return valid;
		}
		
		/**
		 * Checks if a single element is valid and shows error if the element has an error and showError is set to true (default: false). Return true if form is valid.
		 * @param showError if set to true the element will show an ErrorState if the element is not valid.
		 */
		public function isElementValid(element:IHasValue, showError:Boolean = false):Boolean 
		{
			var valid:Boolean = true;
			var errorMessage:String;
			
			var leni:uint = this._rules.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				var ruleData:RuleData = RuleData(this._rules[i]);
				
				if (ruleData.rule.target == element && !ruleData.rule.isValid())
				{
					valid = false;
					if (errorMessage == null)
					{
						errorMessage = ruleData.message;
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
		public function getElements():Array 
		{
			var a:Array = new Array();
			var leni:uint = this._rules.length;
			for (var i:uint = 0;i < leni; i++) 
			{
				a.push(RuleData(this._rules[i]).rule.target);
			}
			return a;
		}

		/**
		 * Stop the realtime validating add by the isValid function
		 */
		public function stopRealtimeValidating():void
		{
			if (this._rules)
			{
				var leni:uint = this._rules.length;
				for (var i:uint = 0;i < leni; i++) 
				{
					IEventDispatcher(RuleData(_rules[i]).rule.target).removeEventListener(Event.CHANGE, this.handleErrorInputFieldChange);
				}
			}
		}
		
		/**
		 * Returns the error message of the first Element with an error
		 * Call method 'isValid()' function before, to generate the message
		 */
		public function getErrorMessage():String
		{
			return this._errorMessage;
		}
		
		/**
		 * Returns the list of all error messages of elements with an error
		 * Call method 'isValid()' function before, to generate the message
		 */
		public function getErrorMessages():Array
		{
			return this._errorMessages;
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
		}

		private function handleErrorInputFieldChange(event:Event):void 
		{
			if (event.currentTarget is IHasValue)
			{
				var leni:uint = _rules.length;
				var isValid:Boolean = true;
				var message:String;
				var ruleData:RuleData;
				for (var i:Number = 0;i < leni; i++) 
				{
					ruleData = RuleData(_rules[i]);
					
					if (ruleData.rule.target != event.currentTarget) continue;

					if (ruleData.rule.target is IHasError)
					{
						if (!ruleData.rule.isValid())
						{
							isValid = false;
							message = ruleData.message;
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
			this.stopRealtimeValidating();
			
			if (this._rules)
			{
				for (var i:int = 0; i < this._rules.length; ++i)
				{
					RuleData(this._rules[i]).destruct();
				}
				this._rules = null;
			}
			
			this._errorMessages = null;
			this._errorMessage = null;
			
			super.destruct();
		}
	}
}

import temple.core.CoreObject;
import temple.ui.form.validation.rules.IValidationRule;

final class RuleData extends CoreObject
{
	internal var rule:IValidationRule;
	internal var message:String;

	public function RuleData(rule:IValidationRule, message:String) 
	{
		this.rule = rule;
		this.message = message;
	}
	
	override public function toString():String
	{
		return super.toString() + " : " + this.rule + " '" + this.message + "'";
	}

	/**
	 * @inheritDoc
	 */
	override public function destruct():void
	{
		if (this.rule)
		{
			this.rule.destruct();
			this.rule = null;
		}
		this.message = null;
		
		super.destruct();
	}
}