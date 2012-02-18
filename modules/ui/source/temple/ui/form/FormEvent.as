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
			
			this._result = result;
		}
		
		/**
		 * A data object which contains information about the result
		 */
		public function get result():IFormResult
		{
			return this._result;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new FormEvent(this.type, this.result, bubbles);
		}
	}
}
