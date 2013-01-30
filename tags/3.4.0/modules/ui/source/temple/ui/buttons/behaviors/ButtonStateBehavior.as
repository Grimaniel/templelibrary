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
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.ui.states.StateHelper;
	import temple.ui.states.disabled.IDisabledState;
	import temple.ui.states.down.IDownState;
	import temple.ui.states.focus.IFocusState;
	import temple.ui.states.over.IOverState;
	import temple.ui.states.select.ISelectState;
	import temple.ui.states.up.IUpState;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * A ButtonDesignBehavior which uses States to dispay the state of a button.
	 * 
	 * @see temple.ui.states.IState
	 * 
	 * @includeExample ../../states/StatesExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ButtonStateBehavior extends AbstractButtonDesignBehavior
	{
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the ButtonStateBehavior of a DisplayObject if the DisplayObject has ButtonStateBehavior. Otherwise null is returned 
		 */
		public static function getInstance(target:DisplayObjectContainer):ButtonStateBehavior
		{
			return ButtonStateBehavior._dictionary[target] as ButtonStateBehavior;
		}
		
		public function ButtonStateBehavior(target:DisplayObjectContainer)
		{
			super(target);
			
			if (ButtonStateBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has ButtonStateBehavior"));
			
			ButtonStateBehavior._dictionary[target] = this;
			
			StateHelper.showState(target, IUpState);
		}
		
		public function get displayObjectContainer():DisplayObjectContainer
		{
			return displayObject as DisplayObjectContainer;
		}

		/**
		 * @inheritDoc
		 */
		override public function set over(value:Boolean):void
		{
			if (over == value || !enabled) return;
			
			super.over = value;
			
			if (over)
			{
				StateHelper.showState(displayObjectContainer, IOverState);
				StateHelper.hideState(displayObjectContainer, IUpState);
			}
			else
			{
				StateHelper.hideState(displayObjectContainer, IOverState);
				StateHelper.showState(displayObjectContainer, IUpState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set down(value:Boolean):void
		{
			if (down == value || !enabled) return;
			
			super.down = value;
			
			if (down)
			{
				StateHelper.showState(displayObjectContainer, IDownState);
			}
			else
			{
				StateHelper.hideState(displayObjectContainer, IDownState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set selected(value:Boolean):void
		{
			if (selected == value || !enabled) return;
			
			super.selected = value;
			
			if (selected)
			{
				StateHelper.showState(displayObjectContainer, ISelectState);
			}
			else
			{
				StateHelper.hideState(displayObjectContainer, ISelectState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set disabled(value:Boolean):void
		{
			if (disabled == value || !enabled) return;
			
			super.disabled = value;
			
			if (disabled)
			{
				StateHelper.showState(displayObjectContainer, IDisabledState);
			}
			else
			{
				StateHelper.hideState(displayObjectContainer, IDisabledState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void
		{
			if (focus == value || !enabled) return;
			
			super.focus = value;
			
			if (focus)
			{
				StateHelper.showState(displayObjectContainer, IFocusState);
			}
			else
			{
				StateHelper.hideState(displayObjectContainer, IFocusState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (target) delete ButtonStateBehavior._dictionary[target];
			
			super.destruct();
		}
	}
}
