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
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.facebook;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookLikeData extends CoreObject implements IFacebookLikeData
	{
		public static function register(facebook:IFacebookService):void
		{
			facebook.registerVO(FacebookConnection.ACTIVITIES, FacebookLikeData);
			facebook.registerVO(FacebookConnection.BOOKS, FacebookLikeData);
			facebook.registerVO(FacebookConnection.GAMES, FacebookLikeData);
			facebook.registerVO(FacebookConnection.INTERESTS, FacebookLikeData);
			facebook.registerVO(FacebookConnection.LIKES, FacebookLikeData);
			facebook.registerVO(FacebookConnection.MOVIES, FacebookLikeData);
			facebook.registerVO(FacebookConnection.MUSIC, FacebookLikeData);
			facebook.registerVO(FacebookConnection.TELEVISION, FacebookLikeData);
		}

		facebook var created_time:Date;
		
		private var _user:IFacebookUserData;
		private var _page:IFacebookPageData;
		private var _facebook:IFacebookService;
		
		public function FacebookLikeData(facebook:IFacebookService)
		{
			super();
			_facebook = facebook;
			toStringProps.push("name", "created");
		}
		
		/**
		 * @inheritDoc
		 */
		public function couple(parent:Object):Class
		{
			if (parent is IFacebookUserData && !_user)
			{
				_user = IFacebookUserData(parent);
				return IFacebookPageData;
			}
			else if (parent is IFacebookPageData && !_page)
			{
				_page = IFacebookPageData(parent);
				return FacebookUserData;
			}
			else
			{
				throwError(new TempleArgumentError(this, "Coupling failed " + parent));
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get user():IFacebookUserData
		{
			return _user;
		}

		/**
		 * @inheritDoc
		 */
		public function get page():IFacebookPageData
		{
			return _page;
		}

		/**
		 * @inheritDoc
		 */
		public function get created():Date
		{
			return facebook::created_time;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return _page ? _page.name : null;
		}
	}
}
