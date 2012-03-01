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
			return this._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		private function init(stage:Stage):void
		{
			if (this._stage || stage == null) return;
			
			this._stage = stage;
			try
			{
				this._stage.stageFocusRect = false;
			}
			catch (error:Error) {}
			
			this._stage.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
		}

		private function get focus():InteractiveObject
		{
			return this._stage ? this._stage.focus : null;
		}
		
		private function set focus(value:InteractiveObject):void
		{
			if (!this._stage && value.stage) this.init(value.stage);
			if (value != this.focus && this._stage)
			{
				if (this._debug) this.logDebug("focus: " + value + (value ? ", parent:" + value.parent : "") + ", old:" + this._stage.focus);
				this._stage.focus = value;
			}
		}
		
		private function handleMouseDown(event:MouseEvent):void
		{
			if (this._debug) this.logDebug("handleMouseDown: " + event.target);
			this.focus = event.target as InteractiveObject;
		}
	}
}