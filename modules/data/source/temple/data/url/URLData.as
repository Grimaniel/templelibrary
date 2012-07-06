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

package temple.data.url 
{
	import temple.common.interfaces.IXMLParsable;
	import temple.core.CoreObject;

	/**
	 * Data object class to hold information about a URL.
	 * 
	 * @author Thijs Broerse
	 */
	public class URLData extends CoreObject implements IXMLParsable 
	{
		private var _name:String;
		private var _url:String;
		private var _target:String;
		private var _features:String;

		/**
		 * Creates a new URLData.
		 * The constructor will be called without parameters by the Parser.
		 */
		public function URLData(name:String = null, url:String = null, target:String = null, features:String = null) 
		{
			this._name = name;
			this._url = url;
			this._target = target;
			this._features = features;
			this.toStringProps.push('name', 'url', 'target', 'features');
			this.emptyPropsInToString = false;
		}
		
		/**
		 * Unique identifying name of the url
		 */
		public function get name():String
		{
			return this._name;
		}
		
		/**
		 * Actual url
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
		 * Target of getURL function.
		 */
		public function get target():String
		{
			return this._target;
		}
		
		/**
		 * A string that determines the various window features to be included in the popup window (like status bar, address bar etc)
		 */
		public function get features():String
		{
			return this._features;
		}

		/**
		 * @private
		 */
		public function set features(value:String):void
		{
			this._features = value;
		}

		/**
		 * @inheritDoc
		 */
		public function parseXML(xml:XML):Boolean 
		{
			this._name = xml.@name;
			this._url = xml.@url;
			this._target = xml.@target;
			this._features = xml.@features;
			
			return this._name && this._url;
		}

		/**
		 * Creates a copy
		 */
		public function clone():URLData
		{
			return new URLData(this._name, this._url, this._target, this._features);
		}
	}
}