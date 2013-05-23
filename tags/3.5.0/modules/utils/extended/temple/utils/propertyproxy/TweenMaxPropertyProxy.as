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
	import temple.utils.types.ObjectUtils;

	import com.greensock.TweenMax;


	/**
	 * Manipulates the property using TweenMax
	 * 
	 * @see com.greensock.TweenMax
	 * 
	 * @author Thijs Broerse
	 */
	public class TweenMaxPropertyProxy extends CoreObject implements IPropertyProxy 
	{
		private var _duration:Number;
		private var _vars:Object;
		private var _tween:TweenMax;

		/**
		 * Creates a new TweenLitePropertyProxy
		 * @param duration duration of the Tween
		 * @param vars an object containing the end values of the properties you're tweening.
		 */
		public function TweenMaxPropertyProxy(duration:Number = .5, vars:Object = null)
		{
			_vars = vars;
			_duration = duration;
		}
		
		/**
		 * Duration of the Tween
		 */
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * @private
		 */
		public function set duration(duration:Number):void
		{
			_duration = duration;
		}
		
		/**
		 * An object containing the end values of the properties you're tweening. For example, to tween to x=100, y=100, you could pass {x:100, y:100}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 */
		public function get vars():Object
		{
			return _vars;
		}
		
		/**
		 * @private
		 */
		public function set vars(vars:Object):void
		{
			_vars = vars;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValue(target:Object, property:String, value:*, onComplete:Function = null):void
		{
			if (_vars == null) _vars = {};
			
			// create a copy of the vars
			var vars:Object = ObjectUtils.clone(_vars);
			
			vars[property] = value;
			if (onComplete != null) vars.onComplete = onComplete;
			_tween = TweenMax.to(target, _duration, vars);
		}
		
		/**
		 * @inheritDoc
		 */
		public function cancel():Boolean
		{
			if (_tween) _tween.kill();
			_tween = null;
			return true;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			cancel();
			_vars = null;
			
			super.destruct();
		}
	}
}
