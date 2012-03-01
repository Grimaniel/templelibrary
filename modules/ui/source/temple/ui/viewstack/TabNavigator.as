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

package temple.ui.viewstack 
{
	import flash.events.Event;

	/**
	 * A TabNavigator combines a <code>ViewStack</code> and a <code>TabBar</code> into one class.
	 * 
	 * @see temple.ui.viewstack.ViewStack
	 * @see temple.ui.viewstack.TabBar
	 * 
	 * @author Thijs Broerse
	 */
	public class TabNavigator extends ViewStack
	{
		private var _tabBar:TabBar;

		public function TabNavigator()
		{
			super();
		}
		
		public function get tabBar():TabBar
		{
			return this._tabBar;
		}
		
		public function set tabBar(value:TabBar):void
		{
			if (this._tabBar) this._tabBar.removeEventListener(Event.CHANGE, this.handleTabBarChange);
			
			this._tabBar = value;
			this._tabBar.addEventListener(Event.CHANGE, this.handleTabBarChange);
		}

		override public function set selectedIndex(value:uint):void 
		{
			super.selectedIndex = value;
			
			if (this._tabBar && this._tabBar.selectedIndex != this.selectedIndex)
			{
				this._tabBar.selectedIndex = this.selectedIndex;
			}
		}

		protected function handleTabBarChange(event:Event):void
		{
			this.selectedIndex = this._tabBar.selectedIndex;
		}
		
		override public function destruct():void
		{
			if (this._tabBar)
			{
				this._tabBar.removeEventListener(Event.CHANGE, this.handleTabBarChange);
				this._tabBar = null;
			}
			
			super.destruct();
		}
	}
}
