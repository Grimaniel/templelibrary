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
	import flash.events.Event;
	import flash.text.TextField;
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.IResettable;
	import temple.common.interfaces.ISelectable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.buttons.SwitchButton;
	import temple.ui.form.validation.IHasError;
	import temple.ui.form.validation.rules.BooleanValidationRule;
	import temple.ui.form.validation.rules.EmptyStringValidationRule;
	import temple.ui.labels.IAutoSizableLabel;
	import temple.ui.labels.IHTMLLabel;
	import temple.ui.labels.ILabel;
	import temple.ui.labels.ITextFieldLabel;
	import temple.ui.labels.LabelUtils;
	import temple.ui.states.StateHelper;



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
	public class CheckBox extends SwitchButton implements ISelectable, IHasError, IHasValue, IResettable, IFormElementComponent, ITextFieldLabel
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
			toStringProps.push('name', 'selected', 'selectedValue', 'unselectedValue', 'label');
			_label = LabelUtils.findLabel(this);
			addEventListener(Event.CHANGE, handleChange);
			
			clickOnEnter = true;
			clickOnSpacebar = true;
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
			return _hasError;
		}

		/**
		 * @inheritDoc 
		 */
		public function set hasError(value:Boolean):void
		{
			if (value)
			{
				showError();
			}
			else
			{
				hideError();
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function showError(message:String = null):void 
		{
			_hasError = true;
			StateHelper.showError(this, message);
			dispatchEvent(new FormElementErrorEvent(FormElementErrorEvent.SHOW_ERROR, message));
		}
		
		/**
		 * @inheritDoc 
		 */
		public function hideError():void 
		{
			_hasError = false;
			StateHelper.hideError(this);
			dispatchEvent(new FormElementErrorEvent(FormElementErrorEvent.HIDE_ERROR));
		}

		/**
		 * @inheritDoc 
		 */
		public function get value():* 
		{
			// selectedValue and unselectedValue are both empty strings (happens when no value is filled in in components), return value as Boolean
			if (_selectedValue == '' && _selectedValue === _unselectedValue) return selected;
			
			return selected ? _selectedValue : _unselectedValue;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set value(value:*):void 
		{
			if (value == _selectedValue)
			{
				selected = true;
			}
			else if (value == _unselectedValue)
			{
				selected = false;
			}
			else if (value && _selectedValue == '' && _unselectedValue == _selectedValue)
			{
				selected = true;
			}
			else if (value != null)
			{
				logWarn("value: unknown value '" + value + "'");
			}
		}

		/**
		 * Reset the checkbox by deselecting &amp; enabling it.
		 */
		public function reset():void 
		{
			enabled = true;
			selected = false;
		}

		/**
		 * Set the value of the CheckBox.
		 * @param selectedValue the value of the CheckBox when it is selected.
		 * @param unselectedValue the value of the CheckBox when it is not selected.
		 */
		public function setValue(selectedValue:*, unselectedValue:* = false):void 
		{
			_selectedValue = selectedValue;
			_unselectedValue = unselectedValue;
		}
		
		/**
		 * The value of the CheckBox when it is selected.
		 */
		public function get selectedValue():*
		{
			return _selectedValue;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Selected value", type="String")]
		public function set selectedValue(value:*):void
		{
			_selectedValue = value;
		}
		
		/**
		 * The value of the CheckBox when it is selected.
		 */
		public function get unselectedValue():*
		{
			return _unselectedValue;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Unselected value", type="String")]
		public function set unselectedValue(value:*):void
		{
			if (_validator == EmptyStringValidationRule)
			{
				logError("unselectedValue: can not be set when CheckBox has a validator");
			}
			else
			{
				_unselectedValue = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get dataName():String
		{
			return _dataName;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Data name", type="String")]
		public function set dataName(value:String):void
		{
			_dataName = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get validationRule():Class
		{
			return _validator;
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
					_validator = null;
					break;
				}
				case "not null":
				{
					_validator = EmptyStringValidationRule;
					
					// check if unselected value is set
					if (unselectedValue != "")
					{
						logWarn("validationRuleName: validation rule will always be valid, unselected value is changed");
						_unselectedValue = '';
					}
					break;
				}
				case "boolean":
				{
					_validator = BooleanValidationRule;
					if (_selectedValue !== true && !(_selectedValue == '' && _selectedValue == _unselectedValue))
					{
						logWarn("validationRuleName: invalid ValidationRule, CheckBox does not return a Boolean");
					}
					break;
				}
				default:
				{
					_validator = null;
					logError("validationRule: unknown validation rule '" + value + "'");
					break;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get errorMessage():String
		{
			return _errorMessage;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Error message", type="String")]
		public function set errorMessage(value:String):void
		{
			_errorMessage = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get tabIndex():int
		{
			return _tabIndex;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Tab index", type="Number", defaultValue="-1")]
		override public function set tabIndex(value:int):void
		{
			_tabIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get text():String
		{
			return _label ? _label.text : '';
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Label", type="String")]
		public function set text(value:String):void
		{
			if (_label)
			{
				_label.text = value;
			}
			else if (value != '')
			{
				logError("label: Label TextField is not specified or found on DisplayList");
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get html():Boolean
		{
			return _label is IHTMLLabel ? (_label as IHTMLLabel).html : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set html(value:Boolean):void
		{
			if (_label is IHTMLLabel)
			{
				(_label as IHTMLLabel).html = value;
			}
			else
			{
				throwError(new TempleError(this, "Label does not implement IHTMLLabel"));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoSize():Boolean
		{
			return (_label is IAutoSizableLabel) ? (_label as IAutoSizableLabel).autoSize : false;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="AutoSize", type="Boolean")]
		public function set autoSize(value:Boolean):void
		{
			if (_label is IAutoSizableLabel)
			{
				(_label as IAutoSizableLabel).autoSize = value;
			}
		}
		
				/**
		 * @inheritDoc
		 */
		public function get multiline():Boolean
		{
			return _label is IAutoSizableLabel && (_label as IAutoSizableLabel).multiline;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Multiline", type="Boolean")]
		public function set multiline(value:Boolean):void
		{
			if (_label is IAutoSizableLabel)
			{
				(_label as IAutoSizableLabel).multiline = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get wordWrap():Boolean
		{
			return _label is IAutoSizableLabel && (_label as IAutoSizableLabel).wordWrap;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="WordWrap", type="Boolean")]
		public function set wordWrap(value:Boolean):void
		{
			if (_label is IAutoSizableLabel)
			{
				(_label as IAutoSizableLabel).wordWrap = value;
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get textField():TextField
		{
			return _label is ITextFieldLabel ? (_label as ITextFieldLabel).textField : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get submit():Boolean
		{
			return _submit;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Submit value", type="Boolean", defaultValue="true")]
		public function set submit(value:Boolean):void
		{
			_submit = value;
		}
		
		/**
		 * If set to true the CheckBox will dispatch an FormElementEvent.SUBMIT on change and the form (if enabled) can be submitted
		 */
		public function get submitOnChange():Boolean
		{
			return _submitOnChange;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Submit on change", type="Boolean", defaultValue="false")]
		public function set submitOnChange(value:Boolean):void
		{
			_submitOnChange = value;
		}
		
		private function handleChange(event:Event):void 
		{
			if (_submitOnChange)
			{
				dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_selectedValue = null;
			_unselectedValue = null;
			_dataName = null;
			_validator = null;
			_errorMessage = null;
			_label = null;
			
			super.destruct();
		}
	}
}
