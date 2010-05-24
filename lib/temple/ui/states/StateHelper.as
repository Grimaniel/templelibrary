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
 */

package temple.ui.states 
{
	import temple.ui.states.error.IErrorState;
	import temple.ui.states.focus.IFocusState;
	import temple.ui.states.select.ISelectState;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Thijs Broerse
	 */
	public class StateHelper 
	{
		public static function showFocus(object:DisplayObjectContainer):void
		{
			StateHelper.showState(object, IFocusState);
		}
		
		public static function hideFocus(object:DisplayObjectContainer):void
		{
			StateHelper.hideState(object, IFocusState);
		}
		
		public static function showError(object:DisplayObjectContainer, message:String):void
		{
			var len:int = object.numChildren;
			for (var i:int = 0; i < len; i++) {
				if(object.getChildAt(i) is IErrorState)
				{
					var errorState:IErrorState = IErrorState(object.getChildAt(i));
					errorState.show();
					errorState.message = message;
				}
			}
		}
		
		public static function hideError(object:DisplayObjectContainer):void
		{
			StateHelper.hideState(object, IErrorState);
		}
		
		public static function showSelected(object:DisplayObjectContainer):void
		{
			StateHelper.showState(object, ISelectState);
		}
		
		public static function hideSelected(object:DisplayObjectContainer):void
		{
			StateHelper.hideState(object, ISelectState);
		}
		
		public static function showState(object:DisplayObjectContainer, state:Class):void
		{
			if(object is state) IState(object).show();
			
			var len:int = object.numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				if(object.getChildAt(i) is state)
				{
					IState(object.getChildAt(i)).show();
				}
			}
		}
		
		public static function hideState(object:DisplayObjectContainer, state:Class):void
		{
			if(object is state) IState(object).hide();
			
			var len:int = object.numChildren;
			for (var i:int = 0; i < len; i++) {
				if(object.getChildAt(i) is state){
					IState(object.getChildAt(i)).hide();
				}
			}
		}
	}
}
