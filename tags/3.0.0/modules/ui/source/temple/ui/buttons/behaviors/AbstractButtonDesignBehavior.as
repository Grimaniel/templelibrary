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
	import temple.common.interfaces.IDisableable;
	import temple.common.interfaces.IEnableable;
	import temple.common.interfaces.ISelectable;
	import temple.core.debug.IDebuggable;

	import flash.display.DisplayObject;


	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractButtonDesignBehavior extends AbstractButtonBehavior implements IButtonDesignBehavior, IDebuggable, IButtonStatus, ISelectable, IDisableable, IEnableable 
	{
		private var _updateByParent:Boolean = true;
		
		public function AbstractButtonDesignBehavior(target:DisplayObject)
		{
			super(target);
			
			target.addEventListener(ButtonEvent.UPDATE, this.handleButtonEvent);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get updateByParent():Boolean
		{
			return this._updateByParent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set updateByParent(value:Boolean):void
		{
			this._updateByParent = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function update(status:IButtonStatus):void
		{
			this.disabled = status.disabled;
			this.selected = status.selected;
			this.focus = status.focus;
			this.over = status.over;
			this.down = status.down;
		}
		
		private function handleButtonEvent(event:ButtonEvent):void
		{
			if (this._updateByParent || event.tunnelTarget == this.target)
			{
				this.update(event.status);
			}
			else
			{
				event.stopTunneling();
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.displayObject) this.displayObject.removeEventListener(ButtonEvent.UPDATE, this.handleButtonEvent);
			super.destruct();
		}
	}
}
