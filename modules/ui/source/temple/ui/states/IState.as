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
	import temple.common.interfaces.IEnableable;
	import temple.common.interfaces.IShowable;
	import temple.core.display.IDisplayObject;

	/**
	 * A 'IState' is a DisplayObject which visualize a specific state of his parent, like 'over', 'down' or 'selected'.
	 * 
	 * <p>If the parent gets this specific state all children which represents this state will be shown, by calling the 'show()' method.
	 * If the parent object loses the state all children of this state will be hidden, by calling the 'hide()' method.</p>
	 * 
	 * <p>Note that the parent object can have multiple states at once and that a single state can be represented by multiple 'state' children.</p>
	 * 
	 * <p>You need to call the show() and hide() method yourself or you could use the StateHelper to do it for you.
	 * Some Temple classes like buttons and form components do this automatically.</p>
	 * 
	 * @see temple.ui.states.StateHelper
	 * 
	 * @see temple.ui.states.BaseState
	 * @see temple.ui.states.BaseTimelineState
	 * @see temple.ui.states.BaseFadeState
	 * 
	 * @see temple.ui.states.disabled.IDisabledState
	 * @see temple.ui.states.disabled.DisabledState
	 * @see temple.ui.states.disabled.DisabledTimelineState
	 * @see temple.ui.states.disabled.DisabledFadeState
	 * 
	 * @see temple.ui.states.down.IDownState
	 * @see temple.ui.states.down.DownState
	 * @see temple.ui.states.down.DownTimelineState
	 * @see temple.ui.states.down.DownFadeState
	 * 
	 * @see temple.ui.states.error.IErrorState
	 * @see temple.ui.states.error.ErrorState
	 * @see temple.ui.states.error.ErrorTimelineState
	 * @see temple.ui.states.error.ErrorFadeState
	 * 
	 * @see temple.ui.states.focus.IFocusState
	 * @see temple.ui.states.focus.FocusState
	 * @see temple.ui.states.focus.FocusTimelineState
	 * @see temple.ui.states.focus.FocusFadeState
	 * 
	 * @see temple.ui.states.open.IOpenState
	 * @see temple.ui.states.open.OpenState
	 * @see temple.ui.states.open.OpenTimelineState
	 * @see temple.ui.states.open.OpenFadeState
	 * 
	 * @see temple.ui.states.over.IOverState
	 * @see temple.ui.states.over.OverState
	 * @see temple.ui.states.over.OverTimelineState
	 * @see temple.ui.states.over.OverFadeState
	 * 
	 * @see temple.ui.states.select.ISelectState
	 * @see temple.ui.states.select.SelectState
	 * @see temple.ui.states.select.SelectTimelineState
	 * @see temple.ui.states.select.SelectFadeState
	 * 
	 * @see temple.ui.states.up.IUpState
	 * @see temple.ui.states.up.UpState
	 * @see temple.ui.states.up.UpTimelineState
	 * @see temple.ui.states.up.UpFadeState
	 * 
	 * @includeExample StatesExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public interface IState extends IEnableable, IDisplayObject, IShowable
	{
	}
}