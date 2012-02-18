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
			this.toStringProps.push('label');
			var textField:TextField = DisplayObjectContainerUtils.findChildOfType(this, TextField) as TextField;
			
			this._label = new TextFieldLabelBehavior(new TextField());
			
			if (textField)
			{
				// if there was a TextField copy it's values
				var index:uint = this.getChildIndex(textField);
				this.removeChild(textField);
				
				this._label.textField.multiline = textField.multiline;
				this._label.textField.selectable = textField.selectable;
				this._label.textField.sharpness = textField.sharpness;
				this._label.textField.text = textField.text;
				this._label.textField.textColor = textField.textColor;
				this._label.textField.thickness = textField.thickness;
				this._label.textField.type = textField.type;
				this._label.textField.wordWrap = textField.wordWrap;
				this._label.textField.width = textField.width;
				this._label.textField.height = textField.height;
				this._label.textField.x = textField.x;
				this._label.textField.y = textField.y;
				this._label.textField.filters = textField.filters;
				this._label.textField.defaultTextFormat = textField.defaultTextFormat;
				
				this.addChildAt(this._label.textField, index);
			}
			else
			{
				this.addChild(this._label.textField);
			}
			this._label.html = true;
			this._label.addEventListener(Event.CHANGE, this.handleLabelChange);
			this._label.addEventListener(Event.RESIZE, this.handleLabelResize);
			
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
			return this._label ? this._label.label : null;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Label", type="String")]
		public function set label(value:String):void
		{
			this._label.label = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get autoSize():String
		{
			return this._label.autoSize;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="AutoSize", type="String", defaultValue="none", enumeration="none,left,right,center")]
		public function set autoSize(value:String):void
		{
			this._label.autoSize = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get html():Boolean
		{
			return this._label.html;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="HTML", type="Boolean", defaultValue="true")]
		public function set html(value:Boolean):void
		{
			this._label.html = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get textField():TextField
		{
			return this._label.textField;
		}

		/**
		 * @inheritDoc
		 */
		public function get cssClass():String
		{
			return this._cssClass;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="CSS Class", type="String")]
		public function set cssClass(value:String):void
		{
			this._cssClass = value;
			StyleManager.getInstance().addTextField(this._label.textField, this._cssClass, this._styleSheetName);
			StyleManager.getInstance().addObject(this, this._cssClass, this._styleSheetName);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get styleSheetName():String
		{
			return this._styleSheetName;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="StyleSheet name", type="String")]
		public function set styleSheetName(value:String):void
		{
			this._styleSheetName = value;
			StyleManager.getInstance().addTextField(this._label.textField, this._cssClass, this._styleSheetName);
			StyleManager.getInstance().addObject(this, this._cssClass, this._styleSheetName);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get textTransform():String
		{
			return this._textTransform;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set textTransform(value:String):void
		{
			this._resetStyle = false;
			switch (value)
			{
				case null:
				case TextTransform.NONE:
				{
					this._textTransform = TextTransform.NONE;
					// do nothing
					break;
				}
				case TextTransform.UCFIRST:
				{
					this._textTransform = value;
					this.label = StringUtils.ucFirst(this.label);
					break;
				}
				case TextTransform.LOWERCASE:
				{
					this._textTransform = value;
					this.label = this.label.toLowerCase();
					break;
				}
				case TextTransform.UPPERCASE:
				{
					this._textTransform = value;
					this.label = this.label.toUpperCase();
					break;
				}
				case TextTransform.CAPITALIZE:
				{
					this._textTransform = value;
					this.label = StringUtils.capitalize(this.label);
					break;
				}
				default:
				{
					throwError(new TempleArgumentError(this, "invalid value for textTransform '" + value + "'"));
					break;
				}
			}
			this._resetStyle = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get antiAlias():String
		{
			return this._antiAlias;
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
					this._antiAlias = value;
					this._label.textField.antiAliasType = AntiAliasType.NORMAL;
					this._label.textField.gridFitType = GridFitType.NONE;
					break;
				}
				case AntiAlias.READABILITY:
				{
					this._antiAlias = value;
					
					if (this._label.textField.getTextFormat().size >= StyleManager.LARGE_FONT_SIZE)
					{
						this._label.textField.antiAliasType = AntiAliasType.NORMAL;
					}
					else
					{
						this._label.textField.antiAliasType = AntiAliasType.ADVANCED;
					}
					
					switch (this._label.textField.getTextFormat().align)
					{
						case TextFormatAlign.LEFT:
							this._label.textField.gridFitType = GridFitType.PIXEL;
							break;
						case TextFormatAlign.CENTER:
						case TextFormatAlign.JUSTIFY:
						case TextFormatAlign.RIGHT:
							this._label.textField.gridFitType = GridFitType.SUBPIXEL;
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
			return this._label.textField.multiline;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Multiline", type="Boolean")]
		public function set multiline(value:Boolean):void
		{
			this._label.textField.multiline = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingLeft(value:Number):void
		{
			this._paddingLeft = value;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Padding Left", type="String")]
		public function set inspectablePaddingLeft(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.paddingLeft = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingRight():Number
		{
			return this._paddingLeft;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingRight(value:Number):void
		{
			this._paddingRight = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Padding Right", type="String")]
		public function set inspectablePaddingRight(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.paddingRight = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingTop(value:Number):void
		{
			this._paddingTop = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Padding Top", type="String")]
		public function set inspectablePaddingTop(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.paddingTop = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paddingBottom(value:Number):void
		{
			this._paddingBottom = value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Padding Bottom", type="String")]
		public function set inspectablePaddingBottom(value:String):void
		{
			if (value != '' && !isNaN(Number(value)))
			{
				this.paddingBottom = Number(value);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get padding():Number
		{
			return this._paddingLeft == this._paddingRight && this._paddingLeft == this._paddingTop && this._paddingLeft == this._paddingBottom ? this._paddingLeft : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set padding(value:Number):void
		{
			this._paddingLeft = this._paddingRight = this._paddingTop = this._paddingBottom = value;
		}
		
		protected function handleLabelChange(event:Event):void
		{
			if (this._resetStyle) this.resetStyle();
			
			this.dispatchEvent(event.clone());
		}

		protected function handleLabelResize(event:Event):void
		{
			this.resize();
		}
		
		protected function resetStyle():void
		{
			this.textTransform = this._textTransform;
		}
		
		protected function resize():void
		{
			if (!isNaN(this._paddingLeft) || !isNaN(this._paddingRight) || this.textField.width != this.width)
			{
				if (!isNaN(this._paddingLeft)) this.textField.x = this._paddingLeft;
				this.width = (this._paddingLeft ? this._paddingLeft : 0) + this.textField.width + (this._paddingRight ? this._paddingRight : 0);
			}
			if (!isNaN(this._paddingTop) || !isNaN(this._paddingBottom) || this.textField.height != this.height)
			{
				if (!isNaN(this._paddingTop)) this.textField.y = this._paddingTop;
				this.height = (this._paddingTop ? this._paddingTop : 0) + this.textField.height + (this._paddingBottom ? this._paddingBottom : 0);
			}
			if (this.liquidBehavior) this.liquidBehavior.update();
			this.dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._label)
			{
				this._label.destruct();
				this._label = null;
			}
			super.destruct();
		}
	}
}
