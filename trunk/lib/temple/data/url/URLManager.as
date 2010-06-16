/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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
 */
 
 package temple.data.url 
{
	import temple.utils.types.StringUtils;
	import temple.utils.types.ArrayUtils;
	import temple.data.collections.HashMap;
	import temple.data.loader.ILoader;
	import temple.data.loader.preload.IPreloadable;
	import temple.data.xml.XMLParser;
	import temple.data.xml.XMLService;
	import temple.data.xml.XMLServiceEvent;
	import temple.debug.DebugManager;
	import temple.debug.IDebuggable;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.utils.TraceUtils;
	import temple.utils.types.ObjectUtils;

	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * @eventType temple.data.url.URLEvent.OPEN
	 */
	[Event(name = "URLEvent.open", type = "temple.data.url.URLEvent")]
	
	/**
	 * The URLManager handles all urls of a project. In most projects the urls will depend on the environment. The live application uses different urls as the development environment.
	 * To handle this you can store the urls in an external xml file, 'urls.xml'. By changing the 'currentgroup' inside the XML you can easely switch between different urls.
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
	 * <p>Every 'url'-node has a 'name', 'url' and (optional) 'target' attribute. Environment-dependent urls are place inside a 'group'-node, global-urls are placed outside a group-node.
	 * It is also possible to use variables inside the urls.xml. You can define a variable by using a 'var'-node, with a 'name' and 'value' attribute. You can use the variable inside a url with '{name-of-the-variable}', wich will be replaced with the value.
	 * By defining the variable in different 'groups' the actual url will we different.</p>
	 * 
	 * <p>The 'currentgroup' can be overruled by code. It is possible to supply different groups (comma-seperated).</p>
	 * 
	 * <p>The URLManager is a singleton and can be accessed by URLManager.getInstance() or by his static functions.</p>
	 * 
	 * <p>By enabling the debug-property more information is logged.</p>
	 * 
	 * @example urls.xml used by the URLManagerExample.as example:
	 * 
	 * @includeExample xml/urls.xml
	 * 
	 * @includeExample URLManagerExample.as
	 * 
	 * @author Thijs Broerse, Arjan van Wijk
	 */
	public final class URLManager extends XMLService implements IDebuggable, ILoader, IPreloadable
	{
		private static var _instance:URLManager;

		/** 
		 * Default name for urls.xml
		 */
		private static const _URLS:String = "urls";
		private var _rawData:XML;

		/**
		 * Get named url data
		 * @param name name of data block
		 * @return the data block, or null if none was found
		 */
		public static function getURLDataByName(name:String):URLData 
		{
			return URLManager.getInstance().getURLDataByName(name);
		}

		/**
		 * Get named url 
		 * @param name name of data block
		 * @return url as string or null if none was found
		 */
		public static function getURLByName(name:String):String 
		{
			return URLManager.getInstance().getURLByName(name);
		}

		/**
		 * Open a browser window for url with specified name
		 * @param name the name of the url
		 * @param variables an object with name-value pairs that replaces {}-var in the URL
		 */
		public static function openURLByName(name:String, variables:Object = null):void 
		{
			URLManager.getInstance().openURLByName(name, variables);
		}

		/**
		 * Open a browser window for specified url
		 */
		public static function openURL(url:String, target:String = ""):void 
		{
			URLManager.getInstance().openURL(url, target);
		}
		
		/**
		 * Load settings from specified url if provided, or from default url
		 * @param url url to load settings from
		 * @param group set wich group is used in the url.xml
		 */
		public static function loadURLs(url:String = "xml/urls.xml", group:String = null):void 
		{
			URLManager.getInstance().loadURLs(url, group);
		}
		
		/**
		 * Directly set the XML data instead of loading is. Usefull if you already loaded the XML file with an external loader. Or when you use inline XML
		 */
		public static function parseXML(xml:XML, group:String = null):void
		{
			URLManager.getInstance().parseXML(xml, group);
		}

		/**
		 * Indicates if the urls.xml is loaded yet
		 */
		public static function isLoaded():Boolean
		{
			return URLManager.getInstance()._loaded;
		}

		/**
		 * Indicates if the urls.xml is beeing loaded, but not loaded yet
		 */
		public static function isLoading():Boolean
		{
			return URLManager.getInstance()._loading;
		}
		
		/**
		 * The used group in the urls.xml. When the xml is loaded, everything will be parsed again.
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
		 * Adds a groupname to the urlgroups. Will process the xml again.
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
			
			if (URLManager.getInstance().isLoaded()) URLManager.getInstance().processXml();
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
			if(URLManager._instance == null) URLManager._instance = new URLManager();
			
			return URLManager._instance;
		}

		private var _urls:Array = [];

		private var _loaded:Boolean = false;
		private var _loading:Boolean = false;
		private var _group:String;
		private var _groups:Array;
		private var _variables:HashMap;

		/**
		 * @private
		 */
		public function URLManager() 
		{
			if (URLManager._instance) throwError(new TempleError(this, "Singleton, use URLManager.getInstance()"));
			
			this._variables = new HashMap("URLManager variables");
			this._groups = new Array();
			
			DebugManager.add(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLoaded():Boolean
		{
			return this._loaded;
		}

		/**
		 * @inheritDoc
		 */
		public function isLoading():Boolean
		{
			return this._loading;
		}
		
		/**
		 * HashMap with name-value pairs for variables inside the url's which should be replaced.
		 * Variables are set as '{var}' and are only replaced onced, when the urls.xml is parsed.
		 * So therefor is only usefull to set a variable before the URLManager is complete. 
		 */
		public function get variables():HashMap
		{
			return this._variables;
		}

		private function loadURLs(url:String, group:String):void 
		{
			if(this._loaded) throwError(new TempleError(this, "Data is already loaded"));
			if(this._loading) throwError(new TempleError(this, "Data is already loading"));
			
			this._loading = true;
			if(group) this._group = group;
			this.load(new URLData(URLManager._URLS, url));
		}
		
		private function parseXML(xml:XML, group:String):void
		{
			if(this._loaded) throwError(new TempleError(this, "Data is already loaded"));
			if(this._loading) throwError(new TempleError(this, "Data is already loading"));
			
			this._loaded = true;
			if(group) this._group = group;
			this.processData(xml, URLManager._URLS);
		}

		private function getURLDataByName(name:String):URLData 
		{
			if (name == null) throwError(new TempleArgumentError(this, "name can not be null"));
			
			if(!this._loaded)
			{
				this.logError("getURLDataByName: URLs are not loaded yet");
				return null;
			}
			
			var len:Number = _urls.length;
			for (var i:Number = 0;i < len; i++) 
			{
				var ud:URLData = URLData(_urls[i]);
				if (ud.name == name) return ud;
			}
			this.logError("getURLDataByName: url with name '" + name + "' not found. Check urls.xml!");
			this.logError(TraceUtils.stackTrace());
			
			return null;
		}

		private function getURLByName(name:String):String 
		{
			if (name == null) throwError(new TempleArgumentError(this, "name can not be null"));
			
			if(!this._loaded)
			{
				this.logError("getURLByName: URLs are not loaded yet");
				return null;
			}
			
			var len:Number = _urls.length;
			for (var i:Number = 0;i < len; i++) 
			{
				var ud:URLData = URLData(_urls[i]);
				if (ud.name == name) return ud.url;
			}
			this.logError("getURLByName: url with name '" + name + "' not found. Check urls.xml!");
			return null;
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
			
			try 
			{
				var request:URLRequest = new URLRequest(url);
				
				if (!ExternalInterface.available) 
				{
					navigateToURL(request, target);
				} 
				else 
				{
					var userAgent:String = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
					
					if (userAgent.indexOf("firefox") != -1 || (userAgent.indexOf("msie") != -1 && uint(userAgent.substr(userAgent.indexOf("msie") + 5, 3)) >= 7)) 
					{
						ExternalInterface.call("window.open", request.url, target);
					} 
					else 
					{
						navigateToURL(request, target);
					}
				}
			}
			catch (e:Error) 
			{
				this.logError("openURLByName: Error navigating to URL '" + url + "', system says:" + e.message);
			}
		}

		/**
		 * Process loaded XML
		 * @param data loaded XML data
		 * @param name name of load operation
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
			if(this._group)
			{
				if (this._debug) this.logInfo("processData: group is set to '" + this._group + "'");
			}
			else
			{
				this._group = this._rawData.@currentgroup; 
				if (this._debug) this.logInfo("processData: group is '" + this._group + "'");
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
			
			var key:String;
			
			for (i = 0;i < vars.length(); i++)
			{
				if (!XML(vars[i]).hasOwnProperty('@name'))
				{
					this.logError("variable has no name attribute: " + vars[i].toXMLString());
				}
				else
				{
					if (!XML(vars[i]).hasOwnProperty('@value')) this.logWarn("variable '" + vars[i].@name + "' has no value attribute: " + vars[i].toXMLString());
					if (!this._variables.hasOwnProperty(vars[i].@name)) this._variables[vars[i].@name] = vars[i].@value;
				}
			}
			
			// parse vars in vars
			if(ObjectUtils.hasValues(this._variables))
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
			
			if(this._debug)
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
			
			if(this._debug)
			{
				s = "";
				for each (ud in this._urls)
				{
					s += "\n\t" + ud.name + ": " + ud.url;
				}
				
				this.logDebug("Current urls in XML: " + s);
			}
			
			// replace vars in urls
			if(ObjectUtils.hasValues(this._variables))
			{
				for each (ud in this._urls)
				{
					for (key in this._variables)
					{
						ud.url = ud.url.split('{' + key + '}').join(this._variables[key]);
					}
				}
			}
			
			if(this._debug)
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
