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
