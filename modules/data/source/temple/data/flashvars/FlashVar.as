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

package temple.data.flashvars 
{
	import temple.common.enum.Enumerator;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import temple.core.CoreObject;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.utils.types.BooleanUtils;

	/**
	 * A FlashVar is an internal class used by the FlashVars to store information about 
	 * the loaderinfo.parameters.
	 * 
	 * @author Arjan van Wijk
	 */
	internal final class FlashVar extends CoreObject
	{ 
		internal var _value:*;
		private var _name:String;
		private var _defaultValue:*;
		private var _type:Class;
		private var _external:Boolean;

		public function FlashVar(name:String, value:*, external:Boolean = false)
		{
			_name = name;
			_value = value == "null" ? null : value;
			_external = external;
			toStringProps.push('name', 'defaultValue', 'value', 'type', 'external');
		}

		/**
		 * The name of the FlashVar
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * Sets/overrides the FlashVar value
		 */
		public function set value(value:*):void
		{
			_value = value;
		}

		/**
		 * The value of the FlashVar. If the value is not set by the LoaderInfo, the defaultValue is returned.
		 */
		public function get value():*
		{
			switch (_type)
			{
				default:
				{
					if (getQualifiedSuperclassName(_type) == getQualifiedClassName(Enumerator))
					{
						return _type(Enumerator.get(_type, _value || _defaultValue));
					}
					else
					{
						return _type((_value == '' || _value == undefined || _value == null) && _defaultValue != null ? _defaultValue : _value);
					}
					break;
				}
				case null:
				case String:
				{
					return (_value == '' || _value == undefined || _value == null) && _defaultValue != null ? _defaultValue : _value;
				}
			
				case Boolean:
				{
					return (_value == '' || _value == undefined) && _defaultValue ? _defaultValue : BooleanUtils.getBoolean(_value);
				}
			
				case Number:
				{
					return (_value == '' || _value == undefined) && _defaultValue ? _defaultValue : Number(_value);
				}
			
				case int:
				{
					return (_value == '' || _value == undefined) && _defaultValue ? _defaultValue : int(_value);
				}

				case uint:
				{
					return (_value == '' || _value == undefined) && _defaultValue ? _defaultValue : uint(_value);
				}
			
				case Array:
				{
					return (_value == '' || _value == undefined) && _defaultValue ? _defaultValue : String(_value).split(',');
				}
			
				case XML:
				{
					return (_value == '' || _value == undefined) && _defaultValue ? _defaultValue : XML(_value);
				}
			}
			return _value;
		}
		
		/**
		 * The defaultValue, used when the value is not set by the LoaderInfo.
		 */
		public function get defaultValue():*
		{
			return _defaultValue;
		}

		/**
		 * @private
		 */
		public function set defaultValue(value:*):void
		{
			_defaultValue = value;
			
			if (_type && _defaultValue)
			{
				if (!(_defaultValue is _type)) throwError(new TempleArgumentError(this, 'defaultValue "' + _defaultValue + '" is not of type ' + _type));
			}
		}

		/**
		 * The type of the value. Possible values are: String, Boolean, Number, int, Array and XML
		 */
		public function get type():Class
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:Class):void
		{
			_type = value;
			
			var val:* = value;
			
			if (_type && !(val is _type) && val is String)
			{
				logWarn("value: can't convert to " + _type + ", result will be a String");
			}
		}

		/**
		 * Indicates if the value is set by the loaderInfo.parameters (true) of the default is used (false)
		 */
		public function get external():Boolean
		{
			return _external;
		}
	}
}
