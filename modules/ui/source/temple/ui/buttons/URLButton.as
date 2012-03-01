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

package temple.ui.buttons 
{
	import temple.data.url.URLManager;

	import flash.events.MouseEvent;

	/**
	 * A <code>LabelButton</code> which is used to navigate to a URL. The <code>URLButton</code> uses the
	 * <code>URLManager</code> to retreive the URL. 
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see ../../../../readme.html
	 * @see temple.data.url.URLManager
	 * 
	 * @author Thijs Broerse
	 */
	public class URLButton extends LabelButton 
	{
		private var _urlName:String;
		private var _url:String;
		private var _urlTarget:String;
		
		public function URLButton()
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK, this.handleClick);
		}
		
		/**
		 * URLName as defined by the URLManager
		 */
		public function get urlName():String
		{
			return this._urlName;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="URLName", type="String")]
		public function set urlName(urlName:String):void
		{
			this._urlName = urlName;
		}
		
		/**
		 * URL to open
		 */
		[Inspectable(name="URL", type="String")]
		public function get url():String
		{
			return this._url;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="URL", type="String")]
		public function set url(value:String):void
		{
			this._url = value;
			
			if (this._urlName) this.logWarn("URLName already set, it's overriding URL!");
		}
		
		/**
		 * Target of the URL
		 */
		public function get urlTarget():String
		{
			return this._urlTarget;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="target window", type="String", defaultValue="_blank", enumeration="_self,_blank,_top")]
		public function set urlTarget(value:String):void
		{
			this._urlTarget = value;
		}
		
		private function handleClick(event:MouseEvent):void
		{
			if (this._urlName)
			{
				URLManager.openURLByName(this._urlName);
			}
			else
			{
				if (this._url)
				{
					URLManager.openURL(this._url, this._urlTarget);
				}
				else
				{
					this.logError("URLName and URL not set, can't open URL");
				}
			}
		}
	}
}
