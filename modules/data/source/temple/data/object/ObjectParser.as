/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
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

package temple.data.object 
{
	import temple.common.interfaces.IObjectParsable;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;

	/**
	 * The ObjectParser parses an Object (ig JSON) to an other object (ig a typed DataValueObject).
	 * The objects to parse to must be of type IObjectParsable. The ObjectParser calles the 'parseObject'
	 * method on the IObjectParsable and passes the Object that needs to be parsed.
	 * 
	 * @see temple.common.interfaces.IObjectParsable
	 * 
	 * @author Arjan van Wijk
	 */
	public class ObjectParser 
	{
		/**
		 * Parses a list (Array) of Objects to a listed of IObjectParsable objects
		 * 
		 * @param list to parse
		 * @param objectClass classname to be instanced; class must implement IObjectParsable
		 * @param ignoreError if true, the return value of parseObject is always added to the array, and the array itself is
		 * returned. Otherwise, an error in parsing will return null.
		 * @param debug if true information is logged if the parsing failed
		 * @return Array of new objects of the specified type, cast to IObjectParsable, or null if parsing returned false.
		 *	
		 * @see temple.common.interfaces.IObjectParsable#parseObject(object)
		 *	
		 */
		public static function parseList(list:Array, objectClass:Class, ignoreError:Boolean = false, debug:Boolean = false):Array 
		{
			var a:Array = new Array();
			
			if (list == null) return a;
			
			var len:int = list.length;
			for (var i:int = 0;i < len; i++) 
			{
				var ipa:IObjectParsable = ObjectParser.parseObject(list[i], objectClass, ignoreError, debug);
				
				if ((ipa == null) && !ignoreError)
				{
					return null;
				}
				else
				{
					a.push(ipa);
				}
			}
			return a;
		}

		/**
		 * Parses a single Object to an IObjectParsable.
		 * 
		 * @param object the object to parse
		 * @param objectClass classname to be instanced; class must implement IObjectParsable
		 * @param ignoreError if true, the return value of IObjectParsable is ignored, and the newly created object is always returned
		 * @param debug if true information is logged if the parsing failed
		 * @return a new object of the specified type, cast to IObjectParsable, or null if parsing returned false.
		 *	
		 * @see temple.common.interfaces.IObjectParsable#parseObject(object)
		 */
		public static function parseObject(object:Object, objectClass:Class, ignoreError:Boolean = false, debug:Boolean = false):IObjectParsable 
		{
			if (object is objectClass && object is IObjectParsable)
			{
				// Object is an instance of objectClass. There is no need to parse it.
				if (debug) Log.info("Object '" + object + "' is an instance of " + objectClass + ", don't need to parse it.", ObjectParser);
				return IObjectParsable(object);
			}
			
			var parsable:IObjectParsable = new objectClass();
			
			if (parsable.parseObject(object) || ignoreError) 
			{
				return parsable;
			}
			else 
			{
				Log.error("Error parsing object: " + object + " to " + parsable, ObjectParser);
				
				return null;
			}
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(ObjectParser);
		}
	}
}
