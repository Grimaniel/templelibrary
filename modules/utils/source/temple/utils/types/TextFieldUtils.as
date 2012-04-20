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

package temple.utils.types 
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.utils.FrameDelay;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	/**
	 * This class contains some functions for TextFields.
	 * 
	 * @author Thijs Broerse
	 */
	public final class TextFieldUtils 
	{
		private static const _MAGICAL_TEXTWIDTH_PADDING:Number = 3;
		
		/**
		 * Inits the give textfield with an autoFormat and sets the defaultTextFormat so you can change the text without losing its formatting
		 * @param textField The TextField to init
		 * @param autoSize The autosize to set
		 */
		public static function init(textField:TextField, autoSize:String = null):void 
		{
			textField.defaultTextFormat = textField.getTextFormat();
			if (autoSize) textField.autoSize = autoSize;
		}

		/**
		 * Trims the text to fit a given textfield.  
		 * @param textField the TextField to set the new text to.
		 * @param abbreviatedString the text that indicates that trimming has occurred; commonly this is "..."
		 * @return a Boolean which indicates if the text in the TextField is trimmed.
		 */  
		public static function trimTextFieldText(textField:TextField, abbreviatedString:String = "..."):Boolean 
		{
			var text:String = textField.text;
			var trimLength:int = text.length;
			var trimmed:Boolean;
			
			while (textField.multiline && textField.textHeight > textField.height || !textField.multiline && textField.textWidth + TextFieldUtils._MAGICAL_TEXTWIDTH_PADDING > textField.width)
			{ 
				--trimLength;
				text = text.substr(0, trimLength);
				text += abbreviatedString;
				textField.text = text;
				trimmed = true;
			}
			return trimmed;
		}

		/**
		 * Trims the htmlText to fit a given textfield.  
		 * @param textField the TextField to set the new text to.
		 * @param abbreviatedString the text that indicates that trimming has occurred; commonly this is "..."
		 * @return a Boolean which indicates if the text in the TextField is trimmed.
		 */  
		public static function trimTextFieldHTMLText(textField:TextField, abbreviatedString:String = "..."):Boolean 
		{
			var styleSheet:StyleSheet = textField.styleSheet;
			textField.styleSheet = null;
			var text:String;
			var closeTag:uint;
			var trimmed:Boolean;
			
			while (textField.multiline && textField.textHeight > textField.height || !textField.multiline && textField.textWidth + TextFieldUtils._MAGICAL_TEXTWIDTH_PADDING > textField.width)
			{
				text = textField.getXMLText(0, textField.text.length - 1 - abbreviatedString.length);
				closeTag = text.lastIndexOf(')</textformat>');
				text = text.substr(0, closeTag) + abbreviatedString + text.substr(closeTag);
				textField.insertXMLText(0, textField.text.length, text);
				trimmed = true;
			}
			new FrameDelay(function():void { textField.styleSheet = styleSheet; }, 5);
			return trimmed;
		}

		/**
		 * Creates a new TextField with the same layout
		 */
		public static function copy(textField:TextField):TextField
		{
			var t:TextField = new TextField();
			
			t.antiAliasType = textField.antiAliasType;
			t.autoSize = textField.autoSize;
			t.defaultTextFormat = textField.defaultTextFormat;
			t.embedFonts = textField.embedFonts;
			t.gridFitType = textField.gridFitType;
			t.mouseWheelEnabled = textField.mouseWheelEnabled;
			t.multiline = textField.multiline;
			t.selectable = textField.selectable;
			t.sharpness = textField.sharpness;
			t.styleSheet = textField.styleSheet;
			t.text = textField.text;
			t.textColor = textField.textColor;
			t.thickness = textField.thickness;
			t.type = textField.type;
			t.wordWrap = textField.wordWrap;
			t.width = textField.width;
			t.height = textField.height;
			t.x = textField.x;
			t.y = textField.y;
			
			t.setTextFormat(textField.getTextFormat());
			return t; 
		}
		
		/**
		 * Searches for TextField in a DisplayObject and set the TextFormat as Default. In this way the textformat won't changes, when you change the text
		 * 
		 * @param displayObject The displayObject that contains the TextFields
		 * @param recursive if set to true all childrens TextFields (and grandchildrens etc) will also be formatted
		 * @param debug if set to true, debug information of the formatted TextFields will be logged
		 */
		public static function formatTextFields(container:DisplayObjectContainer, recursive:Boolean = true, debug:Boolean = false):void
		{
			if (container == null) return;
			
			var child:DisplayObject;
			
			var leni:int = container.numChildren;
			for (var i:int = 0;i < leni ;i++)
			{
				child = container.getChildAt(i);
				
				if (child is TextField)
				{
					TextField(child).defaultTextFormat = TextField(child).getTextFormat();
					
					if (debug) Log.debug("formatTextFields: found TextField '" + TextField(child).name + "', text: '" + TextField(child).text + "'", "temple.utils.types.DisplayObjectContainerUtils");
				}
				else if (recursive && child is DisplayObjectContainer)
				{
					TextFieldUtils.formatTextFields(DisplayObjectContainer(child), recursive, debug);
				}
			}
		}

		/**
		 * Searches for TextField in a DisplayObject and set the text to ''.
		 * 
		 * @param displayObject The displayObject that contains the TextFields
		 * @param recursive if set to true all childrens TextFields (and grandchildrens etc) will also be formatted
		 * @param debug if set to true, debug information of the formatted TextFields will be logged
		 */
		public static function emptyTextFields(container:DisplayObjectContainer, recursive:Boolean = true, debug:Boolean = false):void
		{
			if (container == null) return;
			
			var child:DisplayObject;
			
			var leni:int = container.numChildren;
			for (var i:int = 0;i < leni ;i++)
			{
				child = container.getChildAt(i);
				
				if (child is TextField)
				{
					if (debug) Log.debug("emptyTextFields: found TextField '" + TextField(child).name + "', text: '" + TextField(child).text + "'", "temple.utils.types.DisplayObjectContainerUtils");

					TextField(child).text = '';
				}
				else if (recursive && child is DisplayObjectContainer)
				{
					TextFieldUtils.emptyTextFields(DisplayObjectContainer(child), recursive, debug);
				}
			}
		}

		/**
		 * Searches for TextFields in the displaylist and set embedFonts to true.
		 * 
		 * From Seb Lee-Delisle http://www.sebleedelisle.com/2009/08/font-embedding-wtf-in-flash/
		 */
		public static function embedFontsInTextFields(container:DisplayObjectContainer):void
		{
			var child:DisplayObject;
			for (var i:int = 0;i < container.numChildren;i++)
			{
				child = container.getChildAt(i); 
				if (child is DisplayObjectContainer)
				{
					TextFieldUtils.embedFontsInTextFields(child as DisplayObjectContainer);
				} 
				else if (child is TextField)
				{
					(child as TextField).embedFonts = true;
				} 
			}
		}

		/**
		 * Checks if a TextField uses a TextFormat
		 */
		public static function usesTextFormat(textField:TextField):Boolean
		{
			return (textField.getTextFormat() != null);				
		}

		public static function usesStyleSheet(textField:TextField):Boolean
		{
			return (textField.styleSheet != null);				
		}

		/**
		 * Get the font size of a TextField
		 */
		public static function getFontSize(textField:TextField):Number
		{
			if (textField.text == "") return 0;
			var usesStyleSheet:Boolean = TextFieldUtils.usesStyleSheet(textField);
			var usesOneTextFormat:Boolean = TextFieldUtils.usesTextFormat(textField);

			if (!usesOneTextFormat && !usesStyleSheet)
			{
				throwError(new TempleError(TextFieldUtils, "Getting fontSize only works when you use one TextFormat or a StyleSheet"));				
			}
			if (!usesStyleSheet)
			{
				var textFormat:TextFormat = textField.getTextFormat();
				return textFormat.size as Number;
			}
			else
			{
				var avarageSize:Number = 0;
				var styles:Array = textField.styleSheet.styleNames;
				var i:int = styles.length;
				while (i--)
				{
					var styleName:String = styles[i];

					var styleObject:Object = textField.styleSheet.getStyle(styleName);
					avarageSize += styleObject.fontSize;
				}
				avarageSize = avarageSize / styles.length;
				return avarageSize;
			}
		}

		/**
		 * Set the fontsize on a TextField
		 */
		public static function setFontSize(textField:TextField, fontSize:Number):void
		{
			var usesStyleSheet:Boolean = TextFieldUtils.usesStyleSheet(textField);
			var usesOneTextFormat:Boolean = TextFieldUtils.usesTextFormat(textField);
			if (!usesOneTextFormat && !usesStyleSheet)
			{
				throwError(new TempleError(TextField, "setting fontSize only works when you use one TextFormat or a StyleSheet"));				
			}
			if (!usesStyleSheet)
			{
				var textFormat:TextFormat = textField.getTextFormat();
				textFormat.size = fontSize;
				textField.setTextFormat(textFormat);
			}
			else
			{
				// Because stylesheets usualy work with multiple sizes, we use the differance.
				var prevFontSize:Number = getFontSize(textField);
				var sizeDiff:Number = fontSize - prevFontSize;
				
				var styles:Array = textField.styleSheet.styleNames;
				var i:int = styles.length;
				while (i--)
				{
					var styleName:String = styles[i];
					var styleObject:Object = textField.styleSheet.getStyle(styleName);
					styleObject.fontSize = Number(styleObject.fontSize) + sizeDiff;
					textField.styleSheet.setStyle(styleName, styleObject);
				}
				textField.styleSheet = textField.styleSheet;
			}
		}
		
		/**
		 * Sets the font (textFormat and defaultTextFormat) for the given TextField
		 * @param textField The TextField to set the font on
		 * @param fontName The name of the font to apply on the TextField
		 */
		public static function setFont(textField:TextField, fontName:String):void
		{
			if (textField.styleSheet)
			{
				// TODO: TextFormat can't be set on a TextField with a StyleSheet, so we need to fix something for this
			}
			else
			{
				var textFormat:TextFormat = textField.getTextFormat();
				textFormat.font = fontName;
				textField.setTextFormat(textFormat);
				textField.defaultTextFormat = textFormat;
			}
		}
		
		/**
         * Descreases the fontSize of the TextField till the text has the specified amount of lines.
         */
        public static function fitToLines(field:TextField, lines:int = 1, affectTextFieldHeight:Boolean = false):void 
        {
            var size:Number = Number(field.getTextFormat().size);
            
            while (field.numLines > lines && size)
            {
                TextFieldUtils.setFontSize(field, size--);
            }
            
            if (affectTextFieldHeight)
            {
                var lineMetrics:TextLineMetrics = field.getLineMetrics(0);
                field.height = lineMetrics.height + 4 + lineMetrics.leading * (lines - 1);
            }
        }
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(TextFieldUtils);
		}
	}
}
