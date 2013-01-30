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

package temple.utils 
{
	import flash.events.Event;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.display.CoreSprite;
	import temple.core.display.StageProvider;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import flash.display.Stage;

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
		private static const _TO_STRING_PROPS:Vector.<String> = Vector.<String>(['isSiteEnabled']);
		
		private static var _debug:Boolean;
		private static var _mouseBlocker:CoreSprite;
		private static var _stage:Stage;
		
		/**
		 * Disables the site (not the SiteDisabler)
		 */
		public static function disableSite():void 
		{
			SiteDisabler._stage ||= StageProvider.stage;
			if (SiteDisabler._stage)
			{
				if (!SiteDisabler._mouseBlocker)
				{
					SiteDisabler._mouseBlocker  = new CoreSprite();
					SiteDisabler._mouseBlocker.graphics.beginFill(0xFF0000);
					SiteDisabler._mouseBlocker.graphics.drawRect(0, 0, 1, 1);
					SiteDisabler._mouseBlocker.graphics.endFill();
					SiteDisabler._mouseBlocker.alpha = SiteDisabler._debug ? .1 : 0;
				}
				
				SiteDisabler._mouseBlocker.width = SiteDisabler._stage.stageWidth;
				SiteDisabler._mouseBlocker.height = SiteDisabler._stage.stageHeight;
				SiteDisabler._stage.addChild(SiteDisabler._mouseBlocker);
				SiteDisabler._stage.focus = SiteDisabler._mouseBlocker;
				SiteDisabler._stage.addEventListener(Event.RESIZE, SiteDisabler.handleStageResize);
				
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
			SiteDisabler._stage ||= StageProvider.stage;
			if (SiteDisabler._stage && SiteDisabler._mouseBlocker && SiteDisabler._mouseBlocker.parent)
			{
				SiteDisabler._stage.removeEventListener(Event.RESIZE, SiteDisabler.handleStageResize);
				SiteDisabler._mouseBlocker.parent.removeChild(SiteDisabler._mouseBlocker);
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
			SiteDisabler._mouseBlocker.alpha = value ? .1 : 0;
		}
		
		private static function handleStageResize(event:Event):void
		{
			if (SiteDisabler._mouseBlocker && SiteDisabler._stage)
			{
				SiteDisabler._mouseBlocker.width = SiteDisabler._stage.stageWidth;
				SiteDisabler._mouseBlocker.height = SiteDisabler._stage.stageHeight;
			}
		}
		
		/**
		 * @private
		 */
		public static function toString():String 
		{
			return objectToString(SiteDisabler, _TO_STRING_PROPS);
		}

		/**
		 * @private
		 */
		public function SiteDisabler()
		{
			throwError(new TempleError(this, "This class cannot be instantiated"));
		}
	}
}
