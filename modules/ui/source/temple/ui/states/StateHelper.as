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

package temple.ui.states 
{
	import temple.ui.states.error.IErrorState;
	import temple.ui.states.focus.IFocusState;
	import temple.ui.states.select.ISelectState;

	import flash.display.DisplayObjectContainer;

	/**
	 * A helper class for showing or hiding a specific state.
	 * 
	 * @see temple.ui.states.IState
	 * 
	 * @author Thijs Broerse
	 */
	public class StateHelper 
	{
		/**
		 * Call show() on all children of the object which implements IFocusState.
		 * @param object the DisplayObjectContainer which contains the state clips.
		 * @param instant a Boolean which indicates if the states must use an animation to show itself or do it instantly
		 */
		public static function showFocus(object:DisplayObjectContainer, instant:Boolean = false):void
		{
			StateHelper.showState(object, IFocusState, instant);
		}
		
		/**
		 * Call hide() on all children of the object which implements IFocusState.
		 * @param object the DisplayObjectContainer which contains the state clips.
		 * @param instant a Boolean which indicates if the states must use an animation to hide itself or do it instantly
		 */
		public static function hideFocus(object:DisplayObjectContainer, instant:Boolean = false):void
		{
			StateHelper.hideState(object, IFocusState, instant);
		}
		
		/**
		 * Call show() on all children of the object which implements IErrorState and set an error message.
		 * @param object the DisplayObjectContainer which contains the state clips.
		 * @param message an error message to put in the state.
		 * @param instant a Boolean which indicates if the states must use an animation to show itself or do it instantly
		 */
		public static function showError(object:DisplayObjectContainer, message:String = null, instant:Boolean = false):void
		{
			var len:int = object.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				if (object.getChildAt(i) is IErrorState)
				{
					var errorState:IErrorState = IErrorState(object.getChildAt(i));
					errorState.show(instant);
					if (message != null) errorState.message = message;
				}
			}
		}
		
		/**
		 * Call hide() on all children of the object which implements IErrorStat.
		 * @param object the DisplayObjectContainer which contains the state clips.
		 * @param instant a Boolean which indicates if the states must use an animation to hide itself or do it instantly
		 */
		public static function hideError(object:DisplayObjectContainer, instant:Boolean = false):void
		{
			StateHelper.hideState(object, IErrorState, instant);
		}
		
		/**
		 * Call show() on all children of the object which implements ISelectState.
		 * @param object the DisplayObjectContainer which contains the state clips.
		 * @param instant a Boolean which indicates if the states must use an animation to show itself or do it instantly
		 */
		public static function showSelected(object:DisplayObjectContainer, instant:Boolean = false):void
		{
			StateHelper.showState(object, ISelectState, instant);
		}
		
		/**
		 * Call hide() on all children of the object which implements ISelectState.
		 * @param object the DisplayObjectContainer which contains the state clips.
		 * @param instant a Boolean which indicates if the states must use an animation to hide itself or do it instantly
		 */
		public static function hideSelected(object:DisplayObjectContainer, instant:Boolean = false):void
		{
			StateHelper.hideState(object, ISelectState, instant);
		}
		
		/**
		 * Call show() on all children of the object which implements a specified state.
		 * @param object the DisplayObjectContainer which contains the state clips.
		 * @param state a state interface (must extend IState) to show.
		 * @param instant a Boolean which indicates if the states must use an animation to show itself or do it instantly
		 */
		public static function showState(object:DisplayObjectContainer, state:Class, instant:Boolean = false):void
		{
			if (object is state) IState(object).show(instant);
			
			var len:int = object.numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				if (object.getChildAt(i) is state)
				{
					IState(object.getChildAt(i)).show(instant);
				}
			}
		}
		
		/**
		 * Call hide() on all children of the object which implements a specified state.
		 * @param object the DisplayObjectContainer which contains the state clips.
		 * @param state a state interface (must extend IState) to hide.
		 * @param instant a Boolean which indicates if the states must use an animation to hide itself or do it instantly
		 */
		public static function hideState(object:DisplayObjectContainer, state:Class, instant:Boolean = false):void
		{
			if (object is state) IState(object).hide(instant);
			
			var len:int = object.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				if (object.getChildAt(i) is state)
				{
					IState(object.getChildAt(i)).hide(instant);
				}
			}
		}

		/**
		 * Updates (show or hide) to a specific state
		 */
		public static function update(object:DisplayObjectContainer, state:Class, show:Boolean, instant:Boolean = false):void
		{
			if (show)
			{
				StateHelper.showState(object, state, instant);
			}
			else
			{
				StateHelper.hideState(object, state, instant);
			}
		}
	}
}
