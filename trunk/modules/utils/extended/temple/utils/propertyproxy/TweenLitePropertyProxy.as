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
	import temple.utils.types.ObjectUtils;

	import com.greensock.TweenLite;


	/**
	 * Manipulates the property using TweenLite
	 * 
	 * @see com.greensock.TweenLite
	 * 
	 * @author Thijs Broerse
	 */
	public class TweenLitePropertyProxy extends CoreObject implements IPropertyProxy 
	{
		private var _duration:Number;
		private var _vars:Object;
		private var _tween:TweenLite;

		/**
		 * Creates a new TweenLitePropertyProxy
		 * @param duration duration of the Tween
		 * @param vars an object containing the end values of the properties you're tweening.
		 */
		public function TweenLitePropertyProxy(duration:Number = .5, vars:Object = null)
		{
			this._vars = vars;
			this._duration = duration;
		}
		
		/**
		 * Duration of the Tween
		 */
		public function get duration():Number
		{
			return this._duration;
		}
		
		/**
		 * @private
		 */
		public function set duration(duration:Number):void
		{
			this._duration = duration;
		}
		
		/**
		 * An object containing the end values of the properties you're tweening. For example, to tween to x=100, y=100, you could pass {x:100, y:100}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 */
		public function get vars():Object
		{
			return this._vars;
		}
		
		/**
		 * @private
		 */
		public function set vars(vars:Object):void
		{
			this._vars = vars;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValue(target:Object, property:String, value:*):void
		{
			if (this._vars == null) this._vars = {};
			
			// create a copy of the vars
			var vars:Object = ObjectUtils.clone(this._vars);
			
			vars[property] = value;
			
			this._tween = TweenLite.to(target, this._duration, vars);
		}
		
		/**
		 * @inheritDoc
		 */
		public function cancel():Boolean
		{
			if (this._tween) this._tween.kill();
			this._tween = null;
			return true;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this.cancel();
			this._vars = null;
			
			super.destruct();
		}
	}
}
