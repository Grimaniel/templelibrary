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

package temple.ui.form.validation.rules 
{
	import temple.common.interfaces.IHasValue;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;
	import temple.ui.form.components.ISetValue;
	import temple.utils.Comparor;

	/**
	 * Compares the value of the target with an other value.
	 * 
	 * @see temple.utils.Comparor
	 * @see temple.common.interfaces.IHasValue
	 * 
	 * @author Thijs Broerse
	 */
	public class CompareValuesValidationRule extends AbstractCompareValidationRule implements IValidationRule, IHasValue, ISetValue, IDebuggable
	{
		private var _value:*;
		private var _debug:Boolean;

		public function CompareValuesValidationRule(target:IHasValue, value:*, operator:String = Comparor.EQUAL)
		{
			super(target, operator);
			
			_value = value;
			
			addToDebugManager(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get value():*
		{
			return _value;
		}

		/**
		 * @inheritDoc
		 */
		public function set value(value:*):void
		{
			_value = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isValid():Boolean
		{
			if (debug) logDebug("isValid: " + Comparor.compare(target.value, _value, operator) + ": " + target.value + " " + operator + " " + _value);
			
			return Comparor.compare(target.value, _value, operator);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			_value = null;
			
			super.destruct();
		}
	}
}
