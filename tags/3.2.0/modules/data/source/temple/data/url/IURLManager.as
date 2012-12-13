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
	import temple.core.debug.IDebuggable;
	import temple.core.net.ILoader;
	import temple.core.events.ICoreEventDispatcher;
	
	/**
	 * Interface of the <code>URLManager</code>.
	 * 
	 * @see temple.data.url.URLManager
	 * 
	 * @author Thijs Broerse
	 */
	public interface IURLManager extends ICoreEventDispatcher, ILoader, IDebuggable
	{
		/**
		 * Get named URL data
		 * @param name name of the URL
		 * @return the URLData, or null if none was found
		 */
		function getData(name:String):URLData;
		
		/**
		 * Get a named URL 
		 * @param name name of the URL
		 * @return URL as string or null if none was found.
		 */
		function get(name:String, variables:Object = null):String;
		
		/**
		 * Checks if a URL with a specific name is defined.
		 * @param name name of the URL
		 * @return a Boolean which indicates if the URL which the specific name is defined.
		 */
		function has(name:String):Boolean;
		
		/**
		 * Open a browser window for URL with specified name
		 * @param name the name of the URL
		 * @param variables an object with name-value pairs that replaces {}-var in the URL
		 */
		function openByName(name:String, variables:Object = null):void;
		
		/**
		 * Opens a URL
		 * @param url the URL to open
		 * @param target the name of the target window
		 * @param name the name of the URL which is added to the URLEvent
		 */
		function open(url:String, target:String = null, name:String = null, features:String = null):void;
		
		/**
		 * Load settings from specified URL if provided, or from default URL
		 * @param url URL to load settings from
		 * @param group set which group is used in the url.xml
		 */
		function load(url:String = "inc/xml/urls.xml", group:String = null):void;
		
		/**
		 * Directly set the XML data instead of loading is. Useful if you already loaded the XML file with an external
		 * loader or when you use inline XML.
		 */
		function parse(xml:XML, group:String = null):void;
		
		/**
		 * The used group in the urls.xml. When the XML is loaded, everything will be parsed again.
		 */
		function get group():String;

		/**
		 * @private
		 */
		function set group(value:String):void;
		
		/**
		 * Adds a groupname to the urlgroups. Will process the XML again.
		 * @param group The groupname to add
		 */
		function addGroup(group:String):void;
		
		/**
		 * Removes a groupname from the urlgroups. Will process the xml again.
		 * @param group The groupname to remove
		 */
		function removeGroup(group:String):void
		
		/**
		 * Adds a variable, and if the xml's are loaded they are parsed again
		 * @param name the variable name
		 * @param value the variable value
		 */
		function setVariable(name:String, value:String):void
	}
}
