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

	/**
	 * Limits (min/max) a value before it's set on a property of an object.
	 * 
	 * @author Thijs Broerse
	 */
	public class LimitPropertyProxy extends SimplePropertyProxy 
	{
		private var _min:Number;
		private var _max:Number;

		public function LimitPropertyProxy(min:Number = NaN, max:Number = NaN)
		{
			_min = min;
			_max = max;
		}
		
		/**
		 * The minimal value of the property
		 */
		public function get min():Number
		{
			return _min;
		}
		
		/**
		 * @private
		 */
		public function set min(value:Number):void
		{
			_min = value;
		}
		
		/**
		 * The maximal value of the property
		 */
		public function get max():Number
		{
			return _max;
		}
		
		/**
		 * @private
		 */
		public function set max(value:Number):void
		{
			_max = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function setValue(target:Object, property:String, value:*, onComplete:Function = null):void
		{
			if (!isNaN(value))
			{
				if (!isNaN(_min)) value = Math.max(value, _min);
				if (!isNaN(_max)) value = Math.min(value, _max);
			}
			super.setValue(target, property, value, onComplete);
		}
		
	}
}
