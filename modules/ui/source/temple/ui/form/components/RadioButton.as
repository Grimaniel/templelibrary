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

package temple.ui.form.components 
{
	import temple.core.debug.IDebuggable;

	import flash.events.MouseEvent;

	/**
	 * <p>This class can be used as component by setting this class as 'Component Definition' in the Flash IDE.
	 * You can set different properties in the Flash IDE in the 'Component Inspector'</p>
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see ../../../../../readme.html
	 * @see temple.ui.form.Form
	 * @see temple.ui.form.components.RadioGroup
	 * 
	 * @author Thijs Broerse
	 */
	public class RadioButton extends CheckBox implements IRadioButton, IDebuggable
	{
		private var _group:IRadioGroup;
		private var _toggle:Boolean;
		
		public function RadioButton()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function get groupName():String
		{
			return this._group ? this._group.name : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set groupName(value:String):void
		{
			this.group = RadioGroup.getInstance(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get group():IRadioGroup
		{
			return this._group;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set group(value:IRadioGroup):void
		{
			// remove from group if we already have a group
			if (this._group) this._group.remove(this);
			
			this._group = value;
			if (this._group)
			{
				this._group.add(this, this.selectedValue);
				if (this.selected) this._group.selected = this;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set dataName(value:String):void
		{
			super.dataName = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function set errorMessage(value:String):void
		{
			super.errorMessage = value;
		}

		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Value", type="String")]
		override public function set selectedValue(value:*):void
		{
			// also store value as unselectedm since value will allways be get throug the RadioGroup
			this.unselectedValue = super.selectedValue = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function set unselectedValue(value:*):void
		{
			super.unselectedValue = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function set validationRuleName(value:String):void
		{
			super.validationRuleName = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set submit(value:Boolean):void
		{
			super.submit = value;
		}
		
		/**
		 * Indicates if button can be selected deselect when selected. Default: false
		 */
		public function get toggle():Boolean
		{
			return this._toggle;
		}

		/**
		 * @private
		 */
		public function set toggle(value:Boolean):void
		{
			this._toggle = value;
		}

		/**
		 * @private
		 */
		override protected function handleClick(event:MouseEvent):void
		{
			this.selected = this._toggle ? !this.selected : true;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._group)
			{
				this._group.remove(this);
				this._group = null;
			}
			
			super.destruct();
		}
	}
}
