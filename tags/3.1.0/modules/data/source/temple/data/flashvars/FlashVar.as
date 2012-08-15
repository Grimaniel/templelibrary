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
			this._name = name;
			this._value = value == "null" ? null : value;
			this._external = external;
			this.toStringProps.push('name', 'defaultValue', 'value', 'type', 'external');
		}

		/**
		 * The name of the FlashVar
		 */
		public function get name():String
		{
			return this._name;
		}
		
		/**
		 * Sets/overrides the FlashVar value
		 */
		public function set value(value:*):void
		{
			this._value = value;
		}

		/**
		 * The value of the FlashVar. If the value is not set by the LoaderInfo, the defaultValue is returned.
		 */
		public function get value():*
		{
			switch (this._type)
			{
				default:
				{	
					this.logWarn("value: can't convert to " + this._type + ", result will be a String");
					// no break
				}
				case null:
				case String:
				{
					return (this._value == '' || this._value == undefined || this._value == null) && this._defaultValue != null ? this._defaultValue : this._value;
				}
			
				case Boolean:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : BooleanUtils.getBoolean(this._value);
				}
			
				case Number:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : Number(this._value);
				}
			
				case int:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : int(this._value);
				}

				case uint:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : uint(this._value);
				}
			
				case Array:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : String(this._value).split(',');
				}
			
				case XML:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : XML(this._value);
				}
			}
			return this._value;
		}
		
		/**
		 * The defaultValue, used when the value is not set by the LoaderInfo.
		 */
		public function get defaultValue():*
		{
			return this._defaultValue;
		}

		/**
		 * @private
		 */
		public function set defaultValue(value:*):void
		{
			this._defaultValue = value;
			
			if (this._type && this._defaultValue)
			{
				if (!(this._defaultValue is this._type)) throwError(new TempleArgumentError(this, 'defaultValue "' + this._defaultValue + '" is not of type ' + this._type));
			}
		}

		/**
		 * The type of the value. Possible values are: String, Boolean, Number, int, Array and XML
		 */
		public function get type():Class
		{
			return this._type;
		}

		/**
		 * @private
		 */
		public function set type(value:Class):void
		{
			this._type = value;
		}

		/**
		 * Indicates if the value is set by the loaderInfo.parameters (true) of the default is used (false)
		 */
		public function get external():Boolean
		{
			return this._external;
		}
	}
}
