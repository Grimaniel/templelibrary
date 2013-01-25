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
	import temple.ui.label.TextFieldLabelBehavior;
	import temple.ui.layout.liquid.LiquidContainer;
	import temple.utils.types.DisplayObjectContainerUtils;
	import temple.utils.types.StringUtils;

	import flash.events.Event;
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
	 * A label which can be styled with the <code>StyleManager</code> and CSS.
	 * 
	 * <p>This class can also be used as componten in the Flash IDE. The properties can be set with the Component Inspector.</p>
	 * 
	 * @see temple.ui.style.StyleManager
	 * 
	 * @author Thijs Broerse
	 */
	public class StylableLabel extends LiquidContainer implements IStylableLabel
	{
		private var _label:TextFieldLabelBehavior;
		private var _cssClass:String;
		private var _styleSheetName:String;
		private var _antiAlias:String;
		private var _textTransform:String = TextTransform.NONE;
		private var _paddingLeft:Number;
		private var _paddingRight:Number;
		private var _paddingTop:Number;
		private var _paddingBottom:Number;
		
		// indicates if the style should be reset after a label change
		private var _resetStyle:Boolean;

		public function StylableLabel(label:String = null, cssClass:String = null)
		{
			super();
			toStringProps.push('label');
			var textField:TextField = DisplayObjectContainerUtils.findChildOfType(this, TextField) as TextField;
			
			_label = new TextFieldLabelBehavior(new TextField());
			
			if (textField)
			{
				// if there was a TextField copy it's values
				var index:uint = getChildIndex(textField);
				removeChild(textField);
				
				_label.textField.multiline = textField.multiline;
				_label.textField.selectable = textField.selectable;
				_label.textField.sharpness = textField.sharpness;
				_label.textField.text = textField.text;
				_label.textField.textColor = textField.textColor;
				_label.textField.thickness = textField.thickness;
				_label.textField.type = textField.type;
				_label.textField.wordWrap = textField.wordWrap;
				_label.textField.width = textField.width;
				_label.textField.height = textField.height;
				_label.textField.x = textField.x;
				_label.textField.y = textField.y;
				_label.textField.filters = textField.filters;
				_label.textField.defaultTextFormat = textField.defaultTextFormat;
				
				addChildAt(_label.textField, index);
			}
			else
			{
				addChild(_label.textField);
			}
			_label.html = true;
			_label.addEventListener(Event.CHANGE, handleLabelChange);
			_label.addEventListener(Event.RESIZE, handleLabelResize);
			
			if (label)
			{
				this.label = label;
			}
			this.cssClass = cssClass;
		}

		/**
		 * @inheritDoc
		 */
		public function get label():String
		{
			return _label ? _label.label : null;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Label", type="String")]
		public function set label(value:String):void
		{
			_label.label = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoSize():String
		{
			return _label.autoSize;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="AutoSize", type="String", defaultValue="none", enumeration="none,left,right,center")]
		public function set autoSize(value:String):void
		{
			_label.autoSize = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get html():Boolean
		{
			return _label.html;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="HTML", type="Boolean", defaultValue="true")]
		public function set html(value:Boolean):void
		{
			_label.html = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get textField():TextField
		{
			return _label.textField;
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
			styleManagerInstance.addTextField(_label.textField, _cssClass, _styleSheetName);
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
			styleManagerInstance.addTextField(_label.textField, _cssClass, _styleSheetName);
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
					label = StringUtils.ucFirst(label);
					break;
				}
				case TextTransform.LOWERCASE:
				{
					_textTransform = value;
					label = label.toLowerCase();
					break;
				}
				case TextTransform.UPPERCASE:
				{
					_textTransform = value;
					label = label.toUpperCase();
					break;
				}
				case TextTransform.CAPITALIZE:
				{
					_textTransform = value;
					label = StringUtils.capitalize(label);
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
					_label.textField.antiAliasType = AntiAliasType.NORMAL;
					_label.textField.gridFitType = GridFitType.NONE;
					break;
				}
				case AntiAlias.READABILITY:
				{
					_antiAlias = value;
					
					if (_label.textField.getTextFormat().size >= StyleManager.LARGE_FONT_SIZE)
					{
						_label.textField.antiAliasType = AntiAliasType.NORMAL;
					}
					else
					{
						_label.textField.antiAliasType = AntiAliasType.ADVANCED;
					}
					
					switch (_label.textField.getTextFormat().align)
					{
						case TextFormatAlign.LEFT:
							_label.textField.gridFitType = GridFitType.PIXEL;
							break;
						case TextFormatAlign.CENTER:
						case TextFormatAlign.JUSTIFY:
						case TextFormatAlign.RIGHT:
							_label.textField.gridFitType = GridFitType.SUBPIXEL;
							break;
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
			return _label.textField.multiline;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Multiline", type="Boolean")]
		public function set multiline(value:Boolean):void
		{
			_label.textField.multiline = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Padding Left", type="String")]
		public function set inspectablePaddingLeft(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				paddingLeft = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingRight():Number
		{
			return _paddingLeft;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Padding Right", type="String")]
		public function set inspectablePaddingRight(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				paddingRight = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Padding Top", type="String")]
		public function set inspectablePaddingTop(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				paddingTop = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Padding Bottom", type="String")]
		public function set inspectablePaddingBottom(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				paddingBottom = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get padding():Number
		{
			return _paddingLeft == _paddingRight && _paddingLeft == _paddingTop && _paddingLeft == _paddingBottom ? _paddingLeft : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set padding(value:Number):void
		{
			_paddingLeft = _paddingRight = _paddingTop = _paddingBottom = value;
		}
		
		protected function handleLabelChange(event:Event):void
		{
			if (_resetStyle) resetStyle();
			
			dispatchEvent(event.clone());
		}

		protected function handleLabelResize(event:Event):void
		{
			resize();
		}
		
		protected function resetStyle():void
		{
			textTransform = _textTransform;
		}
		
		protected function resize():void
		{
			if (!isNaN(_paddingLeft) || !isNaN(_paddingRight) || textField.width != width)
			{
				if (!isNaN(_paddingLeft)) textField.x = _paddingLeft;
				width = (_paddingLeft ? _paddingLeft : 0) + textField.width + (_paddingRight ? _paddingRight : 0);
			}
			if (!isNaN(_paddingTop) || !isNaN(_paddingBottom) || textField.height != height)
			{
				if (!isNaN(_paddingTop)) textField.y = _paddingTop;
				height = (_paddingTop ? _paddingTop : 0) + textField.height + (_paddingBottom ? _paddingBottom : 0);
			}
			if (liquidBehavior) liquidBehavior.update();
			dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_label)
			{
				_label.destruct();
				_label = null;
			}
			super.destruct();
		}
	}
}
