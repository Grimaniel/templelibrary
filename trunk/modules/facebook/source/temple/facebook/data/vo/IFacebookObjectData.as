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

package temple.facebook.data.vo
{
	import temple.facebook.service.IFacebookService;
	import temple.data.index.IIndexable;
	import temple.facebook.service.IFacebookCall;

	/**
	 * Base interface for all Facebook objects.
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookObjectData extends IIndexable
	{
		/**
		 * The name of the object
		 */
		function get name():String;

		/**
		 * Type of the object, like 'photo', 'album' or 'user'
		 */
		function get type():String;

		/**
		 * A list of all possible connections of this object.
		 */
		function get connections():Vector.<String>;

		/**
		 * An object which contains all the fields of this object as Booleans.
		 * This object can be used to define which properties you want to retrieve from Facebook.
		 */
		function get fields():IFacebookFields;

		/**
		 * If available this returns a reference to the IFacebookProfileData of this object.
		 * Only available for <code>IFacebookUserData</code>, <code>IFacebookPageData</code> and <code>IFacebookEventData</code>
		 */
		function get profile():IFacebookProfileData;

		/**
		 * Get connected data from Facebook.
		 * @param connection the Facebook method to call
		 * @param callback a function that must be called when the data is retreived from Facebook and parsed.
		 * Note: this function must accept one, and only one, argument of type IFacebookResult.
		 * 	@see temple.facebook.data.enum.FacebookConnection
		 * @param objectClass an optional class which is used for parsing the data to. This class must implement
		 * IObjectParsable. This class can also be provided using the registerVO method.
		 * @param params an optional object for extra parameters
		 * @param fields an object which defines which fields must be returned. This fields object is also used for
		 * automatically permissions retrieving.
		 * @param forceReload if set to true, the service will always reload the requested data, even when cache is
		 * enabled.
		 * 
		 * @see temple.facebook.data.enum.FacebookConnection
		 */
		function get(connection:String, callback:Function = null, objectClass:Class = null, params:Object = null, fields:IFacebookFields = null, forceReload:Boolean = false):IFacebookCall;

		/**
		 * Returns the <code>IFacebookService</code>.
		 */
		function getService():IFacebookService;
	}
}