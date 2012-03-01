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
	import temple.core.CoreObject;

	/**
	 * Class for combining multiple PropertyProxies to one.
	 * 
	 * @author Thijs Broerse
	 */
	public class MultiPropertyProxy extends CoreObject implements IPropertyProxy
	{
		private var _proxies:Array;
		private var _value:*;
		
		public function MultiPropertyProxy(...args)
		{
			this._proxies = new Array();
			
			var leni:int = args.length;
			for (var i:int = 0; i < leni; i++)
			{
				this.addProxy(args[i]);
			}
		}

		public function addProxy(propertyProxy:IPropertyProxy):void
		{
			this._proxies.push(propertyProxy);
		}
		
		/**
		 * @private
		 */
		public function get value():*
		{
			return this._value;
		}

		/**
		 * @private
		 */
		public function set value(value:*):void
		{
			this._value = value;
		}

		public function cancel():Boolean
		{
			for each (var proxy : IPropertyProxy in this._proxies)
			{
				proxy.cancel();
			}
			return true;
		}

		public function setValue(target:Object, property:String, value:*):void
		{
			this._value = value;
			var leni:int = this._proxies.length;
			var proxy:IPropertyProxy;
			for (var i:int = 0; i < leni; i++)
			{
				proxy = this._proxies[i];
				if (i == leni -1)
				{
					proxy.setValue(target, property, this._value);
				}
				else
				{
					proxy.setValue(this, "value", this._value);
				}
			}
		}

		override public function destruct():void
		{
			this.cancel();
			
			if (this._proxies)
			{
				this._proxies.length = 0;
				this._proxies = null;
			}
			this._value = null;
			
			super.destruct();
		}
	}
}
