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
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.IResettable;
	import temple.common.interfaces.ISelectable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.buttons.SwitchButton;
	import temple.ui.form.validation.IHasError;
	import temple.ui.form.validation.rules.BooleanValidationRule;
	import temple.ui.form.validation.rules.EmptyStringValidationRule;
	import temple.ui.label.IAutoSizableLabel;
	import temple.ui.label.IHTMLLabel;
	import temple.ui.label.ILabel;
	import temple.ui.label.ITextFieldLabel;
	import temple.ui.label.LabelUtils;
	import temple.ui.states.StateHelper;

	import flash.events.Event;
	import flash.text.TextField;


	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * @eventType temple.ui.form.components.FormElementEvent.SUBMIT
	 */
	[Event(name = "FormElementEvent.submit", type = "temple.ui.form.components.FormElementEvent")]
	
	/**
	 * A DisplayObject which can be selected and used in a <code>form</code>.
	 * 
	 * <p>This class can be used as component by setting this class as 'Component Definition' in the Flash IDE.
	 * You can set different properties in the Flash IDE in the 'Component Inspector'.</p>
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see ../../../../../readme.html
	 * @see temple.ui.form.Form
	 * 
	 * @includeExample ../FormExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CheckBox extends SwitchButton implements ISelectable, IHasError, IHasValue, IResettable, IFormElementComponent, ITextFieldLabel, ISetValue
	{
		private var _selectedValue:* = true;
		private var _unselectedValue:* = false;
		private var _dataName:String;
		private var _validator:Class;
		private var _errorMessage:String;
		private var _tabIndex:int;
		private var _label:ILabel;
		private var _submit:Boolean = true;
		private var _submitOnChange:Boolean;
		private var _hasError:Boolean;

		public function CheckBox()
		{
			this.toStringProps.push('name', 'selected', 'selectedValue', 'unselectedValue', 'label');
			this._label = LabelUtils.findLabel(this);
			this.addEventListener(Event.CHANGE, this.handleChange);
			
			this.clickOnEnter = true;
			this.clickOnSpacebar = true;
		}

		/**
		 * @inheritDoc 
		 */
		[Inspectable(name="Selected by default", type="Boolean", defaultValue="false")]
		override public function set selected(value:Boolean):void 
		{
			super.selected = value;
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
		 * @inheritDoc 
		 */
		public function get value():* 
		{
			// selectedValue and unselectedValue are both empty strings (happens when no value is filled in in components), return value as Boolean
			if (this._selectedValue == '' && this._selectedValue === this._unselectedValue) return this.selected;
			
			return this.selected ? this._selectedValue : this._unselectedValue;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set value(value:*):void 
		{
			if (value == this._selectedValue)
			{
				this.selected = true;
			}
			else if (value == this._unselectedValue)
			{
				this.selected = false;
			}
			else if (value == true && this._selectedValue == '' && this._unselectedValue == this._selectedValue)
			{
				this.selected = true;
			}
			else if (value != null)
			{
				this.logWarn("value: unknown value '" + value + "'");
			}
		}

		/**
		 * Reset the checkbox by deselecting &amp; enabling it.
		 */
		public function reset():void 
		{
			this.enabled = true;
			this.selected = false;
		}

		/**
		 * Set the value of the CheckBox.
		 * @param selectedValue the value of the CheckBox when it is selected.
		 * @param unselectedValue the value of the CheckBox when it is not selected.
		 */
		public function setValue(selectedValue:*, unselectedValue:* = false):void 
		{
			this._selectedValue = selectedValue;
			this._unselectedValue = unselectedValue;
		}
		
		/**
		 * The value of the CheckBox when it is selected.
		 */
		public function get selectedValue():*
		{
			return this._selectedValue;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Selected value", type="String")]
		public function set selectedValue(value:*):void
		{
			this._selectedValue = value;
		}
		
		/**
		 * The value of the CheckBox when it is selected.
		 */
		public function get unselectedValue():*
		{
			return this._unselectedValue;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Unselected value", type="String")]
		public function set unselectedValue(value:*):void
		{
			if (this._validator == EmptyStringValidationRule)
			{
				this.logError("unselectedValue: can not be set when CheckBox has a validator");
			}
			else
			{
				this._unselectedValue = value;
			}
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
		[Inspectable(name="Validation rule", type="String", defaultValue="none", enumeration="none,not null,boolean")]
		public function set validationRuleName(value:String):void
		{
			switch (value){
				case "none":
				{
					this._validator = null;
					break;
				}
				case "not null":
				{
					this._validator = EmptyStringValidationRule;
					
					// check if unselected value is set
					if (this.unselectedValue != "")
					{
						this.logWarn("validationRuleName: validation rule will always be valid, unselected value is changed");
						this._unselectedValue = '';
					}
					break;
				}
				case "boolean":
				{
					this._validator = BooleanValidationRule;
					if (this._selectedValue !== true && !(this._selectedValue == '' && this._selectedValue == this._unselectedValue))
					{
						this.logWarn("validationRuleName: invalid ValidationRule, CheckBox does not return a Boolean");
					}
					break;
				}
				default:
				{
					this._validator = null;
					this.logError("validationRule: unknown validation rule '" + value + "'");
					break;
				}
			}
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
		public function get label():String
		{
			return this._label ? this._label.label : '';
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Label", type="String")]
		public function set label(value:String):void
		{
			if (this._label)
			{
				this._label.label = value;
			}
			else if (value != '')
			{
				this.logError("label: Label TextField is not specified or found on DisplayList");
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get html():Boolean
		{
			return this._label is IHTMLLabel ? (this._label as IHTMLLabel).html : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set html(value:Boolean):void
		{
			if (this._label is IHTMLLabel)
			{
				(this._label as IHTMLLabel).html = value;
			}
			else
			{
				throwError(new TempleError(this, "Label does not implement IHTMLLabel"));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoSize():String
		{
			return (this._label is IAutoSizableLabel) ? (this._label as IAutoSizableLabel).autoSize : null;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="AutoSize", type="String", defaultValue="none", enumeration="none,left, right, center")]
		public function set autoSize(value:String):void
		{
			if (this._label is IAutoSizableLabel)
			{
				(this._label as IAutoSizableLabel).autoSize = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get textField():TextField
		{
			return this._label is ITextFieldLabel ? (this._label as ITextFieldLabel).textField : null;
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
		 * If set to true the CheckBox will dispatch an FormElementEvent.SUBMIT on change and the form (if enabled) can be submitted
		 */
		public function get submitOnChange():Boolean
		{
			return this._submitOnChange;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Submit on change", type="Boolean", defaultValue="false")]
		public function set submitOnChange(value:Boolean):void
		{
			this._submitOnChange = value;
		}
		
		private function handleChange(event:Event):void 
		{
			if (this._submitOnChange)
			{
				this.dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._selectedValue = null;
			this._unselectedValue = null;
			this._dataName = null;
			this._validator = null;
			this._errorMessage = null;
			this._label = null;
			
			super.destruct();
		}
	}
}
