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
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.utils 
{
	import temple.debug.getClassName;
	import temple.debug.log.Log;

	import flash.display.DisplayObject;
	import flash.system.Capabilities;

	/**
	 * @author Thijs Broerse
	 */
	public final class Environment 
	{
		public static const WEB:String = 'web';
		public static const IDE:String = 'IDE';
		public static const STANDALONE:String = 'StandAlone';
		public static const AIR:String = 'AIR';
		public static const PLUGIN:String = 'PlugIn';
		
		private static const _SPLITTED_PLAYER_VERSION:Array = Capabilities.version.split(",");
		
		/**
		 * Checks the environment in which the SWF is running
		 * @return 
		 * - Environment.PLUGIN
		 * - Environment.IDE
		 * - Environment.STANDALONE
		 * - Environment.AIR
		 */
		public static function getEnvironment():String
		{
			if(Environment.isPlugin())
			{
				return Environment.PLUGIN;
			}
			
			if(Environment.isIDE())
			{
				return Environment.IDE;
			}
		
			if(Environment.isStandAlone())
			{
				return Environment.STANDALONE;
			}
		
			if(Environment.isAirApplication())
			{
				return Environment.AIR;
			}
			
			Log.error("getEnvironment: unknown environment", Environment.toString());
			
			return null;
		}

		/**
		Determines if the SWF is being served on the internet.
			
		@param location: DisplayObject to get location of.
		@return Returns {@code true} if SWF is being served on the internet; otherwise {@code false}.
		@usage
		<code>
		trace(LocationUtil.isWeb(_root));
		</code>
		 */
		public static function isWeb(object:DisplayObject):Boolean 
		{
			return object.loaderInfo.url.substr(0, 4) == 'http';
		}

		/**
		 * Detects if MovieClip's embed location matches passed domain.
		 *	
		 * @param object: MovieClip to compare location of.
		 * @param domain: Web domain.
		 * @return Returns {@code true} if file's embed location matched passed domain; otherwise {@code false}.
		 * @usage
		 * 	To check for domain:
		 *		<code>
		 *			trace(LocationUtil.isDomain(_root, "google.com"));
		 *			trace(LocationUtil.isDomain(_root, "bbc.co.uk"));
		 *		</code>
		 *		
		 *		You can even check for subdomains:
		 *		<code>
		 *			trace(LocationUtil.isDomain(_root, "subdomain.aaronclinger.com"))
		 *		</code>
		 */
		public static function isDomain(object:DisplayObject, domain:String):Boolean 
		{
			return Environment.getDomain(object).slice(-domain.length) == domain;
		}

		/**
		 * Detects MovieClip's domain location.
		 *	
		 * @param location: MovieClip to get location of.
		 * @return Returns full domain (including sub-domains) of MovieClip's location.
		 * @usage
		 *		<code>
		 *			trace(LocationUtil.getDomain(_root));
		 *		</code>
		 * @usageNote Function does not return folder path or file name. The method also treats "www" and sans "www" as the same; if "www" is present method does not return it.
		 */
		public static function getDomain(location:DisplayObject):String 
		{
			var baseUrl:String = (location.loaderInfo.url.split('://')[1] as String).split('/')[0];
			return (baseUrl.substr(0, 4) == 'www.') ? baseUrl.substr(4) : baseUrl;
		}

		/**
		 * Determines if the SWF is running in a browser plug-in.
		 *	
		 * @return Returns {@code true} if SWF is running in the Flash Player browser plug-in; otherwise {@code false}.
		 */
		public static function isPlugin():Boolean 
		{
			return Capabilities.playerType == 'PlugIn' || Capabilities.playerType == 'ActiveX';
		}

		/**
		 * Determines if the SWF is running in the IDE.
		 *
		 * @return Returns {@code true} if SWF is running in the Flash Player version used by the external player or test movie mode; otherwise {@code false}.
		 */
		public static function isIDE():Boolean 
		{
			return Capabilities.playerType == 'External';
		}

		/**
		 * Determines if the SWF is running in the StandAlone player.
		 *	
		 * @return Returns {@code true} if SWF is running in the Flash StandAlone Player; otherwise {@code false}.
		 */
		public static function isStandAlone():Boolean 
		{
			return Capabilities.playerType == 'StandAlone';
		}

		/**
		 * Determines if the runtime environment is an Air application.
		 *
		 * @return Returns {@code true} if the runtime environment is an Air application; otherwise {@code false}.
		 */
		public static function isAirApplication():Boolean 
		{
			return Capabilities.playerType == 'Desktop';
		}
		
		/**
		 * Get FlashPlayer major version
		 *
		 * @return Returns Flash player major version
		 */
		public static function getMajorPlayerVersion():int 
		{
			return parseInt(_SPLITTED_PLAYER_VERSION[0].split(" ").pop());
		}
		
		/**
		 * Get FlashPlayer minor version
		 *
		 * @return Returns Flash player minor version
		 */
		public static function getMinorPlayerVersion():int 
		{
			return parseInt(_SPLITTED_PLAYER_VERSION[1]);
		}
		
		/**
		 * Get FlashPlayer revision
		 *
		 * @return Returns Flash player revison
		 */
		public static function getPlayerRevision():int 
		{
			return parseInt(_SPLITTED_PLAYER_VERSION[2]);
		}
		
		/**
		 * Get Environment Language
		 *
		 * @return Returns Environments language
		 */
		public static function getEnvironmentLanguage():String 
		{
			return Capabilities.language.substr(0, 2);
		}
		
		/**
		 * Check if the current Flash player has support for h.264 video
		 * Returns true if player has support 
		 */
		public static function hasH264Support():Boolean
		{
			return Environment.getMajorPlayerVersion() >= 10 || Environment.getMajorPlayerVersion() == 9 && Environment.getPlayerRevision() >= 115;
		}

		public static function toString():String
		{
			return getClassName(Environment);
		}
	}
}
