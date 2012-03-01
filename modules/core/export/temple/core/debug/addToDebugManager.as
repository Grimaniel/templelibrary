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

package temple.core.debug
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Adds an object to the DebugManager, but only when the DebugManager is available.
	 * 
	 * @param object the object to add to the DebugManager
	 * @param parent if profided, the object will also be added as child of this parent
	 * 
	 * @see temple.core.debug.DebugManager#add()
	 * @see temple.core.debug.DebugManager#addAsChild()
	 * 
	 * @author Thijs Broerse
	 */
	public function addToDebugManager(object:IDebuggable, parent:IDebuggable = null):void
	{
		const definition:String = "temple.core.debug.DebugManager";
		const add:String = "add";
		const addAsChild:String = "addAsChild";
		
		if (ApplicationDomain.currentDomain.hasDefinition(definition))
		{
			var debugManager:Class = getDefinitionByName(definition) as Class;
			
			if (debugManager)
			{
				if ((add in debugManager) && (debugManager[add] is Function))
				{
					debugManager[add](object);
					if (parent) debugManager[addAsChild](object, parent);
				}
			}
		}
	}
}
