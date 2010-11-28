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

package temple.ui.form.components 
{
	import temple.debug.IDebuggable;
	import temple.debug.Registry;
	import temple.ui.IEnableable;
	import temple.ui.IResettable;
	import temple.ui.focus.FocusManager;
	import temple.ui.form.validation.IHasError;
	import temple.ui.form.validation.rules.DutchMobilePhoneValidationRule;
	import temple.ui.form.validation.rules.DutchPhoneValidationRule;
	import temple.ui.form.validation.rules.DutchPostalcodeValidationRule;
	import temple.ui.form.validation.rules.EmailValidationRule;
	import temple.ui.form.validation.rules.EmptyStringValidationRule;
	import temple.ui.form.validation.rules.Restrictions;
	import temple.ui.states.StateHelper;
	import temple.utils.keys.KeyCode;
	import temple.utils.types.DisplayObjectContainerUtils;
	import temple.utils.types.StringUtils;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * @eventType temple.ui.form.components.FormElementEvent.SUBMIT
	 */
	[Event(name = "FormElementEvent.submit", type = "temple.ui.form.components.FormElementEvent")]
	
	/**
	 * @see temple.ui.form.Form
	 * 
	 * @includeExample ../services/FormXMLServiceExample.as
	 * @includeExample ../FormExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class InputField extends FormElementComponent implements IHasError, IResettable, ISetValue, IEnableable, IDebuggable
	{
		private var _textField:TextField;
		private var _text:String;
		private var _hintText:String;
		private var _prefillText:String;
		protected var _showsHint:Boolean;
		private var _textColor:uint;
		private var _hintTextColor:uint;
		private var _errorTextColor:uint;
		private var _trimValue:Boolean = true;
		private var _displayAsPassword:Boolean;
		private var _hasError:Boolean;
		private var _debug:Boolean;
		private var _debugValue:*;
		private var _submitOnEnter:Boolean = true;
		private var _submitOnChange:Boolean;
		private var _previousText:String;
		private var _limitInputToDesign:Boolean;
		private var _normalFontSize:Number;
		private var _minimalFontSize:Number;
		private var _selectTextOnFocus:Boolean = true;
		private var _enabled:Boolean = true;

		/**
		 * Constructor
		 */
		public function InputField(textField:TextField = null) 
		{
			this._textField = textField || DisplayObjectContainerUtils.findChildOfType(this, TextField) as TextField || this.addChild(new TextField()) as TextField;

			this.addEventListener(KeyboardEvent.KEY_DOWN, this.handleKeyDown);
			this._textField.setTextFormat(this._textField.defaultTextFormat);
			this._textField.addEventListener(Event.CHANGE, this.handleTextFieldChange, false, 0, true);
			this._textField.addEventListener(TextEvent.TEXT_INPUT, this.handleTextInput, false, 0, true);
			this._textField.addEventListener(Event.SCROLL, this.handleTextFieldScroll, false, 0, true);
			this._textColor = this._hintTextColor = this._errorTextColor = this._textField.textColor;
			this._normalFontSize = this.fontSize;
			
			if (this._textField.multiline) this._submitOnEnter = false;

			// Register TextField for destruction testing
			Registry.add(this._textField);
		}
		
		/**
		 * Returns a reference to the TextField
		 */
		public function get textField():TextField
		{
			return this._textField;
		}

		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void
		{
			if (value == this._focus) return;
			
			if (value)
			{
				FocusManager.focus = this._textField;
			}
			else if (this._focus)
			{
				FocusManager.focus = null;
			}
		}

		/**
		 * The text in the contained input field
		 */
		public function get text():String 
		{
			return this._showsHint ? "" : this._textField.text;	
		}

		/**
		 * @private
		 */
		public function set text(value:String):void 
		{
			if(value == null) value = "";
			
			this._text = value;
			
			this._textField.text = value;
			this._showsHint = false;
			this.updateHint();
		}
		
		/**
		 * Color of the text, if not set the original color of the TextField is used
		 */
		public function get textColor():uint
		{
			return this._textColor;
		}
		
		/**
		 * @private
		 */
		public function set textColor(textColor:uint):void
		{
			this._textColor = textColor;
		}
		
		/**
		 * Set the hint text to be displayed when nothing has been input in the field yet
		 */
		public function get hintText():String 
		{
			return this._hintText;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Hint text", type="String")]
		public function set hintText(value:String):void 
		{
			if(this._textField.text == this._hintText)
			{
				this._textField.text = value;
			}
			this._hintText = value;
			
			this.updateHint();
		}
		
		/**
		 * Set the prefill text to be displayed when nothing has been input in the field yet
		 */
		public function get prefillText():String 
		{
			return this._prefillText;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Prefill text", type="String")]
		public function set prefillText(value:String):void 
		{
			this._prefillText = value;
			this.text = this._prefillText;
		}

		/**
		 * Set the colour of the hint text
		 */
		public function get hintTextColor():uint
		{
			 return this._hintTextColor;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Hint text color", type="Color", defaultValue="#888888")]
		public function set hintTextColor(value:uint):void 
		{
			this._hintTextColor = value;
			
			if (this._showsHint) this._textField.textColor = this._hintTextColor;
		}
		
		/**
		 * Set the colour of the error text
		 */
		public function get errorTextColor():uint
		{
			 return this._errorTextColor;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Error text color", type="Color", defaultValue="#FF0000")]
		public function set errorTextColor(value:uint):void 
		{
			this._errorTextColor = value;
			
			if (this._hasError) this._textField.textColor = this._errorTextColor;
		}

		/**
		 * @inheritDoc 
		 */
		public function get enabled():Boolean 
		{
			return this._enabled;
		}

		/**
		 * @inheritDoc 
		 */
		[Inspectable(name="Enabled", type="Boolean", defaultValue=true)]
		public function set enabled(value:Boolean):void 
		{
			this._enabled = this.mouseChildren = this.mouseEnabled = value;
			this._textField.mouseEnabled = value;
			this._textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			if (value) this._textField.styleSheet = null;
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
		 * @inheritDoc 
		 */
		override public function get value():* 
		{
			return this._trimValue ? StringUtils.trim(this.text) : this.text;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function set value(value:*):void
		{
			if(value == null) return;
			this.text = value;
		}

		/**
		 * @inheritDoc 
		 */
		public function showError(message:String = null):void 
		{
			this._hasError = true;
			this._textField.textColor = this._errorTextColor;
			StateHelper.showError(this, message);
		}

		/**
		 * @inheritDoc 
		 */
		public function hideError():void 
		{
			this._hasError = false;
			StateHelper.hideError(this);
			
			if (this._showsHint)
			{
				this._textField.textColor = this._hintTextColor;
			}
			else{
				this._textField.textColor = this._textColor;
			}
		}

		/**
		 * Reset the input field
		 */
		public function reset():void 
		{
			this.text = this._prefillText ? this._prefillText : "";
		}
		
		/**
		 * Get or set a restriction on the input 
		 */
		public function get restrict():String 
		{
			return this._textField.restrict;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Restriction", type="String", defaultValue="none", enumeration="none,numeric,numbers,alphanumeric,email,postalcode (Dutch),uppercase,lowercase")]
		public function set restrict(value:String):void 
		{
			switch(value)
			{
				case "none":
				{
					this._textField.restrict = null;
					break;
				}
				case "numeric":
				{
					this._textField.restrict = Restrictions.NUMERIC;
					break;
				}
				case "numbers":
				{
					this._textField.restrict = Restrictions.NUMBERS;
					break;
				}
				case "alphanumeric":
				{
					this._textField.restrict = Restrictions.ALPHANUMERIC;
					break;
				}
				case "email":
				{
					this._textField.restrict = Restrictions.EMAIL;
					break;
				}
				case "postalcode (Dutch)":
				{
					this._textField.restrict = Restrictions.DUTCH_POSTALCODE;
					break;
				}
				case "uppercase":
				{
					this._textField.restrict = Restrictions.UPPERCASE;
					break;
				}
				case "lowercase":
				{
					this._textField.restrict = Restrictions.LOWERCASE;
					break;
				}
				default:
				{
					this._textField.restrict = value;
					break;
				}
			}
		}

		/**
		 * Will display '*******' instead of real characters 
		 */
		public function get displayAsPassword():Boolean
		{
			return this._displayAsPassword;
		}

		/**
		 * @private 
		 */
		[Inspectable(name="Display as password", type="Boolean", defaultValue=false)]
		public function set displayAsPassword(value:Boolean):void
		{
			this._displayAsPassword = value;
			if(this._hintText && this._hintText == this._textField.text)
			{
				this._textField.displayAsPassword = true;
			}
			else
			{
				this._textField.displayAsPassword = value;
			}
		}

		/**
		 * Indicates if the method getValue() trim the value
		 */
		public function get trimValue():Boolean
		{
			return this._trimValue;
		}

		/**
		 * Sets if the value should be trimmed
		 * Trims only the value get by the getValue() method
		 */
		[Inspectable(name="Trim value (remove spaces)", type="Boolean", defaultValue=true)]
		public function set trimValue(value:Boolean):void
		{
			this._trimValue = value;
		}
		
		/**
		 * Get or set the maximum charachters
		 */
		public function get maxChars():int
		{
			return this._textField.maxChars;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Max characters (0 = unlimited, -1 = limited to design)", type="Number", defaultValue="0")]
		public function set maxChars(value:int):void
		{
			if(value == -1)
			{
				this.limitInputToDesign = true;
				this._textField.maxChars = 0;
			}
			else
			{
				this._textField.maxChars = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Validation rule", type="String", defaultValue="none", enumeration="none,mandatory,email,postalcode (Dutch),mobile (Dutch),phone (Dutch)")]
		public function set validationRuleName(value:String):void
		{
			switch(value)
			{
				case "none":
				{
					this._validator = null;
					break;
				}
				case "mandatory":
				{
					this._validator = EmptyStringValidationRule;
					break;
				}
				case "email":
				{
					this._validator = EmailValidationRule;
					break;
				}
				case "postalcode (Dutch)":
				{
					this._validator = DutchPostalcodeValidationRule;
					break;
				}
				case "mobile (Dutch)":
				{
					this._validator = DutchMobilePhoneValidationRule;
					break;
				}
				case "phone (Dutch)":
				{
					this._validator = DutchPhoneValidationRule;
					break;
				}
				default:
				{
					this._validator = null;
					this.logError("validationRuleName: unknown validation rule '" + value + "'");
					break;
				}
			}
		}
		
		/**
		 * De bug value will be prefilled when form runs in debug mode
		 */
		public function get debugValue():*
		{
			return this._debugValue;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Debug value", type="String")]
		public function set debugValue(value:*):void
		{
			this._debugValue = value;
			if(this._debug)
			{
				this.value = this._debugValue;
			}
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
			if(this._debug && this._debugValue)
			{
				this.value = this._debugValue;
			}
		}
		
		/**
		 * When set to true, scaleX and scaleY will be reset to 0 and all children will be resized.
		 * By using this the textfield and all 9-slice children will look normal
		 */
		[Inspectable(name="Reset scaling", type="Boolean")]
		public function set resetScale(value:Boolean):void
		{
			if(value)
			{
				var len:int = this.numChildren;
				for (var i:int = 0; i < len ; i++)
				{
					this.getChildAt(i).width *= this.scaleX;
					this.getChildAt(i).height *= this.scaleY;
				}
				this.scaleX = this.scaleY = 1;
			}
		}
		
		/**
		 * Indicates whether the text field is a multiline text field. If the value is true, the text field is multiline; if the value is false, the text field is a single-line text field.
		 */
		public function get multiline():Boolean
		{
			return this._textField.multiline;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Multiline", type="Boolean", defaultValue=false)]
		public function set multiline(value:Boolean):void
		{
			this._textField.multiline = value;
			if(this._textField.multiline == true)
			{
				this._submitOnEnter = false;
			}
		}
		
		/**
		 * Indicates the alignment of the paragraph. Valid values are TextFormatAlign constants.
		 */
		public function get align():String 
		{
			return this._textField.defaultTextFormat.align;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Align", type="String", defaultValue="left", enumeration="center,justify,left,right")]
		public function set align(value:String):void 
		{
			this._textField.styleSheet = null;
			var textFormat:TextFormat = this._textField.defaultTextFormat;
			textFormat.align = value;
			this._textField.defaultTextFormat = textFormat;
		}
		
		/**
		 * If set to true the InputField will dispatch an FormElementEvent.SUBMIT when the user pressed the enter key and the form (if enabled) can be submitted.
		 * 
		 * When multiline is true, submitOnEnter will always be false.
		 */
		public function get submitOnEnter():Boolean
		{
			return this._submitOnEnter;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Submit on Enter", type="Boolean", defaultValue="true")]
		public function set submitOnEnter(value:Boolean):void
		{
			if(this._textField.multiline == true && value == true)
			{
				this._submitOnEnter = false;
			}
			else
			{
				this._submitOnEnter = value;
			}
		}

		/**
		 * If set to true the InputField will dispatch an FormElementEvent.SUBMIT when the user pressed any key and the form (if enabled) can be submitted.
		 */
		public function get submitOnChange():Boolean
		{
			return this._submitOnChange;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Submit on Change", type="Boolean", defaultValue="true")]
		public function set submitOnChange(value:Boolean):void
		{
			this._submitOnChange = value;
		}
		
		/**
		 * The point size of text in this text format. 
		 */
		public function get fontSize():Number
		{
			return this._textField.defaultTextFormat.size as Number;
		}

		/**
		 * @private
		 */
		public function set fontSize(value:Number):void
		{
			var format:TextFormat = this._textField.defaultTextFormat;
			format.size = value;
 
			this._textField.setTextFormat(format);
			this._textField.defaultTextFormat = format;
		}
		
		/**
		 * Limits the text to the design. It will prevend horizontal or vertical scrolling in the textfield 
		 */
		public function get limitInputToDesign():Boolean
		{
			return this._limitInputToDesign;
		}
		
		/**
		 * @private
		 */
		public function set limitInputToDesign(value:Boolean):void
		{
			this._limitInputToDesign = value;
		}
		
		/**
		 * The minimal size of the font when the font is automatically adjusted to de design.
		 * If set to NaN, auto fontsize is not used. Values of 0 of lower will automiticly set to NaN.
		 * 
		 * Based on the AutomaticFontSizeBehaviour of Jankees van Woezik
		 * http://blog.base42.nl/2009/08/13/automatic-font-size-adjuster/
		 */
		public function get minimalFontSize():Number
		{
			return this._minimalFontSize;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Minimal Font Size", type="Number", defaultValue="0")]
		public function set minimalFontSize(value:Number):void
		{
			this._minimalFontSize = value > 0 ? value : NaN;
		}
		
		/**
		 * Indicates if the text should be selected if the InputField gets focus
		 * @default true;
		 */
		public function get selectTextOnFocus():Boolean
		{
			return this._selectTextOnFocus;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Select Text On Focus", type="Boolean", defaultValue="true")]
		public function set selectTextOnFocus(value:Boolean):void
		{
			this._selectTextOnFocus = value;
		}

		/**
		 * @private
		 */
		override protected function handleFocusIn(event:FocusEvent):void 
		{
			super.handleFocusIn(event);
			
			this.updateHint();
			if (this._selectTextOnFocus)
			{
				FocusManager.focus = this.textField;
				this._textField.setSelection(0, this._textField.text.length);
			}
		}

		/**
		 * @private
		 */
		override protected function handleFocusOut(event:FocusEvent):void 
		{
			super.handleFocusOut(event);
			this.updateHint();
		}

		/**
		 * @private
		 */
		protected function handleTextFieldChange(event:Event):void
		{
			if(!isNaN(this._minimalFontSize))
			{
				this.fontSize = this._normalFontSize;
				while(this._textField.textWidth > this._textField.width || this._textField.textHeight > this._textField.height)
				{
					this.fontSize -= 1;
					if(this.fontSize <= this._minimalFontSize)
					{
						this.fontSize = this._minimalFontSize;
						break;
					}
				}
			}
			
			if(this._limitInputToDesign)
			{
				if(this._textField.textWidth > this._textField.width)
				{
					this._textField.text = this._previousText;
				}
				this._textField.scrollH = 0;

				if(this._textField.textHeight > this._textField.height)
				{
					this._textField.text = this._previousText;
				}
				this._textField.scrollV = 0;
			}
			event.stopPropagation();
			this.dispatchEvent(new Event(Event.CHANGE));
			
			if(this._submitOnChange)
			{
				this.dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
			}
		}

		/**
		 * @private
		 */
		protected function updateHint():void 
		{
			if (this._focus && this._showsHint) 
			{
				this._showsHint = false;
				this._textField.text = "";
				this._textField.textColor = this._textColor;
				this._textField.displayAsPassword = this._displayAsPassword;
			}
			else if (!this._focus && !this._showsHint && (this._textField.text == "")) 
			{
				this._showsHint = true;
				if(this._hintText)
				{
					this._textField.text = this._hintText;
					this._textField.textColor = this._hintTextColor;
					this._textField.displayAsPassword = false;
				}
			}
			else if (this._textField.text != this._hintText && !this._hasError)
			{
				this._showsHint = false;
				this._textField.textColor = this._textColor;
				this._textField.displayAsPassword = this._displayAsPassword;
			}
		}
		
		/**
		 * @private
		 */
		protected function handleKeyDown(event:KeyboardEvent):void
		{
			if(this._submitOnEnter && event.keyCode == KeyCode.ENTER)
			{
				event.stopPropagation();
				this.dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
			}
		}
		
		/**
		 * @private
		 */
		protected function handleTextFieldScroll(event:Event):void
		{
			if(this._limitInputToDesign) this._textField.scrollH = this._textField.scrollV = 0;
		}

		/**
		 * @private
		 */
		protected function handleTextInput(event:TextEvent):void
		{
			this._previousText = this._textField.text;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function destruct():void
		{
			this._text = null;
			this._hintText = null;
			this._prefillText = null;
			this._debugValue = null;
			
			if(this._textField)
			{
				this._textField.removeEventListener(Event.CHANGE, this.handleTextFieldChange);
				this._textField.removeEventListener(TextEvent.TEXT_INPUT, this.handleTextInput);
				this._textField.removeEventListener(Event.SCROLL, this.handleTextFieldScroll);
				this._textField = null;
			}
			
			super.destruct();
		}
	}
}
