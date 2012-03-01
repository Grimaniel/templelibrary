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

package temple.ui.behaviors 
{
	import temple.common.interfaces.IEnableable;
	import temple.core.debug.IDebuggable;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * The AutoVisibleBehavior watches the <code>alpha</code> property of a <code>DisplayObject</code>.
	 * If the <code>alpha</code> is <code>0</code>, the <code>visible</code> property of the <code>DisplayObject</code>
	 * is set to <code>false</code>, otherwise to <code>true</code>.
	 * 
	 * <p>This class is very usefull for timeline animations. Since invisible object can not be clicked.</p>
	 * 
	 * @author Thijs Broerse
	 */
	public class AutoVisibleBehavior extends AbstractDisplayObjectBehavior implements IEnableable, IDebuggable
	{
		private var _enabled:Boolean = true;
		private var _debug:Boolean;

		public function AutoVisibleBehavior(target:DisplayObject)
		{
			super(target);
			
			target.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
		}
		
		/**
		 * @inheritDoc
		 */
		public function enable():void
		{
			this._enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function disable():void
		{
			this._enabled = false;
		}
		
		/**
		 * @inheritDoc
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

		private function handleEnterFrame(event:Event):void 
		{
			if (this._enabled && this.displayObject)
			{
				if (this.displayObject.alpha > 0 && !this.displayObject.visible)
				{
					this.displayObject.visible = true;
					
					if (this.debug) this.logDebug("visible set to false because alpha is 0");
				}
				else if (this.displayObject.alpha == 0 && this.displayObject.visible)
				{
					this.displayObject.visible = false;
					
					if (this.debug) this.logDebug("visible set to true because alpha is not 0");
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.displayObject) this.displayObject.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			
			super.destruct();
		}
	}
}
