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

package temple.ui.focus 
{
	import temple.core.CoreObject;
	import temple.core.debug.IDebuggable;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;

	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	/**
	 * A singleton who manages the focus in your application.
	 * 
	 * @author Thijs Broerse
	 */
	public class FocusManager extends CoreObject implements IDebuggable
	{
		private static const _instance:FocusManager = new FocusManager();
		
		private var _stage:Stage;
		private var _debug:Boolean;

		public function FocusManager()
		{
			if (_instance) throwError(new TempleError(this, "Singleton, don't call constructor directly"));
		}
		
		/**
		 * Initialize the FocusManager. You only have to call this once. But calling this multiple times doesn't break anything.
		 */
		public static function init(stage:Stage):void
		{
			FocusManager._instance.init(stage);
		}
		
		/**
		 * The object that has the focus
		 */
		public static function get focus():InteractiveObject
		{
			return FocusManager._instance.focus;
		}
		
		/**
		 * @private
		 */
		public static function set focus(value:InteractiveObject):void
		{
			FocusManager._instance.focus = value;
		}
		
		/**
		 * Set the focus on an object
		 */
		public static function setFocus(value:InteractiveObject):void
		{
			FocusManager._instance.focus = value;
		}
		
		/**
		 * @private
		 */
		public static function get debug():Boolean
		{
			return FocusManager._instance.debug;
		}
		
		/**
		 * @private
		 */
		public static function set debug(value:Boolean):void
		{
			FocusManager._instance.debug = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}

		private function init(stage:Stage):void
		{
			if (_stage || stage == null) return;
			
			_stage = stage;
			try
			{
				_stage.stageFocusRect = false;
			}
			catch (error:Error) {}
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		}

		private function get focus():InteractiveObject
		{
			return _stage ? _stage.focus : null;
		}
		
		private function set focus(value:InteractiveObject):void
		{
			if (!_stage && value.stage) init(value.stage);
			if (value != focus && _stage)
			{
				if (_debug) logDebug("focus: " + value + (value ? ", parent:" + value.parent : "") + ", old:" + _stage.focus);
				_stage.focus = value;
			}
		}
		
		private function handleMouseDown(event:MouseEvent):void
		{
			if (_debug) logDebug("handleMouseDown: " + event.target);
			focus = event.target as InteractiveObject;
		}
	}
}