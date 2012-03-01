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
