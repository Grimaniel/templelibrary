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

package temple.ui.form.services 
{
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.ui.form.result.IFormResult;

	import flash.events.Event;

	/**
	 * Event dispatched by a FormService when the FormService is ready submitting the data. The FormServiceEvent indicates if the submit was successful or not.
	 * 
	 * @author Thijs Broerse
	 */
	public class FormServiceEvent extends Event 
	{
		/**
		 * Dispatched when a submit was successful. There is no need to check the result.
		 */
		public static const SUCCESS:String = "FormServiceEvent.success";

		/**
		 * Dispatched after submit is complete. Check the result to see if the submit was successful.
		 */
		public static const RESULT:String = "FormServiceEvent.result";
		
		/**
		 * Dispatched when and error occurs during submission.
		 */
		public static const ERROR:String = "FormServiceEvent.error";
		
		private var _result:IFormResult;

		public function FormServiceEvent(type:String, result:IFormResult = null)
		{
			super(type);
			
			this._result = result;
			
			if (type == FormServiceEvent.RESULT && result == null)
			{
				throwError(new TempleArgumentError(this, "result can not be null if type equals '" + FormServiceEvent.RESULT + "'"));
			}
		}
		
		/**
		 * The result of the event.
		 */
		public function get result():IFormResult
		{
			return this._result;
		}

		override public function clone():Event
		{
			return new FormServiceEvent(this.type, this._result);
		}

	}
}
