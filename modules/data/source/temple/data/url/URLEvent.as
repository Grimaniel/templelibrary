/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.data.url 
{
	import flash.events.Event;

	/**
	 * Dispatched by the URLManager when a URL is opened.
	 * 
	 * @see temple.data.url.URLManager
	 * 
	 * @author Arjan van Wijk
	 */
	public class URLEvent extends Event 
	{
		/**
		 * Dispatched when an URL is opened by the URLManager
		 */
		public static const OPEN:String = "URLEvent.open";
		
		private var _url:String;
		private var _targetFrame:String;
		private var _name:String;

		public function URLEvent(type:String, url:String, targetFrame:String, name:String) 
		{
			super(type);
			
			this._url = url;
			this._targetFrame = targetFrame;
			this._name = name;
		}

		/**
		 * The URL that is navigated to
		 */
		public function get url():String
		{
			return this._url;
		}
		
		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			this._url = value;
		}
		
		/**
		 * The target of the URL, like '_self' or '_blank'
		 */
		public function get targetFrame():String
		{
			return this._targetFrame;
		}
		
		/**
		 * @private
		 */
		public function set targetFrame(value:String):void
		{
			this._targetFrame = value;
		}
		
		/**
		 * The name of the url (if available)
		 */
		public function get name():String
		{
			return this._name;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event 
		{
			return new URLEvent(this.type, this.url, this.targetFrame, this.name);
		}
	}
}
