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
			_texts = new Dictionary(true);
		}
		
		/**
		 * The text which is used when <code>setValue</code> is called.
		 * Use {value} to define which part must be replaced with the passed value.  
		 */
		public function get text():String
		{
			return _text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			_text = value;
			
			if (value.indexOf(_REPLACEMENT) == -1)
			{
				logWarn("No replacement tag \"" + _REPLACEMENT + "\" found in text");
			}
		}

		/**
		 * Set a text for a specific value.
		 */
		public function setTextForValue(value:*, text:String):void
		{
			_texts[value] = text;
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
		public function setValue(target:Object, property:String, value:*, onComplete:Function = null):void
		{
			target[property] = String(value in _texts ? _texts[value] : _text).replace(_REPLACEMENT, value);
			if (onComplete != null) onComplete();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_text = null;
			_texts = null;
			
			super.destruct();
		}
	}
}
