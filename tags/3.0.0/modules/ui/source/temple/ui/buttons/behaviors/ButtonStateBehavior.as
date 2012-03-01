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
			return this.displayObject as DisplayObjectContainer;
		}

		/**
		 * @inheritDoc
		 */
		override public function set over(value:Boolean):void
		{
			if (this.over == value || !this.enabled) return;
			
			super.over = value;
			
			if (this.over)
			{
				StateHelper.showState(this.displayObjectContainer, IOverState);
				StateHelper.hideState(this.displayObjectContainer, IUpState);
			}
			else
			{
				StateHelper.hideState(this.displayObjectContainer, IOverState);
				StateHelper.showState(this.displayObjectContainer, IUpState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set down(value:Boolean):void
		{
			if (this.down == value || !this.enabled) return;
			
			super.down = value;
			
			if (this.down)
			{
				StateHelper.showState(this.displayObjectContainer, IDownState);
			}
			else
			{
				StateHelper.hideState(this.displayObjectContainer, IDownState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set selected(value:Boolean):void
		{
			if (this.selected == value || !this.enabled) return;
			
			super.selected = value;
			
			if (this.selected)
			{
				StateHelper.showState(this.displayObjectContainer, ISelectState);
			}
			else
			{
				StateHelper.hideState(this.displayObjectContainer, ISelectState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set disabled(value:Boolean):void
		{
			if (this.disabled == value || !this.enabled) return;
			
			super.disabled = value;
			
			if (this.disabled)
			{
				StateHelper.showState(this.displayObjectContainer, IDisabledState);
			}
			else
			{
				StateHelper.hideState(this.displayObjectContainer, IDisabledState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set focus(value:Boolean):void
		{
			if (this.focus == value || !this.enabled) return;
			
			super.focus = value;
			
			if (this.focus)
			{
				StateHelper.showState(this.displayObjectContainer, IFocusState);
			}
			else
			{
				StateHelper.hideState(this.displayObjectContainer, IFocusState);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.target) delete ButtonStateBehavior._dictionary[this.target];
			
			super.destruct();
		}
	}
}
