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

package temple.ui.buttons 
{
	import temple.common.interfaces.IEnableable;
	import temple.common.interfaces.IFocusable;
	import temple.common.interfaces.ISelectable;
	import temple.ui.buttons.behaviors.ButtonBehavior;
	import temple.ui.buttons.behaviors.ButtonStateBehavior;
	import temple.ui.buttons.behaviors.ButtonTimelineBehavior;
	import temple.ui.buttons.behaviors.INestableButton;
	import temple.ui.focus.FocusManager;
	import temple.ui.label.LiquidLabel;

	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * A button with text and built-in <code>LiquidBehavior</code>. 
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see ../../../../readme.html
	 * @see temple.ui.buttons.behaviors.ButtonBehavior
	 * @see temple.ui.layout.liquid.LiquidBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class LiquidLabelButton extends LiquidLabel implements ISelectable, IFocusable, INestableButton, IEnableable
	{
		private var _buttonBehavior:ButtonBehavior;
		private var _timelineBehavior:ButtonTimelineBehavior;
		private var _stateBehavior:ButtonStateBehavior;
		private var _selected:Boolean;

		public function LiquidLabelButton(textField:TextField = null)
		{
			super(textField);
			
			this.stop();
			
			this._buttonBehavior = new ButtonBehavior(this);
			if (this.totalFrames > 1) this._timelineBehavior = new ButtonTimelineBehavior(this);
			this._stateBehavior = new ButtonStateBehavior(this);
		}
		
		/**
		 * Returns a reference to the ButtonBehavior
		 */
		public function get buttonBehavior():ButtonBehavior
		{
			return this._buttonBehavior;
		}

		/**
		 * Returns a reference to the ButtonTimelineBehavior
		 */
		public function get buttonTimelineBehavior():ButtonTimelineBehavior
		{
			return this._timelineBehavior;
		}

		/**
		 * Returns a reference to the ButtonTimelineBehavior
		 */
		public function get buttonStateBehavior():ButtonStateBehavior
		{
			return this._stateBehavior;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Enabled", type="Boolean", defaultValue="true")]
		override public function set enabled(value:Boolean):void
		{
			this.mouseEnabled = super.enabled = value; 
			if (this._buttonBehavior) this._buttonBehavior.disabled = !value;
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
		public function get selected():Boolean
		{
			return this._selected;
		}

		/**
		 * @inheritDoc
		 */
		public function set selected(value:Boolean):void 
		{
			if (this._selected != value)
			{
				if (this._buttonBehavior) this._buttonBehavior.selected = this._selected = value;
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focus():Boolean
		{
			return this._buttonBehavior ? this._buttonBehavior.focus : false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focus(value:Boolean):void
		{
			if (value == this.focus) return;
			
			if (value)
			{
				FocusManager.focus = this;
			}
			else if (this.focus)
			{
				FocusManager.focus = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get updateByParent():Boolean
		{
			return this._stateBehavior && this._stateBehavior.updateByParent && this._timelineBehavior && this._timelineBehavior.updateByParent;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Update By Parent", type="Boolean", defaultValue="true")]
		public function set updateByParent(value:Boolean):void
		{
			if (this._stateBehavior) this._stateBehavior.updateByParent = value; 
			if (this._timelineBehavior) this._timelineBehavior.updateByParent = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._buttonBehavior = null;
			this._timelineBehavior = null;
			this._stateBehavior = null;
			
			super.destruct();
		}
	}
}
