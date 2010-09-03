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

package temple.ui.buttons.behaviors 
{
	import temple.debug.IDebuggable;
	import temple.ui.IDisableable;
	import temple.ui.IEnableable;
	import temple.ui.ISelectable;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;
	import temple.ui.focus.IFocusable;

	import flash.display.DisplayObject;

	/**
	 * Abstract implementation of a button behavior.
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractButtonBehavior extends AbstractDisplayObjectBehavior implements IDebuggable, IButtonStatus, ISelectable, IDisableable, IEnableable, IFocusable
	{
		private var _over:Boolean;
		private var _down:Boolean;
		private var _disabled:Boolean;
		private var _selected:Boolean;
		private var _debug:Boolean;
		private var _enabled:Boolean;
		private var _focus:Boolean;

		public function AbstractButtonBehavior(target:DisplayObject)
		{
			super(target);
			this._enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get over():Boolean
		{
			return this._over;
		}
		
		/**
		 * @private
		 */
		public function set over(value:Boolean):void
		{
			this._over = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get down():Boolean
		{
			return this._down;
		}
		
		/**
		 * @private
		 */
		public function set down(value:Boolean):void
		{
			this._down = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get selected():Boolean
		{
			return this._selected;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selected(value:Boolean):void
		{
			this._selected = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Enables or disables the Button, not the ButtonBehavior. Use 'enable' to enable or disable the ButtonBehavior
		 */
		public function get disabled():Boolean
		{
			return this._disabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set disabled(value:Boolean):void
		{
			this._disabled = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Enables or disables the ButtonBehavior, not the button. Use 'disable' to enable or disable the Button 
		 */
		public function get enabled():Boolean
		{
			return this._enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			this._enabled = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return this._focus;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			this._focus = value;
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
	}
}
