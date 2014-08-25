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

package temple.ui.form 
{
	import temple.ui.form.result.IFormResult;

	import flash.events.Event;

	/**
	 * Event dispatched by the Form. The FormEvent is used to inform about the result of the validation of the form and to inform about the result of the submit of the form.
	 * 
	 * @includeExample services/XMLFormServiceExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class FormEvent extends Event 
	{
		/**
		 * Dispatched when the form is validated and is valid.
		 */
		public static const VALIDATE_SUCCESS:String = "FormEvent.validateSuccess";
		
		/**
		 * Dispatched when the form is validated and the form is invalid.
		 */
		public static const VALIDATE_ERROR:String = "FormEvent.validateError";
		
		/**
		 * Dispatched when the form is submitted successful.
		 */
		public static const SUBMIT_SUCCESS:String = "FormEvent.submitSuccess";
		
		/**
		 * Dispatched when the form is submitted unsuccessful.
		 */
		public static const SUBMIT_ERROR:String = "FormEvent.submitError";

		/**
		 * Dispatched when the form is reset.
		 */
		public static const RESET:String = "FormEvent.reset";

		private var _result:IFormResult;

		public function FormEvent(type:String, result:IFormResult = null, bubbles:Boolean = false) 
		{
			super(type, bubbles);
			
			_result = result;
		}
		
		/**
		 * A data object which contains information about the result
		 */
		public function get result():IFormResult
		{
			return _result;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new FormEvent(type, result, bubbles);
		}
	}
}
