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
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.vo.FacebookLikeData;
	import temple.facebook.data.vo.FacebookMusicListenData;
	import temple.facebook.data.vo.FacebookPlaylistData;
	import temple.facebook.data.vo.FacebookSongData;
	import temple.facebook.service.IFacebookCall;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	internal class FacebookMusicAPI extends AbstractFacebookObjectAPI implements IFacebookMusicAPI
	{
		public function FacebookMusicAPI(service:IFacebookService)
		{
			super(service, FacebookConnection.MUSIC, FacebookLikeData);
		}

		public function getLikes(callback:Function = null, id:String = 'me', offset:Number = NaN, limit:Number = NaN, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return getItems(callback, id, offset, limit, null, params, forceReload);
		}

		public function getListens(callback:Function = null, id:String = 'me', offset:Number = NaN, limit:Number = NaN, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			if (!isNaN(offset))	(params ||= {}).offset = uint(offset);
			if (!isNaN(limit)) (params ||= {}).limit = uint(limit);
			
			return service.get(callback, FacebookConnection.MUSIC_LISTENS, id, FacebookMusicListenData, params, null, forceReload);
		}

		public function getPlaylist(id:String, callback:Function = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return service.get(callback, null, id, FacebookPlaylistData, params, null, forceReload);
		}
		
		public function getSong(id:String, callback:Function = null, params:Object = null, forceReload:Boolean = false):IFacebookCall
		{
			return service.get(callback, null, id, FacebookSongData, params, null, forceReload);
		}
	}
}
