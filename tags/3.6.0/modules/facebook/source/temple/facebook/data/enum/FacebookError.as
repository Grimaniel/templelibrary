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

package temple.facebook.data.enum
{
	/**
	 * Enumerator class containing the possible values of a Facebook error.
	 * 
	 * @author Thijs Broerse
	 */
	public final class FacebookError
	{
		/**
		 * Handles all errors that don't stem from invalid requests -- e.g., perhaps errors resulting from databases that are down or logic errors in code.
		 */
		public static const UNKNOWN_ERROR:String = "unknown_error";

		/**
		 * The default OAuth exception. It means the request is missing a required parameter, includes an unsupported parameter or parameter value, repeats a parameter, includes multiple credentials, utilizes more than one mechanism for authenticating the client, or is otherwise malformed.
		 */
		public static const INVALID_REQUEST:String = "invalid_request";

		/**
		 * The client identifier provided is invalid, the client failed to authenticate, the client did not include its credentials, provided multiple client credentials, or used unsupported credentials type.
		 */
		public static const INVALID_CLIENT:String = "invalid_client";

		/**
		 * The authenticated client is not authorized to use the access grant type provided.
		 */
		public static const UNAUTHORIZED_CLIENT:String = "unauthorized_client";

		/**
		 * The redirection URI provided does not match a pre-registered value.
		 */
		public static const REDIRECT_URI_MISMATCH:String = "redirect_uri_mismatch";

		/**
		 * The end-user or authorization server denied the request.
		 */
		public static const ACCESS_DENIED:String = "access_denied";

		/**
		 * The requested response type is not supported by the authorization server.
		 */
		public static const UNSUPPORTED_RESPONSE_TYPE:String = "unsupported_response_type";

		/**
		 * The requested scope is invalid, unknown, malformed, or exceeds the previously granted scope.
		 */
		public static const INVALID_SCOPE:String = "invalid_scope";

		/**
		 * The provided access grant is invalid, expired, or revoked (e.g. invalid assertion, expired authorization token, bad end-user password credentials, or mismatching authorization code and redirection URI).
		 */
		public static const INVALID_GRANT:String = "invalid_grant";

		/**
		 * The access grant included - its type or another attribute - is not supported by the authorization server.
		 */
		public static const UNSUPPORTED_GRANT_TYPE:String = "unsupported_grant_type";

		/**
		 * The access token provided is invalid. Resource servers SHOULD use this error code when receiving an expired token which cannot be refreshed to indicate to the client that a new authorization is necessary. The resource server MUST respond with the HTTP 401 (Unauthorized) status code.
		 */
		public static const INVALID_TOKEN:String = "invalid_token";

		/**
		 * The access token provided has expired.
		 */
		public static const EXPIRED_TOKEN:String = "expired_token";

		/**
		 * The request requires higher privileges than provided by the access token. The resource server SHOULD respond with the HTTP 403 (Forbidden) status code and MAY include the "scope" attribute with the scope necessary to access the protected resource.
		 */
		public static const INSUFFICIENT_SCOPE:String = "insufficient_scope";

		/**
		 * The code provided is invalid.
		 */
		public static const INVALID_CODE:String = "invalid_code";

		/**
		 * The request is for data which does not exist.
		 */
		public static const NOT_FOUND:String = "not_found";

		/**
		 * The requested authentication type is not supported by the authorization server.
		 */
		public static const UNSUPPORTED_AUTH_TYPE:String = "unsupported_auth_type";
	}
}
