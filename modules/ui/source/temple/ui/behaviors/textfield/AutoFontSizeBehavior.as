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

package temple.ui.behaviors.textfield 
{
	import temple.core.debug.IDebuggable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * Autosize the font to fit in a TextField. 
	 * 
	 * <p>The AutoFontSizeBehavior is automatically triggered if an Event.CHANGE event dispatched by the TextField.
	 * You can also update the AutoFontSizeBehavior manually by calling update().</p>
	 * 
	 * <p>If the TextField is destructed the AutoFontSizeBehavior will automatic be destructed.</p>
	 * 
	 * Original class by Jankees van Woezik
	 * <a href="http://blog.base42.nl/2009/08/13/automatic-font-size-adjuster/" target="_blank">http://blog.base42.nl/2009/08/13/automatic-font-size-adjuster/</a>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new AutoFontSizeBehavior(textField);
	 * </listing>
	 * 
	 * @author Jankees van Woezik, Thijs Broerse
	 */
	public class AutoFontSizeBehavior extends AbstractDisplayObjectBehavior implements IDebuggable
	{
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the AutoFontSizeBehavior of a TextField if the TextField has AutoFontSizeBehavior. Otherwise null is returned.
		 */
		public static function getInstance(target:TextField):AutoFontSizeBehavior
		{
			return AutoFontSizeBehavior._dictionary[target] as AutoFontSizeBehavior;
		}
		
		/**
		 * Updates the size of the font of the TextField.
		 * The AutoFontSizeBehavior will set the maximal fontsize that will fit in the TextField.
		 * Returns true if the update could resize the font so it will fit, otherwise it will return false. 
		 */
		public static function update(textField:TextField, maxFontSize:Number = NaN, minFontSize:uint = 9, maxWidth:Number = NaN, maxHeight:Number = NaN):Boolean
		{
			textField.scrollV = 0;
			textField.scrollH = 0;
			
			if (!isNaN(maxFontSize)) setFontSize(textField, maxFontSize);
			
			maxWidth ||= textField.width;
			maxHeight ||= textField.height;
			var size:Number = Number(textField.getTextFormat().size);
			
			var notfit:Boolean;
 
			if (textField.multiline)
			{
				while (notfit = maxHeight < textField.textHeight + (4 * textField.numLines)) 
				{ 
					if (size <= minFontSize) break;
					setFontSize(textField, size -= 0.5);
				}
			}
			else
			{
				while (notfit = maxWidth < textField.textWidth) 
				{ 
					if (size <= minFontSize) break;
					setFontSize(textField, size -= 0.5);
				}
			}
			
			return !notfit;
		}
		
		private static function setFontSize(textField:TextField, size:Number):void 
		{
			var currentTextFormat:TextFormat = textField.getTextFormat();
			currentTextFormat.size = size;
 
			textField.setTextFormat(currentTextFormat);
			textField.defaultTextFormat = currentTextFormat;
		}
		
		private var _maxFontSize:Number;
		private var _minFontSize:uint;
		private var _previousText:String;
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _debug:Boolean;
		
		/**
		 * Adds AutoFontSizeBehavior to a TextField
		 * @param textField the TextField that needs te be autosized
		 * @param maxFontSize the maximum size of the font in the TextField. If NaN the current size of the font is used.
		 * @param minFontSize the minimim size of the font in the TextField.
		 * @param willUpdateOnInput indicates if the text in the TextField could be updated and the AutoFontSizeBehavior would update the fontsize.
		 */
		public function AutoFontSizeBehavior(textField:TextField, maxFontSize:Number = NaN, minFontSize:uint = 9, willUpdateOnInput:Boolean = true)
		{
			super(textField);
			
			if (AutoFontSizeBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has AutoFontSizeBehavior"));
			
			AutoFontSizeBehavior._dictionary[target] = this;
			
			_minFontSize = minFontSize;
			
			if (isNaN(maxFontSize)) maxFontSize = Number(textField.getTextFormat().size);
			
			_maxFontSize = maxFontSize;
			_maxWidth = textField.width;
			_maxHeight = textField.height;
			
			update();
			
			if (willUpdateOnInput)
			{
				_previousText = "";
				textField.addEventListener(Event.CHANGE, handleTextFieldChange);
				textField.addEventListener(KeyboardEvent.KEY_UP, handleTextFieldChange);
				textField.addEventListener(TextEvent.TEXT_INPUT, handleTextFieldChange);
				textField.addEventListener(Event.SCROLL, handleTextFieldScroll);
			}
		}

		/**
		 * Updates the size of the font of the TextField.
		 * The AutoFontSizeBehavior will set the maximal fontsize that will fit in the TextField 
		 */
		public function update():void
		{
			if (debug) logDebug("update: ");
			
			if (!AutoFontSizeBehavior.update(textField, _maxFontSize, _minFontSize, _maxWidth, _maxHeight) && _previousText != null )
 			{
				textField.text = _previousText;
			}
			else 
			{
				_previousText = textField.text;
			}
		}

		/**
		 * Returns a reference of the TextField of the AutoFontSizeBehavior
		 */
		public function get textField():TextField
		{
			return target as TextField;
		}
		
		/**
		 * The maximum size of the font of the TextField
		 */
		public function get maxFontSize():Number
		{
			return _maxFontSize;
		}
		
		/**
		 * @private
		 */
		public function set maxFontSize(value:Number):void
		{
			_maxFontSize = value;
		}
		
		/**
		 * The minimal size of the font of the TextField
		 */
		public function get minFontSize():uint
		{
			return _minFontSize;
		}
		
		/**
		 * @private
		 */
		public function set minFontSize(value:uint):void
		{
			_minFontSize = value;
		}
		
		/**
		 * 
		 */
		public function get maxWidth():Number
		{
			return _maxWidth;
		}

		/**
		 * @private
		 */
		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
			update();
		}
		
		/**
		 * 
		 */
		public function get maxHeight():Number
		{
			return _maxHeight;
		}

		/**
		 * @private
		 */
		public function set maxHeight(value:Number):void
		{
			_maxHeight = value;
			update();
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
		
		private function handleTextFieldChange(event:Event):void
		{
			update();
		}
		
		private function handleTextFieldScroll(event:Event):void
		{
			textField.scrollV = 0;
			textField.scrollH = 0;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (target) delete AutoFontSizeBehavior._dictionary[target];
			
			_previousText = null;
			
			if (textField)
			{
				textField.removeEventListener(Event.CHANGE, handleTextFieldChange);
				textField.removeEventListener(KeyboardEvent.KEY_UP, handleTextFieldChange);
				textField.removeEventListener(TextEvent.TEXT_INPUT, handleTextFieldChange);
				textField.removeEventListener(Event.SCROLL, handleTextFieldScroll);
			}
			super.destruct();
		}
	}
}