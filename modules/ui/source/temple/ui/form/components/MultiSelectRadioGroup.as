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
	import temple.common.interfaces.IHasValue;
	import temple.common.interfaces.ISelectable;
	import temple.core.display.StageProvider;
	import temple.utils.keys.KeyCode;
	import temple.utils.keys.KeyManager;

	import flash.events.Event;

	/**
	 * A <code>RadioGroup</code> which allows you to select more then one <code>RadioButton</code>.
	 * 
	 * <p>The <code>value</code> property always returns an <code>Array</code> with the values of the selected buttons</p>
	 * 
	 * @author Thijs Broerse
	 */
	public class MultiSelectRadioGroup extends RadioGroup 
	{
		private var _selectedButtons:Array;
		
		public function MultiSelectRadioGroup()
		{
			if (StageProvider.stage) KeyManager.init(StageProvider.stage);
			
			this._selectedButtons = new Array();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get value():* 
		{
			var value:Array = [];
			
			var leni:int = this._selectedButtons.length;
			for (var i:int = 0; i < leni; i++)
			{
				if (this._selectedButtons[i]) value.push(IHasValue(this._selectedButtons[i]).value);
			}
			return value;
		}

		override protected function handleButtonChange(event:Event):void
		{
			if (!(event.target is ISelectable)) return;
			
			if (ISelectable(event.target).selected)
			{
				if (this._selected != event.target)
				{
					this._selected = ISelectable(event.target);
					
					if (!(KeyManager.isDown(KeyCode.CONTROL) || KeyManager.isDown(KeyCode.SHIFT)))
					{
						for each (var button : ISelectable in this._selectedButtons)
						{
							if (button) button.selected = false;
						}
						this._selectedButtons.length = 0;
					}
					this._selectedButtons.push(this._selected);
					
					if (this._dispatchChangeEvent) this.dispatchEvent(new Event(Event.CHANGE));
				}
			}
			else if (this._selected == event.target)
			{
				this._selected = null;
				if (this._dispatchChangeEvent) this.dispatchEvent(new Event(Event.CHANGE));
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._selectedButtons)
			{
				this._selectedButtons.length = 0;
				this._selectedButtons = null;
			}
			
			super.destruct();
		}
	}
}
