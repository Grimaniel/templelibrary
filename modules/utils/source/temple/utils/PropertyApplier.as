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

package temple.utils 
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.utils.ObjectType;
	import temple.utils.types.BooleanUtils;

	/**
	 * The PropertyApllier can aplly the properties of a (dynamic) property-object to an other object.
	 * 
	 * <p>The PropertyApllier loops through all the properies of the property-object and tries to set
	 * the values to the object.</p>
	 *
	 * @author Thijs Broerse
	 */
	public final class PropertyApplier 
	{
		/**
		 * Applies the values of properties to object
		 * @param object the object where to properties are applied to
		 * @param properties the object that contains all the properties, NOTE: object must be dynamic!
		 * @param debug if set to true, warnings are logged when properties can't be applied
		 * @return the object
		 */
		public static function apply(object:Object, properties:Object, debug:Boolean = false):Object
		{
			if (object == null)
			{
				Log.error("Object can not be null", PropertyApplier);
				return object;
			}
			if (properties == null)
			{
				Log.error("Properties can not be null", PropertyApplier);
				return object;
			}
			
			for (var key:String in properties)
			{
				if (object.hasOwnProperty(key))
				{
					try
					{
						switch (typeof(object[key]))
						{
							case ObjectType.BOOLEAN:
							{
								object[key] = BooleanUtils.getBoolean(properties[key]);
								break;
							}
							default:
							{
								object[key] = properties[key];
								break;
							}
						}
					}
					catch (error:Error)
					{
						if (debug) Log.warn("property '" + key + "' can not be applied to " + object, PropertyApplier);
					}
				}
				else
				{
					if (debug) Log.warn("Object '" + object + "' has no property '" + key + "'", PropertyApplier);
				}
			}
			
			return object;
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(PropertyApplier);
		}
	}
}
