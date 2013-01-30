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
	import temple.core.CoreObject;
	import temple.facebook.data.facebook;

	/**
	 * @author Thijs Broerse
	 */
	internal class FacebookWorkData extends CoreObject implements IFacebookWorkData
	{
		public static const FIELDS:FacebookWorkFields = new FacebookWorkFields();
		
		facebook var employer:IFacebookProfileData;
		facebook var location:IFacebookObjectData;
		facebook var position:IFacebookObjectData;
		facebook var start_date:Date;
		facebook var end_date:Date;
		facebook var description:String;
		facebook var projects:Array;
		facebook var from:IFacebookProfileData;
		
		// Note: the Facebook property is 'with', but since this is a reserved word in AS3, we use 'among'
		facebook var among:Vector.<IFacebookUserData>;

		public function FacebookWorkData()
		{
			toStringProps.push("employer");
		}
		
		public function get employer():IFacebookProfileData
		{
			return facebook::employer;
		}

		public function get location():IFacebookObjectData
		{
			return facebook::location;
		}

		public function get position():IFacebookObjectData
		{
			return facebook::position;
		}

		public function get start():Date
		{
			return facebook::start_date;
		}

		public function get end():Date
		{
			return facebook::end_date;
		}

		public function get description():String
		{
			return facebook::description;
		}

		public function get among():Vector.<IFacebookUserData>
		{
			return facebook::among;
		}

		public function get projects():Array
		{
			return facebook::projects;
		}
	}
}
