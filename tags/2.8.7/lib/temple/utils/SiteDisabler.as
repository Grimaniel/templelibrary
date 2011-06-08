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
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.debug.log.Log;
	import temple.debug.objectToString;

	/**
	 * The SiteDisabler can prefend all DisplayObject to receive MouseEvents.
	 * 
	 * <p><strong>What does it do</strong></p>
	 * <p>After calling SiteDisabler.disableSite() all MouseEvents are blocked.</p>
	 * 
	 * <p><strong>Why should you use it</strong></p>
	 * <p>If you do not want the user to click on anything. For instance when the application is busy and clicking
	 * buttons could cause errors.</p>
	 * 
	 * <p><strong>How should you use it</strong></p>
	 * <p>Call SiteDisabler.disableSite() to disable all MouseEvents. Call SiteDisabler.enableSite() to enable the MouseEvents</p>
	 *
	 * @example
	 * <listing version="3.0">
	 * SiteDisabler.disableSite(); // all MouseEvents are now disabled
	 * 
	 * SiteDisabler.enableSite(); // all MouseEvents are now enabled
	 * </listing> 
	 * 
	 * @author Thijs Broerse
	 */
	public final class SiteDisabler extends Object
	{
		private static const _TO_STRING_PROPS:Array = ['isSiteEnabled'];
		
		private static var _debug:Boolean;
		
		/**
		 * Disables the site (not the SiteDisabler)
		 */
		public static function disableSite():void 
		{
			if (StageProvider.stage)
			{
				StageProvider.stage.mouseChildren = false;
				if (SiteDisabler.debug) Log.debug("disableSite", SiteDisabler);
			}
			else
			{
				Log.warn("Stage is not set in StageProvider, can't disable site", SiteDisabler);
			}
		}
		
		/**
		 * Enables the site (not the SiteDisabler)
		 */
		public static function enableSite():void 
		{
			if (StageProvider.stage)
			{
				StageProvider.stage.mouseChildren = true;
				if (SiteDisabler.debug) Log.debug("enableSite", SiteDisabler);
			}
		}

		/**
		 * Indicates is the site is currently enabled.
		 */
		public static function get isSiteEnabled():Boolean
		{
			return StageProvider.stage ? StageProvider.stage.mouseChildren : true;
		}
		
		public static function get debug():Boolean
		{
			return SiteDisabler._debug;
		}

		public static function set debug(value:Boolean):void
		{
			SiteDisabler._debug = value;
		}
		
		public static function toString():String 
		{
			return objectToString(SiteDisabler, _TO_STRING_PROPS);
		}

		public function SiteDisabler()
		{
			throwError(new TempleError(this, "This class cannot be instantiated"));
		}
	}
}
