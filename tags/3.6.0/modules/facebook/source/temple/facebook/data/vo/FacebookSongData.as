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
	import temple.facebook.data.FacebookParser;
	import temple.facebook.data.facebook;
	import temple.facebook.service.IFacebookService;

	/**
	 * @private
	 * 
	 * @author Arjan van Wijk
	 */
	public class FacebookSongData extends FacebookObjectData implements IFacebookSongData
	{
		/**
		 * User by Indexer
		 * @see temple.data.index.Indexer#INDEX_CLASS
		 */
		public static function get indexClass():Class
		{
			return IFacebookObjectData;
		}
		
		// Register classes as implementation of Interfaces
		FacebookParser.facebook::CLASS_MAP[IFacebookSongData] = FacebookSongData;
		FacebookParser.facebook::CLASS_MAP[IFacebookMusicianData] = FacebookMusicianData;

		facebook var url:String;
		facebook var title:String;
		facebook var application:IFacebookApplicationData;
		facebook var description:String;
		facebook var musician:Vector.<IFacebookMusicianData>;
		facebook var type:String;
		facebook var updated_time:Date;
		facebook var album:Object;
		facebook var duration:int = -1;
		facebook var image:String;
		facebook var audio:Object;
		facebook var site_name:String;
		
		public function FacebookSongData(service:IFacebookService)
		{
			super(service, "music.song");
		}

		public function get url():String
		{
			return facebook::url;
		}

		public function get title():String
		{
			return facebook::title;
		}
		
		override public function get name():String
		{
			return super.name || title;
		}

		public function get application():IFacebookApplicationData
		{
			return facebook::application;
		}

		public function get description():String
		{
			return facebook::description;
		}

		public function get musician():Vector.<IFacebookMusicianData>
		{
			return facebook::musician;
		}
	}
}
