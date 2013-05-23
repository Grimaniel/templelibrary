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
	 * Used for FQL.
	 * 
	 * @see http://developers.facebook.com/docs/reference/fql/
	 * 
	 * @author Thijs Broerse
	 */
	public final class FacebookTable
	{
		/**
		 * Query this table to return information about a photo album.
		 */
		public static const ALBUM:String = "album";

		/**
		 * Query this table to return read-only properties about an application.
		 */
		public static const APPLICATION:String = "application";

		/**
		 * An FQL table containing the requests sent via an app to a user.
		 */
		public static const APPREQUEST:String = "apprequest";

		/**
		 * Query this table to return information about a checkin. By default, this query returns the last 20 checkins and returns a maximum of 500 checkins.
		 */
		public static const CHECKIN:String = "checkin";

		/**
		 * Query this table to obtain comments associated with one or more [fb:comments]
		 */
		public static const COMMENT:String = "comment";

		/**
		 * The comments_info FQL table. Query this table to obtain XIDs for fb:comments objects associated with an application ID.
		 */
		public static const COMMENTS_INFO:String = "comments_info";

		/**
		 * Query this table to return a user's friends and the Facebook Pages to which the user is connected.
		 */
		public static const CONNECTION:String = "connection";

		/**
		 * Query this table to return information about a cookie.
		 */
		public static const COOKIES:String = "cookies";

		/**
		 * Query this table to return the application IDs for which the specified user is listed as a developer in the Developer application.
		 */
		public static const DEVELOPER:String = "developer";

		/**
		 * The domain table provides a read-only mapping between domain names and ids.
		 */
		public static const DOMAIN:String = "domain";

		/**
		 * Query this table to return information about the admin of a domain.
		 */
		public static const DOMAIN_ADMIN:String = "domain_admin";

		/**
		 * Query this table to return information about an event.
		 */
		public static const EVENT:String = "event";

		/**
		 * Query this table to return information about a user's status for an event or see a list of events for a user.
		 */
		public static const event_member:String = "";

		/**
		 * Query this table to return detailed information about a user's family.
		 */
		public static const FAMILY:String = "family";

		/**
		 * Query this table to determine whether two users are linked together as friends.
		 */
		public static const FRIEND:String = "friend";

		/**
		 * Query this table either to determine which users have sent friend requests to the logged-in user or to query whether a friend request has been sent from the logged-in user to a specific user.
		 */
		public static const FRIEND_REQUEST:String = "friend_request";

		/**
		 * Query this table to return any friend lists owned by the specified user.
		 */
		public static const FRIENDLIST:String = "friendlist";

		/**
		 * Query this table to determine which users are members of a friend list.
		 */
		public static const FRIENDLIST_MEMBER:String = "friendlist_member";

		/**
		 * Query this table to return information about a group.
		 */
		public static const GROUP:String = "group";

		/**
		 * Query this table to return information about the members of a group, or retrieve a list of groups of which a user is a member
		 */
		public static const GROUP_MEMBER:String = "group_member";

		/**
		 * The insights table contains statistics about Applications, Pages and Domains
		 */
		public static const INSIGHTS:String = "insights";

		/**
		 * Query this table to return the user IDs of users who like a given Facebook object (video, note, link, photo, or album).
		 */
		public static const LIKE:String = "like";

		/**
		 * Query this table to return the links a user has posted.
		 */
		public static const LINK:String = "link";

		/**
		 * The link_stat table contains counts that show how users on Facebook are interacting with a given link.
		 */
		public static const LINK_STAT:String = "link_stat";

		/**
		 * The mailbox_folder table contains information about a user's mailbox folders.
		 */
		public static const MAILBOX_FOLDER:String = "mailbox_folder";

		/**
		 * Query this table to return information about messages in a thread.
		 */
		public static const MESSAGE:String = "message";

		/**
		 * Query this table to return the notes the current user has written or to return details for a particular note.
		 */
		public static const NOTE:String = "note";

		/**
		 * Query this table to get the notifications for the current session user, that is, any notification that appears on http://www.facebook.com/notifications.php.
		 */
		public static const NOTIFICATION:String = "notification";

		/**
		 * Query this table to return information about a URL in the Open Graph
		 */
		public static const OBJECT_URL:String = "object_url";

		/**
		 * Query this table to return information about a Facebook Page.
		 */
		public static const PAGE:String = "page";

		/**
		 * Query this table to return information about which Facebook Pages the user Admins.
		 */
		public static const PAGE_ADMIN:String = "page_admin";

		/**
		 * An FQL table that can be used to return a list of a users that are blocked from a Facebook Page.
		 */
		public static const PAGE_BLOCKED_USER:String = "page_blocked_user";

		/**
		 * Query this table to return information about the user who likes a Facebook Page.
		 */
		public static const PAGE_FAN:String = "page_fan";

		/**
		 * Query this table to return the permissions the current user has granted to the app.
		 */
		public static const PERMISSIONS:String = "permissions";

		/**
		 * Query this table to return more descriptive information about extended permissions.
		 */
		public static const PERMISSIONS_INFO:String = "permissions_info";

		/**
		 * Query this table to return information about a photo.
		 */
		public static const PHOTO:String = "photo";

		/**
		 * Query this table to return information about a photo tag.
		 */
		public static const PHOTO_TAG:String = "photo_tag";

		/**
		 * Query this table to return information about a place.
		 */
		public static const PLACE:String = "place";

		/**
		 * Query this table to return a user's privacy setting for a given object_id.
		 */
		public static const PRIVACY:String = "privacy";

		/**
		 * Query default privacy settings for a user for a particular app
		 */
		public static const PRIVACY_SETTING:String = "privacy_setting";

		/**
		 * Query this table to return certain (typically publicly) viewable information for a profile.
		 */
		public static const PROFILE:String = "profile";

		/**
		 * A Question as represented in FQL.
		 */
		public static const QUESTION:String = "question";

		/**
		 * An option for a question, as represented in FQL.
		 */
		public static const QUESTION_OPTION:String = "question_option";

		/**
		 * The votes on a particular option for a question, as represented in FQL.
		 */
		public static const QUESTION_OPTION_VOTES:String = "question_option_votes";

		/**
		 * Query this table to obtain reviews associated with an application, a user or both.
		 */
		public static const REVIEW:String = "review";

		/**
		 * Query this table to determine whether two users are linked together as friends.
		 */
		public static const STANDARD_FRIEND_INFO:String = "standard_friend_info";

		/**
		 * Query this table to return standard information about a user, for use when you need analytic information only.
		 */
		public static const STANDARD_USER_INFO:String = "standard_user_info";

		/**
		 * Query this table to return one or more of a user's statuses.
		 */
		public static const STATUS:String = "status";

		/**
		 * Query this table to return posts from a user's stream or the user's profile.
		 */
		public static const STREAM:String = "stream";

		/**
		 * Query this table to return a filter_key that can be used to query the stream FQL table, as seen through any content filters the user has available on Facebook.
		 */
		public static const STREAM_FILTER:String = "stream_filter";

		/**
		 * Query this table to return associations between users or Facebook Pages and the items they tag in status posts.
		 */
		public static const STREAM_TAG:String = "stream_tag";

		/**
		 * Query this table to return information about message threads in a user's Inbox.
		 */
		public static const THREAD:String = "thread";

		/**
		 * Query this table to return the native strings (original, untranslated text in your application interface) and the translated strings for your application.
		 */
		public static const TRANSLATION:String = "translation";

		/**
		 * This table can be used to access information about messages in the new Facebook messaging system.
		 */
		public static const UNIFIED_MESSAGE:String = "unified_message";

		/**
		 * This table can be used to access information about threads in the new Facebook messaging system.
		 */
		public static const UNIFIED_THREAD:String = "unified_thread";

		/**
		 * This table should be used to access information about subscribe and unsubscribe actions performed on a thread in the new Facebook messaging system.
		 */
		public static const UNIFIED_THREAD_ACTION:String = "unified_thread_action";

		/**
		 * This table should be used to access information about the number of threads in a folder in the new Facebook messaging system.
		 */
		public static const UNIFIED_THREAD_COUNT:String = "unified_thread_count";

		/**
		 * An FQL table containing the Open Graph URLs that the current session user has Liked.
		 */
		public static const URL_LIKE:String = "url_like";

		/**
		 * Query this table to return detailed information from a user's profile.
		 */
		public static const USER:String = "user";

		/**
		 * The video table contains information about videos.
		 */
		public static const VIDEO:String = "video";

		/**
		 * The video_tag table contains information about users tagged in videos.
		 */
		public static const VIDEO_TAG:String = "video_tag";
	}
}
