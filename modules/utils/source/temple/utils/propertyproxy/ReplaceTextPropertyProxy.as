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

package temple.utils.propertyproxy
{
	import flash.utils.Dictionary;
	import temple.core.CoreObject;
	import temple.utils.propertyproxy.IPropertyProxy;

	/**
	 * Replaces '{value}' is a string with the specified value and sets the replaced String.
	 * 
	 * @author Thijs Broerse
	 */
	public class ReplaceTextPropertyProxy extends CoreObject implements IPropertyProxy
	{
		private static const _REPLACEMENT:String = "{value}";
		
		private var _text:String;
		private var _texts:Dictionary;
		
		public function ReplaceTextPropertyProxy(text:String = null)
		{
			super();
			
			if (text) this.text = text;
			this._texts = new Dictionary(true);
		}
		
		/**
		 * The text which is used when <code>setValue</code> is called.
		 * Use {value} to define which part must be replaced with the passed value.  
		 */
		public function get text():String
		{
			return this._text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			this._text = value;
			
			if (value.indexOf(_REPLACEMENT) == -1)
			{
				this.logWarn("No replacement tag \"" + _REPLACEMENT + "\" found in text");
			}
		}

		/**
		 * Set a text for a specific value.
		 */
		public function setTextForValue(value:*, text:String):void
		{
			this._texts[value] = text;
			log('this._texts', (this._texts));
		}

		/**
		 * @private
		 * 
		 * This object can not be canceled.
		 */
		public function cancel():Boolean
		{
			return true;
		}

		/**
		 * @inheritDoc
		 */
		public function setValue(target:Object, property:String, value:*):void
		{
			target[property] = String(value in this._texts ? this._texts[value] : this._text).replace(_REPLACEMENT, value);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._text = null;
			this._texts = null;
			
			super.destruct();
		}
	}
}
