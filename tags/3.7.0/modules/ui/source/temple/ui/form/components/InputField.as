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
	import temple.common.interfaces.IEnableable;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.Registry;
	import temple.ui.focus.FocusManager;
	import temple.ui.form.validation.rules.DutchMobilePhoneValidationRule;
	import temple.ui.form.validation.rules.DutchPhoneValidationRule;
	import temple.ui.form.validation.rules.DutchPostalcodeValidationRule;
	import temple.ui.form.validation.rules.EmailValidationRule;
	import temple.ui.form.validation.rules.EmptyStringValidationRule;
	import temple.ui.form.validation.rules.Restrictions;
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
	 * Use for text input (like name or email). An InputField must have at least an editable TextField
	 * (a instance name is not necessary).
	 * 
	 * <p>An InputField has the following states:</p>
	 * 
	 * <ul>
	 * 	<li><strong>IErrorState</strong>: All children which implemented this state will be shown when the InputField has an error.
	 * 	An (optional) error message can be passed to this child.</li>
	 * 
	 * 	<li><strong>IFocusState</strong>: All children which implemented this state will be shown when the InputField get the focus.</li>
	 * </ul>
	 * 
	 * @see temple.ui.form.Form
	 * 
	 * @see temple.ui.states.error.IErrorState
	 * @see temple.ui.states.error.ErrorState
	 * @see temple.ui.states.error.ErrorTimelineState
	 * @see temple.ui.states.error.ErrorFadeState
	 * 
	 * @see temple.ui.states.focus.IFocusState
	 * @see temple.ui.states.focus.FocusState
	 * @see temple.ui.states.focus.FocusTimelineState
	 * @see temple.ui.states.focus.FocusFadeState
	 * 
	 * @includeExample ../services/XMLFormServiceExample.as
	 * @includeExample ../FormExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class InputField extends FormElementComponent implements IInputField, IEnableable, IDebuggable
	{
		private var _textField:TextField;
		private var _hintText:String;
		private var _prefillText:String;
		private var _showsHint:Boolean;
		private var _defaultTextFormat:TextFormat;
		private var _hintTextFormat:TextFormat;
		private var _errorTextFormat:TextFormat;
		private var _trimValue:Boolean = true;
		private var _displayAsPassword:Boolean;
		private var _debug:Boolean;
		private var _debugValue:*;
		private var _submitOnEnter:Boolean = true;
		private var _previousText:String;
		private var _limitInputToDesign:Boolean;
		private var _normalFontSize:Number;
		private var _minimalFontSize:Number;
		private var _selectTextOnFocus:Boolean = true;
		private var _enabled:Boolean = true;
		private var _updateHintOnChange:Boolean;

		/**
		 * Constructor
		 */
		public function InputField(textField:TextField = null) 
		{
			if (textField && !contains(textField))
			{
				textField.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
				textField.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
			}
			
			_textField = textField || DisplayObjectContainerUtils.getChildOfType(this, TextField) as TextField || addChild(new TextField()) as TextField;

			addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			_textField.defaultTextFormat = _textField.getTextFormat();
			_textField.setTextFormat(_textField.defaultTextFormat);
			_textField.addEventListener(Event.CHANGE, handleTextFieldChange, false, 0, true);
			_textField.addEventListener(TextEvent.TEXT_INPUT, handleTextInput, false, 0, true);
			_textField.addEventListener(Event.SCROLL, handleTextFieldScroll, false, 0, true);
			_defaultTextFormat = _textField.defaultTextFormat; 
			_normalFontSize = fontSize;
			
			if (_textField.multiline) _submitOnEnter = false;

			// Register TextField for destruction testing
			Registry.add(_textField);
		}
		
		/**
		 * Returns a reference to the TextField.
		 */
		public function get textField():TextField
		{
			return _textField;
		}

		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void
		{
			if (value == focus) return;
			
			if (value)
			{
				FocusManager.focus = _textField;
			}
			else if (focus)
			{
				FocusManager.focus = null;
			}
		}

		/**
		 * The text in the contained input field.
		 */
		public function get text():String 
		{
			return _showsHint ? "" : _textField.text;	
		}

		/**
		 * @private
		 */
		public function set text(value:String):void 
		{
			if (value == null) value = "";
			
			_textField.text = value;
			_showsHint = false;
			updateHint();
			_textField.dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 
		 */
		public function appendText(newText:String):void
		{
			if (_textField)
			{
				_textField.appendText(newText);
				_showsHint = false;
				updateHint();
				_textField.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get defaultTextFormat():TextFormat
		{
			return _defaultTextFormat;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set defaultTextFormat(value:TextFormat):void
		{
			_defaultTextFormat = value;
			if (!_showsHint && !hasError)
			{
				setTextFormat(_defaultTextFormat);
			}
		}
		
		/**
		 * Set the hint text to be displayed when nothing has been input in the field yet.
		 * The hintText will automatically disappear when the InputField get focus and can be used the clarify the usage of the InputField.
		 */
		public function get hintText():String 
		{
			return _hintText;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Hint text", type="String")]
		public function set hintText(value:String):void 
		{
			if (_textField.text == _hintText)
			{
				_textField.text = value;
			}
			_hintText = value;
			
			updateHint();
		}
		
		/**
		 * Set the prefill text to be displayed when nothing has been input in the field yet.
		 */
		public function get prefillText():String 
		{
			return _prefillText;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Prefill text", type="String")]
		public function set prefillText(value:String):void 
		{
			_prefillText = value;
			text = _prefillText;
		}

		/**
		 * @inheritDoc
		 */
		public function get hintTextFormat():TextFormat
		{
			 return _hintTextFormat;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set hintTextFormat(value:TextFormat):void 
		{
			_hintTextFormat = value;
			
			if (_showsHint) setTextFormat(_hintTextFormat);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get errorTextFormat():TextFormat
		{
			 return _errorTextFormat;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set errorTextFormat(value:TextFormat):void 
		{
			_errorTextFormat = value;
			
			if (hasError) setTextFormat(_errorTextFormat);
		}

		/**
		 * @inheritDoc 
		 */
		public function get enabled():Boolean 
		{
			return _enabled;
		}

		/**
		 * @inheritDoc 
		 */
		[Inspectable(name="Enabled", type="Boolean", defaultValue=true)]
		public function set enabled(value:Boolean):void 
		{
			_enabled = mouseChildren = mouseEnabled = value;
			_textField.mouseEnabled = value;
			_textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			if (value) _textField.styleSheet = null;
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
		 * @inheritDoc 
		 */
		override public function get value():* 
		{
			return _trimValue ? StringUtils.trim(text) : text;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function set value(value:*):void
		{
			if (value == null) return;
			text = value;
		}

		/**
		 * @inheritDoc 
		 */
		override public function showError(message:String = null):void 
		{
			super.showError(message);
			
			if (_errorTextFormat) setTextFormat(_errorTextFormat);
		}

		/**
		 * @inheritDoc 
		 */
		override public function hideError():void 
		{
			super.hideError();
			setTextFormat(_showsHint ? _hintTextFormat : _defaultTextFormat);
		}

		/**
		 * Reset the input field.
		 */
		public function reset():void 
		{
			text = _prefillText ? _prefillText : "";
			textField.scrollH = textField.scrollV = 0;
		}
		
		/**
		 * Get or set a restriction on the InputField.
		 * @see temple.ui.form.validation.rules.Restrictions
		 */
		public function get restrict():String 
		{
			return _textField.restrict;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Restriction", type="String", defaultValue="none", enumeration="none,numeric,numbers,alphanumeric,email,postalcode (Dutch),uppercase,lowercase")]
		public function set restrict(value:String):void 
		{
			switch (value)
			{
				case "none":
				{
					_textField.restrict = null;
					break;
				}
				case "numeric":
				{
					_textField.restrict = Restrictions.NUMERIC;
					break;
				}
				case "numbers":
				{
					_textField.restrict = Restrictions.NUMBERS;
					break;
				}
				case "alphanumeric":
				{
					_textField.restrict = Restrictions.ALPHANUMERIC;
					break;
				}
				case "email":
				{
					_textField.restrict = Restrictions.EMAIL;
					break;
				}
				case "postalcode (Dutch)":
				{
					_textField.restrict = Restrictions.DUTCH_POSTALCODE;
					break;
				}
				case "uppercase":
				{
					_textField.restrict = Restrictions.UPPERCASE;
					break;
				}
				case "lowercase":
				{
					_textField.restrict = Restrictions.LOWERCASE;
					break;
				}
				default:
				{
					_textField.restrict = value;
					break;
				}
			}
		}

		/**
		 * Will display asterisks (&#42;&#42;&#42;&#42;) instead of real characters. 
		 */
		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}

		/**
		 * @private 
		 */
		[Inspectable(name="Display as password", type="Boolean", defaultValue=false)]
		public function set displayAsPassword(value:Boolean):void
		{
			_displayAsPassword = value;
			if (_hintText && _hintText == _textField.text)
			{
				_textField.displayAsPassword = true;
			}
			else
			{
				_textField.displayAsPassword = value;
			}
		}

		/**
		 * Indicates if the value is trimmed.
		 */
		public function get trimValue():Boolean
		{
			return _trimValue;
		}

		/**
		 * Sets if the value should be trimmed.
		 * Trims only the value get by the getValue() method.
		 */
		[Inspectable(name="Trim value (remove spaces)", type="Boolean", defaultValue=true)]
		public function set trimValue(value:Boolean):void
		{
			_trimValue = value;
		}
		
		/**
		 * The maximum amount of characters that can be typed in the InputField.
		 */	
		public function get maxChars():int
		{
			return _textField.maxChars;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Max characters (0 = unlimited, -1 = limited to design)", type="Number", defaultValue="0")]
		public function set maxChars(value:int):void
		{
			if (value == -1)
			{
				limitInputToDesign = true;
				_textField.maxChars = 0;
			}
			else
			{
				_textField.maxChars = value;
			}
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Validation rule", type="String", defaultValue="none", enumeration="none,mandatory,email,postalcode (Dutch),mobile (Dutch),phone (Dutch)")]
		public function set validationRuleName(value:String):void
		{
			switch (value)
			{
				case "none":
				{
					_validator = null;
					break;
				}
				case "mandatory":
				{
					_validator = EmptyStringValidationRule;
					break;
				}
				case "email":
				{
					_validator = EmailValidationRule;
					break;
				}
				case "postalcode (Dutch)":
				{
					_validator = DutchPostalcodeValidationRule;
					break;
				}
				case "mobile (Dutch)":
				{
					_validator = DutchMobilePhoneValidationRule;
					break;
				}
				case "phone (Dutch)":
				{
					_validator = DutchPhoneValidationRule;
					break;
				}
				default:
				{
					_validator = null;
					logError("validationRuleName: unknown validation rule '" + value + "'");
					break;
				}
			}
		}
		
		/**
		 * De bug value will be prefilled when form runs in debug mode.
		 */
		public function get debugValue():*
		{
			return _debugValue;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Debug value", type="String")]
		public function set debugValue(value:*):void
		{
			_debugValue = value;
			if (_debug)
			{
				value = _debugValue;
			}
		}
		
		/**
		 * A Boolean which indicates if the text in the InputField can be edited
		 */
		public function get editable():Boolean
		{
			return _textField.type == TextFieldType.INPUT;
		}

		/**
		 * @private
		 */
		public function set editable(value:Boolean):void
		{
			_textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
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
			if (_debug && _debugValue)
			{
				value = _debugValue;
			}
		}
		
		/**
		 * Setter function to make the resetScale option available in the Component Inspector, when the InputField is used as component. 
		 * 
		 * @private
		 */
		[Inspectable(name="Reset scaling", type="Boolean")]
		public function set inspectableResetScale(value:Boolean):void
		{
			if (value)
			{
				resetScale();
			}
		}

		/**
		 * When set to true, scaleX and scaleY will be reset to 0 and all children will be resized.
		 * By using this the textfield and all 9-slice children will look normal.
		 */
		public function resetScale():void
		{
			var len:int = numChildren;
			for (var i:int = 0; i < len ; i++)
			{
				getChildAt(i).width *= scaleX;
				getChildAt(i).height *= scaleY;
			}
			scaleX = scaleY = 1;
		}

		/**
		 * Indicates whether the text field is a multiline text field. If the value is true, the text field is multiline; if the value is false, the text field is a single-line text field.
		 */
		public function get multiline():Boolean
		{
			return _textField.multiline;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Multiline", type="Boolean", defaultValue=false)]
		public function set multiline(value:Boolean):void
		{
			_textField.multiline = value;
			if (_textField.multiline)
			{
				_submitOnEnter = false;
			}
		}
		
		/**
		 * Indicates the alignment of the paragraph. Valid values are TextFormatAlign constants.
		 */
		public function get align():String 
		{
			return _textField.defaultTextFormat.align;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Align", type="String", defaultValue="left", enumeration="center,justify,left,right")]
		public function set align(value:String):void 
		{
			_textField.styleSheet = null;
			var textFormat:TextFormat = _textField.defaultTextFormat;
			textFormat.align = value;
			_textField.defaultTextFormat = textFormat;
		}
		
		/**
		 * If set to true the InputField will dispatch an FormElementEvent.SUBMIT when the user pressed the enter key and the form (if enabled) can be submitted.
		 * 
		 * When multiline is true, submitOnEnter will always be false.
		 */
		public function get submitOnEnter():Boolean
		{
			return _submitOnEnter;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Submit on Enter", type="Boolean", defaultValue="true")]
		public function set submitOnEnter(value:Boolean):void
		{
			if (_textField.multiline && value)
			{
				_submitOnEnter = false;
			}
			else
			{
				_submitOnEnter = value;
			}
		}

		/**
		 * The point size of text in this text format. 
		 */
		public function get fontSize():Number
		{
			return _defaultTextFormat.size as Number;
		}

		/**
		 * @private
		 */
		public function set fontSize(value:Number):void
		{
			_defaultTextFormat.size = value;
			
			if (_hintTextFormat) _defaultTextFormat.size = value;
			if (_errorTextFormat) _errorTextFormat.size = value;
			
			if (hasError)
			{
				setTextFormat(_errorTextFormat);
			}
			else if (_showsHint)
			{
				setTextFormat(_hintTextFormat);
			}
			else
			{
				setTextFormat(_defaultTextFormat);
			}
		}
		
		/**
		 * Limits the text to the design. It will prevend horizontal or vertical scrolling in the textfield.
		 */
		public function get limitInputToDesign():Boolean
		{
			return _limitInputToDesign;
		}
		
		/**
		 * @private
		 */
		public function set limitInputToDesign(value:Boolean):void
		{
			_limitInputToDesign = value;
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
			return _minimalFontSize;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Minimal Font Size", type="Number", defaultValue="0")]
		public function set minimalFontSize(value:Number):void
		{
			_minimalFontSize = value > 0 ? value : NaN;
		}
		
		/**
		 * Indicates if the text should be selected if the InputField gets focus.
		 * @default true;
		 */
		public function get selectTextOnFocus():Boolean
		{
			return _selectTextOnFocus;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Select Text On Focus", type="Boolean", defaultValue="true")]
		public function set selectTextOnFocus(value:Boolean):void
		{
			_selectTextOnFocus = value;
		}
		
		/**
		 * A Boolean which indicates if currently the hint text is shown.
		 */
		public function get showsHint():Boolean
		{
			return _showsHint;
		}

		/**
		 * A Boolean which indicates if the hintText should be removed when the InputField gets focus (false) or when
		 * the text changed (true). Default value is false.
		 * 
		 * @default false
		 */
		public function get updateHintOnChange():Boolean
		{
			return _updateHintOnChange;
		}

		/**
		 * @private
		 */
		public function set updateHintOnChange(value:Boolean):void
		{
			_updateHintOnChange = value;
			updateHint();
		}
		
		/**
		 * @private
		 */
		override protected function handleFocusIn(event:FocusEvent):void 
		{
			super.handleFocusIn(event);
			
			if (!_updateHintOnChange) updateHint();
			if (_selectTextOnFocus)
			{
				FocusManager.focus = textField;
				_textField.setSelection(0, _textField.text.length);
			}
		}

		/**
		 * @private
		 */
		override protected function handleFocusOut(event:FocusEvent):void 
		{
			super.handleFocusOut(event);
			updateHint();
		}

		/**
		 * @private
		 */
		protected function handleTextFieldChange(event:Event):void
		{
			if (_showsHint) updateHint();
			
			if (_updateHintOnChange && _textField.text == "")
			{
				showHint();
			}
			
			if (!isNaN(_minimalFontSize))
			{
				fontSize = _normalFontSize;
				while (_textField.textWidth > _textField.width || _textField.textHeight > _textField.height)
				{
					fontSize -= 1;
					if (fontSize <= _minimalFontSize)
					{
						fontSize = _minimalFontSize;
						break;
					}
				}
			}
			
			if (_limitInputToDesign)
			{
				if (_textField.textWidth > _textField.width)
				{
					_textField.text = _previousText;
				}
				_textField.scrollH = 0;

				if (_textField.textHeight > _textField.height)
				{
					_textField.text = _previousText;
				}
				_textField.scrollV = 0;
			}
			event.stopPropagation();
			dispatchEvent(new Event(Event.CHANGE));
			
			if (submitOnChange)
			{
				dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
			}
		}

		/**
		 * @private
		 */
		protected function updateHint():void 
		{
			if (focus && _showsHint) 
			{
				_showsHint = false;
				_textField.text = "";
				setTextFormat(_defaultTextFormat);
				_textField.displayAsPassword = _displayAsPassword;
			}
			else if (!focus && !_showsHint && (_textField.text == "")) 
			{
				showHint();
			}
			else if (_showsHint && _textField.text != _hintText && !hasError)
			{
				_showsHint = false;
				setTextFormat(_defaultTextFormat);
				_textField.displayAsPassword = _displayAsPassword;
			}
		}

		protected function showHint():void
		{
			_showsHint = true;
			if (_hintText)
			{
				_textField.text = _hintText;
				setTextFormat(_hintTextFormat);
				_textField.displayAsPassword = false;
			}
		}

		
		/**
		 * @private
		 */
		protected function handleKeyDown(event:KeyboardEvent):void
		{
			if (_submitOnEnter && event.keyCode == KeyCode.ENTER)
			{
				event.stopPropagation();
				dispatchEvent(new FormElementEvent(FormElementEvent.SUBMIT));
			}
		}
		
		/**
		 * @private
		 */
		protected function handleTextFieldScroll(event:Event):void
		{
			if (_limitInputToDesign) _textField.scrollH = _textField.scrollV = 0;
		}

		/**
		 * @private
		 */
		protected function handleTextInput(event:TextEvent):void
		{
			_previousText = _textField.text;
			if (_showsHint) updateHint();
		}

		private function setTextFormat(format:TextFormat):void
		{
			_textField.setTextFormat(_textField.defaultTextFormat = format || _defaultTextFormat);
		}

		
		/**
		 * @inheritDoc 
		 */
		override public function destruct():void
		{
			_hintText = null;
			_prefillText = null;
			_debugValue = null;
			
			if (_textField)
			{
				_textField.removeEventListener(Event.CHANGE, handleTextFieldChange);
				_textField.removeEventListener(TextEvent.TEXT_INPUT, handleTextInput);
				_textField.removeEventListener(Event.SCROLL, handleTextFieldScroll);
				_textField.removeEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
				_textField.removeEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
				_textField = null;
			}
			
			super.destruct();
		}
	}
}
