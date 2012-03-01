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
	import temple.core.events.ICoreEventDispatcher;
	import temple.ui.form.result.IFormResult;

	/**
	 * @eventType temple.ui.form.services.FormServiceEvent.SUCCESS
	 */
	[Event(name = "FormServiceEvent.success", type = "temple.ui.form.services.FormServiceEvent")]

	/**
	 * @eventType temple.ui.form.services.FormServiceEvent.RESULT
	 */
	[Event(name = "FormServiceEvent.result", type = "temple.ui.form.services.FormServiceEvent")]

	/**
	 * @eventType temple.ui.form.services.FormServiceEvent.ERROR
	 */
	[Event(name = "FormServiceEvent.error", type = "temple.ui.form.services.FormServiceEvent")]

	/**
	 * A IFormService handles the data of a Form. When a Form is submitted it send his data to a IFormService, using the
	 * '<code>submit</code>' method. After the IFormService handled the data is returns an IFormResult (only if the data
	 * is handled synchronously, otherwise null is returned) and dispatched an FormServiceEvent. 
	 * 
	 * @see temple.ui.form.Form
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFormService extends ICoreEventDispatcher
	{
		/**
		 * Handles the form data. If the data is handled synchronously an IFormResult is returned. If the data is handled asynchronously, null is returned.
		 * After submit is complete a FormServiceEvent is dispatched.
		 */
		function submit(data:Object):IFormResult;
	}
}
