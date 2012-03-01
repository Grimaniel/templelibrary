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
