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
	import temple.core.debug.IDebuggable;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
	import temple.data.collections.HashMap;
	import temple.utils.PropertyApplier;
	import temple.utils.types.ObjectUtils;

	import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * Singleton which manage the style of <code>IStylable</code> objects with CSS.
	 * 
	 * @see temple.ui.style.IStylable 
	 * 
	 * @author Thijs Broerse
	 */
	public class StyleManager extends CoreEventDispatcher implements IDebuggable
	{
		public static const DEFAULT_STYLESHEET:String = "default";
		
		public static const LARGE_FONT_SIZE:uint = 48;
		
		private var _defaultStyle:String = 'body';
		private var _styleSheets:HashMap;
		private var _textFields:Dictionary;
		private var _objects:Dictionary;
		private var _hasStyles:Boolean;
		private var _debug:Boolean;

		/**
		 * @private
		 */
		public function StyleManager()
		{
			this._styleSheets = new HashMap("StyleManager StyleSheets");
			this._styleSheets[StyleManager.DEFAULT_STYLESHEET] = new StyleSheet();
			
			this._textFields = new Dictionary(true);
			this._objects = new Dictionary(true);
		}
		
		/**
		 * Get a StyleSheet by name.
		 */
		public function getStyleSheet(name:String = StyleManager.DEFAULT_STYLESHEET, createIfNull:Boolean = true):StyleSheet
		{
			if (!this._styleSheets.hasOwnProperty(name))
			{
				if (!createIfNull) return null;
				
				this._styleSheets[name] = new StyleSheet();
			}
			return this._styleSheets[name] as StyleSheet;
		}
		
		/**
		 * An array that contains the names (as strings) of all of the styles registered in the StyleManager. 
		 */
		public function getStyleNames(stylesheetName:String = StyleManager.DEFAULT_STYLESHEET):Array
		{
			return this.getStyleSheet(stylesheetName).styleNames;
		}
		
		/**
		 * Parses the CSS in CSSText and loads the style sheet with it. If a style in CSSText is already in styleSheet, the properties in styleSheet are retained, and only the ones in CSSText are added or changed in styleSheet.
		 * @param cssText the CSS text to parse.
		 * @param apply if set to false styles are not immediatly applied to all Objects and TextFields. Call 'applyCSS' to apply CSS.
		 * @param stylesheetName 
		 */
		public function parseCSS(cssText:String, apply:Boolean = true, stylesheetName:String = StyleManager.DEFAULT_STYLESHEET):void
		{
			if (stylesheetName == null || stylesheetName == '') stylesheetName = StyleManager.DEFAULT_STYLESHEET;
			
			this._hasStyles = true;
			
			this.getStyleSheet(stylesheetName).parseCSS(cssText);
			
			if (this._debug) this.logDebug("Stylesheet '" + stylesheetName + "' has styleNames: " + this.getStyleSheet(stylesheetName).styleNames);
			
			if (apply) this.applyStyles();
		}
		
		/**
		 * Apply styles to all TextFields and Objects
		 */
		public function applyStyles():void
		{
			var styleInfo:StyleInfo;
			
			for (var textField:Object in this._textFields)
			{
				styleInfo = this._textFields[textField] as StyleInfo;
				this.updateTextField(textField as TextField, styleInfo.cssClass, styleInfo.stylesheetName, styleInfo.setStyleSheet);
			}
			for (var object:Object in this._objects)
			{
				styleInfo = this._objects[object] as StyleInfo;
				this.updateObject(object, styleInfo.cssClass, styleInfo.stylesheetName);
			}
		}
		

		/**
		 * Add a TextField to the StyleManager. By now the style of the TextField is controlled by the StyleManager.
		 * You can use a css file to adjust the style.
		 * @param textField the TextField to style
		 * @param cssClass The name of the class in the css file that is used to style the TextField. If no cssClass is given the defaultStyle is used
		 * @param stylesheetName The name of the StyleSheet to use
		 * @param setStyleSheet Indicates if the StyleSheet should be set on the TextField (true) or only applied as TextFormat (false).
		 * If the styleSheet is set the TextField is not editable anymore. So you should set this property to false if you add an editable
		 * TextField (like an InputField).
		 */
		public function addTextField(textField:TextField, cssClass:String = null, stylesheetName:String = StyleManager.DEFAULT_STYLESHEET, setStyleSheet:Boolean = true):void
		{
			if (textField == null) throwError(new TempleArgumentError(this, "TextField can not be null"));
			if (stylesheetName == null || stylesheetName == '') stylesheetName = StyleManager.DEFAULT_STYLESHEET;
			
			if (this._debug) this.logDebug("addTextField: '" + textField.name + "' " + (cssClass ? "cssClass: '" + cssClass + "'" : "") + (stylesheetName != StyleManager.DEFAULT_STYLESHEET ? ", stylesheet: " + stylesheetName : ""));
			
			var styleInfo:StyleInfo = (this._textFields[textField] as StyleInfo);
			
			if (!styleInfo)
			{
				this._textFields[textField] = new StyleInfo(stylesheetName, cssClass, setStyleSheet);
			}
			else if (styleInfo.equals(stylesheetName, cssClass, setStyleSheet))
			{
				// no changes, do nothing
				return;
			}
			else
			{
				styleInfo.update(stylesheetName, cssClass);
			}
			this.updateTextField(textField, cssClass, stylesheetName, setStyleSheet);
		}
		
		/**
		 * Add an object to the StyleManager that need to be styled. Every kind of object can (possibly) be styled
		 * @param object The object to style
		 * @param cssClass The name of the class in the css file that is used to style the object. If no cssClass is given the defaultStyle is used
		 * @param stylesheetName The name of the StyleSheet to use
		 */
		public function addObject(object:Object, cssClass:String = null, stylesheetName:String = StyleManager.DEFAULT_STYLESHEET):void
		{
			if (object == null) throwError(new TempleArgumentError(this, "Object can not be null"));
			if (stylesheetName == null || stylesheetName == '') stylesheetName = StyleManager.DEFAULT_STYLESHEET;
			
			if (this._debug) this.logDebug("addObject: '" + object + "' " + (cssClass ? "cssClass: '" + cssClass + "'" : "") + (stylesheetName != StyleManager.DEFAULT_STYLESHEET ? ", stylesheet: " + stylesheetName : ""));
			
			if (!this._objects[object])
			{
				this._objects[object] = new StyleInfo(stylesheetName, cssClass);
			}
			else
			{
				(this._objects[object] as StyleInfo).update(stylesheetName, cssClass);
			}
			
			this.updateObject(object, cssClass, stylesheetName);
		}
		
		/**
		 * The default css class of all TextFields when now cssClass is given with the TextField
		 */
		public function get defaultStyle():String
		{
			return this._defaultStyle;
		}
		
		/**
		 * @private
		 */
		public function set defaultStyle(value:String):void
		{
			this._defaultStyle = value;
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
		
		private function updateTextField(textField:TextField, cssClass:String, stylesheetName:String, setStyleSheet:Boolean):void
		{
			if (this._debug) this.logDebug("updateTextField: '" + textField.name + "' " + (cssClass ? "cssClass: '" + cssClass + "'" : "") + (stylesheetName != StyleManager.DEFAULT_STYLESHEET ? ", stylesheet: " + stylesheetName : ""));
	
			if (cssClass == null || cssClass == "")
			{
				cssClass = this._defaultStyle;
			}
			else if (cssClass.charAt(0) != ".")
			{
				cssClass = "." + cssClass;
			}
			
			var styleSheet:StyleSheet = this.getStyleSheet(stylesheetName);
			
			var style:Object = styleSheet.getStyle(cssClass);
			
			if (ObjectUtils.hasValues(style))
			{
				textField.styleSheet = null;
				var textFormat:TextFormat = styleSheet.transform(style);
				textField.defaultTextFormat = textFormat;
				textField.setTextFormat(textFormat);
			}
			else if (this._hasStyles)
			{
				this.logWarn("updateTextField: class '" + cssClass + "' not found in StyleSheet '" + stylesheetName + "', needed for " + ObjectUtils.convertToString(textField));
			}
			// do not set stylesheet if textField is input, since you can't edit TextFields with a StyleSheet
			if (textField.type != TextFieldType.INPUT && setStyleSheet)
			{
				textField.styleSheet = styleSheet;
			}
			textField.embedFonts = true;
			textField.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function updateObject(object:Object, cssClass:String, stylesheetName:String):void
		{
			if (this._debug) this.logDebug("updateObject: '" + object + "' " + (cssClass ? "cssClass: '" + cssClass + "'" : "") + (stylesheetName != StyleManager.DEFAULT_STYLESHEET ? ", stylesheet: " + stylesheetName : ""));
			
			if (cssClass == null || cssClass == "")
			{
				cssClass = this._defaultStyle;
			}
			else if (cssClass.charAt(0) != ".")
			{
				cssClass = "." + cssClass;
			}
			var style:Object = this.getStyleSheet(stylesheetName).getStyle(cssClass);
			
			if (ObjectUtils.hasValues(style))
			{
				PropertyApplier.apply(object, style, this._debug);
			}
			else if (this._hasStyles)
			{
				this.logWarn("updateTextField: class '" + cssClass + "' not found in StyleSheet '" + stylesheetName + "', needed for " + ObjectUtils.convertToString(object));
			}
		}
	}
}