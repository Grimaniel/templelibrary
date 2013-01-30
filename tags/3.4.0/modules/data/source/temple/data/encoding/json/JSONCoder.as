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

/*
Copyright (c) 2008, Adobe Systems Incorporated
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are
met:

 * Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.
  
 * Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.
  
 * Neither the name of Adobe Systems Incorporated nor the names of its 
contributors may be used to endorse or promote products derived from 
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package temple.data.encoding.json
{

	/**
	 * This class provides encoding and decoding of the JSON format.
	 *
	 * <p>Example usage:
	 * <code>
	 * // create a JSON string from an internal object
	 * JSONCoder.encode(myObject);
	 * // read a JSON string into an internal object
	 * var myObject:Object = JSONCoder.decode(jsonString);
	 * </code></p>
	 *
	 * @includeExample Person.as
	 * @includeExample Gender.as
	 * @includeExample JSONExample.as
	 * 
	 * @includeExample ../../index/Person.as
	 * @includeExample ../../index/JSONIndexExample.as
	 * 
	 * @see temple.data.encoding.json.JSONEncoder
	 * @see temple.data.encoding.json.JSONDecoder
	 * 
	 * @author Adobe (modified by Thijs Broerse and Arjan van Wijk)
	 */
	public class JSONCoder
	{
		/**
		 * Encodes an object into a JSON string.
		 *
		 * @param object The object to create a JSON string for.
		 * @return the JSON string representing object.
		 */
		public static function encode(object:Object, useExplicitType:Boolean = false, skipTransientVars:Boolean = true, skipReadOnlyVars:Boolean = true):String
		{	
			return new JSONEncoder(object, useExplicitType, skipTransientVars, skipReadOnlyVars).getString();
		}

		/**
		 * Decodes a JSON string into a native object.
		 * 
		 * @param string The JSON string representing the object.
		 * @param strict Flag indicating if the decoder should strictly adhere to the JSON standard or not. The default
		 *  of <code>true</code>. Throws errors if the format does not match the JSON syntax exactly.
		 *  Pass <code>false</code> to allow for non-properly-formatted JSON strings to be decoded with more leniancy.
		 * @return A native object as specified by string.
		 * 
		 * @throw JSONParseError
		 */
		public static function decode(string:String, strict:Boolean = true, skipNulls:Boolean = true):*
		{	
			return new JSONDecoder(string, strict, skipNulls).getValue();	
		}
	}
}