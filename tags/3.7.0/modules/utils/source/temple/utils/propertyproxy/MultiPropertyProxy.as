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
	import temple.core.CoreObject;

	/**
	 * Class for combining multiple PropertyProxies to one.
	 * 
	 * @author Thijs Broerse
	 */
	public class MultiPropertyProxy extends CoreObject implements IPropertyProxy
	{
		private var _proxies:Vector.<IPropertyProxy>;
		private var _value:*;
		
		public function MultiPropertyProxy(...args)
		{
			_proxies = new Vector.<IPropertyProxy>();
			
			var leni:int = args.length;
			for (var i:int = 0; i < leni; i++)
			{
				addProxy(args[i]);
			}
		}

		public function addProxy(propertyProxy:IPropertyProxy):void
		{
			_proxies.push(propertyProxy);
		}
		
		/**
		 * @private
		 */
		public function get value():*
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(value:*):void
		{
			_value = value;
		}

		/**
		 * @inheritDoc
		 */
		public function cancel():Boolean
		{
			for each (var proxy:IPropertyProxy in _proxies)
			{
				proxy.cancel();
			}
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getValue(target:Object, property:String):*
		{
			return _value;
		}

		/**
		 * @inheritDoc
		 */
		public function setValue(target:Object, property:String, value:*, onComplete:Function = null):void
		{
			_value = value;
			var leni:int = _proxies.length;
			var proxy:IPropertyProxy;
			// TODO: chain proxies using onComplete
			for (var i:int = 0; i < leni; i++)
			{
				proxy = _proxies[i];
				if (i == leni -1)
				{
					proxy.setValue(target, property, _value);
				}
				else
				{
					proxy.setValue(this, "value", _value);
				}
			}
			if (onComplete != null) onComplete();
		}

		override public function destruct():void
		{
			cancel();
			
			if (_proxies)
			{
				_proxies.length = 0;
				_proxies = null;
			}
			_value = null;
			
			super.destruct();
		}
	}
}
