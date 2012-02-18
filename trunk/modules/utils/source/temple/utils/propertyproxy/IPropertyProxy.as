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

package temple.utils.propertyproxy 
{
	import temple.common.interfaces.ICancellable;
	import temple.core.destruction.IDestructible;

	/**
	 * An IPropertyProxy set a property on an Object to a given value. The IPropertyProxy can manipulate the value
	 * before it's set. Therefor you can e.g. add a Tween to a property or round the value. 
	 * 
	 * @includeExample ../../ui/behaviors/DragBehaviorExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public interface IPropertyProxy extends IDestructible, ICancellable
	{
		/**
		 * Set the value of a property through the proxy
		 * @param target the object that has the property to affect
		 * @param property the name of the property
		 * @param value the value to be set
		 */
		function setValue(target:Object, property:String, value:*):void;
	}
}
