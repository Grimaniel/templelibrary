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
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.ui.states 
{
	import temple.ui.IShowable;
	import temple.ui.IDisplayObject;
	import temple.ui.IEnableable;

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
	 * @includeExample StatesExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public interface IState extends IEnableable, IDisplayObject, IShowable
	{
	}
}