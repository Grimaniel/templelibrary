/*
 *	Temple Library for ActionScript 3.0
 *	Copyright � MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.utils 
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;

	/**
	 * The PropertyApllier can aplly the properties of a (dynamic) property-object to an other object.
	 * 
	 * <p>The PropertyApllier loops through all the properies of the property-object and tries to set
	 * the values to the object.</p>
	 * 
	 * TODO: rename this class
	 * 
	 * @includeExample PropertyApplierExample.as
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
		public static function apply(target:*, properties:Object, debug:Boolean = false):*
		{
			if (target == null)
			{
				Log.error("Target can not be null", PropertyApplier);
				return target;
			}
			if (properties == null)
			{
				Log.error("Properties can not be null", PropertyApplier);
				return target;
			}
			
			for (var property:String in properties)
			{
				if (!setProperty(target, property, properties[property], debug))
				{
					if (debug) Log.warn("Target '" + target + "' has no property '" + property + "'", PropertyApplier);
				}
			}
			
			return target;
		}
		
		/**
		 * Sets a propety of an object
		 * @param object the object
		 * @param property the property that must set. Property can contain dots to set nested properties.
		 * @param value the value to set the property to
		 * @param debug if set to true, warnings are logged when the property can't be set
		 * @return true if is was successful
		 */
		public static function setProperty(target:Object, property:String, value:*, debug:Boolean = false):Boolean
		{
			if (target === null) return false;
			var index:int, prop:String;
			
			if (property in target)
			{
				try
				{
					switch (true)
					{
						case target[property] is Function && (target[property] as Function).length == 1:
						{
							target[property](value);
							break;
						}
						case target[property] is Boolean:
						{
							target[property] = value;
							break;
						}
						default:
						{
							target[property] = value;
							break;
						}
					}
				}
				catch (error:Error)
				{
					if (debug) Log.warn("property '" + property + "' can not be applied to " + target + "\n" + error, PropertyApplier);
					
					return false;
				}
				return true;
			}
			else if ((index = property.indexOf(".")) != -1 && (prop = property.substr(0, index)) in target)
			{
				return setProperty(target[prop], property.substr(index + 1), value, debug);
			}
			
			return false;
		}
		
		/**
		 * Gets the value of a propety of an object
		 * @param object the object
		 * @param property the property that must set. Property can contain dots to set nested properties.
		 * @return the value of the property
		 */
		public static function getProperty(target:Object, property:String):*
		{
			var index:int, prop:String;
			
			if (property in target)
			{
				return target[property];
			}
			else if ((index = property.indexOf(".")) != -1 && (prop = property.substr(0, index)) in target)
			{
				return getProperty(target[prop], property.substr(index + 1));
			}
			
			return false;
		}
		
		/**
		 * Checks if the object has a specific propety
		 * @param object the object
		 * @param property the property that must set. Property can contain dots to set nested properties.
		 * @return the value of the property
		 */
		public static function hasProperty(target:Object, property:String):*
		{
			var index:int, prop:String;
			
			if (!target)
			{
				return false;
			}
			else if (property in target)
			{
				return true;
			}
			else if ((index = property.indexOf(".")) != -1 && (prop = property.substr(0, index)) in target)
			{
				return hasProperty(target[prop], property.substr(index + 1));
			}
			return false;
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
