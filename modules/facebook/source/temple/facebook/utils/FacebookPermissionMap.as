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

package temple.facebook.utils
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.facebook.data.enum.FacebookConnection;
	import temple.facebook.data.enum.FacebookConstant;
	import temple.facebook.data.enum.FacebookEventPrivacy;
	import temple.facebook.data.enum.FacebookPermission;
	import temple.facebook.data.enum.FacebookRequestMethod;
	import temple.facebook.data.vo.IFacebookAlbumData;
	import temple.facebook.data.vo.IFacebookEventData;
	import temple.facebook.data.vo.IFacebookObjectData;
	import temple.facebook.data.vo.IFacebookUserData;
	import temple.facebook.service.IFacebookService;
	
	
	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public final class FacebookPermissionMap
	{
		public static function getForMethod(facebook:IFacebookService, method:String, id:String, requestMethod:FacebookRequestMethod):String
		{
			if (method)
			{
				var index:int = method.indexOf("/");
				if (index != -1) method = method.substr(0, index);
			}
			
			switch (requestMethod)
			{
				case FacebookRequestMethod.GET:
				{
					switch (method)
					{
						case null:
						case "":
						{
							return null;
						}
						case FacebookConnection.ACCOUNTS:
						{
							return FacebookPermission.MANAGE_PAGES;
						}
						case FacebookConnection.ACHIEVEMENTS:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_GAMES_ACTIVITY : FacebookPermission.FRIENDS_GAMES_ACTIVITY;
						}
						case FacebookConnection.ACTIVITIES:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_ACTIVITIES : FacebookPermission.FRIENDS_ACTIVITIES;
						}
						case FacebookConnection.ALBUMS:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_PHOTOS : FacebookPermission.FRIENDS_PHOTOS;
						}
						case FacebookConnection.BOOKS:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_LIKES : FacebookPermission.FRIENDS_LIKES;
						}
						case FacebookConnection.CHECKINS:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_CHECKINS : FacebookPermission.FRIENDS_CHECKINS;
						}
						case FacebookConnection.EVENTS:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_EVENTS : FacebookPermission.FRIENDS_EVENTS;
						}
						case FacebookConnection.FAMILY:
						{
							return FacebookPermission.USER_RELATIONSHIPS;
						}
						case FacebookConnection.FEED:
						{
							// TODO: Any valid access_token or read_stream to see non-public posts.
							return FacebookPermission.READ_STREAM;
						}
						case FacebookConnection.FRIENDLISTS:
						{
							return FacebookPermission.READ_FRIENDLISTS;
						}
						case FacebookConnection.FRIENDREQUESTS:
						{
							return FacebookPermission.READ_REQUESTS;
						}
						case FacebookConnection.GAMES:
						{
							return FacebookPermission.USER_LIKES;
						}
						case FacebookConnection.GROUPS:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_GROUPS : FacebookPermission.FRIENDS_GROUPS;
						}
						case FacebookConnection.HOME:
						{
							return FacebookPermission.READ_STREAM;
						}
						case FacebookConnection.INBOX:
						{
							return FacebookPermission.READ_MAILBOX;
						}
						case FacebookConnection.INTERESTS:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_INTERESTS : FacebookPermission.FRIENDS_INTERESTS;
						}
						case FacebookConnection.LIKES:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_LIKES : FacebookPermission.FRIENDS_LIKES;
						}
						case FacebookConnection.MOVIES:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_LIKES : FacebookPermission.FRIENDS_LIKES;
						}
						case FacebookConnection.NOTES:
						{
							return FacebookPermission.READ_STREAM;
						}
						case FacebookConnection.NOTIFICATIONS:
						{
							return FacebookPermission.MANAGE_NOTIFICATIONS;
						}
						case FacebookConnection.OUTBOX:
						{
							return FacebookPermission.READ_MAILBOX;
						}
						case FacebookConnection.PHOTOS:
						{
							if (id == FacebookConstant.ME) return FacebookPermission.USER_PHOTOS;
							
							var album:IFacebookObjectData = facebook.getObject(id);
							if (album == facebook.me) return FacebookPermission.USER_PHOTOS;
							if (album is IFacebookUserData) return FacebookPermission.FRIENDS_PHOTOS;
							if (album is IFacebookAlbumData && IFacebookAlbumData(album).from)
							{
								if (IFacebookAlbumData(album).from == facebook.me)
								{
									return FacebookPermission.USER_PHOTOS;
								}
								else
								{
									return FacebookPermission.FRIENDS_PHOTOS;
								}
							}
							return null;
						}
						case FacebookConnection.POKES:
						{
							return FacebookPermission.READ_MAILBOX;
						}
						case FacebookConnection.STATUSES:
						{
							return FacebookPermission.READ_STREAM;
						}
						case FacebookConnection.TAGGED:
						{
							return FacebookPermission.READ_STREAM;
						}
						case FacebookConnection.TELEVISION:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_LIKES : FacebookPermission.FRIENDS_LIKES;
						}
						case FacebookConnection.UPDATES:
						{
							return FacebookPermission.READ_MAILBOX;
						}
						case FacebookConnection.VIDEOS:
						{
							return id == FacebookConstant.ME ? FacebookPermission.USER_VIDEOS : FacebookPermission.FRIENDS_VIDEOS;
						}
						case FacebookConnection.INVITED:
						case FacebookConnection.ATTENDING:
						case FacebookConnection.MAYBE:
						case FacebookConnection.DECLINED:
						case FacebookConnection.NOREPLY:
						{
							var event:IFacebookEventData = facebook.getObject(id) as IFacebookEventData;
							if (event != null)
							{
								if (event.privacy == FacebookEventPrivacy.OPEN)
								{
									return null;
								}
								else
								{
									return event.owner == facebook.me ? FacebookPermission.USER_EVENTS : FacebookPermission.FRIENDS_EVENTS;
								} 	
							}
							break;
						}
						default:
						{
							return null;
						}
					}
					break;
				}
				case FacebookRequestMethod.POST:
				{
					switch (method)
					{
						case FacebookConnection.FEED:
						case FacebookConnection.COMMENTS:
						{
							return FacebookPermission.PUBLISH_STREAM;
						}
						case FacebookConnection.EVENTS:
						{
							return FacebookPermission.CREATE_EVENT; 
						}
						case FacebookConnection.ATTENDING:
						case FacebookConnection.DECLINED:
						case FacebookConnection.MAYBE:
						{
							return FacebookPermission.RSVP_EVENT; 
						}
						case FacebookConnection.CHECKINS:
						{
							return FacebookPermission.PUBLISH_CHECKINS; 
						}
						case FacebookConnection.SCORES:
						{
							return FacebookPermission.PUBLISH_ACTIONS; 
						}
						default:
						{
							return null;
						}
					}
				}
				case FacebookRequestMethod.FQL:
				case FacebookRequestMethod.FQL_MULTI_QUERY:
				{
					return null;
				}
			}
			
			Log.warn("Can't resolve permission for method '" + method.replace('{id}', id) + "'", FacebookPermissionMap);
			
			return null;
		}

		public static function toString():String
		{
			return objectToString(FacebookPermissionMap);
		}
	}
}