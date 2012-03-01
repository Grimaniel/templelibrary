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

package temple.ui.buttons.behaviors 
{
	import temple.common.interfaces.IEnableable;
	import temple.core.debug.IDebuggable;
	import temple.ui.behaviors.AbstractDisplayObjectBehavior;

	import flash.display.DisplayObject;


	/**
	 * @private
	 * 
	 * Abstract implementation of a button behavior.
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractButtonBehavior extends AbstractDisplayObjectBehavior implements IDebuggable, IButtonStatus, IEnableable
	{
		private var _over:Boolean;
		private var _down:Boolean;
		private var _disabled:Boolean;
		private var _selected:Boolean;
		private var _debug:Boolean;
		private var _enabled:Boolean;
		private var _focus:Boolean;
		private var _lockOver:Boolean;
		private var _lockDown:Boolean;

		public function AbstractButtonBehavior(target:DisplayObject)
		{
			super(target);
			this._enabled = true;
			
			this.toStringProps.push('over', 'down', 'selected', 'disabled', 'focus');
		}
		
		/**
		 * @inheritDoc
		 */
		public function get over():Boolean
		{
			return this._over || this._lockOver;
		}
		
		/**
		 * @private
		 */
		public function set over(value:Boolean):void
		{
			this._over = value;
		}

		/**
		 * Lock the over state of the button. If set to true the button will display the over state even when the mouse isn't over the button. 
		 */
		public function get lockOver():Boolean
		{
			return this._lockOver;
		}

		/**
		 * @private
		 */
		public function set lockOver(value:Boolean):void
		{
			this._lockOver = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get down():Boolean
		{
			return this._down || this._lockDown;
		}
		
		/**
		 * @private
		 */
		public function set down(value:Boolean):void
		{
			this._down = value;
		}

		/**
		 * Lock the down state of the button. If set to true the button will display the down state even when the mouse isn't over or pressing the button. 
		 */
		public function get lockDown():Boolean
		{
			return this._lockDown;
		}

		/**
		 * @private
		 */
		public function set lockDown(value:Boolean):void
		{
			this._lockDown = value;
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
		public function enable():void
		{
			this.enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			this.enabled = false;
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
