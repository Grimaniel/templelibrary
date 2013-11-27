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

package temple.facebook.api
{
	import temple.facebook.data.vo.FacebookPostFields;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.vo.FacebookPostData;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	/**
	 * @author Thijs Broerse
	 */
	internal class FacebookPostAPI extends AbstractFacebookObjectAPI implements IFacebookPostAPI
	{
		public function FacebookPostAPI(service:IFacebookService)
		{
			super(service, FacebookConnection.FEED, FacebookPostData);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPost(id:String, callback:Function = null, fields:FacebookPostFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return getItem(id, callback, fields, params, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function getPosts(callback:Function = null, id:String = 'me', since:Date = null, until:Date = null, fields:FacebookPostFields = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			if (since) (params ||= {}).since = int(since.time * .001);
			if (until) (params ||= {}).until = int(until.time * .001);
			
			return getItems(callback, id, NaN, NaN, fields, params, forceReload);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAllPosts(callback:Function = null, id:String = 'me', fields:FacebookPostFields = null, forceReload:Boolean = false):IFacebookCall
		{
			return getAlltems(callback, id, fields, forceReload);
		}

		/**
		 * @inheritDoc
		 */
		public function create(message:String, id:String = "me", callback:Function = null, picture:String = null, link:String = null, name:String = null, caption:String = null, description:String = null, source:String = null, objectAttachment:String = null):IFacebookCall
		{
			var params:Object = {message: message};
			
			if (picture) params.picture = picture;
			if (link) params.link = link;
			if (name) params.name = name;
			if (caption) params.caption = caption;
			if (description) params.description = description;
			if (source) params.source = source;
			if (objectAttachment) params.object_attachment = objectAttachment;
			
			return service.post(method, callback, id, params);
		}
	}
}
