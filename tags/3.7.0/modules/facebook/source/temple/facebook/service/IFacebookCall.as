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

package temple.facebook.service
{
	import temple.common.interfaces.IPendingCall;
	import temple.core.destruction.IDestructible;
	import temple.facebook.data.enum.FacebookRequestMethod;

	/**
	 * Dispatched when the call is completed.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * Dispatched when the call is cancelled.
	 * 
	 * @eventType flash.events.Event.CANCEL
	 */
	[Event(name = "cancel", type = "flash.events.Event")]

	/**
	 * Object containing information about a call on the <code>FacebookAPI</code> and <code>FacebookService</code>.
	 * 
	 * <p>This object dispatches a <code>COMPLETE</code> event when the call is completed. It also contains the data
	 * which is returned from Facebook.</p>
	 * 
	 * @author Arjan van Wijk
	 */
	public interface IFacebookCall extends IPendingCall, IDestructible
	{
		/**
		 * The Facebook method of the call.
		 * @see temple.facebook.data.enum.FacebookConnection
		 */
		function get method():String;

		/**
		 * The ID of the Facebook object related to the call.
		 */
		function get id():String;

		/**
		 * Additional parameters provided with the call.
		 */
		function get params():Object;

		/**
		 * The FacebookRequestMethod.
		 * @see temple.facebook.data.enum.FacebookRequestMethod
		 */
		function get requestMethod():FacebookRequestMethod;

		/**
		 * Forces the execution of this call, even when the <code>FacebookService</code> is not initialized.
		 */
		function force():IFacebookCall;
	}
}
