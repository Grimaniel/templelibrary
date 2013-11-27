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

	/**
	 * Fields object for events.
	 * 
	 * <p>Set every propery you want to receive to true.</p>
	 * 
	 * @see temple.facebook.api.IFacebookAPI#events
	 * @see temple.facebook.api.IFacebookEventAPI#getEvents()
	 * @see temple.facebook.data.vo.IFacebookEventData
	 * @see http://developers.facebook.com/docs/reference/api/event/
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookEventFields extends AbstractFacebookFields
	{
		/**
		 * Returns a list of all fields of a <code>IFacebookEventData</code> object
		 */
		public static function all():Vector.<String>
		{
			return AbstractFacebookFields.all(FacebookEventFields);
		}
		
		/**
		 * The ID of the event
		 */
		[Alias(fql="eid")]
		public var id:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#owner
		 */
		[Alias(fql="creator")]
		public var owner:Boolean;
		
		/**
		 * The name of the event
		 */
		public var name:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#description
		 */
		public var description:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#start
		 */
		[Alias(graph="start_time", fql="start_time")]
		public var start:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#end
		 */
		[Alias(graph="end_time", fql="end_time")]
		public var end:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#location
		 */
		public var location:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#venue
		 */
		public var venue:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#privacy
		 */
		public var privacy:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#updated
		 */
		[Alias(graph="updated_time", fql="update_time")]
		public var updated:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#tagline
		 */
		[Alias(graph="not-available", fql="tagline")]
		public var tagline:Boolean;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#feed
		 */
		[Alias(fql="not-available")]
		public var feed:*;

		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#noreply
		 */
		[Alias("not-available")]
		public var noreply:*;

		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#invited
		 */
		[Alias(fql="not-available")]
		public var invited:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#attending
		 */
		[Alias(fql="not-available")]
		public var attending:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#maybe
		 */
		[Alias(fql="not-available")]
		public var maybe:*;
		
		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#declined
		 */
		[Alias(fql="not-available")]
		public var declined:*;

		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#picture
		 */
		[Alias(fql="not-available")]
		public var picture:Boolean;

		/**
		 * @copy temple.facebook.data.vo.IFacebookEventData#videos
		 */
		public var videos:Boolean;

		/**
		 * @param fields an optional list of fields with must be set to <code>true</code> automatically
		 */
		public function FacebookEventFields(fields:Vector.<String> = null, limit:int = 0)
		{
			super(fields, limit);
		}
	}
}
