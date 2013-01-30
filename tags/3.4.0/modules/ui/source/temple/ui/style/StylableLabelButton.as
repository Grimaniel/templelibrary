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

package temple.ui.style 
{
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.ui.buttons.LabelButton;
	import temple.ui.label.IHTMLLabel;
	import temple.ui.label.ITextFieldLabel;
	import temple.ui.label.TextFieldLabelBehavior;
	import temple.utils.types.DisplayObjectContainerUtils;
	import temple.utils.types.StringUtils;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * Dispatched after the text in the TextField is changed
	 * Event will also be dispatched from the TextField
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name = "change", type = "flash.events.Event")]

	/**
	 * Dispatched after size of the TextField is changed
	 * Event will also be dispatched from the TextField
	 * @eventType flash.events.Event.RESIZE
	 */
	[Event(name = "resize", type = "flash.events.Event")]
	
	/**
	 * A StylableLabelButton is a <code>LabelButton</code> which can be styled using CSS.
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see temple.ui.buttons.LabelButton
	 * @see temple.ui.style.StyleManager
	 * @see temple.ui.buttons.behaviors.ButtonBehavior
	 * @see ../../../../readme.html
	 * 
	 * @author Thijs Broerse
	 */
	public class StylableLabelButton extends LabelButton implements IStylableLabel
	{
		private var _cssClass:String;
		private var _styleSheetName:String;
		private var _antiAlias:String;
		private var _textTransform:String = TextTransform.NONE;
		
		// indicates if the style should be reset after a label change
		protected var _resetStyle:Boolean;
		
		public function StylableLabelButton()
		{
			super();
		}

		override protected function init(textField:TextField = null):void
		{
			if (!textField) textField = DisplayObjectContainerUtils.findChildOfType(this, TextField) as TextField;
				
			var newTextField:TextField = new TextField();
			
			if (textField)
			{
				// if there was a TextField copy it's values
				var index:uint = getChildIndex(textField);
				
				newTextField.multiline = textField.multiline;
				newTextField.selectable = textField.selectable;
				newTextField.sharpness = textField.sharpness;
				newTextField.textColor = textField.textColor;
				newTextField.thickness = textField.thickness;
				newTextField.type = textField.type;
				newTextField.wordWrap = textField.wordWrap;
				newTextField.width = textField.width;
				newTextField.height = textField.height;
				newTextField.x = textField.x;
				newTextField.y = textField.y;
				newTextField.filters = textField.filters;
				
				// hide textField (we can't remove it, it will be back everytime we are on frame 1)
				textField.visible = false;
				textField.text = '';
				textField.width = textField.height = 1;

				addChildAt(newTextField, index);
			}
			else
			{
				addChild(newTextField);
			}

			_label = new TextFieldLabelBehavior(newTextField);
			(_label as IHTMLLabel).html = true;
			(_label as IEventDispatcher).addEventListener(Event.CHANGE, handleLabelChange);
		}

		/**
		 * @inheritDoc
		 */
		public function get cssClass():String
		{
			return _cssClass;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="CSS Class", type="String")]
		public function set cssClass(value:String):void
		{
			_cssClass = value;
			styleManagerInstance.addTextField((_label as ITextFieldLabel).textField, _cssClass, _styleSheetName);
			styleManagerInstance.addObject(this, _cssClass, _styleSheetName);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get styleSheetName():String
		{
			return _styleSheetName;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="StyleSheet name", type="String")]
		public function set styleSheetName(value:String):void
		{
			_styleSheetName = value;
			styleManagerInstance.addTextField((_label as ITextFieldLabel).textField, _cssClass, _styleSheetName);
			styleManagerInstance.addObject(this, _cssClass, _styleSheetName);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get textTransform():String
		{
			return _textTransform;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set textTransform(value:String):void
		{
			_resetStyle = false;
			switch (value)
			{
				case null:
				case TextTransform.NONE:
				{
					_textTransform = TextTransform.NONE;
					// do nothing
					break;
				}
				case TextTransform.UCFIRST:
				{
					_textTransform = value;
					this.label = StringUtils.ucFirst(this.label);
					break;
				}
				case TextTransform.LOWERCASE:
				{
					_textTransform = value;
					this.label = label.toLowerCase();
					break;
				}
				case TextTransform.UPPERCASE:
				{
					_textTransform = value;
					this.label = label.toUpperCase();
					break;
				}	
				case TextTransform.CAPITALIZE:
				{
					_textTransform = value;
					this.label = StringUtils.capitalize(this.label);
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "invalid value for textTransform '" + value + "'"));
					break;
				}
			}
			_resetStyle = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get antiAlias():String
		{
			return _antiAlias;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Anti-alias", type="String", defaultValue="please choose...", enumeration="please choose...,animation,readability")]
		public function set antiAlias(value:String):void
		{
			switch (value)
			{
				case AntiAlias.ANIMATION:
				{
					_antiAlias = value;
					(_label as ITextFieldLabel).textField.antiAliasType = AntiAliasType.NORMAL;
					(_label as ITextFieldLabel).textField.gridFitType = GridFitType.NONE;
					break;
				}
				case AntiAlias.READABILITY:
				{
					_antiAlias = value;
					
					if ((_label as ITextFieldLabel).textField.getTextFormat().size >= StyleManager.LARGE_FONT_SIZE)
					{
						(_label as ITextFieldLabel).textField.antiAliasType = AntiAliasType.NORMAL;
					}
					else
					{
						(_label as ITextFieldLabel).textField.antiAliasType = AntiAliasType.ADVANCED;
					}
					
					switch ((_label as ITextFieldLabel).textField.getTextFormat().align)
					{
						case TextFormatAlign.LEFT:
						{
							ITextFieldLabel(_label).textField.gridFitType = GridFitType.PIXEL;
							break;
						}
						case TextFormatAlign.CENTER:
						case TextFormatAlign.JUSTIFY:
						case TextFormatAlign.RIGHT:
						{
							ITextFieldLabel(_label).textField.gridFitType = GridFitType.SUBPIXEL;
							break;
						}
					}
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "invalid value for antiAlias: '" + value + "'"));
					break;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get multiline():Boolean
		{
			return (_label as ITextFieldLabel).textField.multiline;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Multiline", type="Boolean")]
		public function set multiline(value:Boolean):void
		{
			(_label as ITextFieldLabel).textField.multiline = value;
		}

		private function handleLabelChange(event:Event):void
		{
			if (_resetStyle) resetStyle();
		}

		protected function resetStyle():void
		{
			this.textTransform = _textTransform;
		}

		override public function destruct():void
		{
			if (_label && _label is IEventDispatcher) (_label as IEventDispatcher).removeEventListener(Event.CHANGE, handleLabelChange);
			
			super.destruct();
		}
	}
}
