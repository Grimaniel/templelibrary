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
	import flash.utils.escapeMultiByte;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.addToDebugManager;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.net.ILoader;
	import temple.data.collections.HashMap;
	import temple.data.xml.XMLParser;
	import temple.data.xml.XMLService;
	import temple.data.xml.XMLServiceEvent;
	import temple.utils.TraceUtils;
	import temple.utils.types.ArrayUtils;
	import temple.utils.types.ObjectUtils;
	import temple.utils.types.StringUtils;

	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * @eventType temple.data.url.URLEvent.OPEN
	 */
	[Event(name = "URLEvent.open", type = "temple.data.url.URLEvent")]
	
	/**
	 * The URLManager handles all URLs of a project. In most projects the URLs will depend on the environment. The live application uses different URLs as the development environment.
	 * To handle this you can store the urls in an external XML file, 'urls.xml'. By changing the 'currentgroup' inside the XML you can easily switch between different URLs.
	 * The 'urls.xml' uses the following syntax:
	 * <listing version="3.0">
	 * &lt;?xml version="1.0" encoding="UTF-8"?&gt;
	 * &lt;urls currentgroup="development"&gt;
	 * 	&lt;group id="development"&gt;
	 * 		&lt;url name="link" url="http://www.development_url.com" target="_blank" /&gt;
	 * 		&lt;var name="path" value="http://www.development_path.com" /&gt;
	 * 	&lt;/group&gt;
	 * 	&lt;group id="live"&gt;
	 * 		&lt;url name="link" url="http://www.live_url.com" target="_blank" /&gt;
	 * 		&lt;var name="path" value="http://www.live_path.com" /&gt;
	 * 	&lt;/group&gt;
	 * 	&lt;url name="global" url="http://www.global.com" target="_blank" /&gt;
	 * 	&lt;url name="submit" url="{path}/submit" /&gt;
	 * &lt;/urls&gt;
	 * </listing>
	 * 
	 * <p>Every 'url'-node has a 'name', 'url' and (optional) 'target' attribute. Environment-dependent URLs are place inside a 'group'-node, global-urls are placed outside a group-node.
	 * It is also possible to use variables inside the urls.xml. You can define a variable by using a 'var'-node, with a 'name' and 'value' attribute. You can use the variable inside a URL with '{name-of-the-variable}', which will be replaced with the value.
	 * By defining the variable in different 'groups' the actual URL will we different.</p>
	 * 
	 * <p>The 'currentgroup' can be overruled by code. It is possible to supply different groups (comma-separated).</p>
	 * 
	 * <p>The URLManager is a singleton and can be accessed by URLManager.getInstance() or by his static functions.</p>
	 * 
	 * <p>By enabling the debug-property more information is logged.</p>
	 * 
	 * @example urls.xml used by the URLManagerExample.as example:
	 * 
	 * @includeExample urls.xml
	 * 
	 * @includeExample URLManagerExample.as
	 * 
	 * @author Thijs Broerse, Arjan van Wijk
	 */
	public final class URLManager extends XMLService implements IDebuggable, ILoader
	{
		private static var _instance:URLManager;

		/** 
		 * Default name for urls.xml
		 */
		private static const _URLS:String = "urls";

		/**
		 * Get named URL data
		 * @param name name of the URL
		 * @return the URLData, or null if none was found
		 */
		public static function getURLDataByName(name:String):URLData 
		{
			return URLManager.getInstance().getURLDataByName(name);
		}

		/**
		 * Get named URL 
		 * @param name name of the URL
		 * @return URL as string or null if none was found.
		 */
		public static function getURLByName(name:String):String 
		{
			return URLManager.getInstance().getURLByName(name);
		}

		/**
		 * Checks if a URL with a specific name is defined.
		 * @param name name of the URL
		 * @return a Boolean which indicates if the URL which the specific name is defined.
		 */
		public static function hasURLByName(name:String):Boolean 
		{
			return URLManager.getInstance().hasURLByName(name);
		}

		/**
		 * Open a browser window for URL with specified name
		 * @param name the name of the URL
		 * @param variables an object with name-value pairs that replaces {}-var in the URL
		 */
		public static function openURLByName(name:String, variables:Object = null):void 
		{
			URLManager.getInstance().openURLByName(name, variables);
		}

		/**
		 * Open a browser window for specified URL
		 */
		public static function openURL(url:String, target:String = ""):void 
		{
			URLManager.getInstance().openURL(url, target);
		}
		
		/**
		 * Load settings from specified URL if provided, or from default URL
		 * @param url URL to load settings from
		 * @param group set which group is used in the url.xml
		 */
		public static function loadURLs(url:String = "xml/urls.xml", group:String = null):void 
		{
			URLManager.getInstance().loadURLs(url, group);
		}
		
		/**
		 * Directly set the XML data instead of loading is. Useful if you already loaded the XML file with an external loader. Or when you use inline XML
		 */
		public static function parseXML(xml:XML, group:String = null):void
		{
			URLManager.getInstance().parseXML(xml, group);
		}

		/**
		 * Indicates if the urls.xml is loaded yet
		 */
		public static function get isLoaded():Boolean
		{
			return URLManager.getInstance()._loaded;
		}

		/**
		 * Indicates if the urls.xml is being loaded, but not loaded yet
		 */
		public static function get isLoading():Boolean
		{
			return URLManager.getInstance()._loading;
		}
		
		/**
		 * The used group in the urls.xml. When the XML is loaded, everything will be parsed again.
		 */
		public static function get group():String
		{
			return URLManager.getInstance()._group;
		}

		/**
		 * @private
		 */
		public static function set group(value:String):void
		{
			if (URLManager.getInstance()._group == value) return;
			
			URLManager.getInstance()._group = value;
			
			if (URLManager.getInstance()._loaded) URLManager.getInstance().processXml();
		}
		
		/**
		 * Adds a groupname to the urlgroups. Will process the XML again.
		 * @param value The groupname to add
		 */
		public static function addGroup(value:String):void
		{
			var instance:URLManager = URLManager.getInstance();
			
			instance._groups = instance._group.split(',');
			instance._groups.push(value);
			instance._groups = ArrayUtils.createUniqueCopy(instance._groups);
			instance._group = instance._groups.join(',');
			
			if (instance._loaded) instance.processXml();
		}

		/**
		 * Removes a groupname from the urlgroups. Will process the xml again.
		 * @param value The groupname to remove
		 */
		public static function removeGroup(value:String):void
		{
			URLManager.getInstance()._groups = URLManager.getInstance()._group.split(',');
			ArrayUtils.removeValueFromArray(URLManager.getInstance()._groups, value);
			URLManager.getInstance()._group = URLManager.getInstance()._groups.join(','); 
			
			if (URLManager.getInstance()._loaded) URLManager.getInstance().processXml();
		}
		
		
		/**
		 * Adds a variable, and if the xml's are loaded they are parsed again
		 * @param name the variable name
		 * @param value the variable value
		 */
		public static function setVariable(name:String, value:String):void
		{
			URLManager.getInstance()._variables[name] = value;
			
			if (URLManager.getInstance().isLoaded) URLManager.getInstance().processXml();
		}
		
		/**
		 * Wrapper function for URLManager.getInstance().addEventListener
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			URLManager.getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * Wrapper function for URLManager.getInstance().addEventListenerOnce
		 */
		public static function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void 
		{
			URLManager.getInstance().addEventListenerOnce(type, listener, useCapture, priority);
		}

		/**
		 * Wrapper function for URLManager.getInstance().removeEventListener
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			URLManager.getInstance().removeEventListener(type, listener, useCapture);
		}

		/**
		 * Wrapper function for URLManager.getInstance().removeAllEventListeners
		 */
		public static function removeAllEventListeners():void 
		{
			URLManager.getInstance().removeAllEventListeners();
		}
		
		/**
		 * Returns the instance of the URLManager
		 */
		public static function getInstance():URLManager 
		{
			return URLManager._instance ||= new URLManager();
		}

		private var _urls:Array;
		private var _loaded:Boolean;
		private var _loading:Boolean;
		private var _group:String;
		private var _groups:Array;
		private var _variables:HashMap;
		private var _rawData:XML;

		/**
		 * @private
		 */
		public function URLManager() 
		{
			if (URLManager._instance) throwError(new TempleError(this, "Singleton, use URLManager.getInstance()"));
			
			this._urls = new Array();
			this._variables = new HashMap("URLManager variables");
			this._groups = new Array();
			
			addToDebugManager(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return this._loaded;
		}

		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return this._loading;
		}
		
		/**
		 * HashMap with name-value pairs for variables inside the url's which should be replaced.
		 * Variables are set as '{var}' and are only replaced onced, when the urls.xml is parsed.
		 * So therefor is only useful to set a variable before the URLManager is complete. 
		 */
		public function get variables():HashMap
		{
			return this._variables;
		}

		private function loadURLs(url:String, group:String):void 
		{
			if (this._loaded) throwError(new TempleError(this, "Data is already loaded"));
			if (this._loading) throwError(new TempleError(this, "Data is already loading"));
			
			this._loading = true;
			if (group) this._group = group;
			this.load(new URLData(URLManager._URLS, url));
		}
		
		private function parseXML(xml:XML, group:String):void
		{
			if (this._loaded) throwError(new TempleError(this, "Data is already loaded"));
			if (this._loading) throwError(new TempleError(this, "Data is already loading"));
			
			this._loaded = true;
			if (group) this._group = group;
			this.processData(xml, URLManager._URLS);
		}

		private function getURLDataByName(name:String):URLData 
		{
			if (name == null) throwError(new TempleArgumentError(this, "name can not be null"));
			
			if (!this._loaded)
			{
				this.logError("getURLDataByName: URLs are not loaded yet");
				return null;
			}
			
			var ud:URLData;
			var len:Number = this._urls.length;
			for (var i:Number = 0;i < len; i++) 
			{
				ud = URLData(this._urls[i]);
				if (ud.name == name) return ud;
			}
			this.logError("getURLDataByName: url with name '" + name + "' not found. Check urls.xml!");
			this.logError(TraceUtils.stackTrace());
			
			return null;
		}

		private function getURLByName(name:String):String 
		{
			if (name == null) throwError(new TempleArgumentError(this, "name can not be null"));
			
			if (!this._loaded)
			{
				this.logError("getURLByName: URLs are not loaded yet");
				return null;
			}
			
			var ud:URLData;
			var len:Number = this._urls.length;
			for (var i:Number = 0;i < len; i++) 
			{
				ud = URLData(this._urls[i]);
				if (ud.name == name) return ud.url;
			}
			this.logError("getURLByName: url with name '" + name + "' not found. Check urls.xml!");
			return null;
		}
		
		private function hasURLByName(name:String):Boolean
		{
			var ud:URLData;
			var len:Number = this._urls.length;
			for (var i:Number = 0;i < len; i++) 
			{
				ud = URLData(this._urls[i]);
				if (ud.name == name) return true;
			}
			return false;
		}

		private function openURLByName(name:String, variables:Object = null):void 
		{
			var ud:URLData = URLManager.getURLDataByName(name);
			if (!ud) return;
			
			var url:String = ud.url;
			
			if (variables) url = StringUtils.replaceVars(url, variables);
			
			this.openURL(url, ud.target, name);
		}

		private function openURL(url:String, target:String, name:String = null):void
		{
			if (url == null) throwError(new TempleArgumentError(this, "url can not be null"));
			this.dispatchEvent(new URLEvent(URLEvent.OPEN, url, target, name));
			
			if (this.debug) this.logDebug("openURL: \"" + url + "\", target=\"" + target + "\"");
			
			if (!ExternalInterface.available)
			{
				navigateToURL(new URLRequest(url), target);
			}
			else
			{
				var userAgent:String = String(ExternalInterface.call(<script><![CDATA[function(){ return navigator.userAgent; }]]></script>)).toLowerCase();
				
				/**
				 * Use JavaScript to open the URL when the browser is FireFox or Internet Explorer 7 or higher
				 */
				if (userAgent.indexOf("firefox") != -1 || (userAgent.indexOf("msie") != -1 && uint(userAgent.substr(userAgent.indexOf("msie") + 5, 3)) >= 7))
				{
					if (this.debug) this.logDebug("openURL using JavaScript, userAgent=\"" + userAgent + "\"");
					ExternalInterface.call(String(<script><![CDATA[function(){ window.open("{url}", "{target}");}]]></script>).replace("{url}", url).replace("{target}", target));
				}
				else
				{
					navigateToURL(new URLRequest(url), target);
				}
			}
		}

		/**
		 * @private
		 */
		override protected function processData(data:XML, name:String):void 
		{
			this._rawData = data;
			
			this.processXml();

			this._loaded = true;
			this._loading = false;
			
			this._loader.destruct();
			this._loader = null;

			// send event we're done
			this.dispatchEvent(new XMLServiceEvent(XMLServiceEvent.COMPLETE, name)); 
			this.dispatchEvent(new XMLServiceEvent(XMLServiceEvent.ALL_COMPLETE)); 
		}
		
		private function processXml():void
		{
			if (this._group)
			{
				if (this.debug) this.logInfo("processData: group is set to '" + this._group + "'");
			}
			else
			{
				this._group = this._rawData.@currentgroup; 
				if (this.debug) this.logInfo("processData: group is '" + this._group + "'");
			}
			
			this._groups = this._group.split(',');
			
			var i:int;
			
			// get grouped variables
			var vars:XMLList= new XMLList();
			for (i = 0; i < this._groups.length; i++)
			{
				vars += this._rawData.group.(@id == (this._groups[i])).child('var');
			}
			
			// add ungrouped variables
			vars += this._rawData.child('var');
			
			var key:String, node:XML;
			
			for (i = 0;i < vars.length(); i++)
			{
				node = XML(vars[i]);
				
				if (!node.hasOwnProperty('@name'))
				{
					this.logError("variable has no name attribute: " + node.toXMLString());
				}
				else
				{
					if (!node.hasOwnProperty('@value')) this.logWarn("variable '" + node.@name + "' has no value attribute: " + node.toXMLString());
					if (!this._variables.hasOwnProperty(node.@name))
					{
						var value:String = node.@value;
						if (node.hasOwnProperty('@escape') && node.@escape == "true") value = escape(value);
						if (node.hasOwnProperty('@escapemultibyte') && node.@escapemultibyte == "true") value = escapeMultiByte(value);
						this._variables[node.@name] = value;
					}
				}
			}
			
			// parse vars in vars
			if (ObjectUtils.hasValues(this._variables))
			{
				do
				{
					var changed:Boolean = false;
					for (var key1:String in this._variables)
					{
						for (var key2:String in this._variables)
						{
							var prevValue:String = this._variables[key1]; 
							this._variables[key1] = this._variables[key1].split('{' + key2 + '}').join(this._variables[key2]);
							if (prevValue != this._variables[key1]) changed = true;
						}
					}
				}
				while (changed);
			}
			
			if (this.debug)
			{
				var s:String = "";
				for (key in this._variables)
				{
					s += "\n\t" + key + ": " + this._variables[key];
				}
				this.logDebug("Current vars in URLManager: " + s);
			}

			
			this._urls = new Array();
			var urls:XMLList = new XMLList();
			
			// get grouped urls
			for (i = 0; i < this._groups.length; i++)
			{
				// check if currentgroup is valid
				if (this._groups[i] && this._rawData.group.(@id == (this._groups[i])) == undefined)
				{
					this.logError("processData: group '" + this._groups[i] + "' not found, check urls.xml");
				}
				else
				{
					urls += this._rawData.group.(@id == (this._groups[i])).url;
				}
			}

			// add ungrouped urls
			urls += this._rawData.url;
			
			this._urls = XMLParser.parseList(urls, URLData, false, this.debug);
			
			var ud:URLData;
			
			if (this.debug)
			{
				s = "";
				for each (ud in this._urls)
				{
					s += "\n\t" + ud.name + ": " + ud.url;
				}
				this.logDebug("Current urls in XML: " + s);
			}
			
			// replace vars in urls
			if (ObjectUtils.hasValues(this._variables))
			{
				for each (ud in this._urls)
				{
					for (key in this._variables)
					{
						ud.url = ud.url.split('{' + key + '}').join(this._variables[key]);
					}
				}
			}
			
			if (this.debug)
			{
				s = "";
				for each (ud in this._urls)
				{
					s += "\n\t" + ud.name + ": " + ud.url;
				}
				
				this.logDebug("Current urls in URLManager: " + s);
			}
		}

		/**
		 * Destructs the URLManager
		 */
		override public function destruct():void
		{
			URLManager._instance = null;
			this._urls = null;
			this._rawData = null;
			this._group = null;
			this._groups = null;
			super.destruct();
		}
	}
}
