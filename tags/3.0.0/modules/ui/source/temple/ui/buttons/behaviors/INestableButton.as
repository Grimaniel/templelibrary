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

	/**
	 * Interface for buttons which can be nested into other buttons.
	 * 
	 * <p>Nesting means that the button can be placed in the timeline of an other button (or on the timeline of a child
	 * (or grand-child etcetera) of the button. The nested button will react on the status of the container button.</p>
	 * 
	 * @author Thijs Broerse
	 */
	public interface INestableButton 
	{
		/**
		 * A Boolean that indicates if the button should update on a (tunneled) ButtonEvent from his parent (or other ancestors).
		 * Only applicable when this button is nested inside an other button. If set to true the button will show the same state as his parent.
		 * If set to false, this button will only react on his own states. Default: true
		 * 
		 * @includeExample NestedMultiStateButtonsExample.as
		 * 
		 * @default true
		 */
		function get updateByParent():Boolean;
		
		/**
		 * @private
		 */
		function set updateByParent(value:Boolean):void;
	}
}
